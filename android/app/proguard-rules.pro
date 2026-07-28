##########################################################
# ProGuard Rules - يُسر تطبيق
# يمنع R8 من حذف كلاسات Firebase والمكتبات الأساسية
##########################################################

# ===== Flutter =====
-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.**

# ===== Firebase Core =====
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# ===== Firebase Messaging (FCM) =====
-keep class com.google.firebase.messaging.** { *; }
-keepnames class com.google.firebase.messaging.FirebaseMessagingService
-keep class * extends com.google.firebase.messaging.FirebaseMessagingService

# ===== Firebase Realtime Database =====
-keep class com.google.firebase.database.** { *; }
-keepattributes Signature
-keepattributes *Annotation*

# ===== Flutter Local Notifications =====
-keep class com.dexterous.** { *; }
-dontwarn com.dexterous.**

# ===== Geolocator =====
-keep class com.baseflow.geolocator.** { *; }
-dontwarn com.baseflow.geolocator.**

# ===== Permission Handler =====
-keep class com.baseflow.permissionhandler.** { *; }

# ===== Dio / OkHttp =====
-dontwarn okhttp3.**
-dontwarn okio.**
-keep class okhttp3.** { *; }
-keep class okio.** { *; }

# ===== Jackson / JSON =====
-keepattributes Signature
-keepattributes *Annotation*
-keep class com.fasterxml.jackson.** { *; }
-dontwarn com.fasterxml.**

# ===== Kotlin Coroutines =====
-keep class kotlinx.coroutines.** { *; }
-dontwarn kotlinx.coroutines.**

# ===== General Android =====
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception
-keep class * implements android.os.Parcelable { *; }
