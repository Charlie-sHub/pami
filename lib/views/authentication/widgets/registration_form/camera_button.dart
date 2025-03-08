import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pami/application/authentication/registration_form/registration_form_bloc.dart';
import 'package:pami/views/core/misc/open_picture_select_dialog.dart';

/// Camera button widget
class CameraButton extends StatelessWidget {
  /// Default constructor
  const CameraButton({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RegistrationFormBloc>();
    return Column(
      children: <Widget>[
        IconButton(
          iconSize: 80,
          icon: const Icon(Icons.photo_camera),
          onPressed: () => openPictureSelectDialog(context).then(
            (imageFile) {
              if (imageFile != null) {
                bloc.add(RegistrationFormEvent.imageChanged(imageFile));
              }
            },
          ),
        ),
        BlocBuilder<RegistrationFormBloc, RegistrationFormState>(
          buildWhen: _buildWhen,
          builder: (context, state) => Visibility(
            visible: state.showErrorMessages && state.imageFile.isNone(),
            child: const Text(
              'Please select an image',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }

  bool _buildWhen(_, RegistrationFormState current) =>
      current.showErrorMessages && current.imageFile.isNone() ||
      current.imageFile.isSome();
}
