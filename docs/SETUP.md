# Setup

```bash
cd keneniapp
flutter pub get
flutterfire configure
flutter run
```

Configure Cloudinary: create an unsigned upload preset and set the cloud name and preset in the upload service. Enable Firestore and Authentication in Firebase.

Web build for GitHub Pages:

```bash
flutter build web --release --base-href "/keneni_memorial_web_app/"
```
