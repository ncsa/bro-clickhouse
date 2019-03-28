create table ntlm (
day Date DEFAULT toDate(ts),
ts DateTime,
uid String,
orig_h String,
orig_p UInt16,
resp_h String,
resp_p UInt16,
username Nullable(String),
hostname String,
domainname Nullable(String),
success Enum8('F'=0, 'T'=1),
status String
)
ENGINE = MergeTree(day,sipHash64(uid), (day,sipHash64(uid), uid), 8192);
