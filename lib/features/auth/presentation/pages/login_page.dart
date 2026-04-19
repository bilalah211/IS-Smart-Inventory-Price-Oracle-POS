import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartinevntary/core/constants/app_assets.dart';
import 'package:smartinevntary/core/constants/app_strings.dart';
import 'package:smartinevntary/core/theme/app_colors.dart';
import 'package:smartinevntary/core/theme/app_textstyle.dart';
import 'package:smartinevntary/core/utils/flushbar_utils.dart';
import 'package:smartinevntary/core/utils/validator.dart';
import 'package:smartinevntary/features/auth/presentation/bloc/bloc_events/auth_events.dart';
import 'package:smartinevntary/features/auth/presentation/widgets/auth_button.dart';
import 'package:smartinevntary/features/products/presentation/bloc/product_states.dart';
import 'package:smartinevntary/features/products/presentation/pages/dashboard_page.dart';

import '../bloc/bloc/auth_bloc.dart';
import '../bloc/bloc_states/auth_states.dart';
import '../widgets/my_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordHide = true;
  bool isLogin = true;
  bool isRemember = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryLight,
      //---[Login Form]---
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: BlocConsumer<AuthBloc, AuthStates>(
            builder: (context, state) {
              return Column(
                children: [
                  //---[APP LOGO AND NAME]---
                  _buildTopSection(),
                  Expanded(child: _buildBottomSheet(state, context)),
                ],
              );
            },
            listener: (context, state) {
              if (state is LoadingState) {
                return;
              }
              if (state is AuthLoadedState) {
                if (!isLogin) {
                  setState(() {
                    isLogin = true;
                  });
                  FlushbarUtils.showSuccess(
                    context,
                    message: "Registration successful! Please Sign In.",
                  );
                  emailController.clear();
                  passwordController.clear();
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardPage()),
                  );
                  emailController.clear();
                  passwordController.clear();
                }
              }
              if (state is AuthErrorState) {
                FlushbarUtils.showError(
                  context,
                  message: 'Authentication Error',
                );
              }
            },
          ),
        ),
      ),
    );
  }

  //---[APP LOGO AND NAME]---
  Widget _buildTopSection() {
    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 30),
      decoration: BoxDecoration(color: AppColors.primaryLight),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: .center,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primaryLight),
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    height: 90,
                    fit: BoxFit.fill,
                    AppAssets.appLogo,
                  ),
                ),
              ),

              SizedBox(width: 20),
              Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    AppStrings.appName,
                    style: AppTextStyles.brandLogoName.copyWith(
                      color: AppColors.bgWhite,
                    ),
                  ),
                  Text(
                    isLogin ? AppStrings.headerSignIn : AppStrings.headerSignUp,
                    style: AppTextStyles.headerPrimary.copyWith(
                      fontSize: 22,
                      color: AppColors.lightGrey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),

          //---[APP HEADER]---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: .center,
              children: [
                Text(
                  isLogin ? AppStrings.signInDes : AppStrings.signupDes,
                  style: AppTextStyles.bodyTextSecondary.copyWith(
                    fontSize: 15,
                    color: AppColors.lightGrey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //---[SIGN IN & SIGN UP FORM]---
  Widget _buildBottomSheet(AuthStates state, BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,

      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          // 🔥 SCROLLABLE CONTENT
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  //---[TOGGLE SIGNIN & SIGNUP FORM]---
                  Container(
                    height: 55,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        children: [
                          //SIGN IN
                          _buildToggleButton(
                            name: AppStrings.signIn,
                            style: AppTextStyles.bodyTextSecondary.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            onTap: () {
                              emailController.clear();
                              passwordController.clear();
                              setState(() => isLogin = true);
                            },
                            color: isLogin
                                ? AppColors.bgWhite
                                : AppColors.lightGrey,
                          ),

                          //SIGN UP
                          _buildToggleButton(
                            name: AppStrings.signUp,
                            style: AppTextStyles.bodyTextSecondary.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            onTap: () {
                              setState(() => isLogin = false);
                              emailController.clear();
                              passwordController.clear();
                            },
                            color: isLogin
                                ? AppColors.lightGrey
                                : AppColors.bgWhite,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  _buildText(name: AppStrings.email, isRequired: true),
                  SizedBox(height: 6),

                  MyTextFormField(
                    text: AppStrings.textFieldEmail,
                    controller: emailController,
                    prefixIcon: Icon(Icons.email_outlined),
                    isObscureText: false,
                    validator: AppValidators.validateEmail,
                  ),
                  SizedBox(height: 15),

                  //---[PASSWORD FIELD]---
                  _buildText(name: AppStrings.password, isRequired: true),
                  SizedBox(height: 6),

                  MyTextFormField(
                    text: AppStrings.textFieldPassword,
                    controller: passwordController,
                    isObscureText: _isPasswordHide,
                    prefixIcon: Icon(Icons.lock_outline),
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          _isPasswordHide = !_isPasswordHide;
                        });
                      },
                      child: Icon(
                        _isPasswordHide
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                    validator: AppValidators.validatePassword,
                  ),
                  SizedBox(height: 20),

                  //---[REMEMBER ME]---
                  isLogin
                      ? Row(
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isRemember = !isRemember;
                                    });
                                  },
                                  child: isRemember
                                      ? Icon(
                                          Icons.check_box,
                                          color: AppColors.primaryLight,
                                        )
                                      : Icon(
                                          Icons.check_box_outline_blank,
                                          color: AppColors.primaryLight,
                                        ),
                                ),
                                SizedBox(width: 5),
                                _buildText(
                                  name: AppStrings.rememberMe,
                                  color: AppColors.primaryLight,
                                ),
                              ],
                            ),
                            Spacer(),
                            _buildText(
                              name: AppStrings.forgotPassword,
                              color: AppColors.primaryLight,
                            ),
                          ],
                        )
                      : SizedBox(height: 25),
                  SizedBox(height: 40),

                  //---[LOGIN BUTTON]---
                  AuthButton(
                    isLoading: state is AuthLoadingState,
                    text: isLogin ? AppStrings.signIn : AppStrings.signUp,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        if (isLogin) {
                          context.read<AuthBloc>().add(
                            LoginEvent(
                              emailController.text,
                              passwordController.text,
                              isRemember,
                            ),
                          );
                        } else {
                          context.read<AuthBloc>().add(
                            RegisterEvent(
                              emailController.text,
                              passwordController.text,
                            ),
                          );
                        }
                      }
                    },
                  ),
                  SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(child: Divider(endIndent: 10)),
                      Text(
                        isLogin ? 'Or sign in with' : 'Or sign up with',
                        style: AppTextStyles.bodyTextSecondary.copyWith(
                          fontSize: 14,
                        ),
                      ),
                      Expanded(child: Divider(indent: 10)),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: .center,
                    children: [
                      _buildSocialContainer(image: AppAssets.apple),
                      _buildSocialContainer(image: AppAssets.google),
                      _buildSocialContainer(image: AppAssets.apple),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialContainer({String? image}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
      height: 55,
      width: 55,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.greyBorder),
      ),
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.contain,
              image: AssetImage(image ?? ''),
            ),
          ),
        ),
      ),
    );
  }

  //---[TOGGLE BUTTON]---
  Widget _buildToggleButton({
    required String name,
    Color? color,
    TextStyle? style,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,

        child: Container(
          height: 43,
          width: 100,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: Text(name, style: style)),
        ),
      ),
    );
  }

  //---[TEXT FIELDS HEADER]---

  Widget _buildText({
    required String name,
    Color? color,
    bool isRequired = false,
  }) {
    return RichText(
      text: TextSpan(
        text: name,
        style: AppTextStyles.bodyTextSecondary.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: color,
        ),
        children: [
          if (isRequired)
            const TextSpan(
              text: ' *',
              style: TextStyle(
                color: Colors.red,
              ), // Make the star red for clarity
            ),
        ],
      ),
    );
  }
}
