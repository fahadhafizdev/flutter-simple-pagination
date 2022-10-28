import 'dart:developer';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController scrollController = ScrollController();
  ScrollController scrollController2 = ScrollController();
  List<String> items = [];
  List<String> items2 = [];
  bool loading = false, allLoaded = false;

  bool loading2 = false, allLoaded2 = false;

  bool page1 = true, page2 = false;

  mockFetch() async {
    if (allLoaded) {
      return;
    }
    setState(() {
      loading = true;
    });
    await Future.delayed(const Duration(milliseconds: 600));
    List<String> newData = items.length >= 60
        ? []
        : List.generate(20, (index) => 'menu1 ${index + items.length}');
    if (newData.isNotEmpty) {
      items.addAll(newData);
    }

    setState(() {
      loading = false;
      allLoaded = newData.isEmpty;
    });
  }

  mockFetch2() async {
    if (allLoaded2) {
      return;
    }
    setState(() {
      loading2 = true;
    });
    await Future.delayed(const Duration(milliseconds: 600));
    List<String> newData = items.length >= 60
        ? []
        : List.generate(20, (index) => 'menu2 ${index + items2.length}');
    if (newData.isNotEmpty) {
      items2.addAll(newData);
    }

    setState(() {
      loading2 = false;
      allLoaded2 = newData.isEmpty;
    });
  }

  @override
  void initState() {
    mockFetch();
    mockFetch2();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent &&
          !loading) {
        log('PAGINATE CALL 1');
        page1 ? mockFetch() : mockFetch2();
      }
    });

    scrollController2.addListener(() {
      if (scrollController2.position.pixels >=
              scrollController2.position.maxScrollExtent &&
          !loading2) {
        log('PAGINATE CALL 2');
        page1 ? mockFetch() : mockFetch2();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    scrollController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget menu1() {
      return ListView.builder(
        controller: scrollController,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index]),
          );
        },
        itemCount: items.length,
      );
    }

    Widget menu2() {
      return ListView.builder(
        controller: scrollController2,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items2[index]),
          );
        },
        itemCount: items2.length,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Pagination'),
        actions: [
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              page1 = true;
              page2 = false;
              setState(() {});
            },
            child: Icon(Icons.menu),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              page1 = false;
              page2 = true;
              setState(() {});
            },
            child: Icon(Icons.menu_book),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: (items.isNotEmpty)
          ? Stack(
              children: [
                page1 ? menu1() : menu2(),
                if (loading || loading2) ...[
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ]
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
