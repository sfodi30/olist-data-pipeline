select
    lpad("geolocation_zip_code_prefix"::varchar, 5, '0') as geolocation_zip_code_prefix,
    "geolocation_lat" as geolocation_lat,
    "geolocation_lng" as geolocation_lng,
    "geolocation_city" as geolocation_city,
    "geolocation_state" as geolocation_state

from {{ source('raw', 'geolocation') }}