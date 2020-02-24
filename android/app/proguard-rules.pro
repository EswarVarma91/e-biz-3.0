## Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-keep class app.loup.geolocation.** { *; }
-keepclasseswithmembers class * {
        @com.squareup.moshi.* <methods>;
    }

   -keep @com.squareup.moshi.JsonQualifier interface *

    # Enum field names are used by the integrated EnumJsonAdapter.
    # values() is synthesized by the Kotlin compiler and is used by EnumJsonAdapter indirectly
    # Annotate enums with @JsonClass(generateAdapter = false) to use them with Moshi.
   -keepclassmembers @com.squareup.moshi.JsonClass class * extends java.lang.Enum {
        <fields>;
        **[] values();
    }
-dontwarn javax.annotation.**
-dontwarn io.flutter.embedding.**
