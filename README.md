# form_map

Foam Map

## Getting Started

Android #
Add Mapbox read token value in the application manifest android/app/src/main/AndroidManifest.xml:

  `<application ...
    <meta-data android:name="com.mapbox.token" android:value="YOUR_TOKEN_HERE" />`
iOS #
Add these lines to your Info.plist

`<key>io.flutter.embedded_views_preview</key>
<true/>
<key>MGLMapboxAccessToken</key>
<string>YOUR_TOKEN_HERE</string>`