import 'package:a_tareqaak/presentation/cubit/auth/logout/logout_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:a_tareqaak/domain/entity/auth/logout/logout_entity.dart';


// كيوبيت نموذج واجهة تسجيل الخروج
class LogoutCubit extends Cubit<LogoutCubitState> {
  LogoutCubit() : super(const LogoutCubitState(entity: LogoutEntity()));
}