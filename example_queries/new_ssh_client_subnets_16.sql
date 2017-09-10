SELECT
    concat(splitByChar('.', orig_h)[1], '.', splitByChar('.', orig_h)[2]) AS subnet,
    min(day) AS first,
    groupUniqArray(orig_h) AS hosts,
    groupUniqArray(resp_h) AS dests
FROM ssh
WHERE (direction = 'INBOUND') AND (auth_success = 'T')
GROUP BY subnet
ORDER BY first DESC
LIMIT 20
