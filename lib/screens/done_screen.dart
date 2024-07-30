import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/cubit.dart';
import 'package:todo_app/widgets/reusable_widget.dart';
import '../cubit/states.dart';

class DoneScreen extends StatelessWidget {
  const DoneScreen({super.key,});
  
  @override
  Widget build(BuildContext context) {
    // using buildListUiContainer widget from reusable_widget
    return BlocConsumer<AppCubit,AppStates>(
        builder: (context, state) =>
            buildListUiContainer(context, tasks: AppCubit.get(context).doneTasks),
        listener: (context, state) {});
  }
}
