import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:time_track/data/services/auth_services.dart';
import 'package:time_track/ui/pages/login_page/login_page.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MyAppBar({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}

class _MyAppBarState extends State<MyAppBar> {
  void openDrawer() {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.title),
      leading: IconButton(
        onPressed: openDrawer,
        icon: const Icon(Icons.menu),
      ),
      actions: <Widget>[
        PopupMenuButton(
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                child: TextButton(
                  onPressed: () {
                    _logout();
                  },
                  child: const Text('Cerrar sesión'),
                ),
              ),
            ];
          },
        )
      ],
    );
  }

  void _logout() async {
    try {
      final tokenData = await AuthService().getToken();
      final token = tokenData['token'];
      AuthService().logout(accessToken: token!);
      toLogin();
    } on Exception catch (e) {
      safePrint(e);
    }
  }

  toLogin() {
    Navigator.pushNamedAndRemoveUntil(
        context, LoginPage.routeName, (route) => false);
  }
}
