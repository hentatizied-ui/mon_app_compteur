import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PropertiesScreen extends StatefulWidget {
  const PropertiesScreen({super.key});

  @override
  State<PropertiesScreen> createState() => _PropertiesScreenState();
}

class _PropertiesScreenState extends State<PropertiesScreen> {
  List<Map<String, dynamic>> _properties = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _rentController = TextEditingController();
  final TextEditingController _roomsController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _rentController.dispose();
    _roomsController.dispose();
    _areaController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  Future<void> _loadProperties() async {
    print('=== CHARGEMENT DES BIENS ===');
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? propertiesJson = prefs.getString('properties');
      
      print('Données chargées: $propertiesJson');
      
      if (propertiesJson != null && propertiesJson.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(propertiesJson);
        setState(() {
          _properties = decoded.map((e) => Map<String, dynamic>.from(e)).toList();
        });
      } else {
        setState(() {
          _properties = [
            {
              'id': '1',
              'name': 'Appartement Centre Ville',
              'address': '15 rue de Paris, 75001 Paris',
              'rent': 1200,
              'rooms': 3,
              'area': 65,
              'status': 'Occupé',
              'image': '🏢',
              'type': 'Appartement',
            },
            {
              'id': '2',
              'name': 'Maison avec Jardin',
              'address': '8 avenue des Roses, 69002 Lyon',
              'rent': 1800,
              'rooms': 5,
              'area': 110,
              'status': 'Libre',
              'image': '🏠',
              'type': 'Maison',
            },
            {
              'id': '3',
              'name': 'Studio Étudiant',
              'address': '3 rue de la Gare, 13001 Marseille',
              'rent': 550,
              'rooms': 1,
              'area': 25,
              'status': 'Occupé',
              'image': '🏢',
              'type': 'Studio',
            },
          ];
        });
        await _saveProperties();
      }
      print('Liste chargée: ${_properties.length} biens');
    } catch (e) {
      print('Erreur chargement: $e');
    }
  }

  Future<void> _saveProperties() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String jsonString = jsonEncode(_properties);
      await prefs.setString('properties', jsonString);
      print('Sauvegarde OK: ${_properties.length} biens');
    } catch (e) {
      print('Erreur sauvegarde: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          'Mes biens',
          style: GoogleFonts.urbanist(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, size: 28),
            color: const Color(0xFF1E88E5),
            onPressed: _showAddPropertyDialog,
          ),
        ],
      ),
      body: _properties.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _properties.length,
              itemBuilder: (context, index) {
                return _buildPropertyCard(_properties[index], index);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF1E88E5).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.house_outlined,
              size: 50,
              color: Color(0xFF1E88E5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Aucun bien',
            style: GoogleFonts.urbanist(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Cliquez sur + pour ajouter votre premier bien',
            style: GoogleFonts.urbanist(
              fontSize: 14,
              color: const Color(0xFF757575),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyCard(Map<String, dynamic> property, int index) {
    final isOccupied = property['status'] == 'Occupé';
    final statusColor = isOccupied ? const Color(0xFF4CAF50) : const Color(0xFFFF9800);
    final statusText = isOccupied ? 'Occupé' : 'Libre';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _showPropertyDetails(property, index),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF1E88E5).withOpacity(0.2),
                            const Color(0xFF1E88E5).withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(property['image'], style: const TextStyle(fontSize: 32)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            property['name'],
                            style: GoogleFonts.urbanist(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A1A1A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 14, color: Color(0xFF9E9E9E)),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  property['address'],
                                  style: GoogleFonts.urbanist(
                                    fontSize: 12,
                                    color: const Color(0xFF757575),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              property['type'],
                              style: GoogleFonts.urbanist(fontSize: 10, color: const Color(0xFF757575)),
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
                        statusText,
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildInfoItem(icon: Icons.euro, label: 'Loyer', value: '${property['rent']} €'),
                    const SizedBox(width: 16),
                    _buildInfoItem(icon: Icons.square_foot, label: 'Surface', value: '${property['area']} m²'),
                    const SizedBox(width: 16),
                    _buildInfoItem(icon: Icons.bed, label: 'Pièces', value: '${property['rooms']}'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem({required IconData icon, required String label, required String value}) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF9E9E9E)),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.urbanist(fontSize: 10, color: const Color(0xFF9E9E9E))),
              Text(value, style: GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF1A1A1A))),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddPropertyDialog() {
    _nameController.clear();
    _addressController.clear();
    _rentController.clear();
    _roomsController.clear();
    _areaController.clear();
    _typeController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0E0E0),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text('Ajouter un bien', style: GoogleFonts.urbanist(fontSize: 20, fontWeight: FontWeight.w600, color: const Color(0xFF1A1A1A))),
                    const SizedBox(height: 8),
                    Text('Remplissez les informations du bien', style: GoogleFonts.urbanist(fontSize: 14, color: const Color(0xFF757575))),
                    const SizedBox(height: 24),
                    
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Nom du bien *',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Veuillez entrer un nom' : null,
                    ),
                    const SizedBox(height: 16),
                    
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Adresse *',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Veuillez entrer une adresse' : null,
                    ),
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _typeController,
                            decoration: InputDecoration(
                              labelText: 'Type',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _rentController,
                            decoration: InputDecoration(
                              labelText: 'Loyer (€) *',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) => value == null || value.isEmpty ? 'Requis' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _areaController,
                            decoration: InputDecoration(
                              labelText: 'Surface (m²) *',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) => value == null || value.isEmpty ? 'Requis' : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _roomsController,
                            decoration: InputDecoration(
                              labelText: 'Pièces',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Annuler'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _addProperty,
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E88E5)),
                            child: const Text('Ajouter'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _addProperty() async {
    if (_formKey.currentState!.validate()) {
      final newProperty = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': _nameController.text,
        'address': _addressController.text,
        'rent': int.tryParse(_rentController.text) ?? 0,
        'rooms': int.tryParse(_roomsController.text) ?? 1,
        'area': int.tryParse(_areaController.text) ?? 0,
        'status': 'Libre',
        'image': '🏢',
        'type': _typeController.text.isNotEmpty ? _typeController.text : 'Bien',
      };

      setState(() {
        _properties.add(newProperty);
      });
      
      await _saveProperties();

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bien ajouté avec succès !'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _deleteProperty(Map<String, dynamic> property, int index) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer le bien'),
          content: Text('Voulez-vous vraiment supprimer "${property['name']}" ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  _properties.removeAt(index);
                });
                await _saveProperties();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Bien "${property['name']}" supprimé'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showPropertyDetails(Map<String, dynamic> property, int index) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF1E88E5).withOpacity(0.2),
                          const Color(0xFF1E88E5).withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(child: Text(property['image'], style: const TextStyle(fontSize: 32))),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(property['name'], style: GoogleFonts.urbanist(fontSize: 20, fontWeight: FontWeight.w600)),
                        Text(property['address'], style: GoogleFonts.urbanist(fontSize: 14, color: const Color(0xFF757575))),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildDetailItem('€', 'Loyer', '${property['rent']} €')),
                  Expanded(child: _buildDetailItem('📐', 'Surface', '${property['area']} m²')),
                  Expanded(child: _buildDetailItem('🛏️', 'Pièces', '${property['rooms']}')),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _deleteProperty(property, index);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Supprimer'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Fermer'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(String icon, String label, String value) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(value, style: GoogleFonts.urbanist(fontSize: 16, fontWeight: FontWeight.w600)),
        Text(label, style: GoogleFonts.urbanist(fontSize: 12, color: const Color(0xFF9E9E9E))),
      ],
    );
  }
}