name: dev_studio
description: A professional developer studio application with dark theme.
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.6
  webview_flutter: ^4.4.4
  http: ^1.1.0
  shared_preferences: ^2.2.2
  url_launcher: ^6.2.2
  flutter_slidable: ^3.0.1
  intl: ^0.19.0
  provider: ^6.1.1
  shimmer: ^3.0.0
  flutter_animate: ^4.3.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1

flutter:
  uses-material-design: true
  assets:
    - assets/
```