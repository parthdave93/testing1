import 'package:firebase_core/firebase_core.dart';
import 'package:habo_master/helpers.dart';
import 'package:habo_master/provider.dart';
import 'package:habo_master/widgets/calendar_column.dart';
import 'package:habo_master/widgets/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:habo_master/providers/habits.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(Habo());
}

class Habo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light),
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Bloc()),
          ChangeNotifierProvider(
            create: (context) => TodosProvider(),
          ),
        ],
        child: Consumer<Bloc>(builder: (context, counter, _) {
          final bloc = Provider.of<Bloc>(context);
          return MaterialApp(
            theme: Provider.of<Bloc>(context).getSettings.getLight,
            darkTheme: Provider.of<Bloc>(context).getSettings.getDark,
            home: !bloc.getDataLoaded ? LoadingScreen() : HomeScreen(),
          );
        }));
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      key: Provider.of<Bloc>(context).getScafoldKey,
      appBar: AppBar(
          title: Text(
            "Habo",
            style: Theme.of(context).textTheme.headline5,
          ),
          backgroundColor: Colors.transparent,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.settings),
              color: Colors.grey[400],
              tooltip: 'Settings',
              onPressed: () {
                Provider.of<Bloc>(context, listen: false).hideSnackBar();
                navigateToSettingsPage(context);
              },
            ),
          ]),
      body: CalendarColumn(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<Bloc>(context, listen: false).hideSnackBar();
          navigateToCreatePage(context);
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 35.0,
        ),
      ),
    ));
  }
}
