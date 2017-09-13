SELECT
    client,
    sum(bytes) AS total_bytes,
    uniq(orig_h) as clients
FROM
(
    SELECT
        uid,
        orig_h,
        client
    FROM ssh
    WHERE day > today() -3
)
ANY LEFT JOIN
(
    SELECT
        uid,
        orig_bytes + resp_bytes AS bytes
    FROM conn
    WHERE (day > today() -3) AND (service = ['ssh'])
) USING (uid)
GROUP BY client
ORDER BY total_bytes DESC
LIMIT 20
