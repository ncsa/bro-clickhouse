SELECT
    day,
    uniq(orig_h) AS c,
    bar(c, 0, 20000)
FROM ssh
WHERE (auth_success != 'T') AND (day > (today() - 30))
GROUP BY day
ORDER BY day ASC
