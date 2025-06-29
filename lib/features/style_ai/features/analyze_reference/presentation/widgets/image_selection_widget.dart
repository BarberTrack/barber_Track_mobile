import 'dart:io';
import 'package:flutter/material.dart';

class ImageSelectionWidget extends StatelessWidget {
  final File? selectedImage;
  final VoidCallback onSelectImage;

  const ImageSelectionWidget({
    super.key,
    required this.selectedImage,
    required this.onSelectImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E3A8A),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: [_buildImageContainer(), _buildSelectButton()]),
    );
  }

  Widget _buildImageContainer() {
    return Container(
      height: 280,
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selectedImage != null
              ? const Color(0xFF3498DB)
              : Colors.grey[300]!,
          width: 2,
        ),
        color: selectedImage != null ? null : Colors.black,
      ),
      child: selectedImage != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(selectedImage!, fit: BoxFit.cover),
            )
          : _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF3498DB).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.image_outlined,
            size: 48,
            color: Color(0xFF3498DB),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Selecciona una imagen',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Elige una foto de referencia de tu galería',
          style: TextStyle(fontSize: 14, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSelectButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton.icon(
          onPressed: onSelectImage,
          icon: Icon(
            selectedImage != null ? Icons.edit : Icons.photo_library_outlined,
            size: 20,
          ),
          label: Text(
            selectedImage != null ? 'Cambiar imagen' : 'Seleccionar de galería',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3498DB),
            foregroundColor: Colors.white,
            elevation: 2,
            shadowColor: const Color(0xFF3498DB).withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
