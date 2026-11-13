plugins {
    id("com.android.application")
    // Plugin Firebase (Google Services) dipasang secara kondisional di bagian
    // bawah berkas ini, supaya proyek tetap bisa di-build tanpa
    // google-services.json (berkas itu tidak di-commit, lihat .gitignore).
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.sera_z"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.sera_z"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

// Firebase hanya diaktifkan bila google-services.json sudah disalin ke
// android/app/. Build debug tetap boleh jalan untuk uji UI, tetapi build
// release wajib punya konfigurasi Firebase.
val membangunRelease = gradle.startParameter.taskNames.any {
    it.contains("release", ignoreCase = true)
}
if (file("google-services.json").exists()) {
    apply(plugin = "com.google.gms.google-services")
} else if (membangunRelease) {
    throw GradleException(
        "google-services.json wajib ada untuk build release. " +
            "Letakkan berkasnya di android/app/google-services.json."
    )
} else {
    logger.lifecycle(
        "google-services.json tidak ditemukan: build debug tanpa Firebase. " +
            "Login Google tidak akan berfungsi."
    )
}
