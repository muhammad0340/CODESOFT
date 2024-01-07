import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:to_do_list_app/db/db_helper.dart';
import 'package:to_do_list_app/service/theme_service.dart';
import 'package:to_do_list_app/ui/add_task_bar.dart';
import 'package:to_do_list_app/ui/home_page.dart';
import 'package:to_do_list_app/ui/splash_screen.dart';
import 'package:to_do_list_app/ui/theme.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDb();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeService().theme,
      home:SplashScreen()
      //AddTaskPage()
      //HomePage(),
    );
  }
}
