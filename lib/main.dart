import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:specvuz_gesture_interceptor/blocs/heatmap_bloc/heatmap_bloc.dart';
import 'package:specvuz_gesture_interceptor/blocs/overlay_bloc/overlay_bloc.dart';
import 'package:specvuz_gesture_interceptor/screens/home_page.dart';
import 'package:specvuz_gesture_interceptor/overlays/gesture_interceptor.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GestureInterceptor(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {



  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OverlayBloc>(
          create: (_) => OverlayBloc(),
        ),
        BlocProvider<HeatmapBloc>(
          create: (_) => HeatmapBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'СпецвузАвтоматика GestureInterceptor',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF05014A),
            brightness: Brightness.dark,
          ),
        ),
        home: const HomePage(),
      ),
    );
  }
}
