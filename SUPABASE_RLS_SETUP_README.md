# Supabase RLS Setup for booking_history Table

This document provides the complete SQL script to configure your `booking_history` table with Row Level Security (RLS) and proper default values.

## 📋 What This Script Does

1. **✅ Ensures Default Status Value**: Sets the `status` column to default to `'pending'` for all new records
2. **🔒 Enables Row Level Security**: Activates RLS on the `booking_history` table
3. **🛡️ Creates Permissive RLS Policies**: Allows all users to perform all operations (SELECT, INSERT, UPDATE, DELETE)
4. **🧪 Tests the Setup**: Inserts test data and verifies the configuration works correctly

## 🚀 How to Use

### Step 1: Run the SQL Script
1. Open your Supabase Dashboard
2. Go to the **SQL Editor**
3. Copy and paste the entire contents of `setup_booking_history_rls.sql`
4. Click **Run** to execute the script

### Step 2: Verify the Results
The script will show you:
- ✅ Table structure verification
- ✅ RLS status confirmation
- ✅ Policy creation results
- ✅ Test data insertion
- ✅ Status default verification

## 📊 Expected Output

After running the script, you should see:

```
✅ Status column default value set to 'pending'
✅ RLS enabled on booking_history table
✅ 4 RLS policies created successfully
✅ 3 test bookings inserted
✅ All test bookings have status = 'pending' by default
```

## 🔧 RLS Policies Created

| Policy Name | Operation | Description |
|-------------|-----------|-------------|
| `Allow all users to read bookings` | SELECT | Allows all users to read booking data |
| `Allow all users to insert bookings` | INSERT | Allows all users to create new bookings |
| `Allow all users to update bookings` | UPDATE | Allows all users to modify existing bookings |
| `Allow all users to delete bookings` | DELETE | Allows all users to delete bookings |

## 🧪 Test Data

The script inserts 3 test bookings:
- **Test Restaurant 1**: Downtown Location, Table for 2, $50 deposit
- **Test Restaurant 2**: Uptown Location, Table for 4, $75 deposit  
- **Test Restaurant 3**: Midtown Location, Table for 6, $100 deposit

All test bookings will have `status = 'pending'` by default.

## 🔍 Verification Queries

After running the script, you can verify everything works with these queries:

```sql
-- Check RLS is enabled
SELECT tablename, rowsecurity FROM pg_tables WHERE tablename = 'booking_history';

-- Check policies exist
SELECT policyname, cmd FROM pg_policies WHERE tablename = 'booking_history';

-- Check default status values
SELECT id, restaurant_name, status FROM booking_history ORDER BY created_at DESC LIMIT 5;

-- Count by status
SELECT status, COUNT(*) FROM booking_history GROUP BY status;
```

## 🛠️ Troubleshooting

### If RLS is not enabled:
```sql
ALTER TABLE public.booking_history ENABLE ROW LEVEL SECURITY;
```

### If policies are missing:
```sql
-- Recreate all policies
CREATE POLICY "Allow all users to read bookings" ON public.booking_history FOR SELECT TO public USING (true);
CREATE POLICY "Allow all users to insert bookings" ON public.booking_history FOR INSERT TO public WITH CHECK (true);
CREATE POLICY "Allow all users to update bookings" ON public.booking_history FOR UPDATE TO public USING (true) WITH CHECK (true);
CREATE POLICY "Allow all users to delete bookings" ON public.booking_history FOR DELETE TO public USING (true);
```

### If default status is not working:
```sql
ALTER TABLE public.booking_history ALTER COLUMN status SET DEFAULT 'pending';
```

## 🧹 Cleanup (Optional)

To remove test data after verification:
```sql
DELETE FROM public.booking_history WHERE restaurant_name LIKE 'Test Restaurant%';
```

## 📱 Flutter Integration

Your Flutter app is now ready to use the booking service with the updated table structure:

```dart
// The BookingService will now store additional fields:
// - location (from restaurant.location)
// - time (from seat data)
// - seats (from seat data)
// - deposit (calculated from seat data)
// - refund (calculated from deposit and restaurant.refundAmount)
// - status (defaults to 'pending' from database)
```

## 🔐 Security Notes

- **Current Setup**: All users can perform all operations (permissive for development)
- **Production**: Consider implementing user-specific policies for production use
- **Authentication**: Ensure your Flutter app is properly authenticated with Supabase

## 📞 Support

If you encounter any issues:
1. Check the Supabase logs in the Dashboard
2. Verify your table structure matches the expected schema
3. Ensure RLS policies are correctly applied
4. Test with the verification queries provided above
