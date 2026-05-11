part of 'edit_playlist_name_cubit.dart';

abstract class EditPlaylistNameState extends Equatable {
  const EditPlaylistNameState();

  @override
  List<Object> get props => [];
}

class EditPlaylistNameInitial extends EditPlaylistNameState {}

class SaveNameInProgress extends EditPlaylistNameState {}

class SaveNameSuccess extends EditPlaylistNameState {}

class SaveNameFailure extends EditPlaylistNameState {
  const SaveNameFailure(this.errorMessage);

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
