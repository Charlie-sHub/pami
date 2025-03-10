import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pami/application/authentication/registration_form/registration_form_bloc.dart';
import 'package:pami/views/authentication/widgets/registration_form/camera_button.dart';
import 'package:pami/views/core/misc/open_picture_select_dialog.dart';

/// User image picker widget
class UserImagePicker extends StatelessWidget {
  /// Default constructor
  const UserImagePicker({
    required this.imageFileOption,
    super.key,
  });

  /// The image file option
  final Option<XFile> imageFileOption;

  @override
  Widget build(BuildContext context) => imageFileOption.fold(
        CameraButton.new,
        (imageFile) => TextButton(
          onPressed: () async {
            final bloc = context.read<RegistrationFormBloc>();
            final imageFile = await openPictureSelectDialog(context);
            if (imageFile != null) {
              bloc.add(RegistrationFormEvent.imageChanged(imageFile));
            }
          },
          child: CircleAvatar(
            radius: 50,
            backgroundImage: FileImage(
              File(imageFile.path),
            ),
          ),
        ),
      );
}
