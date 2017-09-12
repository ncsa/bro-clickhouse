#!/usr/bin/env python
import os
import sys
from json import dumps
import itertools
from collections import OrderedDict

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

    vectors = set(field for field, type in zip(fields, types) if type.startswith("vector["))

    for row in it:
        if row.startswith('#'):
            if row.startswith('#fields'):
                fields = row.rstrip()[1:].split(None, 1)[1].split(sep)
            continue
        parts = row.rstrip().split(sep)
        parts = [p if p != '-' else '' for p in parts]
        if len(parts) != len(fields):
            continue
        rec = OrderedDict(zip(fields, parts))
        for f in vectors:
            if f in rec:
                rec[f] = rec[f].split(set_sep)
        yield rec

def maybe_float(v):
    try:
        return float(v)
    except ValueError:
        return None
def maybe_int(v):
    try:
        return int(v)
    except ValueError:
        return None

class Determinator:
    def __init__(self, field):
        self.field = field
        self.uniques = set()
        self.all_int = True
        self.all_float = True
        self.max_number = 0
        self.is_list = False
        self.max_length = 0
        self.min_length = 1000
        
    def add(self, val):
        if val == '-':
            return
        if val == '(empty)':
            val = []
        if self.is_list or isinstance(val, list):
            self.is_list = True
            return
        int_val = None

        if self.all_int:
            int_val = maybe_int(val)
            self.all_int = int_val is not None
        if self.all_float:
            self.all_float = maybe_float(val) is not None
        if int_val is not None:
            self.max_number = max(self.max_number, int_val)

        if len(self.uniques) < 100:
            self.uniques.add(val)

        if isinstance(val, basestring):
            self.max_length = max(self.max_length, len(val))
            if val != '':
                self.min_length = min(self.min_length, len(val))

#conn_state Enum8('OTH'=0, 'REJ'=1, 'RSTO'=2, 'RSTOS0'=3, 'RSTR'=4, 'RSTRH'=5, 'S0'=6, 'S1'=7, 'S2'=8, 'S3'=9, 'SF'=10, 'SH'=11, 'SHR'=12),
    def enum(self):
        fields = ["'{0}'={1}".format(val, i) for (i, val) in enumerate(self.uniques)]
        inner = ', '.join(fields)
        return 'Enum8({0})'.format(inner)


    def schema(self):
        if self.field == 'ts':
            return 'DateTime'
        if self.is_list:
            return 'Array(String)'
        if len(self.uniques) < 40:
            return self.enum()

        if self.all_int:
            return 'UInt16' if self.max_number < 65536 else 'UInt64'
        if self.all_float:
            return 'Float32' #or 64?
        
        if self.min_length == self.max_length:
            return 'FixedString({0})'.format(self.min_length)

        return 'String'
    def info(self):
        print "uniques:", len(self.uniques)
        print "all int:", self.all_int
        print "all float:", self.all_float
        print "max number:", self.max_number
        print "is list:", self.is_list
        print "min length:", self.min_length
        print "max length:", self.max_length

        if len(self.uniques) < 5:
            print "uniques:", self.uniques
        

def main():
    records = reader(sys.stdin)

    first = next(records)
    fields = OrderedDict()
    for k,v in first.items():
        fields[k]=Determinator(k)
        fields[k].add(v)

    for rec in records:
        for k, v in rec.items():
            fields[k].add(v)

    for k,v in fields.items():
        #print k
        #v.info()
        print "{0} {1},".format(k, v.schema())


if __name__ == "__main__":
    main()
