import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import 'package:a_tareqaak/core/extension/localization_extension.dart';
import 'package:a_tareqaak/core/extension/theme_color_extension.dart';
import 'package:a_tareqaak/core/resources/app_fonts.dart';
import 'package:a_tareqaak/core/resources/app_values.dart';
import 'package:a_tareqaak/core/routes/app_routes.dart';
import 'package:a_tareqaak/presentation/bloc/auth/logout/i_logout_event.dart';
import 'package:a_tareqaak/presentation/bloc/auth/logout/i_logout_state.dart';
import 'package:a_tareqaak/presentation/bloc/auth/logout/logout_bloc.dart';
import 'package:a_tareqaak/presentation/cubit/auth/logout/logout_cubit.dart';
import 'package:a_tareqaak/presentation/cubit/language/language_cubit.dart';
import 'package:a_tareqaak/presentation/cubit/theme/theme_cubit.dart';
import 'package:a_tareqaak/presentation/widgets/custom_snack_bar.dart';
import 'package:a_tareqaak/presentation/widgets/text/body_title.dart';
import 'package:a_tareqaak/presentation/widgets/text/section_title.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final List<FaIconData> icons = [
    FontAwesomeIcons.user,
    FontAwesomeIcons.wallet,
    FontAwesomeIcons.language,
    FontAwesomeIcons.moon,
    FontAwesomeIcons.headset,
    FontAwesomeIcons.circleQuestion,
    FontAwesomeIcons.rightFromBracket,
  ];

  @override
  Widget build(BuildContext context) {
    final tr = context.loc;

    List<String> titles = [
      tr.view_profile,
      tr.wallet_and_payment,
      tr.language_switch,
      tr.dark_mode,
      tr.customer_service,
      tr.my_reports,
      tr.logout,
    ];

    // 👈 تجميع LogoutCubit و LogoutBloc بنفس النمط المعماري للمشروع
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LogoutCubit()),
        BlocProvider(create: (_) => LogoutBloc()),
      ],
      child: Scaffold(
        backgroundColor: context.appColors.backGround,
        body: SafeArea(
          // 👈 الاستماع لحالة نتيجة تسجيل الخروج من السيرفر عبر LogoutBloc
          child: BlocConsumer<LogoutBloc, ILogoutState>(
            listener: (context, apiState) {
              if (apiState is LogoutSuccess) {
                showCustomSnackBar(
                  context: context,
                  title: tr.success_title,
                  message: tr.logout,
                  contentType: ContentType.success,
                );
                // 👈 التوجيه الصريح لشاشة تسجيل الدخول بـ Typed Route بعد نجاح العملية
                LoginRoute().go(context);
              } else if (apiState is LogoutFailed) {
                showCustomSnackBar(
                  context: context,
                  title: tr.error_title,
                  message: apiState.message,
                  contentType: ContentType.failure,
                );
              }
            },
            builder: (context, apiState) {
              return Column(
                children: [
                  // الشريط العلوي
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppPaddingWidth.p20,
                      vertical: AppPaddingHeight.p15,
                    ),
                    child: Center(
                      child: SectionTitle(
                        text: tr.settings,
                        fontSize: AppFontSize.s18,
                        fontWeight: AppFontWeight.bold,
                      ),
                    ),
                  ),

                  // قائمة الخيارات
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppPaddingWidth.p20,
                      ),
                      child: ListView.separated(
                        itemCount: titles.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: AppHeight.h12),
                        itemBuilder: (context, index) => _buildSettingCard(
                          context,
                          icon: index != 3
                              ? icons[index]
                              : (context.watch<ThemeCubit>().isDarkMode
                                  ? FontAwesomeIcons.sun
                                  : FontAwesomeIcons.moon),
                          title: titles[index],
                          isLoading: index == 6 && apiState is LogoutLoading,
                          color: index == 6 ? context.appColors.red : null,
                          onTap: () {
                            if (index == 0) {
                              DriverProfileRoute().push(context);
                            } else if (index == 1) {
                              WalletRoute().push(context);
                            } else if (index == 2) {
                              context.read<LanguageCubit>().toggleLanguage();
                            } else if (index == 3) {
                              context.read<ThemeCubit>().toggleTheme();
                            } else if (index == 4) {
                              CustomerServiceRoute().push(context);
                            } else if (index == 5) {
                              MyReportsRoute().push(context);
                            } else if (index == 6) {
                              // 👈 استدعاء API تسجيل الخروج عبر الـ Event المخصص
                              context.read<LogoutBloc>().add(
                                    const LogoutSubmitEvent(),
                                  );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSettingCard(
    BuildContext context, {
    required FaIconData icon,
    required String title,
    bool isLoading = false,
    Color? color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: context.appColors.white,
        borderRadius: BorderRadius.circular(AppRadius.r14),
        border: Border.all(color: context.appColors.lightGreySec),
      ),
      child: ListTile(
        onTap: isLoading ? null : onTap,
        leading: isLoading
            ? SizedBox(
                width: AppWidth.w18,
                height: AppHeight.h18,
                child: const CircularProgressIndicator(strokeWidth: 2),
              )
            : FaIcon(
                icon,
                size: AppSize.s18,
                color: color ?? context.appColors.primary,
              ),
        title: BodyTitle(
          text: title,
          fontSize: AppFontSize.s15,
          fontWeight: AppFontWeight.bold,
          color: color ?? context.appColors.blackText,
        ),
        trailing: FaIcon(
          FontAwesomeIcons.chevronLeft,
          size: AppSize.s14,
          color: context.appColors.greyText,
        ),
      ),
    );
  }
}