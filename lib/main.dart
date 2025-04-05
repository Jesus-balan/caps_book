  import 'package:caps_book/features/config/routes.dart';
  import 'package:caps_book/features/data/repositories/booking_repository.dart';
  import 'package:caps_book/features/presentation/blocs/attendance/attendance_bloc.dart';
  import 'package:caps_book/features/presentation/blocs/booking/booking_bloc.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';

 void main() {
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => BookingRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AttendanceBloc()),
          BlocProvider(create: (context) => BookingBloc(context.read<BookingRepository>())),
        ],
        child: const MyApp(),
      ),
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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        onGenerateRoute: AppRoutes.generateRoute,
      );
    }
  }
