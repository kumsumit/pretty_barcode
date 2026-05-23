# Publishing

Before publishing:

1. Ensure `pretty_qr_code` is available as a hosted dependency at the version in
   `pubspec.yaml`, or replace that dependency with the intended public source.
2. Remove `dependency_overrides` from `pubspec.yaml`.
3. Run:

   ```sh
   flutter pub get
   dart format --set-exit-if-changed lib example test
   flutter analyze
   flutter test
   flutter pub publish --dry-run
   ```

4. Verify the README examples compile against hosted dependencies.
5. Tag the release with the package version.

The workspace currently keeps `dependency_overrides` so development uses the
local source checkouts:

- `../dart_barcode/barcode`
- `../flutter_pretty_qr`

