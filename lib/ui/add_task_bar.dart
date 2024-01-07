import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list_app/controller/task_controller.dart';
import 'package:to_do_list_app/ui/theme.dart';
import 'package:to_do_list_app/ui/widgets/button.dart';
import 'package:to_do_list_app/ui/widgets/input_field.dart';

import '../model/task.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectDate = DateTime.now();
  String _endTime = "9:30 PM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectdRemind = 5;
  List<int> remindList = [
    5,10,15,20,25,
  ];
  int _selectedColor = 0;
  String _selectRepeat = "none";
  List<String> repeatList = ['none','daily','weekly','monthly'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(context),
      body: Container(
        padding: EdgeInsets.only(right: 20, left: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Task",
                style: headingStyle,
              ),
              MyInputField(title: "Title", hint: "Enter Your Title",controller: _titleController,),
              MyInputField(title: "Note", hint: "Enter Your Note",controller: _noteController,),
              MyInputField(
                title: "Date",
                hint: DateFormat.yMd().format(_selectDate),
                widget: IconButton(
                  onPressed: () {
                    _getDateFormUser();
                  },
                  icon: Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(child: MyInputField
                    (title: "Start time",
                    hint: _startTime,
                    widget: IconButton(onPressed: (){
                      _getTimeFromUser(isStartTime:true);
                    },
                        icon: Icon(Icons.access_time_rounded,
                          color: Colors.grey,
                        ),),),),
                  SizedBox(width: 12,),
                  Expanded(child: MyInputField
                    (title: "End Time",
                    hint: _endTime,
                    widget: IconButton(onPressed: (){
                      _getTimeFromUser(isStartTime:false);
                    },
                      icon: Icon(Icons.access_time_rounded,
                        color: Colors.grey,
                      ),),),),
                ],
              ),
              MyInputField(
                title: "Remind",
                hint: "$_selectdRemind minuts earlier",
                widget: DropdownButton(
                  icon: Icon(Icons.keyboard_arrow_down,color: Colors.grey,),
                  iconSize: 32,
                  elevation: 4,
                  style: subtitleStyle,
                  items: remindList.map<DropdownMenuItem<String>>((int value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                        child: Text(value.toString()));
                  },
                  ).toList(), onChanged: (String? newValue) {
                    setState(() {
                      _selectdRemind = int.parse(newValue!);
                    });
                },
                ),
              ),
              MyInputField(
                title: "Repeat",
                hint: "$_selectRepeat",
                widget: DropdownButton(
                  icon: Icon(Icons.keyboard_arrow_down,color: Colors.grey,),
                  iconSize: 32,
                  elevation: 4,
                  style: subtitleStyle,
                  items: repeatList.map<DropdownMenuItem<String>>((String? value) {
                    return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value.toString()));
                  },
                  ).toList(),
                  onChanged: (String? newValue) {
                  setState(() {
                    _selectRepeat = newValue!;
                  });
                },
                ),
              ),
              SizedBox(height: 18,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              //_selectColorFuntion(),
                  MyButton(label: "Create Task", onTap: ()=>_validateDate()),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  _validateDate(){
    if(_titleController.text.isNotEmpty&&_noteController.text.isNotEmpty){
      //add data to the database
      _addTaskToDb();
      Get.back();
    }else if(_titleController.text.isEmpty || _noteController.text.isEmpty){
      Get.snackbar("Required", "All field are requrid !",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: pinkClr,
        icon: Icon(Icons.warning_amber_rounded,color: pinkClr,),
      );

    }
  }
  _addTaskToDb()async{
 int value =  await _taskController.addTask(
      task:Task(
        note: _noteController.text,
        title: _titleController.text,
        date: DateFormat.yMd().format(_selectDate),
        startTime: _startTime,
        endTime: _endTime,
        remind: _selectdRemind,
        repeat: _selectRepeat,
        color: _selectedColor,
        isCompleted: 0,
      )
  );
 print("id "+"$value"" is create");
  }
  _selectColorFuntion(){
    return     Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Color",style: titleStyle,),
        SizedBox(height: 8,),
        Wrap(
          children: List<Widget>.generate(3, (int index){
            return GestureDetector(
              onTap: (){
                setState(() {
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: index==0?primaryClr:index==1?pinkClr:yellowClr,
                  child: _selectedColor==index?Icon(Icons.done,size: 16,color: Colors.white,):Container(),
                ),
              ),
            );
          }),
        )
      ],
    );
}
  _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      // backgroundColor:,
      leading: GestureDetector(
        onTap: () {
          // ThemeService().switchTheme();
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
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
  _getDateFormUser() async {
    DateTime? _pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2025),
    );
    if(_pickerDate!=null){
     setState(() {
       _selectDate = _pickerDate;
     });
    }else{
      print("its null or something get wrong");
    }
  }
  _getTimeFromUser( {required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    String _formatedTime = pickedTime.format(context);
    if(pickedTime==null){

    }else if(isStartTime==true){
      setState(() {
        _startTime = _formatedTime;
      });
    }else if(isStartTime==false){
     setState(() {
       _endTime = _formatedTime;
     });
    }
  }
  _showTimePicker(){
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
          hour: int.parse(_startTime.split(":")[0]),
          minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
        ),);
  }
}
