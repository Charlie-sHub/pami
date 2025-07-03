import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pami/application/authentication/registration_form/registration_form_bloc.dart';
import 'package:pami/domain/core/entities/user.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/views/authentication/widgets/email_text_field.dart';
import 'package:pami/views/authentication/widgets/password_text_field.dart';
import 'package:pami/views/authentication/widgets/registration_form/bio_text_field.dart';
import 'package:pami/views/authentication/widgets/registration_form/email_confirmator_text_field.dart';
import 'package:pami/views/authentication/widgets/registration_form/eula_checkbox.dart';
import 'package:pami/views/authentication/widgets/registration_form/name_text_field.dart';
import 'package:pami/views/authentication/widgets/registration_form/password_confirmator_text_field.dart';
import 'package:pami/views/authentication/widgets/registration_form/submit_registration_button.dart';
import 'package:pami/views/authentication/widgets/registration_form/user_image_picker.dart';
import 'package:pami/views/authentication/widgets/registration_form/username_text_field.dart';
import 'package:pami/views/core/theme/text_styles.dart';

/// Registration form widget
class RegistrationForm extends StatelessWidget {
  /// Default constructor
  const RegistrationForm({
    required this.userOption,
    super.key,
  });

  /// The user option, some if there was a successful third party log in
  /// and none if registering directly
  final Option<User> userOption;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<RegistrationFormBloc, RegistrationFormState>(
        buildWhen: _buildWhen,
        builder: (context, state) {
          final bloc = context.read<RegistrationFormBloc>();
          return SingleChildScrollView(
            key: const Key('singleChildScrollView'),
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 20,
            ),
            child: Form(
              autovalidateMode: state.showErrorMessages
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'PAMI',
                    style: AppTextStyles.displayLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  UserImagePicker(imageFileOption: state.imageFile),
                  const SizedBox(height: 20),
                  EmailTextField(
                    initialValue: userOption.fold(
                      () => null,
                      (user) => user.email.value.fold(
                        (_) => null,
                        (email) => email,
                      ),
                    ),
                    eventToAdd: (String value) => bloc.add(
                      RegistrationFormEvent.emailAddressChanged(value),
                    ),
                    validator: (_) => _emailValidator(state),
                  ),
                  const SizedBox(height: 10),
                  const EmailConfirmatorTextField(),
                  const SizedBox(height: 20),
                  PasswordTextField(
                    eventToAdd: (String value) => bloc.add(
                      RegistrationFormEvent.passwordChanged(value),
                    ),
                    validator: (_) => _passwordValidator(state),
                  ),
                  const SizedBox(height: 10),
                  const PasswordConfirmatorTextField(),
                  const SizedBox(height: 20),
                  NameTextField(
                    initialValue: userOption.fold(
                      () => null,
                      (user) => user.name.value.fold(
                        (_) => null,
                        (name) => name,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  UsernameTextField(
                    initialValue: userOption.fold(
                      () => null,
                      (user) => user.username.value.fold(
                        (_) => null,
                        (username) => username,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  BioTextField(
                    initialValue: userOption.fold(
                      () => null,
                      (user) => user.bio.value.fold(
                        (_) => null,
                        (bio) => bio,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const EulaCheckbox(),
                  const SizedBox(height: 20),
                  const SubmitRegistrationButton(),
                ],
              ),
            ),
          );
        },
      );

  bool _buildWhen(
    RegistrationFormState previous,
    RegistrationFormState current,
  ) =>
      current.initialized ||
      current.showErrorMessages ||
      current.user.bio.isValid() ||
      !current.user.bio.isValid() ||
      current.user.username.isValid() ||
      !current.user.username.isValid() ||
      current.user.name.isValid() ||
      !current.user.name.isValid() ||
      current.user.email.isValid() ||
      !current.user.email.isValid() ||
      current.emailConfirmator.isValid() ||
      !current.emailConfirmator.isValid() ||
      current.passwordConfirmator.isValid() ||
      !current.passwordConfirmator.isValid() ||
      previous.acceptedEULA != current.acceptedEULA ||
      current.imageFile.fold(
        () => false,
        (_) => true,
      );

  String? _passwordValidator(RegistrationFormState state) =>
      state.password.value.fold(
        (failure) => switch (failure) {
          EmptyString() => 'Empty password',
          InvalidPassword() => 'Invalid password',
          _ => 'Unknown error',
        },
        (_) => null,
      );

  String? _emailValidator(RegistrationFormState state) =>
      state.user.email.value.fold(
        (failure) => switch (failure) {
          InvalidEmail() => 'Invalid email',
          _ => 'Unknown error',
        },
        (_) => null,
      );
}
