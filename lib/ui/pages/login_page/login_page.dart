import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_track/styles/colors/colors.dart';
import 'package:time_track/ui/pages/login_page/change_password.dart';
import 'package:time_track/ui/widgets/button.dart';
import 'package:time_track/ui/widgets/text_field.dart';
import 'package:time_track/utils/app_utils.dart';

import '../../../data/services/auth_services.dart';
import '../../../utils/auth_messages.dart';
import '../../../utils/validators.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const String routeName = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

final _myFormKey1 = GlobalKey<FormState>();
class _LoginPageState extends State<LoginPage> {
  final double _padding = 16.0;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background,
      body: SingleChildScrollView(
        child: Column(
        children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [ 
                SvgPicture.asset(
                  'assets/logo.svg',
                  width: 200,
                  height: 200,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: const [
                    Text(
                      'Time',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: MyColors.white,
                          fontSize: 40,
                        ),
                      ),
                    Text(
                      'Track',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: MyColors.primary,
                        fontSize: 40,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: _padding*2),
                Padding(
                  padding: EdgeInsets.all(_padding),
                  child: const Text(
                    '¡Bienvenido de vuelta! Por favor, proporciona tus credenciales para acceder.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: MyColors.white,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            _buildBody(),
        ],
        ),
      )
    );
  }

  Widget _buildBody(){
    if(_isLoading){
      return const Center(
        child: CircularProgressIndicator(),
      );
    }else {
      return Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Form(
                  key: _myFormKey1,
                  child: Column(
                    children: [
                      MyTextField(
                        hintText: 'Correo electrónico', 
                        icon: Icons.email, 
                        obscureText: false, 
                        validator: Validator.validateEmail, 
                        controller: emailController,
                        color: MyColors.white,
                      ),
                      MyTextField(
                        hintText: 'Contraseña', 
                        icon: Icons.lock, 
                        obscureText: true, 
                        validator: Validator.validatePassword, 
                        controller: passwordController,
                        color: MyColors.white,
                      ),                   ],
                  ),
                ),
                MyButton(
                  onPressed: () => _login(), 
                  text: 'Ingresar', 
                  color: MyColors.primary, 
                  textColor: MyColors.white,
                  padding: _padding,
                )
              ],
            );
    }
  }


  void _login() async{
    if (_myFormKey1.currentState!.validate()){
      try {
        setState(() {
          _isLoading = true;
        });
        String password = passwordController.text;
        String email = emailController.text;

        final result = await AuthService().signInUser(
          email: email,
          password: password,
        );
        final status = result['status'];
        final session = result['session'];
        switch(status){
          case AuthMessages.login:
            message('Bienvenido', 3, MyColors.primary);
            toHome();
            break;
          case AuthMessages.newPasswordRequired:
            message('Por seguridad necesitas Cambiar tu contraseña para poder ingresar', 3, MyColors.orange);
            toChangePassword(session);
            break;
          default:
            message(result['message'], 3, MyColors.red);
            break;
        }

      }catch(err){
        safePrint(err);
        message(err.toString(), 3, MyColors.red);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
      
    }
  }
  void toChangePassword(String session){
    Map<String, String> args = {
      'session': session,
      'email': emailController.text,
    };
    Navigator.pushNamed(context, ChangePasswordPage.routeName, arguments: args);
  }

  void toHome(){
    AppUtils.toHome(context);
  }
  void message(String message, int duration, Color color) {
    AppUtils.message(context, message, duration, color);
  }
}