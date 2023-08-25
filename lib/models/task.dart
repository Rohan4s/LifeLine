class Task{
  int? id;
  String? title;
  int? isCompleted;
  String? date;
  String? time;
  int? remind;
  Task({
    this.id,
    this.title,
    this.isCompleted,
    this.date,
    this.time,
    this.remind,
});
  Task.fromJson(Map<String,dynamic>json){
    id=json['id'];
    title=json['title'];
    isCompleted=json['isCompleted'];
    date=json['date'];
    time=json['time'];
    remind=json['remind'];
  }
  Map<String, dynamic>toJson(){
    final Map<String,dynamic> data=new Map<String,dynamic>();
    data['id']=this.id;
    data['title']=this.title;
    data['isCompleted']=this.isCompleted;
    data['date']=this.date;
    data['time']=this.time;
    data['remind']=this.remind;
    return data;

  }
}