-- name: strc
-- generates 'select count(*) from ..' for each table in schema_name
select 'select count(*) from ' || table_schema || '.' || table_name || ';'
   from information_schema.tables
   where table_schema = :'schema_name';