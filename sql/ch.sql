-- name: ch.sql
-- generates 10 bucket column_histogram
-- source, https://tapoueh.org/blog/2014/02/postgresql-aggregates-and-histograms/
with crange as (
    select min(:column_name) as min,
           max(:column_name) as max
      from :schema_name.:table_name
),
     histogram as (
   select width_bucket(:column_name, c.min, c.max, 9) as bucket,
          int4range(min(:column_name), 
                    max(:column_name), '[]') as range,
          count(*) as freq
     from :schema_name.:table_name, crange c
     group by bucket
     order by bucket
)
 select bucket, range, freq,
        repeat('■',
               (   freq::float
                 / max(freq) over()
                 * 30
               )::int
        ) as bar
   from histogram;