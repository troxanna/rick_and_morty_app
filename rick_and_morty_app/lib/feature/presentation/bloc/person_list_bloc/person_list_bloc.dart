import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_app/core/error/failure.dart';
import 'package:rick_and_morty_app/feature/domain/entities/person_entity.dart';
import 'package:rick_and_morty_app/feature/domain/usecases/get_all_persons.dart';
import 'package:rick_and_morty_app/feature/presentation/bloc/person_list_bloc/person_list_event.dart';
import 'package:rick_and_morty_app/feature/presentation/bloc/person_list_bloc/person_list_state.dart';

const SERVER_FAILURE_MESSAGE = 'Server Failure';
const CACHED_FAILURE_MESSAGE = 'Cache Failure';

class PersonListBloc extends Bloc<PersonListEvent, PersonListState> {
  final GetAllPersons getPersons;
  int page = 1;

  PersonListBloc({required this.getPersons}) : super(PersonListEmpty()) {
    on<GetPersons>(_onEvent);
  }

  FutureOr<void> _onEvent(
      GetPersons event, Emitter<PersonListState> emit) async {
    print('loading');
    if (state is PersonListLoading) return;
    final currentState = state;

    var oldPerson = <PersonEntity>[];
    if (currentState is PersonListLoaded) {
      oldPerson = currentState.personList;
    }
    emit(PersonListLoading(oldPerson, isFirstFetch: page == 1));
    final failureOrPerson = await getPersons(PagePersonParams(page: page));
    failureOrPerson.fold(
        (failure) =>
            emit(PersonListError(message: _mapFailureToMessage(failure))),
        (character) {
      page++;
      final persons = (state as PersonListLoading).oldPersonList;
      persons.addAll(character);
      print('List length: ${persons.length.toString()}');
      emit(PersonListLoaded(persons));
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHED_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
