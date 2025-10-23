# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.

# Supabase Flutter rules
-keep class io.supabase.** { *; }
-keep class com.supabase.** { *; }
-keep class supabase.** { *; }

# Keep Supabase authentication classes
-keep class * extends io.supabase.flutter.postgrest.PostgrestBuilder
-keep class * extends io.supabase.flutter.postgrest.PostgrestFilterBuilder
-keep class * extends io.supabase.flutter.postgrest.PostgrestQueryBuilder

# Keep Supabase client and auth classes
-keep class io.supabase.flutter.SupabaseClient { *; }
-keep class io.supabase.flutter.auth.SupabaseAuth { *; }
-keep class io.supabase.flutter.auth.AuthResponse { *; }
-keep class io.supabase.flutter.auth.Session { *; }
-keep class io.supabase.flutter.auth.User { *; }

# Keep JSON serialization classes
-keep class com.google.gson.** { *; }
-keep class kotlinx.serialization.** { *; }

# Keep HTTP client classes
-keep class okhttp3.** { *; }
-keep class retrofit2.** { *; }

# Keep Flutter plugin classes
-keep class io.flutter.plugins.** { *; }

# Keep all native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep all classes with @Keep annotation
-keep @androidx.annotation.Keep class * { *; }

# Keep all classes in supabase package
-keep class supabase.** { *; }

# Keep all classes in io.supabase package
-keep class io.supabase.** { *; }

# Keep all classes in com.supabase package  
-keep class com.supabase.** { *; }
