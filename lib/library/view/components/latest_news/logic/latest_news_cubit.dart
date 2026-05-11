import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hypnosis_downloads/library/view/components/latest_news/data/models/latest_news_item.dart';

part 'latest_news_state.dart';

class LatestNewsCubit extends Cubit<LatestNewsState> {
  LatestNewsCubit() : super(const LatestNewsStateInitial());

  Future<void> onAppOpened() async {
    emit(const LatestNewsLoadInProgress());
    try {
      // Take all documents by collection.
      List<QueryDocumentSnapshot> documents =
          (await FirebaseFirestore.instance.collection('latest_news').get())
              .docs;

      // If documents are empty return nothing.
      if (documents.isEmpty) {
        emit(const LatestNewsStateInitial());
        return;
      }
      // Sort documents by newest.
      documents.sort((a, b) {
        Timestamp timestampA = (a.data() as Map)['timestamp'] as Timestamp;
        Timestamp timestampB = (b.data() as Map)['timestamp'] as Timestamp;
        return timestampB.compareTo(timestampA);
      });

      emit(
        LatestNewsLoadSuccess(
          latestNewsItem: LatestNewsItem(
            text: documents[0]['text'],
            timestamp: documents[0]['timestamp'],
          ),
        ),
      );
    } catch (e) {
      emit(LatestNewsLoadFailure(e.toString()));
    }
  }
}
