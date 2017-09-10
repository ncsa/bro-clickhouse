SELECT
    resp_h,
    uniq(day) AS days,
    max(day) AS latest,
    countIf(auth_success = 'T') as success,
    countIf(auth_success = 'F') as failure,
    countIf(auth_success = '')  as unknown,
    uniqIf(orig_h, auth_success = 'T') AS success_sources,
    uniqIf(orig_h, auth_success != 'T') AS failure_sources
FROM default.ssh
WHERE (direction IN ('INBOUND', ''))
GROUP BY resp_h
HAVING success > 0
ORDER BY success_sources DESC
