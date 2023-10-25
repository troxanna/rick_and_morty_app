import 'package:equatable/equatable.dart';

abstract class PersonListEvent extends Equatable {
  const PersonListEvent();

  @override
  List<Object?> get props => [];
}

class GetPersons extends PersonListEvent {
  final int page;

  const GetPersons(this.page);
}
