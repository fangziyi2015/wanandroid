import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:wanandroid/http/api.dart';
import 'package:wanandroid/http/http_util.dart';
import 'package:wanandroid/res/colors.dart';
import 'package:wanandroid/webview/webview_page.dart';

import '../entity/article_entity.dart';
import '../entity/banner_entity.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<BannerItemData> banners = [];
  List<ArticleItemData> articleList = [];

  late EasyRefreshController _easyRefreshController;
  late SwiperController _swiperController;

  int _page = 0;
  bool hasMore = true;

  @override
  void initState() {
    _easyRefreshController = EasyRefreshController(
        controlFinishRefresh: true, controlFinishLoad: true);
    _swiperController = SwiperController();

    _loadData();
    super.initState();
  }

  @override
  void dispose() {
    _easyRefreshController.dispose();
    _swiperController.dispose();
    super.dispose();
  }

  void _loadData() async {
    var bannerResponse = await HttpUtil.getInstance().get(Api.bannerPath);
    debugPrint("bannerResponse:${bannerResponse.toString()}");
    var bannerEntity = BannerEntity.fromJson(bannerResponse);

    var articleResponse =
        await HttpUtil.getInstance().get("${Api.articlePath}$_page/json");
    var articleEntity = ArticleEntity.fromJson(articleResponse);

    setState(() {
      banners = bannerEntity.data ?? [];
      articleList = articleEntity.data?.datas ?? [];
    });

    _swiperController.startAutoplay();
  }

  void _loadMore() async {
    var articleResponse =
        await HttpUtil.getInstance().get("${Api.articlePath}$_page/json");
    var articleEntity = ArticleEntity.fromJson(articleResponse);

    setState(() {
      var more = articleEntity.data?.datas;
      if (more != null) {
        articleList.addAll(more);
        // 由于每页加载十条，如果最后一次加载的数量少于10条，则认为没有更多数据了
        if (more.length < 10) {
          hasMore = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: EasyRefresh.builder(
            controller: _easyRefreshController,
            header: const PhoenixHeader(
                skyColor: YColors.colorPrimary,
                position: IndicatorPosition.locator,
                safeArea: false),
            footer: const PhoenixFooter(
                skyColor: YColors.colorPrimary,
                position: IndicatorPosition.locator),
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1), () {
                // 是否在tree中
                if (!mounted) {
                  return;
                }

                setState(() {
                  _page = 0;
                });

                _loadData();

                _easyRefreshController.finishRefresh();
                _easyRefreshController.resetFooter();
              });
            },
            onLoad: () async {
              await Future.delayed(const Duration(seconds: 1), () {
                if (!mounted) {
                  return;
                }

                setState(() {
                  _page++;
                });

                _loadMore();

                _easyRefreshController.finishLoad(
                    hasMore ? IndicatorResult.success : IndicatorResult.noMore);
              });
            },
            childBuilder: (BuildContext context, ScrollPhysics physics) {
              return CustomScrollView(
                physics: physics,
                slivers: [
                  SliverAppBar(
                    backgroundColor: Theme.of(context).primaryColor,
                    expandedHeight:
                        MediaQuery.of(context).size.width / 1.8 * 0.8 +
                            20, // +20是上下的padding
                    pinned: false,
                    flexibleSpace: FlexibleSpaceBar(
                      background: _getBannerView(),
                    ),
                  ),
                  const HeaderLocator.sliver(),
                  SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                    if (articleList.isEmpty) return null;
                    return _articleItemView(index);
                  }, childCount: articleList.length))
                ],
              );
            }),
      ),
    );
  }

  Widget _articleItemView(int index) {
    final item = articleList[index];

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
        surfaceTintColor: Colors.white,
        elevation: 6,
        margin: index == 0
            ? const EdgeInsets.only(left: 10, right: 10, top: 14, bottom: 6)
            : const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: column,
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return WebViewPage(item.link ?? "", item.title ?? "");
        }));
      },
    );
  }

  Widget _getBannerView() {
    return Container(
      width: MediaQuery.of(context).size.width,
      //1.8是banner宽高比，0.8是viewportFraction的值
      height: MediaQuery.of(context).size.width / 1.8 * 0.8,
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Swiper(
        itemCount: banners.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                  image: NetworkImage(banners[index].imagePath ?? ""),
                  fit: BoxFit.fill),
            ),
          );
        },
        loop: false,
        autoplay: false,
        autoplayDelay: 3000,
        //触发时是否停止播放
        autoplayDisableOnInteraction: true,
        duration: 600,
        controller: _swiperController,
        // 指示器
        pagination: const SwiperPagination(
            builder: RectSwiperPaginationBuilder(
                color: Colors.red,
                size: Size(20, 8),
                activeSize: Size(20, 8),
                activeColor: Colors.blue)),
        //视图宽度，即显示的item的宽度屏占比
        viewportFraction: 0.8,
        //两侧item的缩放比
        scale: 0.9,
        onTap: (int index) {
          debugPrint("点击了：$index");
        },
      ),
    );
  }
}
