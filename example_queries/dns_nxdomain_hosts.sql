SELECT
    orig_h,
    uniq(query) AS count
FROM dns
WHERE day = today() AND rcode_name='NXDOMAIN'
GROUP BY orig_h
ORDER BY count DESC
LIMIT 20
