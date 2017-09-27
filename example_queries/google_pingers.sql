SELECT
    orig_h,
    uniqExact(day) AS days,
    min(day) AS first,
    max(day) AS last
FROM
(
    SELECT
        day,
        orig_h,
        sum(orig_pkts) AS pkts
    FROM conn
    WHERE (day > '2017-09-01') AND (proto = 'icmp') AND (resp_h = '8.8.8.8')
    GROUP BY
        day,
        orig_h
    HAVING pkts > 5000
)
GROUP BY orig_h
HAVING days > 4
