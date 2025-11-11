// restaurant_pricing_page.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RestaurantPricingPage extends StatefulWidget {
  final int restaurantId;
  const RestaurantPricingPage({super.key, required this.restaurantId});
  @override
  State<RestaurantPricingPage> createState() => _RestaurantPricingPageState();
}

class _RestaurantPricingPageState extends State<RestaurantPricingPage> {
  final supabase = Supabase.instance.client;
  final _depositController = TextEditingController();
  final _refundController = TextEditingController();

  bool isLoading = true;
  bool isSaving = false;
  DateTime? lastUpdated;
  double currentDeposit = 0.0;
  double currentRefund = 0.0;

  @override
  void initState() {
    super.initState();
    _loadPricingData();
  }

  @override
  void dispose() {
    _depositController.dispose();
    _refundController.dispose();
    super.dispose();
  }

  Future<void> _loadPricingData() async {
    setState(() => isLoading = true);
    try {
      final response = await supabase
          .from('restaurants')
          .select('deposit_per_person, refund_amount, last_pricing_update')
          .eq('id', widget.restaurantId)
          .maybeSingle();

      if (response != null) {
        setState(() {
          currentDeposit = (response['deposit_per_person'] ?? 0).toDouble();
          currentRefund = (response['refund_amount'] ?? 0.0).toDouble();
          lastUpdated = response['last_pricing_update'] != null
              ? DateTime.parse(response['last_pricing_update'])
              : null;
          _depositController.text = currentDeposit.toStringAsFixed(2);
          _refundController.text = currentRefund.toStringAsFixed(2);
        });
      }
    } catch (e) {
      debugPrint('Error loading pricing: $e');
      _showMessage('Failed to load pricing data', isError: true);
    } finally {
      setState(() => isLoading = false);
    }
  }

  bool _canUpdateToday() {
    if (lastUpdated == null) return true;
    final now = DateTime.now();
    final lastUpdate = lastUpdated!;
    return now.year != lastUpdate.year ||
        now.month != lastUpdate.month ||
        now.day != lastUpdate.day;
  }

  Future<void> _savePricing() async {
    if (!_canUpdateToday()) {
      _showMessage('You can only update pricing once per day', isError: true);
      return;
    }

    final deposit = double.tryParse(_depositController.text);
    final refund = double.tryParse(_refundController.text);

    if (deposit == null || deposit < 0) {
      _showMessage('Please enter a valid deposit amount', isError: true);
      return;
    }

    if (refund == null || refund < 0 || refund > 100) {
      _showMessage('Refund must be between 0% and 100%', isError: true);
      return;
    }

    setState(() => isSaving = true);

    try {
      await supabase
          .from('restaurants')
          .update({
            'deposit_per_person': deposit.toInt(),
            'refund_amount': refund,
            'last_pricing_update': DateTime.now().toIso8601String(),
          })
          .eq('id', widget.restaurantId);

      await _loadPricingData();
      _showMessage('Pricing updated successfully!');
    } catch (e) {
      debugPrint('Error saving pricing: $e');
      _showMessage('Failed to update pricing', isError: true);
    } finally {
      setState(() => isSaving = false);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  String _getNextUpdateTime() {
    if (lastUpdated == null) return 'Now';
    final tomorrow = DateTime(
      lastUpdated!.year,
      lastUpdated!.month,
      lastUpdated!.day + 1,
    );
    final now = DateTime.now();
    if (now.isAfter(tomorrow)) return 'Now';

    final hours = tomorrow.difference(now).inHours;
    final minutes = tomorrow.difference(now).inMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  @override
  Widget build(BuildContext context) {
    final canUpdate = _canUpdateToday();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Pricing Settings'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade200, height: 1),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: canUpdate
                            ? [Colors.green.shade400, Colors.green.shade600]
                            : [Colors.orange.shade400, Colors.orange.shade600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: (canUpdate ? Colors.green : Colors.orange)
                              .withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          canUpdate ? Icons.check_circle : Icons.schedule,
                          color: Colors.white,
                          size: 48,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          canUpdate
                              ? 'You can update pricing today'
                              : 'Already updated today',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (!canUpdate)
                          Text(
                            'Next update available in ${_getNextUpdateTime()}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Current Values Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Pricing',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _InfoTile(
                              icon: Icons.account_balance_wallet,
                              label: 'Deposit per Person',
                              value: 'EGP ${currentDeposit.toStringAsFixed(0)}',
                              color: Colors.deepOrange,
                            ),
                            Container(
                              width: 1,
                              height: 60,
                              color: Colors.grey.shade200,
                            ),
                            _InfoTile(
                              icon: Icons.replay,
                              label: 'Refund Amount',
                              value: '${currentRefund.toStringAsFixed(0)}%',
                              color: Colors.green,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Update Form
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Update Pricing',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Deposit Input
                        _InputField(
                          controller: _depositController,
                          label: 'Deposit per Person',
                          hint: '0',
                          icon: Icons.account_balance_wallet,
                          prefix: 'EGP',
                          enabled: canUpdate && !isSaving,
                        ),

                        const SizedBox(height: 16),

                        // Refund Input
                        _InputField(
                          controller: _refundController,
                          label: 'Refund Percentage',
                          hint: '0',
                          icon: Icons.replay,
                          suffix: '%',
                          enabled: canUpdate && !isSaving,
                        ),

                        const SizedBox(height: 24),

                        // Save Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: canUpdate && !isSaving
                                ? _savePricing
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrange,
                              disabledBackgroundColor: Colors.grey.shade300,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: isSaving
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.save),
                                      const SizedBox(width: 8),
                                      Text(
                                        canUpdate
                                            ? 'Save Changes'
                                            : 'Update Locked Until Tomorrow',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Info Note
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.blue.shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'You can update pricing once per day. New pricing will apply to all future bookings.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.blue.shade900,
                            ),
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
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final String? prefix;
  final String? suffix;
  final bool enabled;

  const _InputField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.prefix,
    this.suffix,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: enabled,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.deepOrange),
            prefixText: prefix != null ? '$prefix ' : null,
            suffixText: suffix,
            filled: true,
            fillColor: enabled ? Colors.grey.shade50 : Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.deepOrange, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================
// NAVIGATION BAR WIDGET
// ============================================

class RestaurantOwnerNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const RestaurantOwnerNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavBarItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
                isActive: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavBarItem(
                icon: Icons.settings_outlined,
                activeIcon: Icons.settings,
                label: 'Pricing',
                isActive: currentIndex == 1,
                onTap: () => onTap(1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isActive
              ? Colors.deepOrange.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? Colors.deepOrange : Colors.grey,
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? Colors.deepOrange : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================
// EXAMPLE USAGE IN MAIN APP
// ============================================

class RestaurantOwnerMainPage extends StatefulWidget {
  final int restaurantId;

  const RestaurantOwnerMainPage({super.key, required this.restaurantId});

  @override
  State<RestaurantOwnerMainPage> createState() =>
      _RestaurantOwnerMainPageState();
}

class _RestaurantOwnerMainPageState extends State<RestaurantOwnerMainPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // Your existing home page with bookings
          Center(
            child: Text(
              'Home Page\n(Your booking list goes here)',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ),
          // Pricing settings page
          RestaurantPricingPage(restaurantId: widget.restaurantId),
        ],
      ),
      bottomNavigationBar: RestaurantOwnerNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
