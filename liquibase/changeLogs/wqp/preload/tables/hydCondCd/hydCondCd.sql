create unlogged table if not exists ${NWIS_WS_STAR_SCHEMA_NAME}.hyd_cond_cd
(hyd_cond_cd                    character varying (1)    primary key
,hyd_cond_srt_nu                integer
,hyd_cond_vld_fg                boolean
,hyd_cond_nm                    character varying (64)
,hyd_cond_ds                    character varying (512)
) with (fillfactor = 100);
