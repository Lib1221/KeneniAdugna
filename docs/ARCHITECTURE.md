# Architecture

A Flutter memorial app with a media gallery, life summary, and short-video feed. Media is hosted on Cloudinary; Firebase provides auth and data.

## Modules (`keneniapp/lib/`)

| File / folder | Role |
| ------------- | ---- |
| `main.dart`, `firebase_options.dart` | App entry and Firebase init |
| `splash_screen.dart` | Launch screen |
| `Gallery/` | Photo grid and full-screen viewer (cached network images from Cloudinary) |
| `video/`, `videoPlayer.dart` | Vertical swipe video feed, TikTok-style playback |
| `life_summary/` | Biography and timeline pages |
| `upload.dart` | Upload flow to Cloudinary (unsigned preset) with Firestore metadata |
| `fav.dart` | Favorites stored per user |
| `notifaction.dart`, `permission.dart` | Push notification setup and runtime permissions |

## Data flow

```
Upload -> Cloudinary (asset URL) -> Firestore document {url, type, caption, createdAt}
Gallery/Video -> Firestore query -> render from Cloudinary URLs
```

Web builds of this app are published in `About_memorial_web_app` and `keneni_memorial_web_app`.
