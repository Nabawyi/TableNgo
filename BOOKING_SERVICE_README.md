# Booking Service Integration

This document explains how to use the new BookingService class to manage restaurant bookings with Supabase.

## Setup Instructions

### 1. Create the Database Table

Run the SQL script in your Supabase SQL editor:

```sql
-- Copy and paste the contents of create_booking_history_table.sql
-- This will create the booking_history table with proper indexes
```

### 2. Import the Service

```dart
import 'package:tablengo/services/booking_service.dart';
import 'package:tablengo/Subapase/subabase.dart';
```

### 3. Usage Examples

#### Adding a Booking

```dart
// Create an instance of the service
final bookingService = BookingService();
final supabaseService = SupabaseService();

// When user books a table
Future<void> bookTable(ResturantData restaurant, int seatIndex, DateTime bookingDate) async {
  try {
    // Add booking to database
    final bookingId = await bookingService.addBooking(restaurant, seatIndex, bookingDate);
    
    // Or use the SupabaseService method (backward compatibility)
    // final bookingId = await supabaseService.addBooking(restaurant, seatIndex, bookingDate);
    
    print('Booking created with ID: $bookingId');
  } catch (e) {
    print('Error creating booking: $e');
  }
}
```

#### Fetching Bookings

```dart
// Fetch all bookings
Future<void> loadBookings() async {
  try {
    final bookings = await bookingService.fetchBookings();
    // Use the bookings list in your UI
    print('Loaded ${bookings.length} bookings');
  } catch (e) {
    print('Error loading bookings: $e');
  }
}
```

#### Updating Booking Status

```dart
// Update booking status
Future<void> updateBookingStatus(int bookingId, String newStatus) async {
  try {
    final success = await bookingService.updateStatus(bookingId, newStatus);
    if (success) {
      print('Booking status updated successfully');
    } else {
      print('Failed to update booking status');
    }
  } catch (e) {
    print('Error updating booking status: $e');
  }
}
```

## Database Schema

The `booking_history` table has the following structure:

| Column | Type | Description |
|--------|------|-------------|
| id | bigint | Primary key (auto-generated) |
| restaurant_id | bigint | Reference to restaurant |
| restaurant_name | text | Restaurant name (denormalized) |
| restaurant_image | text | Restaurant image URL (denormalized) |
| seat_index | int | Selected seat index |
| booking_date | timestamptz | Booking date and time |
| status | text | Booking status (default: 'pending') |
| created_at | timestamptz | Creation timestamp |

## Available Methods

### BookingService Class

- `addBooking(ResturantData restaurant, int seatIndex, DateTime bookingDate)` → Returns booking ID
- `fetchBookings()` → Returns List<BookingItem> ordered by booking_date desc
- `updateStatus(int id, String newStatus)` → Updates booking status
- `getBookingById(int id)` → Returns specific booking
- `deleteBooking(int id)` → Deletes a booking

### SupabaseService Class (Backward Compatibility)

- `addBooking(ResturantData restaurant, int seatIndex, DateTime bookingDate)` → Returns booking ID
- `fetchBookings()` → Returns List<BookingItem> ordered by booking_date desc
- `updateStatus(int id, String newStatus)` → Updates booking status

## Integration with Existing UI

The existing UI components (`BookingCard.dart`, `MyBookingHistoy.dart`) can now be connected to the database:

1. **BookingPage**: When user clicks "Book Now", call `addBooking()` method
2. **MyBookingHistoy**: Use `fetchBookings()` to load bookings from database
3. **BookingCard**: Display booking data from database instead of local state

## Debug Information

All methods include debug prints that will show:
- 🔵 When operations start
- ✅ When operations succeed
- ❌ When operations fail
- 📊 Data counts and statistics

## Error Handling

All methods use proper async/await with try/catch blocks to handle:
- Network errors
- Database connection issues
- Invalid data
- Permission errors

## Next Steps

1. Run the SQL script in Supabase to create the table
2. Update your UI components to use the service methods
3. Test the integration with sample data
4. Add proper error handling in your UI components
