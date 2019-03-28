create table irc (
day Date DEFAULT toDate(ts),
ts DateTime,
uid String,
orig_h String,
orig_p UInt16,
resp_h String,
resp_p UInt16,
nick Nullable(String),
user Nullable(String),
command String,
value String,
addl Nullable(String),
dcc_file_name Nullable(String),
dcc_file_size Nullable(UInt64),
dcc_mime_type Nullable(String),
fuid Nullable(String)
)
ENGINE = MergeTree(day,sipHash64(uid), (day,sipHash64(uid), uid), 8192);
