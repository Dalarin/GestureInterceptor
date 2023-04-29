import 'package:flutter/material.dart';
import 'package:flutter_accessibility_service/flutter_accessibility_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:specvuz_gesture_interceptor/blocs/heatmap_bloc/heatmap_bloc.dart';
import 'package:specvuz_gesture_interceptor/blocs/overlay_bloc/overlay_bloc.dart';
import 'package:specvuz_gesture_interceptor/screens/heat_map_list_screen.dart';
import 'package:specvuz_gesture_interceptor/screens/statistics_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _requestAccessibilityAccess() async {
    await FlutterAccessibilityService.isAccessibilityPermissionEnabled();
    await FlutterAccessibilityService.requestAccessibilityPermission();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HeatmapBloc>(
      create: (_) => HeatmapBloc()..add(GetMostUsedApplications()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('СпецвузАвтоматика'),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonWidget(
                          iconData: Icons.perm_device_information_outlined,
                          onPressed: () async {
                            _requestAccessibilityAccess();
                            final bloc = context.read<OverlayBloc>();
                            bloc.add(RequestInterceptorPermission());
                          },
                        ),
                        ButtonWidget(
                          iconData: Icons.not_started_outlined,
                          onPressed: () {
                            final bloc = context.read<OverlayBloc>();
                            bloc.add(StartGestureInterceptor());
                          },
                        ),
                        ButtonWidget(
                          iconData: Icons.pause_circle_outline_outlined,
                          onPressed: () {
                            final bloc = context.read<OverlayBloc>();
                            bloc.add(CloseGestureInterceptor());
                          },
                        ),
                      ],
                    ),
                    BlocBuilder<HeatmapBloc, HeatmapState>(
                      builder: (context, state) {
                        if (state is HeatMapLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is MostPopularApplicationsLoaded) {
                          return AppUsageContainer(
                            applications: state.applications,
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ButtonWidget(
                          iconData: Icons.map,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const HeatMapListScreen();
                                },
                              ),
                            );
                          },
                        ),
                        ButtonWidget(
                          iconData: Icons.info_outline_rounded,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const StatisticsScreen();
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AppUsageContainer extends StatelessWidget {
  final List<Map<String, dynamic>> applications;

  const AppUsageContainer({Key? key, required this.applications})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Container(
        height: size.height * 0.35,
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 15,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.white,
          ),
        ),
        child: Builder(
          builder: (context) {
            if (applications.isEmpty) {
              return const Center(
                child: Text('Отсутствуют записи'),
              );
            }
            return Column(
              children: [
                Text(
                  'Наиболее используемые приложения',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return _buildAppUsageWidget(applications[index]);
                  },
                  itemCount: applications.length,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppUsageWidget(Map<String, dynamic> application) {
    return ListTile(
      leading: const Icon(Icons.app_blocking),
      title: Text(
        application['package_name'],
        maxLines: 1,
      ),
      subtitle: Text(
        '${application['count']} кликов',
        maxLines: 1,
      ),
    );
  }
}

class ButtonWidget extends StatelessWidget {
  final IconData iconData;
  final VoidCallback onPressed;

  const ButtonWidget({
    Key? key,
    required this.iconData,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Card(
      child: SizedBox(
        width: size.width * 0.25,
        height: size.height * 0.1,
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(iconData),
        ),
      ),
    );
  }
}
