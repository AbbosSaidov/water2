part of 'clientpage_bloc.dart';

abstract class ClientpageEvent extends Equatable {
  const ClientpageEvent();

  @override
  List<Object> get props => [];
}

class LocationAddPressed extends ClientpageEvent {
  final String locationURL;
  final CounterParties user;
  LocationAddPressed({this.locationURL, this.user});
}
