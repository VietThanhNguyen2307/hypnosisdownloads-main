import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:error_handling/error_handling.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'connectivity_status_state.dart';

class ConnectivityStatusCubit extends Cubit<ConnectivityStatusState> {
  ConnectivityStatusCubit(this.connectivity)
      : super(const ConnectivityStatusStateInitial());

  final Connectivity connectivity;
  StreamSubscription? connectivitySubscription;

  Future<void> onPageOpened() async {
    await _showConnectivityStatus();
    await _startListeningToConnectivityStatus();
  }

  Future<void> onPageClosed() async {
    await _stopListeningToConnectivityStatus();
  }

  Future<void> onBackPressed() async {
    emit(const ConnectivityStatusStateInitial());
  }

  Future<void> _showConnectivityStatus() async {
    emit(const ConnectivityStatusLoadInProgress());
    final connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      emit(const ConnectivityStatusOffline());
    } else {
      emit(const ConnectivityStatusOnline());
    }
  }

  Future<void> _startListeningToConnectivityStatus() async {
    try {
      connectivitySubscription =
          connectivity.onConnectivityChanged.listen((connectivityResult) {
        if (connectivityResult == ConnectivityResult.none) {
          emit(const ConnectivityStatusOffline());
        } else {
          emit(const ConnectivityStatusOnline());
        }
      });
    } on UserCanceledException catch (_) {
      emit(const ConnectivityStatusStateInitial());
    } catch (e) {
      emit(ConnectivityStatusLoadFailure(e.toString()));
    }
  }

  Future<void> _stopListeningToConnectivityStatus() async {
    await connectivitySubscription?.cancel();
  }
}
