import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanandroid/pages/home_page.dart';
import 'package:wanandroid/pages/navigator_page.dart';
import 'package:wanandroid/pages/projects_page.dart';
import 'package:wanandroid/pages/search_page.dart';
import 'package:wanandroid/pages/tree_page.dart';
import 'package:wanandroid/res/colors.dart';
import 'package:wanandroid/res/strings.dart';
import 'package:wanandroid/util/favorite_provide.dart';
import 'package:wanandroid/util/theme_provide.dart';
import 'package:wanandroid/util/toast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  int themeIndex = await getTheme();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvide(themeIndex)),
        ChangeNotifierProvider(create: (context) => FavoriteProvide())
      ],
      child: MyApp(themeIndex),
    ),
  );
}

/// 获取主题
Future<int> getTheme() async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  int themeIndex = sp.getInt(YColors.themeIndexKey) ?? 3;
  return themeIndex;
}

class MyApp extends StatelessWidget {
  final int themeIndex;

  const MyApp(this.themeIndex, {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final int themeValue = context.watch<ThemeProvide>().value ?? themeIndex;

    return MaterialApp(
      title: YString.appName,
      theme: ThemeData(
        primaryColor: YColors.themeColor[themeValue]?['primaryColor'],
        primaryColorDark: YColors.themeColor[themeValue]?['primaryColorDark'],
        colorScheme: ColorScheme.fromSwatch(
            accentColor: YColors.themeColor[themeValue]?['accentColor']),
        // useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _selectedIndex = 0;
  String title = YString.appName;

  final _pageController = PageController(initialPage: 0);

  final _pages = [
    const HomePage(),
    const TreePage(),
    const NavigatorPage(),
    const ProjectPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              /// 点击搜索
              Fluttertoast.showToast(msg: "搜索");
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SearchPage()));
            },
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            tooltip: "搜素",
          )
        ],
      ),
      body: PageView.builder(
          onPageChanged: _pageChanged,
          controller: _pageController,
          itemCount: _pages.length,
          itemBuilder: (BuildContext context, int index) => _pages[index]),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.home), label: YString.home),
          BottomNavigationBarItem(
              icon: const Icon(Icons.filter_list), label: YString.tree),
          BottomNavigationBarItem(
              icon: const Icon(Icons.low_priority), label: YString.navi),
          BottomNavigationBarItem(
              icon: const Icon(Icons.apps), label: YString.project),
        ],
        // 背景颜色设置成白色
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        // shifting:非选择状态下，不显示文本，fixed：任何状态下都显示文本
        type: BottomNavigationBarType.fixed,
        fixedColor: Theme.of(context).primaryColor,
        onTap: _onPageTapped,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: _selectedLastItem,
        tooltip: '选中最后一个',
        // 设置成圆形
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      drawer: Drawer(
        width: 240,
        child: Container(width: 100,color: Colors.white,),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _selectedLastItem() {
    ToastUtils.toast("选中最后一个", backgroundColor: Theme.of(context).primaryColor);
    _onPageTapped(3);
  }

  void _onPageTapped(int index) {
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void _pageChanged(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          title = YString.appName;
          break;
        case 1:
          title = YString.tree;
          break;
        case 2:
          title = YString.navi;
          break;
        case 3:
          title = YString.project;
          break;
      }
    });
  }
}
