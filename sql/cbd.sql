select :column_name, count(:column_name)
   from :schema_name.:table_name 
   group by :column_name
   order by count(:column_name) desc;