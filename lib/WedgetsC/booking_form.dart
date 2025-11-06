import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookingForm extends StatefulWidget {
  final int restaurantId;
  final Function(DateTime?, TimeOfDay?, int, double, double) onFormChanged;

  const BookingForm({
    super.key,
    required this.restaurantId,
    required this.onFormChanged,
  });

  @override
  State<BookingForm> createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final supabase = Supabase.instance.client;

  double depositPerPerson = 0.0;
  double refundPercent = 0.0;

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  int numberOfSites = 1;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRestaurantPricing();
  }

  Future<void> _fetchRestaurantPricing() async {
    try {
      final response = await supabase
          .from('restaurants')
          .select('deposit_per_person, refund_amount')
          .eq('id', widget.restaurantId)
          .maybeSingle();

      if (response != null) {
        setState(() {
          depositPerPerson = (response['deposit_per_person'] ?? 0.0).toDouble();
          refundPercent = (response['refund_amount'] ?? 0.0).toDouble();
          isLoading = false;
        });
        _notifyParent(); // Send initial data
      }
    } catch (e) {
      debugPrint('Error fetching restaurant data: $e');
      setState(() => isLoading = false);
    }
  }

  void _notifyParent() {
    widget.onFormChanged(
      selectedDate,
      selectedTime,
      numberOfSites,
      depositPerPerson,
      refundPercent,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final double deposit = depositPerPerson * numberOfSites;
    final double refundAmount = deposit * (refundPercent / 100);
    final double totalPayable = deposit - refundAmount;

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: double.infinity,
        height: 500,
        margin: const EdgeInsets.only(bottom: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              "Add your Booking Details",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),

            // Date picker
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) {
                  setState(() => selectedDate = picked);
                  _notifyParent();
                }
              },
              child: _pickerTile(
                label: selectedDate == null
                    ? 'Select Date'
                    : '${_getDayName(selectedDate!.weekday)} ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                icon: Icons.calendar_today,
              ),
            ),

            // Time picker
            InkWell(
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: selectedTime ?? TimeOfDay.now(),
                );
                if (picked != null) {
                  setState(() => selectedTime = picked);
                  _notifyParent();
                }
              },
              child: _pickerTile(
                label: selectedTime == null
                    ? 'Select Time'
                    : selectedTime!.format(context),
                icon: Icons.access_time,
              ),
            ),

            // Number of Sites
            _counterTile(),

            // Summary
            Container(
              padding: const EdgeInsets.all(10.0),
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Deposit per person: EGP $depositPerPerson"),
                  Text(
                    'Refund on arrival: $refundPercent%',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Total Payable: EGP ${totalPayable.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pickerTile({required String label, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Icon(icon, color: Colors.deepOrange),
        ],
      ),
    );
  }

  Widget _counterTile() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Number of Sites:', style: TextStyle(fontSize: 16)),
          Row(
            children: [
              IconButton(
                onPressed: numberOfSites > 1
                    ? () {
                        setState(() => numberOfSites--);
                        _notifyParent();
                      }
                    : null,
                icon: const Icon(Icons.remove_circle_outline),
                color: Colors.red,
              ),
              Text(
                '$numberOfSites',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() => numberOfSites++);
                  _notifyParent();
                },
                icon: const Icon(Icons.add_circle_outline),
                color: Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String _getDayName(int weekday) {
  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return days[weekday - 1];
}
