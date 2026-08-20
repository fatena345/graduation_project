import 'package:a_tareqaak/presentation/bloc/rides/reservation_action/reservation_actionbloc.dart';
import 'package:a_tareqaak/presentation/cubit/reservation_action/reservation_action_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import 'package:a_tareqaak/core/extension/localization_extension.dart';
import 'package:a_tareqaak/core/extension/theme_color_extension.dart';
import 'package:a_tareqaak/core/helper/share_helper.dart';
import 'package:a_tareqaak/core/l10n/app_localizations.dart';
import 'package:a_tareqaak/core/resources/app_fonts.dart';
import 'package:a_tareqaak/core/resources/app_values.dart';
import 'package:a_tareqaak/core/routes/app_routes.dart';
import 'package:a_tareqaak/data/models/rides/reservation_data_model.dart';
import 'package:a_tareqaak/data/models/rides/ride_data_model.dart';
import 'package:a_tareqaak/domain/entity/rides/id_entity.dart';
import 'package:a_tareqaak/presentation/bloc/rides/reservation_action/i_reservation_action_event.dart';
import 'package:a_tareqaak/presentation/bloc/rides/reservation_action/i_reservation_action_state.dart';

import 'package:a_tareqaak/presentation/bloc/rides/ride_details/i_ride_details_event.dart';
import 'package:a_tareqaak/presentation/bloc/rides/ride_details/i_ride_details_state.dart';
import 'package:a_tareqaak/presentation/bloc/rides/ride_details/ride_details_bloc.dart';
import 'package:a_tareqaak/presentation/cubit/profile/driver_profile_cubit.dart';

import 'package:a_tareqaak/presentation/widgets/custom_elevated_button.dart';
import 'package:a_tareqaak/presentation/widgets/custom_snack_bar.dart';
import 'package:a_tareqaak/presentation/widgets/text/body_title.dart';
import 'package:a_tareqaak/presentation/widgets/text/section_title.dart';

class RideDetailsScreen extends StatelessWidget {
  final RideDataModel ride;

  const RideDetailsScreen({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    // 👈 تجميع الـ Cubit والـ Blocs لجميع العمليات في الشاشة
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              RideDetailsBloc()..add(GetRideDetailsEvent(IdEntity(ride.id!))),
        ),
        BlocProvider(create: (_) => ReservationActionCubit()),
        BlocProvider(create: (_) => ReservationActionBloc()),
      ],
      child: _RideDetailsContent(initialRide: ride),
    );
  }
}

class _RideDetailsContent extends StatelessWidget {
  final RideDataModel initialRide;

  const _RideDetailsContent({required this.initialRide});

  void _shareRide(
      BuildContext context, AppLocalizations tr, RideDataModel? ride) {
    if (ride == null) return;
    final buffer = StringBuffer()
      ..writeln(tr.ride_details_title)
      ..writeln('${tr.departure_location}: ${ride.location ?? ''}')
      ..writeln('${tr.destination}: ${ride.destination ?? ''}')
      ..writeln(
          '${tr.date_and_time}: ${ride.departureDate ?? ''} ${ride.departureTime ?? ''}')
      ..writeln('${tr.driver}: ${ride.driverInfo?.driverName ?? ''}')
      ..writeln('${tr.price}: ${ride.cost ?? ''} ${tr.syrian_pound}');

    ShareHelper.shareText(
      buffer.toString().trim(),
      subject: tr.share_ride,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tr = context.loc;
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    final isRider = context.read<DriverProfileCubit>().isRider;

    return Scaffold(
      backgroundColor: context.appColors.backGround,
      body: SafeArea(
        // 👈 الاستماع لنتيجة قبول أو رفض الحجز عبر ReservationActionBloc
        child: BlocListener<ReservationActionBloc, IReservationActionState>(
          listener: (context, apiState) {
            if (apiState is ReservationActionSuccess) {
              showCustomSnackBar(
                context: context,
                title: tr.success_title,
                message: apiState.message,
                contentType: ContentType.success,
              );
              // إعادة جلب تفاصيل الرحلة المحدثة فور النجاح
              context
                  .read<RideDetailsBloc>()
                  .add(GetRideDetailsEvent(IdEntity(initialRide.id!)));
            } else if (apiState is ReservationActionFailed) {
              showCustomSnackBar(
                context: context,
                title: tr.error_title,
                message: apiState.message,
                contentType: ContentType.failure,
              );
            }
          },
          child: BlocBuilder<RideDetailsBloc, IRideDetailsState>(
            builder: (context, state) {
              if (state is RideDetailsLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is RideDetailsFailed) {
                return Center(child: BodyTitle(text: state.message));
              }
              if (state is RideDetailsLoaded) {
                final ride = state.response?.data?.ride ?? initialRide;
                final reservationsList = ride.reservations ?? <ReservationDataModel>[];
  final driverInfo = ride.driverInfo;

                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppPaddingWidth.p20,
                    vertical: AppPaddingHeight.p15,
                  ),
                  child: Column(
                    spacing: AppHeight.h16,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // الشريط العلوي
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => context.pop(),
                            icon: FaIcon(
                              isRtl
                                  ? FontAwesomeIcons.chevronRight
                                  : FontAwesomeIcons.chevronLeft,
                              color: context.appColors.blackText,
                              size: AppSize.s20,
                            ),
                          ),
                          SectionTitle(
                            text: tr.ride_details_title,
                            fontSize: AppFontSize.s18,
                            fontWeight: AppFontWeight.bold,
                          ),
                          SizedBox(width: AppWidth.w40),
                        ],
                      ),

                      // مسار الرحلة (الانطلاق والوصول)
                      Container(
                        padding: EdgeInsets.all(AppPaddingWidth.p16),
                        decoration: BoxDecoration(
                          color: context.appColors.white,
                          borderRadius: BorderRadius.circular(AppRadius.r16),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  context.appColors.primary.withOpacity(0.08),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SectionTitle(
                              text: ride.location ?? '',
                              fontSize: AppFontSize.s16,
                              color: context.appColors.primary,
                            ),
                            FaIcon(
                              FontAwesomeIcons.arrowRightLong,
                              color: context.appColors.primary,
                              size: AppSize.s20,
                            ),
                            SectionTitle(
                              text: ride.destination ?? '',
                              fontSize: AppFontSize.s16,
                              color: context.appColors.primary,
                            ),
                          ],
                        ),
                      ),

                      // معلومات السائق
                      Container(
                        padding: EdgeInsets.all(AppPaddingWidth.p14),
                        decoration: BoxDecoration(
                          color: context.appColors.white,
                          borderRadius: BorderRadius.circular(AppRadius.r16),
                          border:
                              Border.all(color: context.appColors.lightGreySec),
                        ),
                        child: Row(
                          spacing: AppWidth.w12,
                          children: [
                            CircleAvatar(
                              radius: AppRadius.r25,
                              backgroundColor: context.appColors.lightGrey,
                              child: FaIcon(
                                FontAwesomeIcons.user,
                                color: context.appColors.primary,
                                size: AppSize.s24,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                spacing: AppHeight.h4,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SectionTitle(
                                    text: driverInfo?.driverName ?? tr.driver,
                                    fontSize: AppFontSize.s15,
                                  ),
                                  BodyTitle(
                                    text:
                                        '${ride.departureDate ?? ''} | ${ride.departureTime ?? ''}',
                                    fontSize: AppFontSize.s12,
                                    color: context.appColors.greyText,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // زر تتبع مسار الرحلة المباشر للراكب
                      if (isRider)
                        CustomElevatedButton(
                          height: AppHeight.h50,
                          width: double.infinity,
                          borderRadius: AppRadius.r12,
                          color: context.appColors.primary,
                          onPressed: () {
                            RideTrackingRoute($extra: ride, isDriver: false)
                                .push(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: AppWidth.w8,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.locationCrosshairs,
                                color: context.appColors.white,
                                size: AppSize.s18,
                              ),
                              BodyTitle(
                                text: "تتبع مسار الرحلة مباشرة",
                                color: context.appColors.white,
                                fontSize: AppFontSize.s16,
                                fontWeight: AppFontWeight.bold,
                              ),
                            ],
                          ),
                        ),

                      // زر مشاركة الرحلة للراكب
                      if (isRider)
                        CustomElevatedButton(
                          height: AppHeight.h50,
                          width: double.infinity,
                          borderRadius: AppRadius.r12,
                          color: context.appColors.primary,
                          onPressed: () => _shareRide(context, tr, ride),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: AppWidth.w8,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.shareNodes,
                                color: context.appColors.white,
                                size: AppSize.s18,
                              ),
                              BodyTitle(
                                text: tr.share_ride,
                                color: context.appColors.white,
                                fontSize: AppFontSize.s16,
                                fontWeight: AppFontWeight.bold,
                              ),
                            ],
                          ),
                        ),

                      // 👈 قسم عرض طلبات الحجز المعلقة للسائق فقط
                      if (!isRider)
                        _buildDriverReservationsSection(
                          context: context,
                          tr: tr,
                          reservations:reservationsList,
                        ),
                    ],
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  // بناء قسم طلبات الحجز المخصص للسائق
// بناء قسم طلبات الحجز المعلقة للسائق
Widget _buildDriverReservationsSection({
  required BuildContext context,
  required AppLocalizations tr,
  required List<ReservationDataModel> reservations,
}) {
  return Column(
    spacing: AppHeight.h10,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SectionTitle(
        text: tr.pending_reservations_title,
        fontSize: AppFontSize.s16,
        color: context.appColors.primary,
      ),
      if (reservations.isEmpty)
        Container(
          padding: EdgeInsets.all(AppPaddingWidth.p16),
          decoration: BoxDecoration(
            color: context.appColors.white,
            borderRadius: BorderRadius.circular(AppRadius.r12),
            border: Border.all(color: context.appColors.lightGreySec),
          ),
          child: Center(
            child: BodyTitle(
              text: tr.no_pending_reservations,
              color: context.appColors.greyText,
            ),
          ),
        )
      else
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reservations.length,
          separatorBuilder: (_, __) => SizedBox(height: AppHeight.h12),
          itemBuilder: (context, index) {
            final reservation = reservations[index];
            return _buildReservationCard(
              context: context,
              tr: tr,
              reservation: reservation,
            );
          },
        ),
    ],
  );
}
  // كارد الحجز المزوّد بأزرار قبول ورفض الحجز باستخدام ReservationActionBloc و ReservationActionCubit
  Widget _buildReservationCard({
    required BuildContext context,
    required AppLocalizations tr,
    required ReservationDataModel reservation,
  }) {
    return Container(
      padding: EdgeInsets.all(AppPaddingWidth.p16),
      decoration: BoxDecoration(
        color: context.appColors.white,
        borderRadius: BorderRadius.circular(AppRadius.r16),
        boxShadow: [
          BoxShadow(
            color: context.appColors.primary.withOpacity(0.08),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        spacing: AppHeight.h12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: AppWidth.w10,
                children: [
                  CircleAvatar(
                    radius: AppRadius.r20,
                    backgroundColor: context.appColors.lightGrey,
                    child: FaIcon(
                      FontAwesomeIcons.user,
                      size: AppSize.s18,
                      color: context.appColors.primary,
                    ),
                  ),
                  SectionTitle(
                    text: reservation.riderName ?? "رؤف البني",
                    fontSize: AppFontSize.s15,
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppPaddingWidth.p8,
                  vertical: AppPaddingHeight.p4,
                ),
                decoration: BoxDecoration(
                  color: context.appColors.lightOrange,
                  borderRadius: BorderRadius.circular(AppRadius.r6),
                ),
                child: BodyTitle(
                  text: reservation.status ?? tr.waiting_approval,
                  fontSize: AppFontSize.s11,
                  color: context.appColors.orange,
                  fontWeight: AppFontWeight.bold,
                ),
              ),
            ],
          ),

          // مكان الالتقاء
          Row(
            spacing: AppWidth.w8,
            children: [
              FaIcon(
                FontAwesomeIcons.locationCrosshairs,
                size: AppSize.s14,
                color: context.appColors.primary,
              ),
              BodyTitle(
                text: '${tr.pickup_location_label}: ',
                fontSize: AppFontSize.s12,
                color: context.appColors.greyText,
              ),
              BodyTitle(
                text: reservation.pickupLocation ?? '',
                fontSize: AppFontSize.s13,
                fontWeight: AppFontWeight.bold,
              ),
            ],
          ),

          Divider(color: context.appColors.lightGreySec, height: 0),

          // أزرار التأكيد (القبول) والإلغاء (الرفض)
          if(reservation.status == 'pending' )
          BlocBuilder<ReservationActionBloc, IReservationActionState>(
            builder: (context, apiState) {
              final isLoading = apiState is ReservationActionLoading;
            
              return Row(
                spacing: AppWidth.w10,
                children: [
                  // 1. زر تأكيد الحجز (قبول)
                  Expanded(
                    child: CustomElevatedButton(
                      height: AppHeight.h40,
                      borderRadius: AppRadius.r10,
                      color: context.appColors.primary,
                      loading: isLoading,
                      onPressed: () {
                        // تحديث الحالة بداخل الكيوبيت
                        context
                            .read<ReservationActionCubit>()
                            .selectReservation(reservation.id!);

                        // إرسال حدث القبول لـ ReservationActionBloc
                        context.read<ReservationActionBloc>().add(
                              AcceptReservationEvent(
                                IdEntity(reservation.id!),
                              ),
                            );
                      },
                      child: BodyTitle(
                        text: tr.accept_reservation,
                        color: context.appColors.white,
                        fontSize: AppFontSize.s13,
                        fontWeight: AppFontWeight.bold,
                      ),
                    ),
                  ),

                  // 2. زر إلغاء/رفض الحجز
                  Expanded(
                    child: CustomElevatedButton(
                      height: AppHeight.h40,
                      borderRadius: AppRadius.r10,
                      color: context.appColors.white,
                      borderSide: BorderSide(color: context.appColors.red),
                      loading: isLoading,
                      onPressed: () {
                        // تحديث الحالة بداخل الكيوبيت
                        context
                            .read<ReservationActionCubit>()
                            .selectReservation(reservation.id!);

                        // إرسال حدث الرفض لـ ReservationActionBloc
                        context.read<ReservationActionBloc>().add(
                              RejectReservationEvent(
                                IdEntity(reservation.id!),
                              ),
                            );
                      },
                      child: BodyTitle(
                        text: tr.reject_reservation,
                        color: context.appColors.red,
                        fontSize: AppFontSize.s13,
                        fontWeight: AppFontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}