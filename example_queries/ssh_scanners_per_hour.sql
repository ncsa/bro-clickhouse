SELECT
    toStartOfHour(ts) AS hour,
    uniq(orig_h) AS c,
    bar(c, 0, 2000)
FROM ssh
WHERE (auth_success != 'T') AND (day > (today() - 5))
GROUP BY hour
ORDER BY hour ASC
