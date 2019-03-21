create table signatures (
day Date DEFAULT toDate(ts),
ts DateTime,
src_addr String,
src_port UInt16,
dst_addr String,
dst_port UInt16,
note String,
sig_id String,
event_msg String,
sub_msg String,
sig_count Nullable(UInt32),
host_count Nullable(UInt32)
)
ENGINE = MergeTree(day,sipHash64(src_addr), (day,sipHash64(src_addr), src_addr), 8192);
