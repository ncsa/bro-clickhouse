create table http (
  day Date DEFAULT toDate(ts),
  ts DateTime,
  uid String,
  orig_h String,
  orig_p UInt16,
  resp_h String,
  resp_p UInt16,
  trans_depth UInt16,
  method Enum8('GET'=1,'POST'=2,'PUT'=3,'DELETE'=4, 'HEAD'=5, 'OPTIONS'=6, 'HI'=7, 'AB' = 8, 'CONNECT' = 9),
  host String,
  uri String,
  referrer Nullable(String),
  version String,
  user_agent String,
  request_body UInt32,
  status_code UInt16,
  status_msg String,
  info_code Nullable(UInt16),
  info_msg Nullable(String),
  tags Array(String),
  username Nullable(String),
  password Nullable(String),
  proxied Array(Nullable(String)),
  orig_fuids Array(Nullable(String)),
  orig_filenames Array(Nullable(String)),
  orig_mime_types	Array(Nullable(String)),
  resp_fuids Array(Nullable(String)),
  resp_filenames	Array(Nullable(String)),
  resp_mime_types Array(Nullable(String))


)
  ENGINE = MergeTree(day,cityHash64(uid), (day,cityHash64(uid), uid), 8192);
