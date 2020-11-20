create trigger set_timestamp_groundwater_daily_value
before update on ${NWIS_SCHEMA_NAME}.groundwater_daily_value
for each row
execute procedure ${NWIS_SCHEMA_NAME}.trigger_set_timestamp();
