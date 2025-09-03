# RoxNewsReader 📰

A SwiftUI iOS app that fetches and displays top headlines with bookmarking, filtering, and search from newapi.org

---

## Screenshots


---

## Setup Instructions

1. Clone the repo:
   ```bash
   git clone https://github.com/ava12nish/RoxNewsReader.git
   cd RoxNewsReader
   ```
2. Open in Xcode:
   ```
   open RoxNewsReader.xcodeproj
   ```
3. Build & run on an iOS simulator or device.

Architecture
   SwiftUI + MVVM (for the most Apple native feel)
   - FeedViewModel manages article fetching & state.
   - Views (FeedView, ArticleRowView, ArticleDetailView, BookmarksView) are kept declarative & reactive.
   Networking
   - NewsAPIClient encapsulates API calls.
   - Models (Article, Category) are Codable and decoupled from DTOs.
   Persistence
   - BookmarkStore uses UserDefaults (simple for prototype).
   Design System
   - Rox-inspired pills, cards, typography, accent color, and glow effects are applied consistently.

Features
- Fetch & display top headlines with images, title, source, and snippet
- Bookmark articles with persistent storage
- Search headlines
- Category filter
- Company filter
- Tried to add some Rox styling to the app's UI as well :)

Extra credit
- Bookmarks
- Filtering
- AI features
  - Was really excited for this and tried to implement the relatively new Apple Foundation Models Framework.
  - Spent most of time trying to figure this out as I haven't used it before.
  - But cannot use Apple Intelligence on the simulators.
  - And need iOS 26 on iPhone if you want to make it work when you deploy it on a personal phone.
  - still coded it out and in theory should work.

Notes:
- The bookmarks use UserDefaults but in an actual app should probably implement Core Data.
- The filter only stays in the feed view. But in a larger app would probably want a shared store.
- Would also want to implement retry (for the top articles headlines) and offline cache in a real app.
- Faced a bunch of errors with the AI portion and just when I thought it was good to go realized it would only work on iOS 26+
- however pretty certain apps made by Apple and use Apple Intelligence work on iOS 18+ but makes sense since it's their products lol
- Would also want to secure the api keys on a real app.
