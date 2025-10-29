-- Compare last 3 years with first 3 years
WITH early_period AS (
    SELECT 
        SUM(total_crashes) AS early_crashes,
        SUM(killed) AS early_deaths
    FROM RAW_DATA.city_crashes
    WHERE year BETWEEN 2007 AND 2009
),
recent_period AS (
    SELECT 
        SUM(total_crashes) AS recent_crashes,
        SUM(killed) AS recent_deaths
    FROM RAW_DATA.city_crashes
    WHERE year BETWEEN 2022 AND 2024
)
SELECT 
    early_crashes,
    recent_crashes,
    ROUND(((recent_crashes - early_crashes)::FLOAT / early_crashes) * 100, 2) AS pct_change,
    CASE 
        WHEN recent_crashes < early_crashes THEN '✅ IMPROVING'
        WHEN recent_crashes > early_crashes THEN '⚠️ WORSENING'
        ELSE 'STABLE'
    END AS trend
FROM early_period, recent_period;
----------------------------------------------------
-- Zone performance: 2018 vs 2024
WITH zone_2018 AS (
    SELECT zone, SUM(total_crashes) AS crashes_2018
    FROM RAW_DATA.station_crashes
    WHERE year = 2018
    GROUP BY zone
),
zone_2024 AS (
    SELECT zone, SUM(total_crashes) AS crashes_2024
    FROM RAW_DATA.station_crashes
    WHERE year = 2024
    GROUP BY zone
)
SELECT 
    z18.zone,
    z18.crashes_2018,
    z24.crashes_2024,
    ROUND(((z24.crashes_2024 - z18.crashes_2018)::FLOAT / z18.crashes_2018) * 100, 2) AS pct_change,
    z24.crashes_2024 - z18.crashes_2018 AS absolute_change
FROM zone_2018 z18
LEFT JOIN zone_2024 z24 ON z18.zone = z24.zone
ORDER BY pct_change;
---------------------------------------------------
-- Current year hotspots
SELECT 
    RANK() OVER (ORDER BY total_crashes DESC) AS rank,
    station,
    zone,
    total_crashes,
    fatal_crashes,
    killed,
    non_fatal_crashes,
    injured,
    ROUND((killed::FLOAT / total_crashes), 2) AS severity_rate
FROM RAW_DATA.station_crashes
WHERE year = 2024
ORDER BY rank
LIMIT 20;
-------------------------------------------------------
-- Which type of crash is most lethal?
SELECT 
    year,
    ROUND((SUM(killed)::FLOAT / SUM(fatal_crashes)), 2) AS deaths_per_fatal_crash,
    SUM(fatal_crashes) AS total_fatal_crashes,
    SUM(non_fatal_crashes) AS total_non_fatal_crashes,
    ROUND(((SUM(fatal_crashes)::FLOAT / (SUM(fatal_crashes) + SUM(non_fatal_crashes))) * 100), 2) AS fatal_crash_rate_pct
FROM RAW_DATA.city_crashes
GROUP BY year
ORDER BY year DESC;
-----------------------------------------------------
-- Stations showing positive change (improvement)
WITH station_year_data AS (
    SELECT 
        station,
        zone,
        year,
        total_crashes,
        LAG(total_crashes) OVER (PARTITION BY station ORDER BY year) AS prev_year_crashes
    FROM RAW_DATA.station_crashes
    WHERE year >= 2021
),
improvements AS (
    SELECT 
        station,
        zone,
        MAX(year) AS latest_year,
        SUM(CASE WHEN total_crashes < COALESCE(prev_year_crashes, total_crashes) THEN 1 ELSE 0 END) AS improving_years,
        COUNT(*) AS total_years,
        SUM(total_crashes) AS total_crashes_recent_period
    FROM station_year_data
    GROUP BY station, zone
    HAVING COUNT(*) >= 2
)
SELECT 
    station,
    zone,
    latest_year,
    improving_years,
    total_years,
    total_crashes_recent_period,
    ROUND((improving_years::FLOAT / total_years) * 100, 0) AS improvement_rate_pct
FROM improvements
WHERE improving_years > 0
ORDER BY improvement_rate_pct DESC, total_crashes_recent_period DESC
LIMIT 15;
