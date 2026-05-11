part of 'latest_news_cubit.dart';

abstract class LatestNewsState extends Equatable {
  const LatestNewsState();

  @override
  List<Object?> get props => [];
}

class LatestNewsStateInitial extends LatestNewsState {
  const LatestNewsStateInitial();
}

class LatestNewsLoadInProgress extends LatestNewsState {
  const LatestNewsLoadInProgress();
}

class LatestNewsLoadSuccess extends LatestNewsState {
  final LatestNewsItem latestNewsItem;

  const LatestNewsLoadSuccess({
    required this.latestNewsItem,
  });

  @override
  List<Object?> get props => [latestNewsItem];
}

class LatestNewsLoadFailure extends LatestNewsState {
  const LatestNewsLoadFailure(this.errorMessage);

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
