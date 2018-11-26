create table ssh (
day Date DEFAULT toDate(ts),
ts DateTime,
uid String,
orig_h String,
orig_p UInt16,
resp_h String,
resp_p UInt16,
version Enum8(''=0, '2'=1, '1'=2),
auth_success Enum8(''=0, 'T'=1, 'F'=2),
direction Enum8(''=0, 'INBOUND'=1, 'OUTBOUND'=2),
client String,
server String,
cipher_alg Enum8(''=0, 'arcfour'=1, 'aes256-ctr'=2, 'arcfour256'=3, 'aes128-ctr'=4, 'chacha20-poly1305@openssh.com'=5, 'aes128-cbc'=6, '3des-cbc'=7, 'Algorithm negotiation failed'=8,'aes128-gcm@openssh.com'=9,'aes256-cbc'=10,'arcfour128'=11,'aes256-gcm@openssh.com'=12,'blowfish-cbc'=13,'aes192-ctr'=14, 'cast128-cbc'=15, 'aes192-cbc'=16),
mac_alg Enum8(''=0, 'hmac-sha2-512-etm@openssh.com'=1, 'hmac-md5-etm@openssh.com'=2, 'hmac-sha2-256'=3, 'umac-64@openssh.com'=4, 'hmac-md5'=5, 'hmac-sha1'=6, 'hmac-sha1-etm@openssh.com'=7, 'umac-64-etm@openssh.com'=8,'hmac-sha2-256-etm@openssh.com'=9,'hmac-ripemd160'=10,'umac-128-etm@openssh.com'=11,'Algorithm negotiation failed'=12,'hmac-sha2-512'=13,'hmac-sha1-96'=14),
compression_alg Enum8(''=0, 'none'=1, 'zlib@openssh.com'=2,'zlib'=3,'Algorithm negotiation failed'=4),
kex_alg Enum8(''=0, 'diffie-hellman-group14-sha1'=1, 'diffie-hellman-group-exchange-sha256'=2, 'gss-gex-sha1-dZuIebMjgUqaxvbF7hDbAw=='=3, 'curve25519-sha256@libssh.org'=4, 'diffie-hellman-group1-sha1'=5, 'diffie-hellman-group-exchange-sha1'=6, 'ecdh-sha2-nistp521'=7, 'ecdh-sha2-nistp256'=8,'curve25519-sha256'=9, 'Algorithm negotiation failed'=10,'gss-gex-sha1-toWM5Slw5Ew8Mqkay+al2g=='=11,'gss-group16-sha512-vz8J1E9PzLr8b1K+0remTg=='=12,'gss-group1-sha1-toWM5Slw5Ew8Mqkay+al2g=='=13,'gss-group1-sha1-dZuIebMjgUqaxvbF7hDbAw=='=14,'gss-group1-sha1-vz8J1E9PzLr8b1K+0remTg=='=15,'gss-gex-sha1-vz8J1E9PzLr8b1K+0remTg=='=16),
host_key_alg Enum8(''=0, 'ssh-dss'=1, 'ssh-rsa'=2, 'ssh-ed25519'=3,'rsa-sha2-256'=4,'ecdsa-sha2-nistp256'=5,'ecdsa-sha2-nistp521'=6,'Algorithm negotiation failed'=7,'null'=8),
host_key FixedString(47),
country_code FixedString(2)
)
ENGINE = MergeTree(day,sipHash64(uid), (day,sipHash64(uid), uid), 8192);
