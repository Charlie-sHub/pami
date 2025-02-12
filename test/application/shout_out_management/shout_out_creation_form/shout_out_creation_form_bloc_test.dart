import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/shout_out_management/shout_out_creation_form/shout_out_creation_form_bloc.dart';
import 'package:pami/domain/core/entities/shout_out.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/misc/enums/category.dart';
import 'package:pami/domain/core/misc/enums/shout_out_type.dart';
import 'package:pami/domain/core/validation/objects/entity_description.dart';
import 'package:pami/domain/core/validation/objects/name.dart';
import 'package:pami/domain/shout_out_management/shout_out_management_repository_interface.dart';

import '../../../misc/get_valid_shout_out.dart';
import 'shout_out_creation_form_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ShoutOutManagementRepositoryInterface>()])
void main() {
  late MockShoutOutManagementRepositoryInterface mockRepository;
  late ShoutOutCreationFormBloc shoutOutCreationFormBloc;

  const validTitle = 'valid title';
  const validDescription = 'valid description';
  const validCategories = {Category.food, Category.transportation};
  const validType = ShoutOutType.request;
  final validImage = XFile('path');
  final validShoutOut = getValidShoutOut();
  const failure = Failure.serverError(errorString: 'error');

  setUp(
    () {
      mockRepository = MockShoutOutManagementRepositoryInterface();
      shoutOutCreationFormBloc = ShoutOutCreationFormBloc(mockRepository);
    },
  );

  group(
    'Testing on success',
    () {
      blocTest<ShoutOutCreationFormBloc, ShoutOutCreationFormState>(
        'emits a state with the changed type when Initialized is added',
        seed: () => ShoutOutCreationFormState.initial().copyWith(
          shoutOut: validShoutOut,
        ),
        build: () => shoutOutCreationFormBloc,
        act: (bloc) => bloc.add(
          const ShoutOutCreationFormEvent.initialized(validType),
        ),
        expect: () => [
          ShoutOutCreationFormState.initial().copyWith(
            shoutOut: validShoutOut.copyWith(type: validType),
          ),
        ],
      );

      blocTest<ShoutOutCreationFormBloc, ShoutOutCreationFormState>(
        'emits a state with the changed title when TitleChanged is added',
        seed: () => ShoutOutCreationFormState.initial().copyWith(
          shoutOut: validShoutOut,
        ),
        build: () => shoutOutCreationFormBloc,
        act: (bloc) => bloc.add(
          const ShoutOutCreationFormEvent.titleChanged(validTitle),
        ),
        expect: () => [
          ShoutOutCreationFormState.initial().copyWith(
            shoutOut: validShoutOut.copyWith(title: Name(validTitle)),
          ),
        ],
      );

      blocTest<ShoutOutCreationFormBloc, ShoutOutCreationFormState>(
        'emits a state with the changed image when PictureChanged is added',
        seed: () => ShoutOutCreationFormState.initial().copyWith(
          shoutOut: validShoutOut,
        ),
        build: () => shoutOutCreationFormBloc,
        act: (bloc) => bloc.add(
          ShoutOutCreationFormEvent.pictureChanged(validImage),
        ),
        expect: () => [
          ShoutOutCreationFormState.initial().copyWith(
            shoutOut: validShoutOut,
            imageFile: some(validImage),
          ),
        ],
      );

      blocTest<ShoutOutCreationFormBloc, ShoutOutCreationFormState>(
        'emits a state with the changed description when'
        ' DescriptionChanged is added',
        seed: () => ShoutOutCreationFormState.initial().copyWith(
          shoutOut: validShoutOut,
        ),
        build: () => shoutOutCreationFormBloc,
        act: (bloc) => bloc.add(
          const ShoutOutCreationFormEvent.descriptionChanged(validDescription),
        ),
        expect: () => [
          ShoutOutCreationFormState.initial().copyWith(
            shoutOut: validShoutOut.copyWith(
              description: EntityDescription(validDescription),
            ),
          ),
        ],
      );

      blocTest<ShoutOutCreationFormBloc, ShoutOutCreationFormState>(
        'emits a state with the changed categories when'
        ' CategoriesChanged is added',
        seed: () => ShoutOutCreationFormState.initial().copyWith(
          shoutOut: validShoutOut,
        ),
        build: () => shoutOutCreationFormBloc,
        act: (bloc) => bloc.add(
          const ShoutOutCreationFormEvent.categoriesChanged(validCategories),
        ),
        expect: () => [
          ShoutOutCreationFormState.initial().copyWith(
            shoutOut: validShoutOut.copyWith(categories: validCategories),
          ),
        ],
      );

      blocTest<ShoutOutCreationFormBloc, ShoutOutCreationFormState>(
        'emits [isSubmitting: true, failureOrSuccessOption: none], '
        '[isSubmitting: false, showErrorMessages: true, '
        'failureOrSuccessOption: some(right(unit))] when shoutOut and '
        'image are valid and repository returns Right',
        setUp: () {
          when(
            mockRepository.createShoutOut(
              shoutOut: anyNamed('shoutOut'),
              imageFile: anyNamed('imageFile'),
            ),
          ).thenAnswer((_) async => right(unit));
        },
        seed: () => ShoutOutCreationFormState.initial().copyWith(
          shoutOut: validShoutOut,
          imageFile: some(validImage),
        ),
        build: () => shoutOutCreationFormBloc,
        act: (bloc) => bloc.add(const ShoutOutCreationFormEvent.submitted()),
        expect: () => [
          shoutOutCreationFormBloc.state.copyWith(
            isSubmitting: true,
            showErrorMessages: false,
            failureOrSuccessOption: none(),
          ),
          shoutOutCreationFormBloc.state.copyWith(
            isSubmitting: false,
            showErrorMessages: true,
            failureOrSuccessOption: some(right(unit)),
          ),
        ],
        verify: (_) => verify(
          mockRepository.createShoutOut(
            shoutOut: validShoutOut,
            imageFile: validImage,
          ),
        ).called(1),
      );
    },
  );

  group(
    'Testing on failure',
    () {
      blocTest<ShoutOutCreationFormBloc, ShoutOutCreationFormState>(
        'emits [isSubmitting: true, failureOrSuccessOption: none], '
        '[isSubmitting: false, showErrorMessages: true, '
        'failureOrSuccessOption: some(left(failure))] when shoutOut and '
        'image are valid and repository returns Left',
        setUp: () {
          when(
            mockRepository.createShoutOut(
              shoutOut: anyNamed('shoutOut'),
              imageFile: anyNamed('imageFile'),
            ),
          ).thenAnswer((_) async => left(failure));
        },
        seed: () => ShoutOutCreationFormState.initial().copyWith(
          shoutOut: validShoutOut,
          imageFile: some(validImage),
        ),
        build: () => shoutOutCreationFormBloc,
        act: (bloc) => bloc.add(const ShoutOutCreationFormEvent.submitted()),
        expect: () => [
          shoutOutCreationFormBloc.state.copyWith(
            isSubmitting: true,
            showErrorMessages: false,
            failureOrSuccessOption: none(),
          ),
          shoutOutCreationFormBloc.state.copyWith(
            isSubmitting: false,
            showErrorMessages: true,
            failureOrSuccessOption: some(left(failure)),
          ),
        ],
        verify: (_) => verify(
          mockRepository.createShoutOut(
            shoutOut: validShoutOut,
            imageFile: validImage,
          ),
        ).called(1),
      );

      blocTest<ShoutOutCreationFormBloc, ShoutOutCreationFormState>(
        'emits [isSubmitting: false, showErrorMessages: true, '
        'failureOrSuccessOption: some(left(Failure.emptyFields()))] '
        'when shoutOut is invalid',
        seed: () => ShoutOutCreationFormState.initial().copyWith(
          shoutOut: ShoutOut.empty(),
          imageFile: some(validImage),
        ),
        build: () => shoutOutCreationFormBloc,
        act: (bloc) => bloc.add(const ShoutOutCreationFormEvent.submitted()),
        expect: () => [
          shoutOutCreationFormBloc.state.copyWith(
            isSubmitting: true,
            showErrorMessages: false,
            failureOrSuccessOption: none(),
          ),
          shoutOutCreationFormBloc.state.copyWith(
            isSubmitting: false,
            showErrorMessages: true,
            failureOrSuccessOption: some(
              left(const Failure.emptyFields()),
            ),
          ),
        ],
        verify: (_) => verifyNever(
          mockRepository.createShoutOut(
            shoutOut: anyNamed('shoutOut'),
            imageFile: anyNamed('imageFile'),
          ),
        ),
      );
    },
  );
}
