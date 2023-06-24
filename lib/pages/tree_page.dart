import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid/http/api.dart';
import 'package:wanandroid/http/http_util.dart';
import 'package:wanandroid/pages/tree_detail_page.dart';
import 'package:wanandroid/util/toast.dart';

import '../entity/tree_entity.dart';

class TreePage extends StatefulWidget {
  const TreePage({super.key});

  @override
  State<TreePage> createState() => _TreePageState();
}

class _TreePageState extends State<TreePage> {
  List<TreeData> treeDataList = [];

  final ScrollController _scrollController = ScrollController();
  int _panelIndex = 0;

  bool _isLoading = true;

  @override
  void initState() {
    _loadTreeData();

    _scrollController.addListener(() {
      //当前位置==最大滑动范围 表示已经滑动到了底部
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        ToastUtils.toast("滑动到了底部");
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadTreeData() async {
    try {
      var treeResponse = await HttpUtil.getInstance().get(Api.treePath);
      debugPrint("treeResponse = ${treeResponse.toString()}");
      var treeEntity = TreeEntity.fromJson(treeResponse);

      setState(() {
        treeDataList.clear();
        treeDataList.addAll(treeEntity.data ?? []);
        _isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? _loadingView() : _loadCompleted();
  }

  Widget _loadCompleted() {
    return Scaffold(
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          color: Theme.of(context).primaryColor,
          displacement: 40,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: ExpansionPanelList(
              expansionCallback: (int panelIndex, bool isExpanded) {
                debugPrint("panelIndex:$panelIndex,isExpanded:${!isExpanded}");
                setState(() {
                  _panelIndex = panelIndex;
                  treeDataList[panelIndex].isExpanded = !isExpanded;
                });
              },
              children: treeDataList.map<ExpansionPanel>((treeData) {
                return ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        contentPadding: const EdgeInsets.all(10.0),
                        title: Text(
                          treeData.name ?? "",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        style: ListTileStyle.list,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                      );
                    },
                    body: Container(
                      height: 200,
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: ListView.builder(
                        itemCount: treeData.children?.length ?? 0,
                        itemBuilder: (context, index) {
                          var item = treeData.children?[index];
                          if (item == null) return null;
                          return InkWell(
                            child: ListTile(
                              title: Text(
                                item.name ?? "",
                                style: const TextStyle(color: Colors.blue),
                              ),
                              trailing: const Icon(
                                Icons.chevron_right,
                                color: Colors.blue,
                              ),
                            ),
                            onTap: () {
                              ToastUtils.toast(item.name ?? "");
                              debugPrint("index = $index");
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return TreeDetailPage(treeData, index);
                              }));
                            },
                          );
                        },
                      ),
                    ),
                    isExpanded: treeData.isExpanded);
              }).toList(),
            ),
          ),
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 1), () {
              ToastUtils.toast("下拉刷新");
            });
          },
        ));
  }

  Widget _loadingView() {
    return Container(
      color: Colors.white,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
