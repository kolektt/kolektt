// import 'package:supabase_flutter/supabase_flutter.dart';
//
// import '../domain/entities/discogs_record.dart';
// import '../model/local/collection_record.dart';
// import '../model/supabase/user_collection.dart';
//
// class CollectionRepository {
//   final supabase = Supabase.instance.client;
//
//   Future<List<CollectionRecord>> fetchUserCollection(String userId) async {
//     final response = await supabase
//         .from('user_collections')
//         .select('*, records(*)')
//         .eq('user_id', userId.toString());
//
//     List<CollectionRecord> _collectionRecords = (response as List).map<CollectionRecord>((item) {
//       final recordId = item['record_id'];
//       final recordJson = item['records'] as Map<String, dynamic>?;
//       if (recordJson != null) {
//         recordJson['id'] = recordId;
//         return CollectionRecord(
//             record: DiscogsRecord(
//                 id: 1,
//                 title: '',
//                 resourceUrl: '',
//                 artists: [],
//                 notes: '',
//                 genre: '',
//                 coverImage: '',
//                 catalogNumber: '',
//                 label: '',
//                 format: '',
//                 country: '',
//                 style: '',
//                 condition: '',
//                 conditionNotes: '',
//                 recordId: 1,
//                 artist: '',
//                 releaseYear: 2021),
//             user_collection: UserCollection.fromJson(item));
//       } else {
//         return CollectionRecord.sampleData[0];
//       }
//     }).toList();
//     return _collectionRecords;
//   }
// }
