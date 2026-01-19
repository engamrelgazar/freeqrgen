plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.freeqrgenerator.freeqrgen"
    // Android 15 (API 35) for 16KB page size compliance
    compileSdk = 35
    // NDK r27+ supports 16KB page size
    ndkVersion = "27.2.12479018"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.freeqrgenerator.freeqrgen"
        // Minimum SDK 21 (Android 5.0) for broad compatibility
        minSdk = flutter.minSdkVersion
        // Target Android 15 (API 35) for 16KB page size compliance
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        
        // Explicitly declare 16KB page size support
        ndk {
            // Ensure all ABIs are built with 16KB page alignment
            abiFilters += listOf("armeabi-v7a", "arm64-v8a", "x86", "x86_64")
        }
    }

    buildTypes {
        release {
            // Enable code shrinking, obfuscation, and optimization
            isMinifyEnabled = true
            isShrinkResources = true
            
            // Use ProGuard rules for additional obfuscation
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
