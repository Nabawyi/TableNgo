class SupabaseConfig {
  // Supabase configuration
  static const String supabaseUrl = 'https://hahtppvichfutzsvydye.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhhaHRwcHZpY2hmdXR6c3Z5ZHllIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA0NDAwMjAsImV4cCI6MjA3NjAxNjAyMH0.4h3zolshVbylzwWw46CgrCi1yzZqQVZA6nRLRvzlQ0E';

  // Debug mode flag
  static const bool isDebugMode =
      bool.fromEnvironment('dart.vm.product') == false;

  // Logging configuration
  static bool get shouldLog => isDebugMode;
}
