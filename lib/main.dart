import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app/app.dart';
import 'di/di.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: AppDI.blocProviders(),
      child: const App(),
    ),
  );
}
