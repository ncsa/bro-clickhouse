create table dpd (
day Date DEFAULT toDate(ts),
ts DateTime,
uid String,
orig_h String,
orig_p UInt16,
resp_h String,
resp_p UInt16,
proto Enum8('icmp'=1, 'tcp'=6, 'udp'=17),
analyzer String,
failure_reason String
)
ENGINE = MergeTree(day,sipHash64(uid), (day,sipHash64(uid), uid), 8192);
