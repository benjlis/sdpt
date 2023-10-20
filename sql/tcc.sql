-- name: tcc
-- generates 'select count(column), count(distinct) from ..' 
-- for each column in schema_name.table_name
with select_stmt (code, line_number) as
    (select 'select count(*) row_cnt', 0
     union all
     select ', count(' || column_name || ') ' || 
                column_name || '_cnt, ' ||
            'count(distinct ' || column_name || ') ' ||
                column_name || '_dist',
            ordinal_position
        from information_schema.columns
        where table_schema = :'schema_name' and 
              table_name = :'table_name'
     union all
     select 'from ' || table_schema || '.' || table_name || ';', 
            max(ordinal_position)+1
        from information_schema.columns
        where table_schema = :'schema_name' and 
              table_name = :'table_name'
        group by table_schema, table_name)
select code from select_stmt order by line_number;