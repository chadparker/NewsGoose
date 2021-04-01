# NewsGoose

* Browse Hacker News by day, similar to [hckrnews.com](https://hckrnews.com/)
* Set a points threshold
* Quickly search posts

## Purpose

* Help me check in on Hacker News when I have the time, without feeling like I need to visit the site every day.
* Quickly search past posts sorted by date

## Data

Hckrnews.com stores its data at `/data/yyyymmdd.js`, one JSON file per day. The initial goal for this iOS app was to batch-import all the entries stored in these JSON files into a Core Data (or other format, read on for details) .sqlite file, and bundle it with the app. Newer posts would be fetched from the server to keep the database up-to-date. This would hopefully allow super-responsive browsing and searching (again, see below for details on search).

The data, though, wasn't as consistent as I'd like. The "schema" has changed over the years, adding fields and changing fields' format slightly. I could have dealt with this with Codable, doing some manual decoding, but I was learning FastAPI, a python server-side framework, which uses Pydantic to validate data using python type annotations, so I used it to clean up the data. My downloader was written in python anyway, so I was already in the python mindset. Here's the Pydantic model:

```python
class Post(BaseModel):

    id: str
    
    link_text: str
    link: str
    submitter: str

    type: Optional[str] = None
    source: Optional[str] = None
    dead: bool = False

    points: Optional[int] = None
    comments: Optional[int] = None
    
    date: int
    time: Optional[int] = None

    @validator('comments', 'points', pre=True)
    def none_value(cls, v):
        if v == '':
            return None
        return v
```

I left `type`, `source`, and `time` optional for now; `points` and `comments` should be integers, but were sometimes stored as an empty string, so the `@validator` catches this and returns `None`/`nil` instead. These could easily be required fields, which would default to `0`. All the other fields are guaranteed by Pydantic to exist.

See [downloader.py]() and [pydantic_cleaner.py]() for details.

## ToDo

- [ ] Load new posts from official HN api
- [ ] Add posts pre- 2010/6/9 from official HN api
