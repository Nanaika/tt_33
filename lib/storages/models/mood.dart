import 'package:isar/isar.dart';

part 'mood.g.dart';

@collection
class Mood {
  Id id = Isar.autoIncrement;
  final DateTime date;
  @enumerated
  final MoodType type;
  final List<String> reasons;
  final String comment;

  Mood({required this.date, required this.type, required this.reasons,this.comment = ''});

  @override
  String toString() {
    return 'id = $id\ndate = ${date.year}/${date.month}/${date.day}\ntype = $type';
  }

}
enum MoodType {
  happy, sad, angry, anxiety
}