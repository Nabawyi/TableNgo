// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';

Widget bookingDetailsCard(
  String seats,
  String time,
  String deposit,
  double refundAmount,
) {
  final depositValue =
      double.tryParse(deposit.toString().replaceAll(RegExp(r'[^0-9.]'), '')) ??
      0;

  final refundValue = (depositValue * (refundAmount / 100)).toInt();
  final totalPayable = depositValue - refundValue;

  return Container(
    width: double.infinity,
    margin: const EdgeInsets.symmetric(horizontal: 16),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.grey.shade300, width: 1),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade200,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Selected: $seats - $time",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text("Deposit: $deposit"),
        Text(
          'Refund on arrival: EGP $refundValue',
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          "Total Payable: ${totalPayable.toStringAsFixed(0)}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,
          ),
        ),
      ],
    ),
  );
}
