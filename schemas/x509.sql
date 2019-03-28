create table x509 (
day Date DEFAULT toDate(ts),
ts DateTime,
id String,
version UInt16,
serial String,
subject Nullable(String),
issuer Nullable(String),
not_valid_before DateTime,
not_valid_after Datetime,
key_alg String,
sig_alg String,
key_type String,
key_length UInt16,
exponent String,
curve String,
dns Array(Nullable(String)),
uri Array(Nullable(String)),
email Array(Nullable(String)),
ip Array(Nullable(String)),
ca Enum8('F'=0, 'T'=1),
path_len Nullable(UInt64)
)
ENGINE = MergeTree(day,sipHash64(id), (day,sipHash64(id), id), 8192);
