SELECT
    if(query LIKE 'common_prefix%', 'common_prefix', query) AS query,
    count() AS count,
    round((100 * count) /
    (
        SELECT count()
        FROM dns
        WHERE day = today()
    ), 2) AS pct
FROM dns
WHERE day = today()
GROUP BY query
ORDER BY count DESC
LIMIT 20
