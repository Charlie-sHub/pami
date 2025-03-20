import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/authentication/registration_form/registration_form_bloc.dart';
import 'package:pami/views/authentication/widgets/registration_form/camera_button.dart';

import 'camera_button_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<RegistrationFormBloc>(),
])
void main() {
  late MockRegistrationFormBloc mockBloc;

  setUp(
    () {
      mockBloc = MockRegistrationFormBloc();
      when(mockBloc.state).thenReturn(RegistrationFormState.initial());
    },
  );

  tearDown(() async => mockBloc.close());

  Widget buildWidget() => MaterialApp(
        home: Scaffold(
          body: BlocProvider<RegistrationFormBloc>.value(
            value: mockBloc,
            child: const CameraButton(),
          ),
        ),
      );

  testWidgets(
    'renders correctly',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.byType(IconButton), findsOneWidget);
      expect(find.byIcon(Icons.photo_camera), findsOneWidget);
    },
  );

  testWidgets(
    'triggers imageChanged event when image is selected',
    (tester) async {
      // Arrange
      final imageFile = XFile('path/to/image.jpg');
      when(mockBloc.state).thenReturn(
        RegistrationFormState.initial().copyWith(imageFile: some(imageFile)),
      );

      // Act
      await tester.pumpWidget(buildWidget());
      await tester.tap(find.byType(IconButton));
      await tester.pump();
      await tester.binding.runAsync(
        () async {
          await tester.pumpWidget(
            MaterialApp(
              home: Material(
                child: Builder(
                  builder: (context) {
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) {
                        Navigator.of(context).pop(imageFile);
                      },
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
        mockBloc.add(RegistrationFormEvent.imageChanged(imageFile)),
      ).called(1);
    },
  );

  testWidgets(
    'does not trigger event when no image is selected',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget());
      await tester.tap(find.byType(IconButton));
      await tester.pump();
      await tester.binding.runAsync(
        () async {
          await tester.pumpWidget(
            MaterialApp(
              home: Material(
                child: Builder(
                  builder: (context) {
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) {
                        Navigator.of(context).pop();
                      },
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

  testWidgets(
    'displays error message when no image is selected '
    'and showErrorMessages is true',
    (tester) async {
      // Arrange
      when(mockBloc.state).thenAnswer(
        (_) => RegistrationFormState.initial().copyWith(
          showErrorMessages: true,
        ),
      );

      // Act
      await tester.pumpWidget(buildWidget());
      await tester.pump();

      // Assert
      expect(find.text('Please select an image'), findsOneWidget);
    },
  );

  testWidgets(
    'does not display error message when image is selected',
    (tester) async {
      // Arrange
      when(mockBloc.state).thenAnswer(
        (_) => RegistrationFormState.initial().copyWith(
          showErrorMessages: true,
          imageFile: some(XFile('path/to/image')),
        ),
      );

      // Act
      await tester.pumpWidget(buildWidget());
      await tester.pump();

      // Assert
      expect(find.text('Please select an image'), findsNothing);
    },
  );

  testWidgets(
    'does not display error message when showErrorMessages is false',
    (tester) async {
      // Arrange
      when(mockBloc.state).thenAnswer(
        (_) => RegistrationFormState.initial().copyWith(
          showErrorMessages: false,
          imageFile: none(),
        ),
      );

      // Act
      await tester.pumpWidget(buildWidget());
      await tester.pump();

      // Assert
      expect(find.text('Please select an image'), findsNothing);
    },
  );
}
