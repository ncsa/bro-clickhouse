create table files (
  day Date DEFAULT toDate(ts),
  ts DateTime,
  fuid String,
  tx_hosts Array(String),
  rx_hosts Array(String),
  conn_uids Array(String),
  source Enum8('SSL'=1, 'HTTP'=2,'DTLS'=3),
  depth UInt8,
  analyzers Array(Enum8('SHA1'=1, 'MD5'=2, 'X509'=3, 'NEMAJSEXTRACT'=4, 'NEMAHTMLEXTRACT'=5, 'SFAEXTRACT'=6)),
  mime_type String,
  filename Nullable(String),
  duration Float32,
  local_orig Enum8('F'=0, 'T'=1),
  is_orig Enum8('F'=0, 'T'=1),
  seen_bytes UInt16,
  total_bytes Nullable(UInt16),
  missing_bytes UInt16,
  overflow_bytes UInt16,
  timedout Enum8('F'=0, 'T'=1),
  parent_fuid Nullable(String),
  md5 String,
  sha1 String,
  sha256 Nullable(String),
  extracted Nullable(String),
  extracted_cutoff Nullable(Enum8('F'=0, 'T'=1)),
  extracted_size Nullable(UInt32)
)
ENGINE = MergeTree(day,cityHash64(fuid), (day,cityHash64(fuid), fuid), 8192);
