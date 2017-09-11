SELECT
    toStartOfHour(ts) AS hour,
    countIf(missed_bytes != 0) AS loss,
    count() AS total,
    (100 * loss) / total AS pct
FROM conn
WHERE day >= (today() - 1)
GROUP BY hour
ORDER BY hour ASC
