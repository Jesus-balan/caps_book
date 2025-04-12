import 'package:caps_book/features/config/routes.dart';
import 'package:caps_book/features/config/styles.dart';
import 'package:caps_book/features/data/repositories/login_repository.dart';
import 'package:caps_book/features/data/repositories/ride_boking_repository.dart';
import 'package:caps_book/features/presentation/blocs/login-auth/bloc/login_bloc.dart';
import 'package:caps_book/features/presentation/blocs/ridebooking/myride_bloc.dart';
import 'package:caps_book/features/presentation/blocs/ridebooking/myride_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Now safe to lock orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await Hive.initFlutter(); // Hive init
  final rideRepository = RideRepository(); // <-- define it here
  await Hive.openBox('attendanceBox'); // Add this line
  runApp(  
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoginBloc(LoginRepository())),
        BlocProvider(
          create: (context) => MyrideBloc(rideRepository)..add(const FetchMyRides()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Caps Booking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: ColorStyle.primaryColor),
        useMaterial3: true,
      ),
      initialRoute: '/',
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
