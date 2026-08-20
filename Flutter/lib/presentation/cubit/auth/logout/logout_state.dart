
// حالة الكيوبيت الخاصة بواجهة تسجيل الخروج
import 'package:a_tareqaak/domain/entity/auth/logout/logout_entity.dart';
import 'package:equatable/equatable.dart';

class LogoutCubitState extends Equatable {
  final LogoutEntity? entity;

  const LogoutCubitState({this.entity = const LogoutEntity()});

  LogoutCubitState copyWith({
    LogoutEntity? entity,
  }) {
    return LogoutCubitState(
      entity: entity ?? this.entity,
    );
  }

  @override
  List<Object?> get props => [entity];
}