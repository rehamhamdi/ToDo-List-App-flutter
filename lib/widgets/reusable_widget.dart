import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/cubit/cubit.dart';

BottomBarItem bottomBarItem({
  required IconData icon,
  required String text,
}) =>
    BottomBarItem(
      inActiveItem: Icon(
        icon,
        color: Colors.black,
      ),
      activeItem: Icon(
        icon,
        color: const Color.fromARGB(255, 211, 131, 184),
      ),
      itemLabel: text,
    );
//Container of tasks page has listIcon of CheckBox icon , archived icon , delete icon
Widget buildListUiContainer(context, {required List<Map> tasks}) {
  return Column(
    children: [
      Expanded(
        child: Container(
          width: MediaQuery.of(context).size.width * .95,
          height: MediaQuery.of(context).size.height * .778,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.white),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * .778,
            child: ConditionalBuilder(
                condition: tasks.isNotEmpty,
                builder: (BuildContext context) => ListView.separated(
                    itemBuilder: (context, index) => listIcon(
                        donePressed: () {
                          if (tasks[index]['notes'] == 'done') {
                            AppCubit.get(context)
                                .updateDatabase('notes', tasks[index]['id']);
                          } else {
                            AppCubit.get(context)
                                .updateDatabase('done', tasks[index]['id']);
                          }
                        },
                        deletePressed: () {
                          AppCubit.get(context)
                              .deleteFromDateBase(tasks[index]['id']);
                        },
                        archivePressed: () {
                          if (tasks[index]['notes'] == 'archive') {
                            AppCubit.get(context)
                                .updateDatabase('notes', tasks[index]['id']);
                          } else {
                            AppCubit.get(context)
                                .updateDatabase('archive', tasks[index]['id']);
                          }
                        },
                        model: tasks[index]),
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: tasks.length),
                fallback: (BuildContext context) => const Center(
                      child: Text(
                        'There is no Tasks here',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    )),
          ),
        ),
      ),
    ],
  );
}

//listIcon of CheckBox icon , archived icon , delete icon
Widget listIcon(
    {required VoidCallback donePressed,
    required VoidCallback deletePressed,
    required VoidCallback archivePressed,
    required Map model}) {
  return ListTile(
    title: Row(
      children: [
        IconButton(
            onPressed: donePressed,
            icon: Icon(
              model['notes'] == 'done'
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
              color: Colors.black,
            )),
        Expanded(
          child: Text(
            model["title"],
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        IconButton(
            onPressed: archivePressed,
            icon: Icon(
              model['notes'] == 'archive'
                  ? Icons.archive
                  : Icons.archive_outlined,
              color: Colors.black,
            )),
        IconButton(
            onPressed: deletePressed,
            icon: const Icon(
              Icons.delete,
              color: Colors.black,
            )),
      ],
    ),
    subtitle: Row(
      children: [
        const SizedBox(
          width: 50,
        ),
        Text(
          model["time"],
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
        const SizedBox(
          width: 120,
        ),
        Text(
          model["date"],
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
      ],
    ),
  );
}
