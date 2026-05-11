import 'package:equatable/equatable.dart';
import 'package:error_handling/error_handling.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:hypnosis_downloads/app/common/filtering_mode.dart';
import 'package:hypnosis_downloads/library/data/model/product.dart';
import 'package:hypnosis_downloads/library/data/model/product_pack.dart';
import 'package:hypnosis_downloads/library/data/model/session.dart';
import 'package:hypnosis_downloads/library/data/sessions_repository.dart';

part 'sessions_state.dart';

class SessionsCubit extends Cubit<SessionsState> {
  SessionsCubit(
    this.sessionsRepository,
  ) : super(SessionsInitial());

  final SessionsRepository sessionsRepository;
  FilteringMode filter = FilteringMode.none;

  Future<void> onPageOpened() async {
    emit(SessionsLoadInProgress());
    try {
      final session = await sessionsRepository.getSession();
      await sessionsRepository.init(session);

      emit(SessionsLoadSuccess(session));
    } catch (error, stackTrace) {
      if (await _emitOfflineSessionIfAvailable(error)) {
        return;
      }
      FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: 'Sessions load failure',
        fatal: false,
      );
      emit(SessionsLoadFailure(parseErrorMessageFrom(error)));
    }
  }

  Future<void> onLogout() async {
    emit(SessionsInitial());
  }

  onFilterChanged(FilteringMode filter) {
    if (state is SessionsLoadSuccess) {
      this.filter = filter;
      emit(SessionsLoadSuccess((state as SessionsLoadSuccess).session));
    }
  }

  List<ProductPack> get audioPacks => sessionsRepository.audioPacks;

  List<ProductPack> get scriptPacks => sessionsRepository.scriptPacks;

  List<ProductPack> get audioWithScriptPacks =>
      sessionsRepository.audioWithScriptPacks;

  List<Product> get audios => sessionsRepository.audios;
  List<Product> get scripts => sessionsRepository.scripts;

  Future<void> loadSessions() async {
    try {
      emit(SessionsLoadInProgress());
      final session = await sessionsRepository.getSession();
      await sessionsRepository.init(session);

      emit(SessionsLoadSuccess(session));
    } catch (error, stackTrace) {
      if (await _emitOfflineSessionIfAvailable(error)) {
        return;
      }
      FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: 'Sessions load failure',
        fatal: false,
      );
      emit(SessionsLoadFailure(parseErrorMessageFrom(error)));
    }
  }

  Future<bool> _emitOfflineSessionIfAvailable(Object error) async {
    if (!_isConnectivityError(error)) {
      return false;
    }

    final offlineSession =
        await sessionsRepository.getOfflineSessionForDownloadedProducts();
    final hasOfflineContent = offlineSession.audios.isNotEmpty ||
        offlineSession.scripts.isNotEmpty ||
        offlineSession.audioPacks.isNotEmpty ||
        offlineSession.scriptPacks.isNotEmpty ||
        offlineSession.audioWithScriptPacks.isNotEmpty;

    if (hasOfflineContent) {
      emit(SessionsLoadSuccess(offlineSession));
      return true;
    }
    return false;
  }

  bool _isConnectivityError(Object error) {
    if (error is DioException) {
      return error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.unknown;
    }
    return false;
  }
}
