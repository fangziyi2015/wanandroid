import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid/entity/article_entity.dart';
import 'package:wanandroid/entity/tree_entity.dart';
import 'package:wanandroid/http/api.dart';
import 'package:wanandroid/http/http_util.dart';
import 'package:wanandroid/util/toast.dart';

import '../webview/webview_page.dart';

class TreeDetailPage extends StatefulWidget {
  final TreeData treeData;
  final int index;

  const TreeDetailPage(this.treeData, this.index, {super.key});

  @override
  State<TreeDetailPage> createState() => _TreeDetailPageState();
}

class _TreeDetailPageState extends State<TreeDetailPage>
    with TickerProviderStateMixin {
  List<ArticleItemData> articleItemList = [];
  List<Children> _tabDataList = [];

  late TabController _tabController;

  int _page = 0;
  int _curPageIndex = 0;

  @override
  void initState() {
    _tabController = TabController(
        length: widget.treeData.children?.length ?? 0, vsync: this);
    _curPageIndex = widget.index;
    _tabDataList = widget.treeData.children ?? [];

    _loadTreeDetailData();

    _tabController.addListener(() {
      setState(() {
        if (_tabController.index == _tabController.animation?.value) {
          _curPageIndex = _tabController.index;
        }
      });
      _loadTreeDetailData();
    });

    _tabController.animateTo(_curPageIndex);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadTreeDetailData() async {
    try {
      var treeDetailResponse = await HttpUtil.getInstance().get(
          "${Api.treeArticlePath}$_page/json?cid=${widget.treeData.children?[_curPageIndex].id}");
      debugPrint("treeDetailResponse :${treeDetailResponse.toString()}");
      var articleEntity = ArticleEntity.fromJson(treeDetailResponse);

      setState(() {
        if (_page == 0) {
          articleItemList.clear();
        }
        articleItemList.addAll(articleEntity.data?.datas ?? []);
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          widget.treeData.name ?? "",
          style: const TextStyle(color: Colors.white),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          labelStyle: const TextStyle(fontSize: 16.0),
          unselectedLabelColor: Colors.white60,
          unselectedLabelStyle: const TextStyle(fontSize: 16.0),
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.label,
          isScrollable: true,
          tabs: _tabDataList.map((data) {
            return Tab(
              text: data.name,
            );
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabDataList.map((data) {
          return EasyRefresh(
              header: const TaurusHeader(),
              footer: const TaurusFooter(),
              onRefresh: () async {
                _page = 0;
                _loadTreeDetailData();
              },
              onLoad: () async {
                _page++;
                _loadTreeDetailData();
              },
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return _articleItemView(index);
                },
                itemCount: articleItemList.length,
              ));
        }).toList(),
      ),
    );
  }

  Widget _articleItemView(int index) {
    final item = articleItemList[index];

    /// 标题
    Row row = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            child: Text.rich(TextSpan(children: [
          TextSpan(
              text: item.title ?? "",
              style: const TextStyle(color: Colors.black, fontSize: 16.0))
        ]))),
        const Icon(Icons.chevron_right)
      ],
    );

    /// 标签和作者 以及发布时间
    Row tagAndAuthor = Row(
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 150),
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).primaryColor,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular((20.0)),
          ),
          child: Text(
            item.superChapterName ?? "",
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                overflow: TextOverflow.ellipsis),
            maxLines: 1,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(item.author ?? ""),
        ),
        const Spacer(),
        Text(item.niceDate ?? ""),
      ],
    );

    Column column = Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 5),
          child: row,
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 10),
          child: tagAndAuthor,
        )
      ],
    );

    return InkWell(
      child: Card(
        elevation: 6,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: column,
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return WebViewPage(item.link ?? "", item.title ?? "");
        }));
      },
    );
  }
}
