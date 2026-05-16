import 'package:flutter/material.dart';
import '../../models/caregiver_model.dart';

class CaregiverSetupScreen extends StatefulWidget {
  const CaregiverSetupScreen({super.key});

  @override
  State<CaregiverSetupScreen> createState() => _CaregiverSetupScreenState();
}

class _CaregiverSetupScreenState extends State<CaregiverSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  
  ExperienceLevel _selectedLevel = ExperienceLevel.basic;
  double _currentRate = 110.0;
  final _bioController = TextEditingController();
  final _expController = TextEditingController();
  final _certController = TextEditingController();

  // Rangos de precios según nivel
  final Map<ExperienceLevel, Map<String, double>> _rateRanges = {
    ExperienceLevel.basic: {'min': 110.0, 'max': 170.0},
    ExperienceLevel.intermediate: {'min': 171.0, 'max': 220.0},
    ExperienceLevel.advanced: {'min': 221.0, 'max': 350.0},
  };

  @override
  void initState() {
    super.initState();
    _updateDefaultRate();
  }

  void _updateDefaultRate() {
    setState(() {
      _currentRate = _rateRanges[_selectedLevel]!['min']!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    const primaryPurple = Color(0xFF2D1B4D);
    const accentColor = Color(0xFFD1C4E9);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de Cuidador', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: isDarkMode ? Colors.white : primaryPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Foto de Perfil
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: accentColor.withOpacity(0.2),
                      child: const Icon(Icons.person_rounded, size: 60, color: Colors.grey),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: primaryPurple, shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt_rounded, size: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              _buildSectionTitle('Nivel de Experiencia', Icons.trending_up_rounded, isDarkMode),
              const SizedBox(height: 16),
              _buildLevelSelector(isDarkMode),
              
              const SizedBox(height: 32),

              _buildSectionTitle('Tarifa por Hora (MXN)', Icons.payments_rounded, isDarkMode),
              const SizedBox(height: 8),
              _buildRateSlider(isDarkMode),
              
              const SizedBox(height: 32),

              _buildSectionTitle('Información Profesional', Icons.badge_rounded, isDarkMode),
              const SizedBox(height: 16),
              _buildField(_expController, 'Años de experiencia', Icons.history_rounded, isDarkMode, keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              _buildField(_bioController, 'Bio profesional', Icons.description_rounded, isDarkMode, maxLines: 3),
              const SizedBox(height: 16),
              _buildField(_certController, 'Certificaciones (separadas por comas)', Icons.verified_rounded, isDarkMode),

              const SizedBox(height: 48),

              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _showSavedSnackbar();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode ? accentColor : primaryPurple,
                    foregroundColor: isDarkMode ? primaryPurple : Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text('Completar Perfil', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, bool isDarkMode) {
    return Row(
      children: [
        Icon(icon, size: 22, color: const Color(0xFFD1C4E9)),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildLevelSelector(bool isDarkMode) {
    return Row(
      children: [
        _buildLevelCard('Básico', ExperienceLevel.basic, isDarkMode),
        const SizedBox(width: 8),
        _buildLevelCard('Medio', ExperienceLevel.intermediate, isDarkMode),
        const SizedBox(width: 8),
        _buildLevelCard('Experto', ExperienceLevel.advanced, isDarkMode),
      ],
    );
  }

  Widget _buildLevelCard(String label, ExperienceLevel level, bool isDarkMode) {
    final isSelected = _selectedLevel == level;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedLevel = level;
            _updateDefaultRate();
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFD1C4E9) : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: isSelected ? const Color(0xFFD1C4E9) : Colors.white10),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? const Color(0xFF2D1B4D) : Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRateSlider(bool isDarkMode) {
    final range = _rateRanges[_selectedLevel]!;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('\$${range['min']!.toInt()} MXN', style: const TextStyle(color: Colors.grey)),
            Text(
              '\$${_currentRate.toInt()} MXN',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : const Color(0xFF2D1B4D)),
            ),
            Text('\$${range['max']!.toInt()} MXN', style: const TextStyle(color: Colors.grey)),
          ],
        ),
        Slider(
          value: _currentRate,
          min: range['min']!,
          max: range['max']!,
          divisions: (range['max']! - range['min']!).toInt(),
          activeColor: const Color(0xFFD1C4E9),
          inactiveColor: Colors.white10,
          onChanged: (val) => setState(() => _currentRate = val),
        ),
      ],
    );
  }

  Widget _buildField(TextEditingController controller, String label, IconData icon, bool isDarkMode, {TextInputType? keyboardType, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
      validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: const Color(0xFFD1C4E9)),
        filled: true,
        fillColor: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
      ),
    );
  }

  void _showSavedSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('¡Perfil profesional guardado!'), backgroundColor: Colors.green),
    );
  }
}
