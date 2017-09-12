clickhouse stuff for bro

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
