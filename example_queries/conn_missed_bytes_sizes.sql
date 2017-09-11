SELECT
    roundToExp2(missed_bytes) AS size,
    count() AS count,
    bar(count, 0, 10000) AS b
FROM conn
WHERE day >= (today() - 1)
GROUP BY size
ORDER BY size ASC
