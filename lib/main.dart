import 'package:flutter/material.dart';
import 'package:state_management/data/index.dart';
import 'package:state_management/presentation/flutter_bloc_cubit/flutter_bloc_cubit_app.dart';

void main() {
  ServiceProvider.instance.initialize();
  // runApp(const SimpleApp());
  // runApp(const RiverpodApp());
  // runApp(const HooksApp());
  // runApp(const FlutterBlocApp());
  runApp(const FlutterBlocCubitApp());
}
