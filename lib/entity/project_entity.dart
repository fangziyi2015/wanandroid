class ProjectEntity {
  List<ProjectData>? data;
  int? errorCode;
  String? errorMsg;

  ProjectEntity({this.data, this.errorCode, this.errorMsg});

  ProjectEntity.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ProjectData>[];
      json['data'].forEach((v) {
        data!.add(new ProjectData.fromJson(v));
      });
    }
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['errorCode'] = this.errorCode;
    data['errorMsg'] = this.errorMsg;
    return data;
  }
}

class ProjectData {
  String? author;
  int? courseId;
  String? cover;
  String? desc;
  int? id;
  String? lisense;
  String? lisenseLink;
  String? name;
  int? order;
  int? parentChapterId;
  int? type;
  bool? userControlSetTop;
  int? visible;

  ProjectData(
      {this.author,
        this.courseId,
        this.cover,
        this.desc,
        this.id,
        this.lisense,
        this.lisenseLink,
        this.name,
        this.order,
        this.parentChapterId,
        this.type,
        this.userControlSetTop,
        this.visible});

  ProjectData.fromJson(Map<String, dynamic> json) {
    author = json['author'];
    courseId = json['courseId'];
    cover = json['cover'];
    desc = json['desc'];
    id = json['id'];
    lisense = json['lisense'];
    lisenseLink = json['lisenseLink'];
    name = json['name'];
    order = json['order'];
    parentChapterId = json['parentChapterId'];
    type = json['type'];
    userControlSetTop = json['userControlSetTop'];
    visible = json['visible'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['author'] = this.author;
    data['courseId'] = this.courseId;
    data['cover'] = this.cover;
    data['desc'] = this.desc;
    data['id'] = this.id;
    data['lisense'] = this.lisense;
    data['lisenseLink'] = this.lisenseLink;
    data['name'] = this.name;
    data['order'] = this.order;
    data['parentChapterId'] = this.parentChapterId;
    data['type'] = this.type;
    data['userControlSetTop'] = this.userControlSetTop;
    data['visible'] = this.visible;
    return data;
  }
}
