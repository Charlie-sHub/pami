import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pami/views/core/widgets/image_picker_dialog.dart';

/// Opens the image picker dialog
Future<XFile?> openPictureSelectDialog(BuildContext context) async =>
    showDialog<XFile>(
      context: context,
      builder: (context) => const ImagePickerDialog(),
    );
