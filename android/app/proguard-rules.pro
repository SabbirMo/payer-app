# Flutter Local Notifications
-keep class com.dexterous.flutterlocalnotifications.** { *; }

# Workmanager (Standard package names)
-keep class be.tramckas.workmanager.** { *; }
-keep class dev.fluttercommunity.workmanager.** { *; }
-keep class androidx.work.** { *; }

# Keep Flutter and its plugins
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep common classes that might be obfuscated
-keep class com.google.crypto.tink.** { *; }

# Fix R8 errors for missing Play Core classes (if not using deferred components)
-dontwarn com.google.android.play.core.**
-dontwarn io.flutter.embedding.engine.deferredcomponents.**

# Additional rules for Workmanager & background execution
-keep class * extends androidx.work.Worker { *; }
-keep class * extends androidx.work.ListenableWorker { *; }
-keepattributes Signature,Exceptions,Annotation
-keep class * extends io.flutter.plugin.common.MethodChannel$MethodCallHandler { *; }
-keep class * extends io.flutter.embedding.engine.plugins.FlutterPlugin { *; }

# Keep classes and methods with the @Keep annotation
-keep @interface androidx.annotation.Keep
-keep @androidx.annotation.Keep class * { *; }
-keep class * {
    @androidx.annotation.Keep *;
}

# Keep the callback dispatcher and entry points
-keepattributes *Annotation*
-keep class * {
    @io.flutter.annotation.Keep *;
}

# Explicitly keep Notification and Timezone plugins
-keep class net.wolverinebeach.flutter_timezone.** { *; }
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-dontwarn net.wolverinebeach.flutter_timezone.**
-dontwarn com.dexterous.flutterlocalnotifications.**
