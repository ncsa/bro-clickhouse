create table smb_mapping (
day Date DEFAULT toDate(ts),
ts DateTime,
uid String,
orig_h String,
orig_p UInt16,
resp_h String,
resp_p UInt16,
path String,
service String,
native_file_system Nullable(String),
share_type String
)
ENGINE = MergeTree(day,sipHash64(uid), (day,sipHash64(uid), uid), 8192);
