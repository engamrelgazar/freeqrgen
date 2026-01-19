# Android 16KB Compliance - Quick Reference

## ✅ Status: COMPLIANT

Your app is ready for Google Play submission with Android 15 (API 35) targeting.

---

## Build Commands

### Build Release AAB (for Google Play)
```bash
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab`

### Build Release APK (for testing)
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

---

## Testing on 16KB Device

### Check Device Page Size
```bash
adb shell getconf PAGESIZE
```
- `4096` = 4KB (legacy)
- `16384` = 16KB (modern)

### Install & Test
```bash
flutter install --release
```

---

## What Was Changed

| File | Change | Reason |
|------|--------|--------|
| `android/app/build.gradle.kts` | `compileSdk = 35` | Android 15 support |
| `android/app/build.gradle.kts` | `targetSdk = 35` | 16KB requirement |
| `android/app/build.gradle.kts` | `ndkVersion = "27.2.12479018"` | 16KB native support |
| `android/app/build.gradle.kts` | Added ABI filters | Proper library inclusion |

---

## Key Configuration

```kotlin
android {
    compileSdk = 35              // ✅ Android 15
    ndkVersion = "27.2.12479018" // ✅ 16KB support
    
    defaultConfig {
        minSdk = 21              // ✅ Android 5.0+
        targetSdk = 35           // ✅ Android 15
        
        ndk {
            abiFilters += listOf(
                "armeabi-v7a",   // 32-bit ARM
                "arm64-v8a",     // 64-bit ARM
                "x86",           // 32-bit Intel
                "x86_64"         // 64-bit Intel
            )
        }
    }
}
```

---

## Verification Checklist

Before submitting to Google Play:

- [ ] Build AAB successfully: `flutter build appbundle --release`
- [ ] Test on Android 15 device/emulator
- [ ] Verify no crashes on app launch
- [ ] Check QR generation works
- [ ] Test file export (PNG/PDF)
- [ ] Verify permissions work
- [ ] Review Google Play Console pre-launch report

---

## Toolchain Versions

| Component | Version | Status |
|-----------|---------|--------|
| Flutter | 3.38.5 | ✅ |
| Dart | 3.10.4 | ✅ |
| AGP | 8.11.1 | ✅ |
| Gradle | 8.14 | ✅ |
| Kotlin | 2.2.20 | ✅ |
| NDK | r27.2 | ✅ |
| compileSdk | 35 | ✅ |
| targetSdk | 35 | ✅ |

---

## Common Issues & Solutions

### Issue: "NDK not found"
**Solution**:
```bash
# Install NDK via Android Studio:
# Tools > SDK Manager > SDK Tools > NDK (Side by side)
# Select version 27.2.12479018
```

### Issue: "Unsupported compileSdk"
**Solution**: Update Android SDK Platform to API 35 in Android Studio

### Issue: Build fails with Gradle error
**Solution**:
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter build appbundle --release
```

---

## Resources

- [Full Compliance Report](./ANDROID_16KB_COMPLIANCE_REPORT.md)
- [Google Play 16KB Policy](https://developer.android.com/guide/practices/page-sizes)
- [Flutter Android 15 Guide](https://docs.flutter.dev/release/breaking-changes/android-15-page-size)

---

**Last Updated**: January 18, 2026  
**Next Review**: Before major Flutter SDK updates
