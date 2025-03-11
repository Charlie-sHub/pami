import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pami/views/core/theme/colors.dart';

/// Image picker dialog
class ImagePickerDialog extends StatelessWidget {
  /// Default constructor
  const ImagePickerDialog({super.key});

  @override
  Widget build(BuildContext context) => AlertDialog(
        backgroundColor: AppColors.background,
        actionsPadding: const EdgeInsets.all(10),
        actions: [
          ElevatedButton(
            onPressed: () => _pickImage(context, ImageSource.camera),
            child: const Row(
              children: [
                Icon(Icons.photo_camera),
                SizedBox(width: 10),
                Text(
                  'Camera',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _pickImage(context, ImageSource.gallery),
            child: const Row(
              children: [
                Icon(Icons.grid_view),
                SizedBox(width: 10),
                Text(
                  'Gallery',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final navigatorState = Navigator.of(context);
    final imagePicked = await ImagePicker().pickImage(
      source: source,
      imageQuality: 30,
      maxHeight: 1440,
      maxWidth: 2560,
    );
    if (imagePicked != null) {
      navigatorState.pop(imagePicked);
    }
  }
}
