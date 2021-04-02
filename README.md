# NewsGoose

* Browse Hacker News by day, similar to [hckrnews.com](https://hckrnews.com/)
* Set a points threshold
* Quickly search previous posts

## Purpose

* Help me check in on Hacker News when I have the time, without feeling like I need to visit the site every day.
* Search previous posts, sorted by date

## Data

Hckrnews.com stores its data at `/data/yyyymmdd.js`, one JSON file per day. The initial goal for this iOS app was to batch-import all the entries stored in these JSON files into a Core Data (or other format, read on for details) .sqlite file, and bundle it with the app. Newer posts would be fetched from the server to keep the database up-to-date. This would hopefully allow super-responsive browsing and searching (again, see below for details on search).

Although the data wasn't as consistent as I'd like. The "schema" has changed over the years, adding fields and changing fields' format slightly. I could have dealt with this with Codable, doing some manual decoding, but I was learning FastAPI, a python server-side framework, which uses Pydantic to validate data using python type annotations, so I used Pydantic to clean up the data instead. My downloader was written in python anyway, so I was already in the python mindset. Here's the Pydantic model:

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

I left `type`, `source`, and `time` optional for now; `points` and `comments` should be integers, but were sometimes stored as an empty string, so the `@validator` catches this and returns `None`/`nil` instead. These could easily be required fields, which would default to something like `0`. All the other fields are guaranteed by Pydantic to exist and not be null.

See [downloader.py](downloader.py) and [pydantic_cleaner.py](pydantic_cleaner.py) for details.

## Importing

After downloading and cleaning the `.js` files, I run `importJSToCoreData()` on my Mac to import all the posts into Core Data.

```swift
func importJSToCoreData() {
        var idsSeen = Set<String>()
        for filePath in getDataFilePaths() {
            let url = URL(fileURLWithPath: filePath)
            let data = try! Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            let postReps = try! decoder.decode([PostRepresentation].self, from: data)
            
            for postRep in postReps {
                if !idsSeen.contains(postRep.id) {
                    Post(movieRepresentation: postRep, calendar: calendar)
                    idsSeen.insert(postRep.id)
                }
            }
            try! CoreDataStack.shared.save()
        }
        print("id count: \(idsSeen.count)")
    }
```

I was curious if there were any duplicate `id`s in the data, so I created an `idsSeen` set to make sure to not add any duplicates to Core Data. Since the DB is starting from empty, we can safely keep track in memory and not query the DB before inserting each post. The count (382,309 posts!) without checking the `id` turned out to be the same, but it was a good quick check.

In order to group posts by date sections in a TableView, multiple posts must share the exact date with each other. The problem is that `post.date` stores time information as well as the date, so each post on the same day has a slightly different `date` value. The `Post` convenience initializer takes in a `Calendar` and uses it to calculate a new Date at time zero to save to an additional `day` field for comparison.

```swift
self.day = calendar.startOfDay(for: movieRepresentation.date)
```

## Browsing

Implementing browsing with Core Data worked fairly well. I used a `NSFetchedResultsController` (FRC), which makes dealing with sections and data changes very easy. Loading all posts at once was too slow, so I limit to the most recent 3000 posts, which is plenty fast while changing the post points threshold value. A future improvement would load more posts after scrolling to the bottom of the list.

A segmented control lets the user select the points threshold of the posts that are visible. The default is 300+, but can be changed to All, 100+, 300+, or 500+. When the value is changed, we create a new NSPredicate, give it to the FRC, tell the FRC to `performFetch()`, and tell the TableView to `reloadData()`.

## Search

Since the entire database of posts is small enough, (under 100mb) and can be bundled with the iOS app, I wanted to have a real-time search if possible. The user could start typing, and with each character typed they could get instant matching results. There is a problem, though. I learned that the local storage system I'm using, Core Data, does not have a full-text search capability, so while it's possible to search post titles, it has to loop through the whole data set to find them, which is not very fast. SQLite, which is used by Core Data under-the-hood, *does* have full-text search, but Core Data is not designed to take advantage of it.

For now the search is carried out when the user presses the Search button on the keyboard. Searching with Core Data is fast enough to give sub-second results, just not fast enough to search as the user types. The goal is to move to using SQLite directly, probably using [SQLite.swift](https://github.com/stephencelis/SQLite.swift) or [GRDB](https://github.com/groue/GRDB.swift).

## ToDo

- [ ] Use SQLite directly to make use of FTS5 full-text search
- [ ] Load new posts from official HN api on app launch
- [ ] Batch-add posts pre- 2010/6/9 to the DB from official HN api

