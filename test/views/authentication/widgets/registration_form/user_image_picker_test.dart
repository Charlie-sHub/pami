import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/authentication/registration_form/registration_form_bloc.dart';
import 'package:pami/views/authentication/widgets/registration_form/camera_button.dart';
import 'package:pami/views/authentication/widgets/registration_form/user_image_picker.dart';

import 'user_image_picker_test.mocks.dart';

@GenerateNiceMocks([MockSpec<RegistrationFormBloc>()])
void main() {
  late MockRegistrationFormBloc mockBloc;

  setUp(
    () {
      mockBloc = MockRegistrationFormBloc();
      when(mockBloc.state).thenReturn(RegistrationFormState.initial());
    },
  );

  tearDown(
    () async => mockBloc.close(),
  );

  Widget buildWidget({required Option<XFile> imageFileOption}) => MaterialApp(
        home: Scaffold(
          body: BlocProvider<RegistrationFormBloc>.value(
            value: mockBloc,
            child: UserImagePicker(
              imageFileOption: imageFileOption,
            ),
          ),
        ),
      );

  testWidgets(
    'renders CameraButton when no image is selected',
    (tester) async {
      // Arrange
      const imageFileOption = None<XFile>();

      // Act
      await tester.pumpWidget(
        buildWidget(imageFileOption: imageFileOption),
      );

      // Assert
      expect(find.byType(CameraButton), findsOneWidget);
    },
  );

  testWidgets(
    'renders TextButton with CircleAvatar when image is selected',
    (tester) async {
      // Arrange
      final imageFile = XFile('path/to/image.jpg');
      final imageFileOption = Some(imageFile);

      // Act
      await tester.pumpWidget(
        buildWidget(imageFileOption: imageFileOption),
      );

      // Assert
      expect(find.byType(TextButton), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);
    },
  );

  testWidgets(
    'triggers imageChanged event when TextButton is tapped '
    'and image is selected',
    (tester) async {
      // Arrange
      final imageFile = XFile('path/to/image.jpg');
      final imageFileOption = Some(imageFile);
      final newImageFile = XFile('path/to/new_image.jpg');
      when(mockBloc.state).thenReturn(
        RegistrationFormState.initial().copyWith(
          imageFile: some(XFile('path/to/image.jpg')),
        ),
      );

      // Act
      await tester.pumpWidget(
        buildWidget(imageFileOption: imageFileOption),
      );
      await tester.tap(find.byType(TextButton));
      await tester.pump();
      await tester.binding.runAsync(
        () async {
          await tester.pumpWidget(
            MaterialApp(
              home: Material(
                child: Builder(
                  builder: (context) {
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) => Navigator.of(context).pop(newImageFile),
                    );
                    return const Placeholder();
                  },
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
        },
      );

      // Assert
      verify(
        mockBloc.add(RegistrationFormEvent.imageChanged(newImageFile)),
      ).called(1);
    },
  );

  testWidgets(
    'does not trigger event when TextButton is tapped and no image is selected',
    (tester) async {
      // Arrange
      final imageFile = XFile('path/to/image.jpg');
      final imageFileOption = Some(imageFile);
      when(mockBloc.state).thenReturn(
        RegistrationFormState.initial().copyWith(
          imageFile: some(XFile('path/to/image.jpg')),
        ),
      );

      // Act
      await tester.pumpWidget(
        buildWidget(imageFileOption: imageFileOption),
      );
      await tester.tap(find.byType(TextButton));
      await tester.pump();

      // Simulate no file selection
      await tester.binding.runAsync(
        () async {
          await tester.pumpWidget(
            MaterialApp(
              home: Material(
                child: Builder(
                  builder: (context) {
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) => Navigator.of(context).pop(),
                    );
                    return const Placeholder();
                  },
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
        },
      );

      // Assert
      verifyNever(mockBloc.add(any));
    },
  );
}
