# RoxNewsReader 📰

A SwiftUI iOS app that fetches and displays top headlines with bookmarking, filtering, and search from newapi.org

---

## Screenshots
<img width="129.0" height="279.6" alt="IMG_6943" src="https://github.com/user-attachments/assets/00de9f0f-8b80-4fbe-b84a-2df2481c7e34" />
<img width="129.0" height="279.6" alt="IMG_6944" src="https://github.com/user-attachments/assets/251dd897-4bdc-4f35-8920-c8ee758cd102" />
<img width="129.0" height="279.6" alt="IMG_6945" src="https://github.com/user-attachments/assets/76388227-0c03-4c95-83c9-10aa15b14949" />
<img width="129.0" height="279.6" alt="IMG_6946" src="https://github.com/user-attachments/assets/7bb284ff-02e8-4220-8914-7cfe727f0c8a" />
<img width="129.0" height="279.6" alt="IMG_6947" src="https://github.com/user-attachments/assets/7090a8d8-c932-4022-8bca-26a515044e59" />


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
