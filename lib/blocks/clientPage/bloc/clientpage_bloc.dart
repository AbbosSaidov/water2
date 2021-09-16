import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:water2/models/counterpartyresponse.dart';
import 'package:water2/service/clientPageRepository/clientpagerepository.dart';

part 'clientpage_event.dart';
part 'clientpage_state.dart';

class ClientpageBloc extends Bloc<ClientpageEvent, ClientpageState> {
  final ClientPageRepository repository;
  ClientpageBloc({
    @required this.repository,
  }) : super(ClientpageInitial());

  @override
  Stream<ClientpageState> mapEventToState(
    ClientpageEvent event,
  )async*{
    if(event is LocationAddPressed){
      yield* _locationAddProcess(event.user, event, event.locationURL);
    }
  }

  Stream<ClientpageState> _locationAddProcess(
      CounterParties user, ClientpageEvent event, String url) async* {
    yield ClientpageLoading();
    try {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      String response = await repository.addLocation(user, url);
      yield ClientpageLocationAdded(response: response);
    }catch (err){
      yield ClientpageLocationFailed();
    }
  }
}
