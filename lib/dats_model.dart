import 'package:cloud_firestore/cloud_firestore.dart';

class DataModel {
  final List<QueryDocumentSnapshot<Map>> episodesData;
  int index;
  int max;

  DataModel(this.episodesData, this.index, this.max);
}
