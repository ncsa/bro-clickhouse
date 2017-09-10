SELECT
    resp_h,
    uniq(day) AS days,
    max(day) AS latest,
    countIf(auth_success='T') AS success,
    countIf(auth_success='F') AS failure,
    countIf(auth_success='') AS unknown,
    uniqIf(orig_h, auth_success='T') AS success_sources,
    uniqIf(orig_h, auth_success!='T') AS other_sources
FROM default.ssh
WHERE (direction IN ('INBOUND', ''))
GROUP BY resp_h
HAVING success = 0
ORDER BY failure DESC
