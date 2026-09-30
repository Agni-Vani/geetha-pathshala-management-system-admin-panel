import 'package:flutter/material.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/process_notifier.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/snackbar_notifier.dart';
import 'package:geetha_pathshala_management_web/src/core/utils/utils.dart';
import '../../domain/person_domain.dart';

class ListPeopleController extends ChangeNotifier {
  final ProcessStatusNotifier processStatusNotifier = ProcessStatusNotifier(initialStatus: ProcessEnabled());
  final SearchPeople searchPeople;

  ListPeopleController({required this.searchPeople});

  List<Person> people = [];

  Future<void> load({
    required String organizationId,
    String? searchQuery,
    SnackbarNotifier? snackbarNotifier,
  }) async {
    await handleFutureRequest(
      request: () => searchPeople.call(
        SearchPeopleParams(organizationId: organizationId, query: searchQuery),
      ),
      processStatusNotifier: processStatusNotifier,
      errorSnackbarNotifier: snackbarNotifier,
      onSuccess: (data) {
        people = data;
        notifyListeners();
      },
    );
  }
}
