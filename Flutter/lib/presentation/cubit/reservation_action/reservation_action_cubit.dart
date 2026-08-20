import 'package:a_tareqaak/presentation/cubit/reservation_action/reservation_action_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:a_tareqaak/domain/entity/rides/id_entity.dart';

// كيوبيت إدارة واجهة اختيار رقم الحجز لقبوله أو رفضه
class ReservationActionCubit extends Cubit<ReservationActionCubitState> {
  ReservationActionCubit()
      : super(const ReservationActionCubitState(entity: null));

  void selectReservation(int reservationId) {
    emit(state.copyWith(entity: IdEntity(reservationId)));
  }
}