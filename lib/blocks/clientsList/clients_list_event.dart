
part of 'clients_list_bloc.dart';

abstract class ClientsListEvent extends Equatable {
  const ClientsListEvent();

  @override
  List<Object> get props => [];
}

class LoginSuccessfullyPassed extends ClientsListEvent{
  final LoginRequest request;
  LoginSuccessfullyPassed({this.request});
}


class StartSearch extends ClientsListEvent{}
class ListLoading extends ClientsListEvent{}

class ChangingCategory extends ClientsListEvent{
  final String newCategory;
  ChangingCategory({this.newCategory});
}
class ChangingCategoryFin extends ClientsListEvent{}

class ChangingSearch extends ClientsListEvent{
  final String newSearch;
  ChangingSearch({this.newSearch});
}
class ChangingSearchFin extends ClientsListEvent{
  final String newSearch;
  ChangingSearchFin({this.newSearch});
}

class ExitSearch extends ClientsListEvent{}