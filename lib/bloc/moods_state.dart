import 'package:equatable/equatable.dart';
import 'package:tt33/storages/models/trigger.dart';

class MoodsState extends Equatable {
  const MoodsState({
    this.page = 0,
    required this.triggers,
  });

  final int page;
  final List<Trigger> triggers;

  @override
  List<Object?> get props => [
        page,
        triggers,
      ];

  MoodsState copyWith({int? page, List<Trigger>? triggers}) {
    return MoodsState(
      page: page ?? this.page,
      triggers: triggers ?? this.triggers,
    );
  }
}
