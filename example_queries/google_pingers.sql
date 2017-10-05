SELECT
    orig_h,
    uniqExact(day) AS days,
    min(day) AS first,
    max(day) AS last,
    sum(pkts) AS total_packets,
    max(pkts) AS most_packets_per_day
FROM
(
    SELECT
        day,
        orig_h,
        sum(orig_pkts) AS pkts
    FROM conn
    -- orig_p is icmp type, type 8 == echo.
    WHERE (day > '2017-09-01') AND (proto = 'icmp') AND (resp_h = '8.8.8.8') AND (orig_p == 8)
    GROUP BY
        day,
        orig_h
    HAVING pkts > 5000
)
GROUP BY orig_h
HAVING days > 4

