class TreeEntity {
  List<TreeData>? data;
  int? errorCode;
  String? errorMsg;

  TreeEntity({this.data, this.errorCode, this.errorMsg});

  TreeEntity.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <TreeData>[];
      json['data'].forEach((v) {
        data!.add(new TreeData.fromJson(v));
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

class TreeData {
  List<Article>? articleList;
  String? author;
  List<Children>? children;
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
  bool isExpanded = false;

  TreeData(
      {this.articleList,
        this.author,
        this.children,
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

  TreeData.fromJson(Map<String, dynamic> json) {
    author = json['author'];
    if (json['children'] != null) {
      children = <Children>[];
      json['children'].forEach((v) {
        children!.add(new Children.fromJson(v));
      });
    }
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
    if (this.children != null) {
      data['children'] = this.children!.map((v) => v.toJson()).toList();
    }
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

class Article{

}

class Children {
  List<ArticleList>? articleList;
  String? author;
  List<ChildrenItem>? children;
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

  Children(
      {this.articleList,
        this.author,
        this.children,
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

  Children.fromJson(Map<String, dynamic> json) {
    if (json['articleList'] != null) {
      articleList = <ArticleList>[];
      json['articleList'].forEach((v) {
        articleList!.add(new ArticleList.fromJson(v));
      });
    }
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
    if (this.articleList != null) {
      data['articleList'] = this.articleList!.map((v) => v.toJson()).toList();
    }
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

class ChildrenItem{

}

class ArticleList {
  bool? adminAdd;
  String? apkLink;
  int? audit;
  String? author;
  bool? canEdit;
  int? chapterId;
  String? chapterName;
  bool? collect;
  int? courseId;
  String? desc;
  String? descMd;
  String? envelopePic;
  bool? fresh;
  String? host;
  int? id;
  bool? isAdminAdd;
  String? link;
  String? niceDate;
  String? niceShareDate;
  String? origin;
  String? prefix;
  String? projectLink;
  int? publishTime;
  int? realSuperChapterId;
  int? selfVisible;
  int? shareDate;
  String? shareUser;
  int? superChapterId;
  String? superChapterName;
  String? title;
  int? type;
  int? userId;
  int? visible;
  int? zan;

  ArticleList(
      {this.adminAdd,
        this.apkLink,
        this.audit,
        this.author,
        this.canEdit,
        this.chapterId,
        this.chapterName,
        this.collect,
        this.courseId,
        this.desc,
        this.descMd,
        this.envelopePic,
        this.fresh,
        this.host,
        this.id,
        this.isAdminAdd,
        this.link,
        this.niceDate,
        this.niceShareDate,
        this.origin,
        this.prefix,
        this.projectLink,
        this.publishTime,
        this.realSuperChapterId,
        this.selfVisible,
        this.shareDate,
        this.shareUser,
        this.superChapterId,
        this.superChapterName,
        this.title,
        this.type,
        this.userId,
        this.visible,
        this.zan});

  ArticleList.fromJson(Map<String, dynamic> json) {
    adminAdd = json['adminAdd'];
    apkLink = json['apkLink'];
    audit = json['audit'];
    author = json['author'];
    canEdit = json['canEdit'];
    chapterId = json['chapterId'];
    chapterName = json['chapterName'];
    collect = json['collect'];
    courseId = json['courseId'];
    desc = json['desc'];
    descMd = json['descMd'];
    envelopePic = json['envelopePic'];
    fresh = json['fresh'];
    host = json['host'];
    id = json['id'];
    isAdminAdd = json['isAdminAdd'];
    link = json['link'];
    niceDate = json['niceDate'];
    niceShareDate = json['niceShareDate'];
    origin = json['origin'];
    prefix = json['prefix'];
    projectLink = json['projectLink'];
    publishTime = json['publishTime'];
    realSuperChapterId = json['realSuperChapterId'];
    selfVisible = json['selfVisible'];
    shareDate = json['shareDate'];
    shareUser = json['shareUser'];
    superChapterId = json['superChapterId'];
    superChapterName = json['superChapterName'];
    title = json['title'];
    type = json['type'];
    userId = json['userId'];
    visible = json['visible'];
    zan = json['zan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['adminAdd'] = this.adminAdd;
    data['apkLink'] = this.apkLink;
    data['audit'] = this.audit;
    data['author'] = this.author;
    data['canEdit'] = this.canEdit;
    data['chapterId'] = this.chapterId;
    data['chapterName'] = this.chapterName;
    data['collect'] = this.collect;
    data['courseId'] = this.courseId;
    data['desc'] = this.desc;
    data['descMd'] = this.descMd;
    data['envelopePic'] = this.envelopePic;
    data['fresh'] = this.fresh;
    data['host'] = this.host;
    data['id'] = this.id;
    data['isAdminAdd'] = this.isAdminAdd;
    data['link'] = this.link;
    data['niceDate'] = this.niceDate;
    data['niceShareDate'] = this.niceShareDate;
    data['origin'] = this.origin;
    data['prefix'] = this.prefix;
    data['projectLink'] = this.projectLink;
    data['publishTime'] = this.publishTime;
    data['realSuperChapterId'] = this.realSuperChapterId;
    data['selfVisible'] = this.selfVisible;
    data['shareDate'] = this.shareDate;
    data['shareUser'] = this.shareUser;
    data['superChapterId'] = this.superChapterId;
    data['superChapterName'] = this.superChapterName;
    data['title'] = this.title;
    data['type'] = this.type;
    data['userId'] = this.userId;
    data['visible'] = this.visible;
    data['zan'] = this.zan;
    return data;
  }
}
