import 'package:equatable/equatable.dart';
import 'package:rick_and_morty_app/feature/domain/entities/person_entity.dart';

abstract class PersonListState extends Equatable {
  const PersonListState();

  @override
  List<Object> get props => [];
}

class PersonListEmpty extends PersonListState {}

class PersonListLoading extends PersonListState {
  final List<PersonEntity> oldPersonList;
  final bool isFirstFetch;

  const PersonListLoading(this.oldPersonList, {this.isFirstFetch = false});
  @override
  List<Object> get props => [oldPersonList];
}

class PersonListLoaded extends PersonListState {
  final List<PersonEntity> personList;

  const PersonListLoaded(this.personList);

  @override
  List<Object> get props => [personList];
}

class PersonListError extends PersonListState {
  final String message;

  PersonListError({required this.message});

  @override
  List<Object> get props => [message];
}
