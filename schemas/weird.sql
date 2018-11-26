create table weird (
day Date DEFAULT toDate(ts),
ts DateTime,
uid Nullable(String),
orig_h Nullable(String),
orig_p Nullable(UInt16),
resp_h Nullable(String),
resp_p Nullable(UInt16),
name String,
addl Nullable(String),
notice Enum8('T'=0, 'F'=1),
peer String
)
-- i really don't want to make 'name' part of the PK, but everything else is nullable :(
ENGINE = MergeTree(day,sipHash64(name), (day,sipHash64(name), name), 8192);
