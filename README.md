# NewsGoose

* Browse Hacker News by day, similar to [hckrnews.com](https://hckrnews.com/)
* Set a points threshold
* Quickly search posts

## Purpose

* Help me check in on Hacker News when I have the time, without feeling like I need to visit the site every day.
* Quickly search past posts sorted by date

## Data

Hckrnews.com stores its data at `/data/yyyymmdd.js`, one JSON file per day. My goal for making this for iOS was to batch-import all the entries stored in these JSON files into a Core Data (or other format, read on for details) .sqlite file, and bundle it with the app. Newer posts would be fetched from the server to keep the database up-to-date. This would hopefully allow super-responsive browsing and searching (again, see below for details on search).

