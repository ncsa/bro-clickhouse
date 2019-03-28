create table reporter (
day Date DEFAULT toDate(ts),
ts DateTime,
level String,
message String,
location Nullable(String)
)
ENGINE = MergeTree(day,sipHash64(message), (day,sipHash64(message), message), 8192);
