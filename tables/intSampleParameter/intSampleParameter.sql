create table int_sample_parameter
(nwis_host_nm                   varchar2(42 char)
,db_no                          varchar2(6 char)
,record_no                      varchar2(24 char)
,v71999                         varchar2(12 char)
,v50280                         varchar2(12 char)
,v72015                         varchar2(12 char)
,v82047                         varchar2(12 char)
,v72016                         varchar2(12 char)
,v82048                         varchar2(12 char)
,v00003                         varchar2(12 char)
,v00098                         varchar2(12 char)
,v78890                         varchar2(12 char)
,v78891                         varchar2(12 char)
,v82398                         varchar2(12 char)
,v84164                         varchar2(12 char)
,v71999_fxd_nm                  varchar2(20 char)
,v82398_fxd_tx                  varchar2(80 char)
,v84164_fxd_tx                  varchar2(80 char)
) parallel 4 compress pctfree 0 nologging;
