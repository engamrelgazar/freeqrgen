# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep native methods
-keepclassmembers class * {
    native <methods>;
}

# Remove logging in release builds
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
    public static *** w(...);
}

# Keep file picker classes
-keep class androidx.** { *; }
-keep interface androidx.** { *; }

# Keep permission handler
-keep class com.baseflow.permissionhandler.** { *; }

# Keep path provider
-keep class io.flutter.plugins.pathprovider.** { *; }

# Keep file picker
-keep class com.mr.flutter.plugin.filepicker.** { *; }

# Keep share plus
-keep class dev.fluttercommunity.plus.share.** { *; }

# Obfuscate everything else
-repackageclasses ''
-allowaccessmodification
-optimizations !code/simplification/arithmetic,!code/simplification/cast,!field/*,!class/merging/*
