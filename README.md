# clickhouse stuff for bro

## Description

Schemas for conn, dns, ssh, and sql are in [schemas](schemas).  These work but the enums may need updating over time

Some examples queries are in [example_queries](example_queries)

[import_any.py](import_any.py) can be used to load logs into clickhouse.  It has only been
tested with the above schemas, but should work with all log types with little to no changes.

[generate_schema.py](generate_schema.py) can be used to work out the appropriate schema to use.
Pipe uncompressed bro ASCII log output to it and it will output the appropriate
schema for each field.  More data is required in order to generate the correct
enum definitions.  This tool is slow and not perfect, but is still useful for
coming up with a starting point.

Currently the scripts only work for bro ASCII logs, but a version that can
import json logs would be easy to write.

## Usage
If you have any alarms for .ru traffic, this will light it up, you can also use the [docker image.](https://hub.docker.com/r/yandex/clickhouse-server/)
```
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv E0C56BD4    # optional

sudo apt-add-repository "deb http://repo.yandex.ru/clickhouse/trusty stable main"
sudo apt-get update

sudo apt-get install clickhouse-server-common clickhouse-client -y

sudo service clickhouse-server start
clickhouse-client
```
Check clickhouse is listening on localhost:8123, this should return 1:

`curl 'http://localhost:8123/?query=SELECT%201'`

Import schemas:

`cat schemas/dns.sql`

copy/paste this SQL into the :) prompt/clickhouse client.


Import some data:

`./import_any.py dns /nsm/bro/log/2017-10-10/dns*`

Check how much space this takes up for one day:

`du -h /var/lib/clickhouse/data/default --max-depth=1`

Try out an example query from example_queries directory.

Import rest of your data:

`./import_any.py dns /nsm/bro/log/20*/dns*`
