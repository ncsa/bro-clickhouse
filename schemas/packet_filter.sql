create table packet_filter (
day Date DEFAULT toDate(ts),
ts DateTime,
node String,
filter String,
init Enum8('F'=0, 'T'=1),
success Enum8('F'=0, 'T'=1)
)
ENGINE = MergeTree(day,sipHash64(node), (day,sipHash64(node), node), 8192);
