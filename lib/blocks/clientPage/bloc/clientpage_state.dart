part of 'clientpage_bloc.dart';

abstract class ClientpageState extends Equatable {
  const ClientpageState();

  @override
  List<Object> get props => [];
}

class ClientpageInitial extends ClientpageState {}

class ClientpageLocationAdded extends ClientpageState {
  final String response;

  ClientpageLocationAdded({this.response});
}

class ClientpageLocationFailed extends ClientpageState {}

class ClientpageLoading extends ClientpageState {}
