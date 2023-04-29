import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:specvuz_gesture_interceptor/blocs/heatmap_bloc/heatmap_bloc.dart';

class HeatMapPage extends StatefulWidget {
  final String package;
  const HeatMapPage({Key? key, required this.package}) : super(key: key);

  @override
  State<HeatMapPage> createState() => _HeatMapPageState();
}

class _HeatMapPageState extends State<HeatMapPage> {
  DateTime? _selectedDate;
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HeatmapBloc>(
      create: (_) => HeatmapBloc()..add(GetHeatMapsByPackage(widget.package, DateTime.now())),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.package),
            ),
            body: SafeArea(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 15,
                ),
                children: [
                  CalendarTimeline(
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2002),
                    lastDate: DateTime(2024),
                    monthColor: Theme.of(context).colorScheme.primary,
                    locale: 'ru',
                    onDateSelected: (DateTime? selectedDate) {
                      if (selectedDate != null) {
                        final bloc = context.read<HeatmapBloc>();
                        bloc.add(GetHeatMapsByPackage(widget.package, selectedDate));
                      }
                      _selectedDate = selectedDate;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextFieldWidget(
                        controller: _startTimeController,
                        onTap: () => _showTimePicker(_startTimeController),
                        hint: 'Начальное время',
                      ),
                      TextFieldWidget(
                        controller: _endTimeController,
                        onTap: () => _showTimePicker(_endTimeController),
                        hint: 'Конечное время',
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: BlocBuilder<HeatmapBloc, HeatmapState>(
                      builder: (context, state) {
                        if (state is HeatMapLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is HeatMapsLoaded) {
                          return Image.memory(state.page);
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  void _showTimePicker(TextEditingController controller) async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      controller.text = time.format(context);
    }
  }
}

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onTap;
  final bool readOnly;
  final String hint;

  const TextFieldWidget({
    Key? key,
    required this.controller,
    required this.onTap,
    required this.hint,
    this.readOnly = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: SizedBox(
        width: size.width * 0.4,
        child: TextField(
          controller: controller,
          onTap: onTap,
          readOnly: readOnly,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 5,
            ),
            border: const OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
