import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:date_picker_timeline/extra/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list_app/controller/task_controller.dart';
import 'package:to_do_list_app/model/task.dart';
import 'package:to_do_list_app/service/theme_service.dart';
import 'package:to_do_list_app/ui/add_task_bar.dart';
import 'package:to_do_list_app/ui/theme.dart';
import 'package:to_do_list_app/ui/widgets/button.dart';
import 'package:to_do_list_app/ui/widgets/task_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectDate = DateTime.now();
  final _taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    //final appBarTheme = AppBarTheme();
    //final backgroundColor = Theme.of(context).backgroundColor;
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          SizedBox(height: 10,),
          _addShowTask(),
        ],
      ),
    );
  }

  _addShowTask() {
    return Expanded(child: Obx(() {
      return ListView.builder(
          itemCount: _taskController.taskList.length,
          itemBuilder: (_, index) {
            print(_taskController.taskList.length);
            Task task = _taskController.taskList[index];
            if(task.repeat=="Daily"){
              return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            print("padded this button");
                            _showBottomSheet(
                                context,task);
                          },
                          child: TaskTile(task),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
            if(task.date==DateFormat.yMd().format(_selectDate)){
              return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            print("padded this button");
                            _showBottomSheet(
                                context,task);
                          },
                          child: TaskTile(task),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
            else{
              return Container();
            }


          });
    }));
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(top: 4),
        height: task.isCompleted == 1
            ? MediaQuery.of(context).size.height * 0.24
            : MediaQuery.of(context).size.height * 0.32,
        color: Get.isDarkMode ? darkGreyClr : Colors.white,
        child: Column(
          children: [
            Container(
              width: 120,
              height: 6,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
            ),
            Spacer(),
            task.isCompleted == 1
                ? Container()
                : _bottomSheetButton(
                    lebel: "Task Completed",
                    onTap: () {
                      _taskController.markTaskCompledted(task.id!);
                      Get.back();
                    },
                    clr: primaryClr,
              context:context,
                  ),
            _bottomSheetButton(
              lebel: "Delete Task",
              onTap: () {
                _taskController.delete(task);

                Get.back();
              },
              clr: Colors.red[300]!,
              context:context,
            ),
            SizedBox(height: 20,),
            _bottomSheetButton(
              lebel: "Close",
              onTap: () {
                Get.back();
              },
              clr: Colors.red[300]!,
              isClose:true,
              context:context,
            ),
          ],

        ),
      ),
    );
  }

  _bottomSheetButton({
    required String lebel,
    required Function() onTap,
    required Color clr,
    bool isClose = false,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width:  MediaQuery.of(context).size.width * 0.9,
        decoration:  BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isClose ==true ? Colors.transparent: clr,
          border: Border.all(
            width: 2,
            color: isClose==true?Get.isDarkMode? Colors.grey[600]!:Colors.grey[600]!:clr,
          )
        ),
        child: Center(
          child: Text(
            lebel,style: isClose ? titleStyle :titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: EdgeInsets.only(left: 20, top: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        onDateChange: (date) {
        setState(() {
          _selectDate = date;
        });
        },
      ),
    );
  }

  _addTaskBar() {
    return Container(
      margin: EdgeInsets.only(right: 20, left: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text(
                  "Today",
                  style: headingStyle,
                ),
              ],
            ),
          ),
          MyButton(
              label: "+ Add Task",
              onTap: () async {
                await Get.to(AddTaskPage());
                _taskController.getTasks();
              }),
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      // backgroundColor:,
      leading: GestureDetector(
        onTap: () {
          ThemeService().switchTheme();
        },
        child: Icon(
          Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
          size: 25,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: [
        CircleAvatar(
          backgroundImage: AssetImage("assets/marsalan.jpg"),
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }
}
