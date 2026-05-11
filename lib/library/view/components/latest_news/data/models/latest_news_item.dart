import 'package:cloud_firestore/cloud_firestore.dart';

class LatestNewsItem {
  final String text;
  final Timestamp timestamp;

  const LatestNewsItem({
    required this.text,
    required this.timestamp,
  });
}
