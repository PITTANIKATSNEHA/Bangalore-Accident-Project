# Bengaluru Road Crash Trend Dashboard (2007–2024)

This project delivers a complete end-to-end portfolio case study of Bangalore's road accidents, using Snowflake for data warehousing and Tableau for analytics/visualization. Data-driven insights help pinpoint dangerous zones, high-risk stations, and track city-wide improvements over fifteen years.

## Overview Highlights
- 97,614 crashes, 13,934 deaths, and 18,000+ injuries (2007–2024)
- Crashes dropped by 48.4% since 2007—major safety improvement
- West and East Zones are the riskiest; South is significantly safer
- Ten stations cause most fatalities—targeted intervention = high impact
- Improvement is visible, yet certain stations/zones still need urgent action  
- Interactive dashboards: Trends, Zone-wise, Hotspots, Year-on-Year, and Growth Analysis

## Live Tableau Public Dashboard
[Explore Dashboard on Tableau Public](https://public.tableau.com/app/profile/sneha.pittanikat/viz/RoadcrashTrendDashboard/KPIs)

## Project Structure
├── data/
│ ├── city_crashes.csv
│ ├── station_crashes.csv
│ └── blackspots.csv
├── snowflake/
│ ├── create_tables.sql
│ ├── create_views.sql
│ └── analysis_queries.sql
├── tableau/
│ ├── RoadcrashTrendDashboard.twbx
│ └── screenshots/
│ ├── overview.png
| ├── Trend.png
│ ├── zone.png
│ ├── hotspots.png
│ ├── comparison.png
│ └── improvement.png
├── README.md
├── analysis_notes.md
