-- =====================================================
-- BOOKING HISTORY TABLE SETUP WITH RLS POLICIES
-- =====================================================
-- This script configures the booking_history table with:
-- 1. Default status value enforcement
-- 2. Row Level Security (RLS) enabled
-- 3. Permissive RLS policies for all operations
-- 4. Test data insertion and verification

-- =====================================================
-- STEP 1: ENSURE DEFAULT STATUS VALUE
-- =====================================================

-- First, let's check if the table exists and its current structure
SELECT 
    column_name, 
    data_type, 
    column_default, 
    is_nullable
FROM information_schema.columns 
WHERE table_name = 'booking_history' 
    AND table_schema = 'public'
ORDER BY ordinal_position;

-- Update the default value for status column if it doesn't exist or is different
DO $$
BEGIN
    -- Check if the default constraint exists and update it
    IF EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'booking_history' 
        AND column_name = 'status' 
        AND table_schema = 'public'
    ) THEN
        -- Alter the column to ensure default value is 'pending'
        ALTER TABLE public.booking_history 
        ALTER COLUMN status SET DEFAULT 'pending';
        
        RAISE NOTICE 'Status column default value set to ''pending''';
    ELSE
        RAISE NOTICE 'Status column not found in booking_history table';
    END IF;
END $$;

-- =====================================================
-- STEP 2: ENABLE ROW LEVEL SECURITY (RLS)
-- =====================================================

-- Enable RLS on the booking_history table
ALTER TABLE public.booking_history ENABLE ROW LEVEL SECURITY;

-- Verify RLS is enabled
SELECT 
    schemaname, 
    tablename, 
    rowsecurity as rls_enabled
FROM pg_tables 
WHERE tablename = 'booking_history' 
    AND schemaname = 'public';

-- =====================================================
-- STEP 3: CREATE RLS POLICIES
-- =====================================================

-- Drop existing policies if they exist (to avoid conflicts)
DROP POLICY IF EXISTS "Allow all users to read bookings" ON public.booking_history;
DROP POLICY IF EXISTS "Allow all users to insert bookings" ON public.booking_history;
DROP POLICY IF EXISTS "Allow all users to update bookings" ON public.booking_history;
DROP POLICY IF EXISTS "Allow all users to delete bookings" ON public.booking_history;

-- Policy 1: Allow all users to SELECT (read) data
CREATE POLICY "Allow all users to read bookings" 
ON public.booking_history 
FOR SELECT 
TO public 
USING (true);

-- Policy 2: Allow all users to INSERT data
CREATE POLICY "Allow all users to insert bookings" 
ON public.booking_history 
FOR INSERT 
TO public 
WITH CHECK (true);

-- Policy 3: Allow all users to UPDATE data
CREATE POLICY "Allow all users to update bookings" 
ON public.booking_history 
FOR UPDATE 
TO public 
USING (true) 
WITH CHECK (true);

-- Policy 4: Allow all users to DELETE data
CREATE POLICY "Allow all users to delete bookings" 
ON public.booking_history 
FOR DELETE 
TO public 
USING (true);

-- =====================================================
-- STEP 4: VERIFY RLS POLICIES
-- =====================================================

-- List all policies for the booking_history table
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual,
    with_check
FROM pg_policies 
WHERE tablename = 'booking_history' 
    AND schemaname = 'public'
ORDER BY policyname;

-- =====================================================
-- STEP 5: TEST DATA INSERTION
-- =====================================================

-- Insert test booking records to verify default status and RLS
INSERT INTO public.booking_history (
    restaurant_name,
    restaurant_image,
    location,
    seat_index,
    booking_date,
    time,
    seats,
    deposit,
    refund
    -- Note: status is not specified, should default to 'pending'
) VALUES 
(
    'Test Restaurant 1',
    'https://example.com/restaurant1.jpg',
    'Downtown Location',
    1,
    NOW() + INTERVAL '1 day',
    '7:00 PM',
    'Table for 2',
    50.00,
    10.00
),
(
    'Test Restaurant 2',
    'https://example.com/restaurant2.jpg',
    'Uptown Location',
    3,
    NOW() + INTERVAL '2 days',
    '8:30 PM',
    'Table for 4',
    75.00,
    15.00
),
(
    'Test Restaurant 3',
    'https://example.com/restaurant3.jpg',
    'Midtown Location',
    2,
    NOW() + INTERVAL '3 days',
    '6:00 PM',
    'Table for 6',
    100.00,
    20.00
);

-- =====================================================
-- STEP 6: VERIFY TEST DATA
-- =====================================================

-- Select the last few records to confirm status defaults to 'pending'
SELECT 
    id,
    restaurant_name,
    location,
    seat_index,
    booking_date,
    time,
    seats,
    deposit,
    refund,
    status,
    created_at
FROM public.booking_history 
ORDER BY created_at DESC 
LIMIT 5;

-- Count records by status to verify defaults
SELECT 
    status,
    COUNT(*) as count
FROM public.booking_history 
GROUP BY status
ORDER BY status;

-- =====================================================
-- STEP 7: TEST UPDATE OPERATION
-- =====================================================

-- Test updating a booking status
UPDATE public.booking_history 
SET status = 'completed' 
WHERE restaurant_name = 'Test Restaurant 1';

-- Verify the update
SELECT 
    id,
    restaurant_name,
    status,
    created_at
FROM public.booking_history 
WHERE restaurant_name = 'Test Restaurant 1';

-- =====================================================
-- STEP 8: FINAL VERIFICATION
-- =====================================================

-- Final check: Show all current bookings with their status
SELECT 
    'Current booking_history table status:' as info;

SELECT 
    id,
    restaurant_name,
    status,
    booking_date,
    created_at
FROM public.booking_history 
ORDER BY created_at DESC;

-- Show RLS status
SELECT 
    'RLS Status:' as info,
    tablename,
    rowsecurity as rls_enabled
FROM pg_tables 
WHERE tablename = 'booking_history' 
    AND schemaname = 'public';

-- Show policy count
SELECT 
    'Policy Count:' as info,
    COUNT(*) as total_policies
FROM pg_policies 
WHERE tablename = 'booking_history' 
    AND schemaname = 'public';

-- =====================================================
-- CLEANUP (OPTIONAL - COMMENT OUT IF YOU WANT TO KEEP TEST DATA)
-- =====================================================

-- Uncomment the following lines if you want to clean up test data:
-- DELETE FROM public.booking_history WHERE restaurant_name LIKE 'Test Restaurant%';
-- SELECT 'Test data cleaned up' as cleanup_status;
