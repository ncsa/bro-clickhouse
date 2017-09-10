SELECT
    client,
    uniq(day) AS days,
    max(day) AS latest,
    countIf(auth_success = 'T') as success,
    countIf(auth_success = 'F') as failure,
    countIf(auth_success = '')  as unknown,
    uniq(orig_h) AS sources
FROM default.ssh
WHERE (direction IN ('INBOUND', ''))
GROUP BY client
HAVING success = 0
ORDER BY failure DESC
LIMIT 30
