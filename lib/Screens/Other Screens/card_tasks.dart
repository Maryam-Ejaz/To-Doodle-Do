import 'package:flutter/material.dart';
import 'package:Todo_list_App/Backend/model/note.dart';


class CardTasks extends StatelessWidget {
  Note taskUser;
  bool isActive;

  int Index;
  final colorIcon = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.orange
  ];
  ValueChanged<Note> onSelected;

  CardTasks(
      {Key? key,
      required this.taskUser,
      required this.isActive,
      required this.Index,
      // required this.animation,
      required this.onSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = colorIcon[Index % colorIcon.length];
    var we = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: we * 0.9,
        height: he * 0.09,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 20),
                child: InkWell(
                  onTap: () => onSelected(taskUser),
                  child: isActive
                      ? const Icon(Icons.check_circle_outlined,
                          color: Colors.grey)
                      :  Icon(
                          Icons.circle_outlined,
                          color: color,
                        ),
                )),
            SizedBox(
              width: we * 0.025,
            ),
            Expanded(
                child: Text(taskUser.description,
                    maxLines: 20,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                      // ignore: unrelated_type_equality_checks
                      decoration: isActive
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    )))
          ],
        ),
      ),
    );
  }
}
