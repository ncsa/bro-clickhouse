create table syslog
(
	day Date default toDate(ts),
	ts DateTime,
	uid String,
	orig_h String,
	orig_p UInt16,
	resp_h String,
	resp_p UInt16,
	proto Enum8('tcp' = 1, 'udp' = 2),
	facility Enum8('ALERT' = 1, 'AUTH' = 2, 'AUTHPRIV' = 3, 'CRON' = 4, 'DAEMON' = 5, 'KERN' = 6, 'LOCAL0' = 7, 'LOCAL1' = 8, 'LOCAL2' = 9, 'LOCAL3' = 10, 'LOCAL4' = 11, 'LOCAL5' = 12, 'LOCAL6' = 13, 'LOCAL7' = 14, 'MAIL' = 15, 'NTP' = 16, 'SYSLOG' = 17, 'USER' = 18),
	severity Enum8('ALERT' = 1, 'CRIT' = 2, 'DEBUG' = 3, 'ERR' = 4, 'INFO' = 5, 'NOTICE' = 6, 'WARNING' = 7, 'EMERG' = 8),
	message String,
	schema UInt32
)
engine = MergeTree(day, (day, facility), 8192);

