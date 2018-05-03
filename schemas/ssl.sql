create table ssl (
day Date DEFAULT toDate(ts),
ts DateTime,
uid String,
orig_h String,
orig_p UInt16,
resp_h String,
resp_p UInt16,
version Enum8(''=0, 'DTLSv12'=1, 'DTLSv10'=2, 'TLSv13-draft18'=3, 'TLSv12'=4, 'TLSv10'=5, 'TLSv11'=6, 'SSLv3'=7, 'SSLv2'=8, 'TLSv13-draft23'=9),
cipher String,
curve Enum8(''=0, 'sect571r1'=1, 'sect409k1'=2, 'sect283r1'=3, 'brainpoolP256r1'=4, 'x25519'=5, 'sect571k1'=6, 'brainpoolP384r1'=7, 'secp384r1'=8, 'sect409r1'=9, 'secp256r1'=10, 'secp256k1'=11, 'brainpoolP512r1'=12, 'sect283k1'=13, 'secp192r1'=14, 'secp224r1'=15, 'secp521r1'=16),
server_name String,
resumed Enum8('T'=0, 'F'=1),
last_alert String,
next_protocol Enum8(''=0, 'h2'=1, 'apns-pack-v1:4096:4096'=2, 'http/1.1'=3, 'spdy/3.1'=4, 'spdy/3'=5, 'webrtc'=6, 'grpc-exp'=7, 'bep-relay'=8, 'h2-14'=9, 'bep/1.0'=10),
established Enum8('T'=0, 'F'=1),
cert_chain_fuids Array(String),
client_cert_chain_fuids Array(String),
subject String,
issuer String,
client_subject String,
client_issuer String,
validation_status Enum8(''=0, 'self signed certificate'=1, 'self signed certificate in certificate chain'=2, 'permitted subtree violation'=3, 'unable to get local issuer certificate'=4, 'certificate has expired'=5, 'ok'=6, 'certificate signature failure'=7)
)
ENGINE = MergeTree(day,halfMD5(uid), (day,halfMD5(uid), uid), 8192);
