import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_track/styles/colors/colors.dart';
import 'package:time_track/ui/widgets/button.dart';
import 'package:time_track/ui/widgets/text_field.dart';

import '../../../data/services/auth_services.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/auth_messages.dart';
import '../../../utils/validators.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  static const String routeName = '/change-password';

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

final _myFormKey2 = GlobalKey<FormState>();
class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final double _padding = 16.0;
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController repeatNewPasswordController = TextEditingController();
  bool _isLoading = false;
  

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final email = args['email'];
    final session = args['session'];
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
                    'Debes cambiar tu contraseña para continuar, esto solo se hace una vez. Gracias',
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
            _buildBody(email!, session!),
        ],
        ),
      )
    );
  }

  Widget _buildBody(String email, String session){
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
                  key: _myFormKey2,
                  child: Column(
                    children: [
                      MyTextField(
                        hintText: 'Nueva Contraseña', 
                        icon: Icons.lock, 
                        obscureText: true, 
                        validator: Validator.validatePassword, 
                        controller: newPasswordController,
                        color: MyColors.white,
                      ),
                      MyTextField(
                        hintText: 'Repetir Contraseña', 
                        icon: Icons.lock_reset, 
                        obscureText: true, 
                        validator: Validator.validatePassword, 
                        controller: repeatNewPasswordController,
                        color: MyColors.white,
                      ),                   ],
                  ),
                ),
                MyButton(
                  onPressed: () => _newPassword(email, session),
                  text: 'Ingresar', 
                  color: MyColors.primary, 
                  textColor: MyColors.white,
                  padding: _padding,
                )
              ],
            );
    }
  }

void message(String message, int duration, Color color) {
  AppUtils.message(context, message, duration, color);
}

void toHome(){
  AppUtils.toHome(context);
}

  void _newPassword(String email, String session) async{
    if (_myFormKey2.currentState!.validate()){
        String newPassword = newPasswordController.text;
        String repeatNewPassword = repeatNewPasswordController.text;
        if(newPassword != repeatNewPassword){
          message('Las contraseñas no coinciden', 3, MyColors.red);
          return;
        }
      try {
        setState(() {
          _isLoading = true;
        });

        final result = await AuthService().resetPassword(email: email, session: session, newPassword: newPassword);
        if(result == AuthMessages.login){
          message('Contraseña cambiada correctamente, Bienvenido', 3, MyColors.primary);
          toHome();
          return;
        }

        message(result, 3, MyColors.red);

      }catch(err){
        debugPrint(err.toString());
        message(err.toString(), 3, MyColors.red);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
      
    }
  }
}