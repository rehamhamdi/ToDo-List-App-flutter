import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/cubit.dart';
import 'package:todo_app/cubit/states.dart';
import 'package:todo_app/screens/add_tasks_screen.dart';
import 'package:todo_app/screens/archive_screen.dart';
import 'package:todo_app/screens/done_screen.dart';
import 'package:todo_app/screens/task_screen.dart';
import 'package:todo_app/widgets/reusable_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NotchBottomBarController _controller =
      NotchBottomBarController(index: 0);
  final _pageController = PageController(initialPage: 0);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _titleController = TextEditingController();
  final _timeController = TextEditingController();
  final _dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isBottomSheetShow = false;
  List<Widget> get screens =>
      [const TaskScreen(), const ArchiveScreen(), const DoneScreen()];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              key: _scaffoldKey,
              backgroundColor: const Color.fromARGB(255, 211, 131, 184),
              appBar: AppBar(
                backgroundColor: const Color.fromARGB(255, 211, 131, 184),
                leading: const Icon(
                  Icons.note_alt_rounded,
                  color: Colors.white,
                ),
                title: const Text(
                  "MY ToDo List",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              body: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: screens),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  if (isBottomSheetShow) {
                    if (_formKey.currentState!.validate()) {
                      AppCubit.get(context)
                          .insertToDatabase(
                        title: _titleController.text,
                        time: _timeController.text,
                        date: _dateController.text,
                        notes: "status",
                      )
                          .then((value) {
                        Navigator.pop(context);
                        isBottomSheetShow = false;
                      });
                    }
                  } else {
                    _scaffoldKey.currentState!
                        .showBottomSheet((context) => AddTasksScreen(
                              formKey: _formKey,
                              titleController: _titleController,
                              timeController: _timeController,
                              dateController: _dateController,
                            ))
                        .closed
                        .then((value) {
                      isBottomSheetShow = false;
                    });
                    isBottomSheetShow = true;
                  }
                },
                backgroundColor: Colors.black,
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 35,
                ),
              ),
              bottomNavigationBar: AnimatedNotchBottomBar(
                  color: Colors.white,
                  notchBottomBarController: _controller,
                  elevation: 1,
                  showLabel: true,
                  removeMargins: false,
                  bottomBarWidth: 500,
                  showShadow: false,
                  durationInMilliSeconds: 300,
                  bottomBarItems: [
                    bottomBarItem(
                      icon: Icons.home,
                      text: 'Home',
                    ),
                    bottomBarItem(
                      icon: Icons.archive,
                      text: 'Archived',
                    ),
                    bottomBarItem(
                      icon: Icons.check_box,
                      text: 'Done',
                    ),
                  ],
                  onTap: (int value) {
                    _pageController.jumpToPage(value);
                  },
                  kIconSize: 25,
                  kBottomRadius: 30),
            );
          }),
    );
  }
}
