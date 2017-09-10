select
    IPv4NumToStringClassC(IPv4StringToNum(orig_h)) as subnet,
    min(day) as first,
    groupUniqArray(orig_h) as hosts,
    groupUniqArray(resp_h) as dests
from ssh
where direction='INBOUND' and  auth_success='T'
group by subnet order by first desc limit 20
