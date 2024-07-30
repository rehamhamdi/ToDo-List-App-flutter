import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

  //using Form widget to use it with floatingActionButton (+) in home_screen file
class AddTasksScreen extends StatelessWidget {
  const AddTasksScreen({super.key, required this.formKey, required this.titleController, required this.timeController, required this.dateController});
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController timeController;
  final TextEditingController dateController;
  
  @override
  Widget build(BuildContext context) {
    return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: titleController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your task name";
                              }
                              return null;
                            },
                            onTap: () {},
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              labelText: "Task Name",
                              prefixIcon: const Icon(Icons.title),
                            ),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          TextFormField(
                            controller: timeController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your task time";
                              }
                              return null;
                            },
                            onTap: () {
                              showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now())
                                  .then((value) {
                                timeController.text = value!.format(context);
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              labelText: "Task time",
                              prefixIcon: const Icon(Icons.timer_rounded),
                            ),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          TextFormField(
                            controller: dateController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your task date";
                              }
                              return null;
                            },
                            onTap: () {
                              showDatePicker(
                                      context: context,
                                      firstDate: DateTime.now(),
                                      initialDate: DateTime.now(),
                                      lastDate: DateTime.parse("2200-12-30"))
                                  .then((value) {
                                dateController.text =
                                    DateFormat.yMMMd().format(value!);
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              labelText: "Task Date",
                              prefixIcon: const Icon(Icons.date_range),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
  }
}