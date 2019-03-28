create table socks (
day Date DEFAULT toDate(ts),
ts DateTime,
uid String,
orig_h String,
orig_p UInt16,
resp_h String,
resp_p UInt16,
version UInt16,
user Nullable(String),
status String,
request_host Nullable(String),
request_name Nullable(String),
request_p Nullable(UInt16),
bound_host String,
bound_name Nullable(String),
bound_p UInt16
)
ENGINE = MergeTree(day,sipHash64(uid), (day,sipHash64(uid), uid), 8192);
