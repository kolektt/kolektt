import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.kolektt.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "28.0.13004108"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.kolektt.app"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        // Override the default debug signing config
        getByName("debug") {
            storeFile = file("debug.keystore") // Ensure this file exists in the specified location
            storePassword = "android"           // Default debug store password
            keyAlias = "androiddebugkey"        // Default key alias for debug keystore
            keyPassword = "android"             // Default key password
        }
        // Create a release signing configuration from properties
        create("release") {
            val properties = Properties().apply {
                load(FileInputStream(file("key.properties")))
            }
            storeFile = file(properties["key.store.file"] as String)
            storePassword = properties["key.store.password"] as String
            keyAlias = properties["key.alias.name"] as String
            keyPassword = properties["key.alias.password"] as String
        }
    }

    buildTypes {
        getByName("debug") {
            signingConfig = signingConfigs.getByName("debug")
        }
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}
