class Medicine {
  int? id;
  String? title;
  String? time1;
  String? time2;
  String? time3;
  int? remind;
  int? isCompleted;
  Medicine({
    this.id,
    this.title,
    this.time1,
    this.time2,
    this.time3,
    this.remind,
    this.isCompleted,
  });
  Medicine.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    time1 = json['time1'];
    time2 = json['time2'];
    time3 = json['time3'];
    remind = json['remind'];
    isCompleted = json['isCompleted'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['time1'] = this.time1;
    // data['time2']=this.time2;
    // data['time3']=this.time3;
    data['remind'] = this.remind;
    data['isCompleted'] = this.isCompleted;
    return data;
  }
// Map<String, dynamic> toMap() {
//   return {
//     'id': id,
//     'title': title,
//     'time1': time1,
//     'time2': time2,
//     'time3': time3,
//     'remind': remind,
//     'isCompleted': isCompleted,
//   };
// }
}
