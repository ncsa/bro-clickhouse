SELECT
    resp_h,
    uniqMerge(days),
    minMerge(first),
    maxMerge(last),
    sumMerge(success),
    sumMerge(failure),
    sumMerge(unknown),
    uniqMerge(sources)
FROM ssh_servers
GROUP BY resp_h
