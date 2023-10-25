import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_app/feature/presentation/bloc/person_list_bloc/person_list_bloc.dart';
import 'package:rick_and_morty_app/feature/presentation/bloc/person_list_bloc/person_list_event.dart';
import 'package:rick_and_morty_app/feature/presentation/bloc/person_list_bloc/person_list_state.dart';
import 'package:rick_and_morty_app/feature/presentation/widgets/person_card_widget.dart';
import 'package:rick_and_morty_app/feature/domain/entities/person_entity.dart';

class PersonsList extends StatelessWidget {
  final scrollController = ScrollController();
  final int page = -1;

  PersonsList({Key? key}) : super(key: key);
  void setupScrollController(BuildContext context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          BlocProvider.of<PersonListBloc>(context, listen: false)
              .add(GetPersons(page));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    setupScrollController(context);
    BlocProvider.of<PersonListBloc>(context, listen: false)
        .add(GetPersons(page));

    return BlocBuilder<PersonListBloc, PersonListState>(
        builder: (context, state) {
      List<PersonEntity> persons = [];
      bool isLoading = false;

      if (state is PersonListLoading && state.isFirstFetch) {
        return const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else if (state is PersonListLoading) {
        persons = state.oldPersonList;
        isLoading = true;
      } else if (state is PersonListLoaded) {
        persons = state.personList;
      } else if (state is PersonListError) {
        return Text(
          state.message,
          style: const TextStyle(color: Colors.white, fontSize: 25),
        );
      }
      return ListView.separated(
        controller: scrollController,
        itemBuilder: (context, index) {
          if (index < persons.length) {
            return PersonCard(person: persons[index]);
          } else {
            Timer(const Duration(milliseconds: 30), () {
              scrollController
                  .jumpTo(scrollController.position.maxScrollExtent);
            });
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.grey[400],
          );
        },
        itemCount: persons.length + (isLoading ? 1 : 0),
      );
    });
  }
}
