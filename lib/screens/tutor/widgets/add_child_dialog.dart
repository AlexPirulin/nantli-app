import 'package:flutter/material.dart';
import '../../../models/child_model.dart';
import 'package:uuid/uuid.dart';

class AddChildDialog extends StatefulWidget {
  final Function(ChildModel) onSave; // Renombrado para ser más genérico (Add o Edit)
  final ChildModel? initialChild; // Opcional: si existe, estamos editando

  const AddChildDialog({super.key, required this.onSave, this.initialChild});

  @override
  State<AddChildDialog> createState() => _AddChildDialogState();
}

class _AddChildDialogState extends State<AddChildDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    // Inicializar con datos si estamos editando, o vacíos si es nuevo
    _nameController = TextEditingController(text: widget.initialChild?.name ?? '');
    _ageController = TextEditingController(text: widget.initialChild?.age.toString() ?? '');
    _notesController = TextEditingController(text: widget.initialChild?.specialNotes ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color(0xFF2D1B4D);
    final accentColor = const Color(0xFFD1C4E9);
    final isEditing = widget.initialChild != null;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
      title: Text(
        isEditing ? 'Editar Datos' : 'Agregar Hijo/a',
        style: TextStyle(
          color: isDarkMode ? Colors.white : primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildField(_nameController, 'Nombre', Icons.face_rounded, isDarkMode),
              const SizedBox(height: 16),
              _buildField(
                _ageController, 
                'Edad', 
                Icons.cake_rounded, 
                isDarkMode, 
                keyboardType: TextInputType.number
              ),
              const SizedBox(height: 16),
              _buildField(
                _notesController, 
                'Notas (Alergias, gustos...)', 
                Icons.description_rounded, 
                isDarkMode, 
                maxLines: 3
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final child = ChildModel(
                // Si editamos, mantenemos el ID original; si no, creamos uno nuevo
                id: widget.initialChild?.id ?? const Uuid().v4(),
                name: _nameController.text.trim(),
                age: int.parse(_ageController.text),
                specialNotes: _notesController.text.trim(),
              );
              widget.onSave(child);
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isDarkMode ? accentColor : primaryColor,
            foregroundColor: isDarkMode ? primaryColor : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(isEditing ? 'Guardar' : 'Agregar', style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildField(
    TextEditingController controller, 
    String label, 
    IconData icon, 
    bool isDarkMode, 
    {TextInputType? keyboardType, int maxLines = 1}
  ) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
      validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFFD1C4E9)),
        filled: true,
        fillColor: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
    );
  }
}
