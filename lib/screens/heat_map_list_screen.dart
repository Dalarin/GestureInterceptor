import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:specvuz_gesture_interceptor/blocs/heatmap_bloc/heatmap_bloc.dart';
import 'package:specvuz_gesture_interceptor/screens/heatmap_page.dart';

class HeatMapListScreen extends StatelessWidget {
  const HeatMapListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HeatmapBloc>(
      create: (_) => HeatmapBloc()..add(GetPackageList()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Список приложений'),
        ),
        body: SafeArea(
          child: BlocBuilder<HeatmapBloc, HeatmapState>(
            builder: (context, state) {
              if (state is HeatMapLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is PackagesLoaded) {
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: state.packages.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 5);
                  },
                  itemBuilder: (context, index) {
                    return _buildPackageWidget(context, state.packages[index]);
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPackageWidget(BuildContext context, String package) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return HeatMapPage(package: package);
            },
          ),
        );
      },
      child: Card(
        child: ListTile(
          leading: const Icon(Icons.app_blocking),
          title: Text(package),
        ),
      ),
    );
  }
}
