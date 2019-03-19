create table ftp (
day Date DEFAULT toDate(ts),
ts DateTime,
uid String,
orig_h String,
orig_p UInt16,
resp_h String,
resp_p UInt16,
user String,
password Nullable(String),
command String,
arg Nullable(String),
mime_type Nullable(String),
file_size Nullable(Float64),
reply_code Nullable(Float64),
reply_msg Nullable(String),
passive Nullable(Enum8('F'=0, 'T'=1)),
data_channel_orig_h Nullable(String),
data_channel_resp_h Nullable(String),
data_channel_resp_p Nullable(UInt16),
fuid Nullable(String)
)
ENGINE = MergeTree(day,sipHash64(uid), (day,sipHash64(uid), uid), 8192);
