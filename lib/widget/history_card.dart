import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HistoryCard extends StatelessWidget {
  final String date;
  final String poliklinik;
  final String doctor;
  final String price;
  final String status;
  final Color statusColor;
  final IconData icon;
  final VoidCallback? onTap; // Optional onTap callback

  const HistoryCard({
    required this.date,
    required this.poliklinik,
    required this.doctor,
    required this.price,
    required this.status,
    required this.statusColor,
    required this.icon,
    this.onTap, // Add the onTap argument
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // Respond to tap
      borderRadius: BorderRadius.circular(8), // Optional: Add a ripple effect
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    date,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Color(0xFF808489),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        icon,
                        color: statusColor,
                        size: 14,
                      ),
                      const SizedBox(
                        height: 5,
                        width: 5,
                      ),
                      Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.rectangle,
                      border: Border.all(
                        color: Color(0xFF0C5F5C), // Border color
                        width: 0.48, // Border width
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                        Icons
                            .sentiment_satisfied_alt, // Update to match the smiley icon
                        size: 32,
                        color: Color(0xFF0C5F5C)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          poliklinik,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          doctor,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          price,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
