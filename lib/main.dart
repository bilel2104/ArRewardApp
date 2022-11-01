import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/di.dart';
import 'package:flutter_application_1/app/network_stauts_services.dart';
import 'package:flutter_application_1/presentation/sidebars/notificationSideBar.dart';
import 'package:flutter_application_1/presentation/sidebars/profileSideBar.dart';
import 'package:flutter_application_1/presentation/sidebars/shopsDownBar.dart';
import 'package:flutter_application_1/presentation/widgets/shopsFlipCard.dart';
import 'package:provider/provider.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initAppModule();
  runApp(MultiProvider(providers: [
    StreamProvider<NetworkStatus>(
      create: (context) =>
          NetworkStatusService().networkStatusController.stream,
      initialData: NetworkStatus.Online,
    ),
    ChangeNotifierProvider(create: (_) => ProfileSideBar()),
    ChangeNotifierProvider(create: (_) => NotificationSideBar()),
    ChangeNotifierProvider(create: (_) => ShopsDownBar()),
    ChangeNotifierProvider(create: (_) => Cflip()),
  ], child: MyApp()));
}
