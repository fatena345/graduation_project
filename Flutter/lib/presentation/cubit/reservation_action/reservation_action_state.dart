import 'package:equatable/equatable.dart';
import 'package:a_tareqaak/domain/entity/rides/id_entity.dart';

// حالة الكيوبيت لنموذج واجهة اختيار الحجز المقبول أو المرفوض
class ReservationActionCubitState extends Equatable {
  final IdEntity? entity;

  const ReservationActionCubitState({required this.entity});

  ReservationActionCubitState copyWith({
    IdEntity? entity,
  }) {
    return ReservationActionCubitState(
      entity: entity ?? this.entity,
    );
  }

  @override
  List<Object?> get props => [entity];
}