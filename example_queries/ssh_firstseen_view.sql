CREATE MATERIALIZED VIEW ssh_servers
ENGINE = AggregatingMergeTree(d, (resp_h), 8192)
POPULATE
AS SELECT
    toDate('2000-01-01') d,
    resp_h,
    uniqState(day) AS days,
    minState(ts) as first,
    maxState(ts) as last,
    sumState(caseWithoutExpr(auth_success = 'T', 1, 0)) AS success,
    sumState(caseWithoutExpr(auth_success = 'F', 1, 0)) AS failure,
    sumState(caseWithoutExpr(auth_success = '', 1, 0)) AS unknown,
    uniqState(orig_h) AS sources
FROM ssh
GROUP BY resp_h;
