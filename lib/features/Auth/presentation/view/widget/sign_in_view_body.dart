import 'package:admin_app/core/constant/app_colors.dart';
import 'package:admin_app/core/constant/app_styles.dart';
import 'package:admin_app/core/widget/custom_button.dart';
import 'package:admin_app/core/widget/custom_scaffold.dart';
import 'package:admin_app/core/widget/custom_text_field.dart';
import 'package:admin_app/core/widget/custom_toast.dart';
import 'package:admin_app/features/Auth/presentation/view/widget/custom_auth_app_bar.dart';
import 'package:admin_app/features/Auth/presentation/view_model/bloc/auth_bloc.dart';
import 'package:admin_app/features/home/presentation/view_model/cubit/user_data_cubit.dart';
import 'package:admin_app/generated/l10n.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';

class SignInViewBody extends StatefulWidget {
  const SignInViewBody({super.key});

  @override
  State<SignInViewBody> createState() => _SignInViewBodyState();
}

class _SignInViewBodyState extends State<SignInViewBody> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool visibility = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          SmartDialog.showLoading();
        } else if (state is LoginSuccess) {
          context.read<UserDataCubit>().fetchUserData(state.token);
          context.go('/admin_home');
          CustomToast.show(
            message: state.successMessage,
            alignment: Alignment.topCenter,
            backgroundColor: AppColors.toastColor,
          );
          SmartDialog.dismiss();
        } else if (state is LoginFailure) {
          SmartDialog.dismiss();
          CustomToast.show(
            message: state.errMessage,
            backgroundColor: Colors.red,
          );
        } else if (state is SessionExpired) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/sign_in', (route) => false);
        }
      },
      builder: (context, state) {
        return CustomScaffold(
          body: Form(
            key: formKey,
            child: ListView(
              children: [
                CustomAuthAppBar(
                  title: S.of(context).welcome,
                  subTitle: S.of(context).welcomeDescription,
                ),
                SizedBox(
                  height: 15.h,
                ),
                Text(
                  S.of(context).signIn,
                  style: AppStyles.textStyle20blackBold,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 15.h,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).Email,
                        style: AppStyles.textStyle18black,
                      ),
                      CustomTextfield(
                        hintText: S.of(context).email,
                        obscureText: false,
                        prefixIcon: const Icon(Icons.email),
                        controller: emailController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          return value != null &&
                                  !EmailValidator.validate(value)
                              ? S.of(context).enter_valid_email
                              : null;
                        },
                      ),
                      Text(
                        S.of(context).Password,
                        style: AppStyles.textStyle18black,
                      ),
                      CustomTextfield(
                        hintText: S.of(context).password,
                        prefixIcon: const Icon(Icons.lock_sharp),
                        obscureText: visibility,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              visibility = !visibility;
                            });
                          },
                          icon: visibility
                              ? const Icon(
                                  Icons.visibility_off,
                                  color: Colors.grey,
                                )
                              : const Icon(
                                  Icons.visibility,
                                  color: Colors.grey,
                                ),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: passwordController,
                      ),
                      CustomButton(
                        title: S.of(context).signIn,
                        color: AppColors.activeBlue,
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            BlocProvider.of<AuthBloc>(context).add(LoginEvent(
                              email: emailController.text,
                              password: passwordController.text,
                            ));
                          } else {
                            CustomToast.show(
                              message: S.of(context).check_email,
                            );
                          }
                        },
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
