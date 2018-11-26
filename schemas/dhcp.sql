create table dhcp (
  day Date DEFAULT toDate(ts),
  ts DateTime,
  uid String,
  orig_h String,
  orig_p UInt16,
  resp_h String,
  resp_p UInt16,
  mac String,
  assigned_ip String,
  lease_time Float32,
  trans_id UInt32
)
ENGINE = MergeTree(day,cityHash64(uid), (day,cityHash64(uid), uid), 8192);
