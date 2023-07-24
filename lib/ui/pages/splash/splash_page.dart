import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_track/data/services/auth_services.dart';
import 'package:time_track/styles/colors/colors.dart';
import 'package:time_track/ui/pages/login_page/login_page.dart';
import 'package:time_track/ui/widgets/progress_bar.dart';
import 'package:time_track/utils/app_utils.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  static const String routeName = '/splash';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>{
 
  @override
  void initState() {
    super.initState();
    _loadData();
   }
      
  void _loadData() async {
    try {
      final Map<String, String>tokenData = await AuthService().getToken();
      final token = tokenData['token'];
      final tokenCreated = tokenData['token_created'];

      final tokenCreatedDate = DateTime.parse(tokenCreated!);
      final currentDate = DateTime.now();
      final difference = currentDate.difference(tokenCreatedDate).inMinutes;
      if(difference > 25){
        await AuthService().logout(accessToken: token!);
        throw Exception('Token expirado es necesario volver a loguearse');
      }
      toHome();
    }on Exception catch (e){
      redirect(LoginPage.routeName);
      safePrint(e);
    }
  }
    
  void toHome(){
    AppUtils.toHome(context);
  }
  void redirect(String route){
    Navigator.pushReplacementNamed(context, route);
  }

  final _padding = 16.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background,
      body: Column(
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
                const MyProgressBar(
                    color: MyColors.primary,
                    size: 50.0,
                  ),
              ],
            ),
    );
  }
}