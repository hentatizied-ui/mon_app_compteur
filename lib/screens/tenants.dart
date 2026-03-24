import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TenantsScreen extends StatelessWidget {
  const TenantsScreen({super.key});

  final List<Map<String, dynamic>> _tenants = const [
    {
      'name': 'Marie Dubois',
      'property': 'Appartement Centre Ville',
      'rent': 1200,
      'phone': '06 12 34 56 78',
      'status': 'À jour',
    },
    {
      'name': 'Jean Martin',
      'property': 'Studio Étudiant',
      'rent': 550,
      'phone': '06 98 76 54 32',
      'status': 'En retard',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Locataires',
          style: GoogleFonts.urbanist(
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _tenants.length,
        itemBuilder: (context, index) {
          final tenant = _tenants[index];
          return _buildTenantCard(tenant);
        },
      ),
    );
  }

  Widget _buildTenantCard(Map<String, dynamic> tenant) {
    final isLate = tenant['status'] == 'En retard';
    final statusColor = isLate ? Colors.red : Colors.green;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.person, size: 28, color: Colors.blue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tenant['name'],
                        style: GoogleFonts.urbanist(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tenant['property'],
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tenant['status'],
                    style: GoogleFonts.urbanist(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.euro, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'Loyer: ${tenant['rent']} €/mois',
                  style: GoogleFonts.urbanist(fontSize: 14),
                ),
                const Spacer(),
                const Icon(Icons.phone, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  tenant['phone'],
                  style: GoogleFonts.urbanist(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}