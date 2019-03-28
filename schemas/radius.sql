create table radius (
day Date DEFAULT toDate(ts),
ts DateTime,
uid String,
orig_h String,
orig_p UInt16,
resp_h String,
resp_p UInt16,
username Nullable(String),
mac Nullable(String),
remote_ip Nullable(String),
connect_info Nullable(String),
result String
)
ENGINE = MergeTree(day,sipHash64(uid), (day,sipHash64(uid), uid), 8192);
