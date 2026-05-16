import 'package:flutter/material.dart';
import '../../models/child_model.dart';
import 'widgets/add_child_dialog.dart';

class TutorSetupScreen extends StatefulWidget {
  const TutorSetupScreen({super.key});

  @override
  State<TutorSetupScreen> createState() => _TutorSetupScreenState();
}

class _TutorSetupScreenState extends State<TutorSetupScreen> {
  final List<ChildModel> _children = [];
  final _needsController = TextEditingController();

  void _addOrUpdateChild(ChildModel child) {
    setState(() {
      final index = _children.indexWhere((c) => c.id == child.id);
      if (index != -1) {
        // Actualizar hijo existente
        _children[index] = child;
      } else {
        // Agregar nuevo hijo
        _children.add(child);
      }
    });
  }

  void _removeChild(String id) {
    setState(() => _children.removeWhere((c) => c.id == id));
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    const primaryPurple = Color(0xFF2D1B4D);
    const accentColor = Color(0xFFD1C4E9);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configura tu Perfil', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: isDarkMode ? Colors.white : primaryPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              'Sobre tu hogar',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: isDarkMode ? accentColor : primaryPurple),
            ),
            const SizedBox(height: 8),
            const Text(
              'Cuéntanos qué necesitas para que podamos encontrar al cuidador ideal.',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            
            const SizedBox(height: 32),
            
            _buildSectionTitle('Necesidades Generales', Icons.info_outline_rounded, isDarkMode),
            const SizedBox(height: 12),
            TextField(
              controller: _needsController,
              maxLines: 4,
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
              decoration: InputDecoration(
                hintText: 'Ej: Busco ayuda con las tareas, que sea paciente y sepa primeros auxilios...',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                filled: true,
                fillColor: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
              ),
            ),
            
            const SizedBox(height: 40),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionTitle('Mis Hijos', Icons.child_friendly_rounded, isDarkMode),
                IconButton(
                  onPressed: () => showDialog(
                    context: context, 
                    builder: (context) => AddChildDialog(onSave: _addOrUpdateChild)
                  ),
                  icon: const Icon(Icons.add_circle_outline_rounded, size: 28),
                  color: isDarkMode ? accentColor : primaryPurple,
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            if (_children.isEmpty)
              _buildEmptyState(isDarkMode)
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _children.length,
                itemBuilder: (context, index) => _buildChildCard(_children[index], isDarkMode),
              ),
            
            const SizedBox(height: 60),
            
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  _showSavedSnackbar();
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
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, bool isDarkMode) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFFD1C4E9)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white.withOpacity(0.02) : Colors.black.withOpacity(0.02),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDarkMode ? Colors.white10 : Colors.black12),
      ),
      child: Column(
        children: const [
          Icon(Icons.people_alt_outlined, size: 40, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            'Aún no has registrado a tus hijos.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildChildCard(ChildModel child, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDarkMode ? [] : [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFD1C4E9).withOpacity(0.2),
            child: const Icon(Icons.face_rounded, color: Color(0xFF2D1B4D)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(child.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('${child.age} años', style: const TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ),
          ),
          // Botón Editar
          IconButton(
            icon: const Icon(Icons.edit_note_rounded, color: Colors.grey),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AddChildDialog(
                onSave: _addOrUpdateChild,
                initialChild: child, // Pasar datos actuales para editar
              ),
            ),
          ),
          // Botón Eliminar
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
            onPressed: () => _removeChild(child.id),
          ),
        ],
      ),
    );
  }

  void _showSavedSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Perfil guardado con éxito!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
