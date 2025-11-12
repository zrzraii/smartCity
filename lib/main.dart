import 'package:flutter/material.dart';
import 'package:smart_city/l10n/gen/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'routes.dart';
import 'state/app_state.dart';
import 'ui/design.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appState = AppState();
  await appState.load();
  runApp(MainApp(appState: appState));
}

class MainApp extends StatelessWidget {
  final AppState appState;
  const MainApp({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: appState,
      child: Consumer<AppState>(
        builder: (context, state, _) {
          final router = AppRouter.build(state);
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Smart City',
            routerConfig: router,
            locale: state.locale,
            supportedLocales: const [
              Locale('ru'),
              Locale('kk'),
              Locale('en'),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: buildAppTheme(),
          );
        },
      ),
    );
  }
}
