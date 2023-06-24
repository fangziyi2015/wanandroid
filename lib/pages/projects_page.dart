import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid/http/api.dart';
import 'package:wanandroid/http/http_util.dart';
import 'package:wanandroid/res/colors.dart';

import '../entity/project_detail_entity.dart';
import '../entity/project_entity.dart';
import '../webview/webview_page.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({super.key});

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage>
    with TickerProviderStateMixin {
  List<ProjectData> tabs = [];
  List<ProjectItemData> projectItems = [];
  List<ProjectDetailData> tabDetails = [];

  int _page = 1;
  int _selectedTab = 0;
  int _cid = 294;

  final EasyRefreshController _easyRefreshController = EasyRefreshController();
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 0, vsync: this);
    _loadTabData();
    super.initState();
  }

  @override
  void dispose() {
    _easyRefreshController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _loadTabData() async {
    try {
      var tabResponse = await HttpUtil.getInstance().get(Api.projectPath);
      debugPrint("tabResponse:$tabResponse");
      var projectEntity = ProjectEntity.fromJson(tabResponse);
      setState(() {
        tabs.clear();
        tabs.addAll(projectEntity.data ?? []);
        _tabController = TabController(length: tabs.length, vsync: this);
        _tabController.addListener(() {
          if (_tabController.index == _tabController.animation?.value) {
            setState(() {
              _selectedTab = _tabController.index;
              _page = 0;
            });

            _loadTabDetailData();
          }
        });
        if (tabs.isNotEmpty) {
          _tabController.animateTo(0);
        }
      });

      _loadTabDetailData();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _loadTabDetailData() async {
    try {
      _cid = tabs[_selectedTab].id ?? 294;
      var tabResponse = await HttpUtil.getInstance()
          .get("${Api.projectDetailPath}$_page/json?cid=$_cid");
      debugPrint("tabResponse:$tabResponse");
      var projectDetailEntity = ProjectDetailEntity.fromJson(tabResponse);
      setState(() {
        if (_page == 0) {
          projectItems.clear();
        }
        projectItems.addAll(projectDetailEntity.data?.datas ?? []);
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: TabBar(
            controller: _tabController,
            labelColor: Theme.of(context).primaryColor,
            labelStyle: const TextStyle(fontSize: 16.0),
            unselectedLabelColor: YColors.color_666,
            unselectedLabelStyle: const TextStyle(fontSize: 16.0),
            indicatorColor: Theme.of(context).primaryColor,
            indicatorSize: TabBarIndicatorSize.label,
            isScrollable: true,
            tabs: tabs.map<Widget>((tab) {
              debugPrint("tabName = ${tab.name}");
              return Tab(
                text: tab.name,
              );
            }).toList()),
        body: TabBarView(
            controller: _tabController,
            children: List<Widget>.generate(tabs.length, (index) {
              return EasyRefresh(
                controller: _easyRefreshController,
                header: const PhoenixHeader(),
                footer: const PhoenixFooter(),
                child: _projectListView(index),
                onRefresh: () {
                  /// 刷新数据
                  _page = 0;
                  _loadTabDetailData();
                },
                onLoad: () {
                  _page++;
                  _loadTabDetailData();
                },
              );
            })));
  }

  Widget _projectListView(int tabIndex) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Card(
          surfaceTintColor: Colors.white,
          elevation: 5,
          margin: index == 0
              ? const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 8)
              : const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: _itemContentView(index),
            ),
          ),
        );
      },
      itemCount: projectItems.length,
    );
  }

  Widget _itemContentView(int index) {
    var item = projectItems[index];
    return InkWell(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 200,
              child: Image.network(
                item.envelopePic ?? "",
                fit: BoxFit.fill,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    item.title ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    item.desc ?? "",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                        fontWeight: FontWeight.normal),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        item.niceDate ?? "",
                        maxLines: 1,
                        style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                            fontWeight: FontWeight.normal),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 100,
                        child: Text(
                          item.author ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return WebViewPage(item.link ?? "", item.title ?? "");
        }));
      },
    );
  }
}
