SELECT
    if(client LIKE 'SSH-2.0-PuTTY_%', 'SSH-2.0-PuTTY_whatever', client) AS client,
    uniq(day) AS days,
    max(day) AS latest,
    uniqIf(orig_h, auth_success='T') AS success,
    uniqIf(orig_h, auth_success='F') AS failure,
    uniqIf(orig_h, auth_success='') AS unknown,
    uniq(orig_h) AS total
FROM default.ssh
WHERE (direction IN ('INBOUND', '')) and lower(client) like '%putty%'
GROUP BY client
ORDER BY success DESC
LIMIT 30
