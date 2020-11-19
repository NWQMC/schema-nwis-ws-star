create trigger set_timestamp_discrete_ground_water
before update on ${NWIS_SCHEMA_NAME}.discrete_ground_water
for each row
execute procedure ${NWIS_SCHEMA_NAME}.trigger_set_timestamp();
