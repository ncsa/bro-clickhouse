SELECT
    query,
    count() AS count,
    round((100 * count) /
    (
        SELECT count()
        FROM dns
        WHERE day = today() AND rcode_name='NXDOMAIN'
    ), 2) AS pct
FROM dns
WHERE day = today() AND rcode_name='NXDOMAIN'
GROUP BY query
ORDER BY count DESC
LIMIT 20
