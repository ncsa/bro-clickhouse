SELECT
    resp_h,
    country_code,
    min(day) AS first
FROM ssh
WHERE (direction = 'INBOUND') AND (auth_success = 'T') AND country_code != '\0\0'
GROUP BY resp_h,country_code
ORDER BY first DESC
LIMIT 20
