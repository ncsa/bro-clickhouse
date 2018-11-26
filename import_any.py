#!/usr/bin/env python
import os
import requests
import glob
import subprocess
import sys
import datetime
from json import dumps
from argparse import ArgumentParser
fromtimestamp = datetime.datetime.fromtimestamp

import anydbm

def chunk(it, slice=50):
    """Generate sublists from an iterator
    >>> list(chunk(iter(range(10)),11))
    [[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]]
    >>> list(chunk(iter(range(10)),9))
    [[0, 1, 2, 3, 4, 5, 6, 7, 8], [9]]
    >>> list(chunk(iter(range(10)),5))
    [[0, 1, 2, 3, 4], [5, 6, 7, 8, 9]]
    >>> list(chunk(iter(range(10)),3))
    [[0, 1, 2], [3, 4, 5], [6, 7, 8], [9]]
    >>> list(chunk(iter(range(10)),1))
    [[0], [1], [2], [3], [4], [5], [6], [7], [8], [9]]
    """

    assert(slice > 0)
    a=[]

    for x in it:
        if len(a) >= slice :
            yield a
            a=[]
        a.append(x)

    if a:
        yield a


class Seen:
    def __init__(self, filename):
        self.filename = filename

    def has_seen(self, key):
        d = anydbm.open(self.filename, 'c')
        res = str(key) in d
        d.close()
        return res

    def mark_seen(self, key):
        d = anydbm.open(self.filename, 'c')
        d[str(key)] = '1'
        d.close()

    def remove(self, key):
        d = anydbm.open(self.filename, 'c')
        del d[str(key)]
        d.close()

def reader(f):
    line = ''
    headers = {}
    it = iter(f)
    while not line.startswith("#types"):
        line = next(it).rstrip()
        k,v = line[1:].split(None, 1)
        headers[k] = v

    sep = headers['separator'].decode("string-escape")

    for k,v in headers.items():
        if sep in v:
            headers[k] = v.split(sep)

    headers['separator'] = sep
    fields = headers['fields']
    types = headers['types']
    set_sep = headers['set_separator']

    vectors = set(field for field, type in zip(fields, types) if type.startswith(("set[", "vector[")))

    for row in it:
        if row.startswith("#close"): break
        parts = row.rstrip().split(sep)
        parts = [p if p not in ('-', '(empty)') else None for p in parts]
        rec = dict(zip(fields, parts))
        for f in vectors:
            if rec[f] is not None:
                rec[f] = rec[f].split(set_sep)
        yield rec

last_ts = None
last_day = None
def fixts(ts):
    global last_ts
    global last_day
    if ts == last_ts:
        return last_day
    d =  fromtimestamp(int(ts)).strftime("%Y-%m-%d")
    last_ts = ts
    last_day = d
    return d

def float_to_int(v):
    return int(v[:v.index(".")])

def get_data(filename, cmd):
    f = os.popen("{} {}".format(cmd, filename))
    for rec in reader(f):
        # filter out None entries
        rec = {k: v for k, v in rec.items() if v is not None}


        rec['ts'] = rec['ts'].split(".")[0]
        rec['day'] = fixts(rec['ts'])
        if 'id.orig_h' in rec:
            rec['orig_h'] = rec.pop("id.orig_h")
            rec['orig_p'] = rec.pop("id.orig_p")
            rec['resp_h'] = rec.pop("id.resp_h")
            rec['resp_p'] = rec.pop("id.resp_p")
        if 'service' in rec:
            rec['service'] = rec['service'].split(",")
        if 'remote_location.country_code' in rec:
            rec['country_code'] = rec.pop('remote_location.country_code')
        if 'remote_location.region' in rec:
            rec['region'] = rec.pop('remote_location.region')
            rec['city'] = rec.pop('remote_location.city')
        if 'remote_location.latitude' in rec:
            rec['latitude'] = rec.pop('remote_location.latitude')
            rec['longitude'] = rec.pop('remote_location.longitude')

        if 'TTLs' in rec:
            rec['TTLs'] = [float_to_int(v) for v in rec['TTLs'] if v]
        if 'suppress_for' in rec:
            rec['suppress_for'] = float_to_int(rec['suppress_for'])
        yield rec

done = Seen("clickhouse.imported")

def do_import(filename, table, endpoint, cmd):
    query="INSERT INTO {} FORMAT JSONEachRow".format(table)
    data = get_data(filename, cmd)
    print filename,
    for i, block in enumerate(chunk(data, 50000)):
        block_id = '{}_{}'.format(filename, i)
        if done.has_seen(block_id):
            sys.stdout.write("#")
            continue
        blob = "\n".join(dumps(d) for d in block) + "\n"
        r = requests.post(endpoint, params=dict(query=query,input_format_skip_unknown_fields="1"), data=blob)
        r.raise_for_status()
        done.mark_seen(block_id)
        sys.stdout.write("#")
        sys.stdout.flush()
    print

def get_arguments():
    parser = ArgumentParser(description='This script allows to import Bro logs'
        ' into a clickhouse database.')
    parser.add_argument('table', metavar='TABLE', type=str,
        help='table to insert into')
    parser.add_argument('files', metavar='FILE', type=str, nargs='+',
        help='file(s) to import')
    parser.add_argument('-f', action='store_true', dest='force',
        help='force insert, although already done')
    parser.add_argument('-z', metavar='CMD', type=str, default='zcat',
        dest='cmd', help='command to extract logs (default: zcat)')
    parser.add_argument('-e', metavar='ENDPOINT', type=str, default='http://localhost:8123',
        dest='endpoint', help='database endpoint (default: http://localhost:8123)')
    return parser.parse_args()

def main():
    args = get_arguments()

    for f in args.files:
        if not args.force and done.has_seen(f):
            print f, 'already done'
            continue
        do_import(f, args.table, args.endpoint, args.cmd)
        done.mark_seen(f)

if __name__ == "__main__":
    main()
