SELECT
    resp_h,
    min(day) AS first,
    groupUniqArray(orig_h) as sources
FROM ssh
WHERE (direction = 'INBOUND') AND (auth_success = 'T')
GROUP BY resp_h
ORDER BY first DESC
LIMIT 20
