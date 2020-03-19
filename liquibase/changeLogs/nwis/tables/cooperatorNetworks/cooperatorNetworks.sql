create unlogged table if not exists ${NWIS_SCHEMA_NAME}.cooperator_networks
(cooperator_networks_id          integer generated by default as identity (start with 1)
,cooperator_id                   integer
,network_id                      integer
,primary key (cooperator_networks_id)
,constraint cooperator_net_uk unique (cooperator_id, network_id)
);