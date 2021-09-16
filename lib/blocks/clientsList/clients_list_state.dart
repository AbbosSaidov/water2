part of 'clients_list_bloc.dart';

abstract class ClientsListState extends Equatable {

  const ClientsListState();
  @override
  List<Object> get props => [];
}

class ClientsListInitial extends ClientsListState {}

class ClientsListLoading extends ClientsListState {}

class ClientsListLoadingFailed extends ClientsListState {}

class ClientsListLoaded extends ClientsListState{
  final List<CounterParties> response;
  ClientsListLoaded({
    @required this.response,
  });
}
//searching
class Searching extends ClientsListState {
  final TextEditingController searchQueryController; //= TextEditingController();
  final String searchQuery ; //= "Search query";
  final String searchQueryCategory ; //= "One";
  final List<CounterParties> response ;


  Searching( {this.response,this.searchQuery, this.searchQueryCategory,
    this.searchQueryController});
}
class CategoryHasChanged extends Searching{
  final String searchQueryCategory ;
  final List<CounterParties> response ;
  CategoryHasChanged(this.searchQueryCategory,this.response);
}
class CategoryHasChangedFin extends Searching{
  final String searchQueryCategory ;
  final List<CounterParties> response ;
  CategoryHasChangedFin(this.searchQueryCategory,this.response);
}
class SearchHasChanged extends Searching{
  final String searchQueryCategory ;
  final List<CounterParties> response ;
  SearchHasChanged(this.searchQueryCategory,this.response);
}
class SearchHasChangedFin extends Searching{
  final String searchQueryCategory ;
  final List<CounterParties> response ;
  SearchHasChangedFin(this.searchQueryCategory,this.response);
}

class ExitedSearching extends ClientsListState {
  final List<CounterParties> response ;
  ExitedSearching(this.response);
}