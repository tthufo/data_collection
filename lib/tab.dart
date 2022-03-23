import 'package:flutter/material.dart';
import './tabs/list.dart';
import './tabs/construct.dart';
import './tabs/civil.dart';

class TabView extends StatelessWidget {
  final String title;

  const TabView({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Option();
  }
}

class Option extends StatefulWidget {
  const Option({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Option> with TickerProviderStateMixin {
  late TabController _controller;
  final List<Tab> topTabs = <Tab>[
    const Tab(text: 'Dân cư'),
    const Tab(text: 'Công trình'),
    const Tab(text: 'Danh sách'),
  ];

  TabBar get _tabBar => TabBar(
        indicatorColor: Colors.green,
        labelColor: Colors.greenAccent,
        unselectedLabelColor: Colors.black,
        tabs: topTabs,
        controller: _controller,
      );

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state = $state');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý'),
        backgroundColor: Colors.greenAccent,
        bottom: PreferredSize(
          preferredSize: _tabBar.preferredSize,
          child: ColoredBox(color: Colors.white, child: _tabBar),
        ),
      ),
      body: TabBarView(controller: _controller, children: const [
        CivilView(title: ""),
        ContructView(title: ""),
        Listing(title: "")
      ]),
    );
  }
}
