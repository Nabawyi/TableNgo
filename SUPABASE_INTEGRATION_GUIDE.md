# Supabase Booking History Integration Guide

This guide will help you integrate your Flutter app with Supabase to display dynamic booking data instead of static data.

## 📋 What You'll Get

✅ **Dynamic Data**: Bookings fetched from Supabase database  
✅ **Real-time Updates**: Status changes reflected immediately  
✅ **Proper RLS**: Secure database access with Row Level Security  
✅ **Error Handling**: Graceful error handling and loading states  
✅ **Pull-to-Refresh**: Easy data refresh functionality  

## 🚀 Step-by-Step Setup

### Step 1: Run the SQL Script

1. Open your **Supabase Dashboard**
2. Go to **SQL Editor**
3. Copy and paste the entire contents of `supabase_booking_setup.sql`
4. Click **Run** to execute the script

This will:
- ✅ Set default status to 'pending'
- ✅ Enable Row Level Security
- ✅ Create permissive RLS policies
- ✅ Insert test data
- ✅ Verify everything works

### Step 2: Update Your Flutter App

#### Option A: Replace Existing Files (Recommended)

Replace your existing files with the new Supabase-enabled versions:

```bash
# Backup your existing files first
cp lib/Screens/booking_history.dart lib/Screens/booking_history_backup.dart
cp lib/WedgetsC/booking_card.dart lib/WedgetsC/booking_card_backup.dart

# Use the new Supabase versions
cp lib/Screens/supabase_booking_history.dart lib/Screens/booking_history.dart
cp lib/WedgetsC/supabase_booking_card.dart lib/WedgetsC/booking_card.dart
```

#### Option B: Update Navigation (Alternative)

Update your navigation to use the new Supabase screens:

```dart
// In your navigation code, replace:
Navigator.push(context, MaterialPageRoute(builder: (context) => MyBookingHistoy(...)))

// With:
Navigator.push(context, MaterialPageRoute(builder: (context) => const SupabaseBookingHistory()))
```

### Step 3: Update Your Booking Creation

When users create bookings, use the BookingService:

```dart
// In your booking page, when user clicks "Book Now":
final bookingService = BookingService();

try {
  final bookingId = await bookingService.addBooking(
    restaurant,
    selectedSeatIndex,
    DateTime.now(),
  );
  
  print('Booking created with ID: $bookingId');
  
  // Navigate to booking history
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const SupabaseBookingHistory(),
    ),
  );
} catch (e) {
  print('Error creating booking: $e');
  // Show error message to user
}
```

## 🔧 Key Features

### 1. Dynamic Status Display
- **Pending**: Orange badge
- **Completed**: Green badge  
- **Cancelled**: Red badge
- **Confirmed**: Blue badge

### 2. Real-time Data
- Fetches bookings from Supabase on screen load
- Pull-to-refresh functionality
- Loading states and error handling

### 3. Status Management
- Tap any booking card to update status
- Status changes are saved to database
- Success/error feedback to user

### 4. Database Integration
- Uses your existing `BookingService` class
- Proper error handling with try/catch
- Debug prints for troubleshooting

## 📱 UI Components

### SupabaseBookingCard
- Displays booking information from database
- Dynamic status badges
- Real booking IDs from database
- Responsive to status changes

### SupabaseBookingHistory
- Fetches data from Supabase
- Loading and error states
- Pull-to-refresh functionality
- Status update dialogs

## 🧪 Testing Your Setup

### 1. Verify Database Setup
Run this query in Supabase SQL Editor:
```sql
SELECT id, restaurant_name, status, created_at 
FROM booking_history 
ORDER BY created_at DESC 
LIMIT 5;
```

### 2. Test Flutter App
1. Create a new booking in your app
2. Navigate to booking history
3. Verify the booking appears with 'pending' status
4. Tap the booking to change status
5. Verify the status updates in the database

### 3. Check Debug Logs
Look for these debug messages in your Flutter console:
- 🔵 `BookingService: Adding booking for restaurant...`
- ✅ `BookingService: Successfully added booking with ID: X`
- 🔵 `SupabaseBookingHistory: Loading bookings from Supabase...`
- 📊 `SupabaseBookingHistory: Loaded X bookings`

## 🛠️ Troubleshooting

### Common Issues

#### 1. "No bookings yet" message
- **Cause**: No data in database or RLS blocking access
- **Solution**: Check if test data was inserted, verify RLS policies

#### 2. "Failed to load bookings" error
- **Cause**: Network issue or RLS policy problem
- **Solution**: Check Supabase connection, verify RLS policies

#### 3. Status not updating
- **Cause**: RLS policy blocking updates
- **Solution**: Verify UPDATE policy is correctly set

#### 4. Bookings not appearing after creation
- **Cause**: Booking not saved to database
- **Solution**: Check BookingService.addBooking() is being called

### Debug Queries

Check your database setup:
```sql
-- Verify RLS is enabled
SELECT tablename, rowsecurity FROM pg_tables WHERE tablename = 'booking_history';

-- Check policies exist
SELECT policyname, cmd FROM pg_policies WHERE tablename = 'booking_history';

-- Check data exists
SELECT COUNT(*) FROM booking_history;

-- Check status distribution
SELECT status, COUNT(*) FROM booking_history GROUP BY status;
```

## 🔐 Security Notes

- **Current Setup**: All users can perform all operations (permissive for development)
- **Production**: Consider implementing user-specific policies
- **Authentication**: Ensure your Flutter app is properly authenticated

## 📞 Support

If you encounter issues:

1. **Check Supabase Logs**: Go to Dashboard → Logs
2. **Verify Table Structure**: Ensure columns match expected schema
3. **Test RLS Policies**: Run verification queries
4. **Check Flutter Logs**: Look for debug print statements
5. **Verify Network**: Ensure Supabase connection is working

## 🎉 Next Steps

Once everything is working:

1. **Remove Test Data**: Delete test bookings from database
2. **Add User Authentication**: Implement user-specific RLS policies
3. **Add More Features**: Booking cancellation, refunds, etc.
4. **Optimize Performance**: Add pagination for large booking lists
5. **Add Notifications**: Real-time updates when bookings change

Your booking system is now fully integrated with Supabase! 🚀
