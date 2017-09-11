SELECT
    day,
    query,
    count() AS count,
    uniq(orig_h) AS hosts
FROM dns
WHERE day > (today() - 7)
GROUP BY
    day,
    query
ORDER BY
    day ASC,
    count DESC
LIMIT 2 BY day
