select
    roundToExp2(orig_ip_bytes+resp_ip_bytes) as size,
    count() as count,
    bar(count,0,5000000) as b
from conn
where day=today()
group by size order by size asc
