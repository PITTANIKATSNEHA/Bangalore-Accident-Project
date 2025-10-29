USE SCHEMA ANALYTICS;

-- 1. Yearly trends with fatality rate
CREATE OR REPLACE VIEW v_yearly_trends AS
SELECT year, fatal_crashes, killed, non_fatal_crashes, total_crashes,
    ROUND((fatal_crashes * 100.0 / total_crashes), 2) AS fatal_crash_rate
FROM RAW_DATA.city_crashes
ORDER BY year;

-- 2. Top 10 most dangerous stations
CREATE OR REPLACE VIEW v_top_dangerous_stations AS
SELECT station, zone,
    SUM(total_crashes) AS total_crashes,
    SUM(killed) AS total_deaths,
    SUM(injured) AS total_injuries
FROM RAW_DATA.station_crashes
GROUP BY station, zone
ORDER BY total_crashes DESC
LIMIT 10;

-- 3. Zone summary
CREATE OR REPLACE VIEW v_zone_summary AS
SELECT zone,
    COUNT(DISTINCT station) AS num_stations,
    SUM(total_crashes) AS total_crashes,
    SUM(killed) AS total_deaths,
    ROUND(AVG(total_crashes), 2) AS avg_crashes_per_station
FROM RAW_DATA.station_crashes
GROUP BY zone
ORDER BY total_crashes DESC;

-- 4. Year-over-year comparison
CREATE OR REPLACE VIEW v_yoy_comparison AS
SELECT year, zone,
    SUM(total_crashes) AS total_crashes,
    SUM(killed) AS total_deaths
FROM RAW_DATA.station_crashes
GROUP BY year, zone;

-- 5. Zone × Year trend
CREATE OR REPLACE VIEW v_zone_yearly_trend AS
SELECT year, zone,
    SUM(total_crashes) AS total_crashes,
    SUM(killed) AS total_deaths,
    SUM(injured) AS total_injuries
FROM RAW_DATA.station_crashes
WHERE zone IS NOT NULL
GROUP BY year, zone
ORDER BY year, zone;

-- 6. Station growth analysis (useful for improvement scoring)
CREATE OR REPLACE VIEW v_station_growth_analysis AS
WITH base AS (
  SELECT station, zone, year, total_crashes, killed
  FROM RAW_DATA.station_crashes
  WHERE station IS NOT NULL
), agg AS (
  SELECT station, zone,
    MIN(year) AS first_year,
    MAX(year) AS last_year,
    COUNT(DISTINCT year) AS years_active,
    SUM(total_crashes) AS lifetime_crashes,
    SUM(killed) AS lifetime_deaths,
    MAX(total_crashes) AS peak_crash_year_count,
    MIN(total_crashes) AS lowest_crash_year_count,
    MAX_BY(year, total_crashes) AS peak_year,
    CASE WHEN SUM(total_crashes) = 0 THEN NULL ELSE ROUND(SUM(killed)::FLOAT / SUM(total_crashes), 4) END AS death_rate,
    CASE WHEN MIN(total_crashes) = 0 THEN NULL ELSE ROUND((MAX(total_crashes) - MIN(total_crashes))::FLOAT / NULLIF(MIN(total_crashes), 0), 2) END AS growth_factor
  FROM base
  GROUP BY station, zone
)
SELECT *, last_year AS current_year FROM agg WHERE lifetime_crashes > 0;
