import java.util.Base64
import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// The MapKit key is never committed. It comes from --dart-define=YANDEX_MAPKIT_KEY
// (Flutter forwards dart-defines to Gradle), then from `yandex.mapkit.key` in the
// untracked android/local.properties, then from the YANDEX_MAPKIT_KEY env variable.
val dartDefines: Map<String, String> =
    (project.findProperty("dart-defines") as String?)
        ?.split(",")
        ?.map { String(Base64.getDecoder().decode(it)) }
        ?.filter { it.contains("=") }
        ?.associate { it.substringBefore("=") to it.substringAfter("=") }
        ?: emptyMap()
val localProperties = Properties().apply {
    val file = rootProject.file("local.properties")
    if (file.exists()) file.inputStream().use { load(it) }
}
val yandexMapkitKey: String =
    dartDefines["YANDEX_MAPKIT_KEY"]
        ?: localProperties.getProperty("yandex.mapkit.key")
        ?: System.getenv("YANDEX_MAPKIT_KEY")
        ?: ""

android {
    namespace = "uz.oxunov.tidy.client"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    buildFeatures {
        buildConfig = true
    }

    defaultConfig {
        buildConfigField("String", "YANDEX_MAPKIT_KEY", "\"$yandexMapkitKey\"")
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "uz.oxunov.tidy.client"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        // yandex_mapkit needs API 26.
        minSdk = 26
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
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

dependencies {
    // The lite variant of the MapKit SDK, see yandexMapkit.variant in gradle.properties.
    implementation("com.yandex.android:maps.mobile:4.39.1-lite")
}

flutter {
    source = "../.."
}
