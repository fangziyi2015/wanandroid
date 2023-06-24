import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid/http/http_util.dart';
import 'package:wanandroid/res/colors.dart';

import '../entity/navigator_entity.dart';
import '../http/api.dart';
import '../webview/webview_page.dart';

class NavigatorPage extends StatefulWidget {
  const NavigatorPage({super.key});

  @override
  State<NavigatorPage> createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  List<NaviArticleData> naviDataList = [];
  List<Articles> articleList = [];

  int _selectedIndex = 0;

  @override
  void initState() {
    _loadNaviData();
    super.initState();
  }

  void _loadNaviData() async {
    try {
      var naviResponse = await HttpUtil.getInstance().get(Api.naviPath);
      debugPrint("naviResponse:${naviResponse.toString()}");
      var naviEntity = NavigatorEntity.fromJson(naviResponse);
      setState(() {
        naviDataList.clear();
        naviDataList.addAll(naviEntity.data ?? []);
      });

      _updateNaviDetailData();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _updateNaviDetailData() {
    setState(() {
      articleList.clear();
      articleList.addAll(naviDataList[_selectedIndex].articles ?? []);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.white,
            child: _naviView(),
          ),
        ),
        Expanded(
          flex: 5,
          child: Container(
            color: YColors.color_F9F9F9,
            child: _navDetailView(),
          ),
        )
      ],
    );
  }

  Widget _naviView() {
    return ListView.builder(
      itemCount: naviDataList.length,
      itemBuilder: (context, index) {
        return _naviItemView(index);
      },
    );
  }

  Widget _naviItemView(int index) {
    var item = naviDataList[index];
    return InkWell(
      child: Container(
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _selectedIndex == index ? YColors.color_F9F9F9 : Colors.white,
          border: Border(
              left: BorderSide(
                  width: 5,
                  color: _selectedIndex == index
                      ? Theme.of(context).primaryColor
                      : YColors.color_F9F9F9)),
        ),
        child: Text(
          item.name ?? "",
          style: TextStyle(
              color: _selectedIndex == index
                  ? Theme.of(context).primaryColor
                  : YColors.color_666,
              fontSize: 16.0),
        ),
      ),
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });

        /// 更新详情数据
        _updateNaviDetailData();
      },
    );
  }

  Widget _navDetailView() {
    return ListView(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
        child: Wrap(
            spacing: 6,
            children: List<Widget>.generate(articleList.length, (index) {
              var item = articleList[index];
              return ActionChip(
                elevation: 4,
                shape:const RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(25))),
                shadowColor: Colors.grey.shade200,
                label: Text(item.title ?? "",),
                labelStyle:
                    const TextStyle(color: YColors.color_666, fontSize: 14.0),
                // labelPadding: const EdgeInsets.all(4),
                backgroundColor: Colors.grey.shade200,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return WebViewPage(item.link ?? "", item.title ?? "");
                  }));
                },
              );
            })),
      )
    ]);
  }
}
