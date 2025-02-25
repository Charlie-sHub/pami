import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/profile/profile_editing_form/profile_editing_form_bloc.dart';
import 'package:pami/core/dev/dev_helpers.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/email_address.dart';
import 'package:pami/domain/core/validation/objects/entity_description.dart';
import 'package:pami/domain/core/validation/objects/name.dart';
import 'package:pami/domain/profile/profile_repository_interface.dart';

import 'profile_editing_form_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ProfileRepositoryInterface>()])
void main() {
  late MockProfileRepositoryInterface mockRepository;
  late ProfileEditingFormBloc profileEditingFormBloc;

  final validUser = getValidUser();
  final invalidUser = validUser.copyWith(
    name: Name(''),
    username: Name(''),
    email: EmailAddress(''),
    bio: EntityDescription(''),
  );
  final validImageFile = XFile('path/to/valid/image.jpg');
  const failure = Failure.serverError(errorString: 'error');

  setUp(
    () {
      mockRepository = MockProfileRepositoryInterface();
      profileEditingFormBloc = ProfileEditingFormBloc(mockRepository);
    },
  );

  group(
    'Testing on success',
    () {
      blocTest<ProfileEditingFormBloc, ProfileEditingFormState>(
        'emits [userOption: some(user), initialized: true] when '
        'initialized is added and repository returns Right',
        setUp: () {
          when(mockRepository.getCurrentUser()).thenAnswer(
            (_) async => right(validUser),
          );
        },
        build: () => profileEditingFormBloc,
        act: (bloc) => bloc.add(
          const ProfileEditingFormEvent.initialized(),
        ),
        expect: () => [
          ProfileEditingFormState.initial().copyWith(
            userOption: some(validUser),
            initialized: true,
          ),
        ],
        verify: (_) => verify(
          mockRepository.getCurrentUser(),
        ).called(1),
      );

      blocTest<ProfileEditingFormBloc, ProfileEditingFormState>(
        'emits [imageFile: some(imageFile)] when imageChanged is added',
        build: () => profileEditingFormBloc,
        act: (bloc) => bloc.add(
          ProfileEditingFormEvent.imageChanged(validImageFile),
        ),
        expect: () => [
          ProfileEditingFormState.initial().copyWith(
            imageFile: some(validImageFile),
            failureOrSuccessOption: none(),
          ),
        ],
      );

      blocTest<ProfileEditingFormBloc, ProfileEditingFormState>(
        'emits [userOption: some(user.copyWith(name: Name(name)))] '
        'when nameChanged is added',
        build: () => profileEditingFormBloc,
        act: (bloc) => bloc.add(
          const ProfileEditingFormEvent.nameChanged('New Name'),
        ),
        expect: () => [
          profileEditingFormBloc.state.copyWith(
            userOption: some(
              profileEditingFormBloc.user.copyWith(
                name: Name('New Name'),
              ),
            ),
            failureOrSuccessOption: none(),
          ),
        ],
      );

      blocTest<ProfileEditingFormBloc, ProfileEditingFormState>(
        'emits [userOption: some(user.copyWith(username: '
        'Name(username)))] when usernameChanged is added',
        build: () => profileEditingFormBloc,
        act: (bloc) => bloc.add(
          const ProfileEditingFormEvent.usernameChanged('New Username'),
        ),
        expect: () => [
          profileEditingFormBloc.state.copyWith(
            userOption: some(
              profileEditingFormBloc.user.copyWith(
                username: Name('New Username'),
              ),
            ),
            failureOrSuccessOption: none(),
          ),
        ],
      );

      blocTest<ProfileEditingFormBloc, ProfileEditingFormState>(
        'emits [userOption: some(user.copyWith(email: '
        'EmailAddress(email)))] when emailAddressChanged is added',
        build: () => profileEditingFormBloc,
        act: (bloc) => bloc.add(
          const ProfileEditingFormEvent.emailAddressChanged('new@email.com'),
        ),
        expect: () => [
          profileEditingFormBloc.state.copyWith(
            userOption: some(
              profileEditingFormBloc.user.copyWith(
                email: EmailAddress('new@email.com'),
              ),
            ),
            failureOrSuccessOption: none(),
          ),
        ],
      );

      blocTest<ProfileEditingFormBloc, ProfileEditingFormState>(
        'emits [userOption: some(user.copyWith(bio: '
        'EntityDescription(bio)))] when bioChanged is added',
        build: () => profileEditingFormBloc,
        act: (bloc) => bloc.add(
          const ProfileEditingFormEvent.bioChanged('New Bio'),
        ),
        expect: () => [
          profileEditingFormBloc.state.copyWith(
            userOption: some(
              profileEditingFormBloc.user.copyWith(
                bio: EntityDescription('New Bio'),
              ),
            ),
            failureOrSuccessOption: none(),
          ),
        ],
      );

      blocTest<ProfileEditingFormBloc, ProfileEditingFormState>(
        'emits [isSubmitting: true, failureOrSuccessOption: none], '
        '[isSubmitting: false, showErrorMessages: true, '
        'failureOrSuccessOption: some(right(unit))] when submitted is '
        'added, user is valid, and repository returns Right',
        setUp: () {
          when(mockRepository.updateUserProfile(any)).thenAnswer(
            (_) async => right(unit),
          );
        },
        seed: () => ProfileEditingFormState.initial().copyWith(
          userOption: some(validUser),
          imageFile: some(validImageFile),
        ),
        build: () => profileEditingFormBloc,
        act: (bloc) => bloc.add(
          const ProfileEditingFormEvent.submitted(),
        ),
        expect: () => [
          profileEditingFormBloc.state.copyWith(
            userOption: some(validUser),
            imageFile: some(validImageFile),
            showErrorMessages: false,
            isSubmitting: true,
            failureOrSuccessOption: none(),
          ),
          profileEditingFormBloc.state.copyWith(
            userOption: some(validUser),
            imageFile: some(validImageFile),
            isSubmitting: false,
            showErrorMessages: true,
            failureOrSuccessOption: some(right(unit)),
          ),
        ],
        verify: (_) => verify(
          mockRepository.updateUserProfile(validUser),
        ).called(1),
      );
    },
  );

  group(
    'Testing on failure',
    () {
      blocTest<ProfileEditingFormBloc, ProfileEditingFormState>(
        'emits [userOption: none, failureOrSuccessOption: '
        'some(left(failure)), initialized: true] when initialized is '
        'added and repository returns Left',
        setUp: () {
          when(mockRepository.getCurrentUser()).thenAnswer(
            (_) async => left(failure),
          );
        },
        build: () => profileEditingFormBloc,
        act: (bloc) => bloc.add(
          const ProfileEditingFormEvent.initialized(),
        ),
        expect: () => [
          ProfileEditingFormState.initial().copyWith(
            userOption: none(),
            failureOrSuccessOption: some(left(failure)),
            initialized: true,
          ),
        ],
        verify: (_) => verify(
          mockRepository.getCurrentUser(),
        ).called(1),
      );

      blocTest<ProfileEditingFormBloc, ProfileEditingFormState>(
        'emits [isSubmitting: true, failureOrSuccessOption: none], '
        '[isSubmitting: false, showErrorMessages: true, '
        'failureOrSuccessOption: some(left(failure))] when submitted is '
        'added, user is valid, and repository returns Left',
        setUp: () {
          when(mockRepository.updateUserProfile(any)).thenAnswer(
            (_) async => left(failure),
          );
        },
        seed: () => ProfileEditingFormState.initial().copyWith(
          userOption: some(validUser),
          imageFile: some(validImageFile),
        ),
        build: () => profileEditingFormBloc,
        act: (bloc) => bloc.add(
          const ProfileEditingFormEvent.submitted(),
        ),
        expect: () => [
          ProfileEditingFormState.initial().copyWith(
            userOption: some(validUser),
            imageFile: some(validImageFile),
            showErrorMessages: false,
            isSubmitting: true,
            failureOrSuccessOption: none(),
          ),
          ProfileEditingFormState.initial().copyWith(
            userOption: some(validUser),
            imageFile: some(validImageFile),
            isSubmitting: false,
            showErrorMessages: true,
            failureOrSuccessOption: some(left(failure)),
          ),
        ],
        verify: (_) => verify(
          mockRepository.updateUserProfile(validUser),
        ).called(1),
      );

      blocTest<ProfileEditingFormBloc, ProfileEditingFormState>(
        'emits [isSubmitting: true, failureOrSuccessOption: none], '
        '[isSubmitting: false, showErrorMessages: true, '
        'failureOrSuccessOption: some(left(Failure.emptyFields()))] '
        'when submitted is added and user is invalid',
        seed: () => ProfileEditingFormState.initial().copyWith(
          userOption: some(invalidUser),
          imageFile: some(validImageFile),
        ),
        build: () => profileEditingFormBloc,
        act: (bloc) => bloc.add(
          const ProfileEditingFormEvent.submitted(),
        ),
        expect: () => [
          ProfileEditingFormState.initial().copyWith(
            userOption: some(invalidUser),
            imageFile: some(validImageFile),
            showErrorMessages: false,
            isSubmitting: true,
            failureOrSuccessOption: none(),
          ),
          ProfileEditingFormState.initial().copyWith(
            userOption: some(invalidUser),
            imageFile: some(validImageFile),
            isSubmitting: false,
            showErrorMessages: true,
            failureOrSuccessOption: some(
              left(const Failure.emptyFields()),
            ),
          ),
        ],
        verify: (_) => verifyNever(
          mockRepository.updateUserProfile(any),
        ),
      );
    },
  );
}
