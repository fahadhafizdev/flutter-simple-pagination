import 'dart:developer';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController scrollController = ScrollController();
  List<String> items = [];
  bool loading = false, allLoaded = false;

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
        : List.generate(20, (index) => 'item ${index + items.length}');
    if (newData.isNotEmpty) {
      items.addAll(newData);
    }

    setState(() {
      loading = false;
      allLoaded = newData.isEmpty;
    });
  }

  @override
  void initState() {
    mockFetch();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent &&
          !loading) {
        log('PAGINATE CALL');
        mockFetch();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Pagination'),
      ),
      body: (items.isNotEmpty)
          ? ListView.separated(
              controller: scrollController,
              itemBuilder: (context, index) {
                return !loading && index == items.length - 1
                    ? ListTile(
                        title: Text(items[index]),
                      )
                    : Column(
                        children: [
                          ListTile(
                            title: Text(items[items.length - 1]),
                          ),
                          CircularProgressIndicator(),
                        ],
                      );
              },
              separatorBuilder: (context, index) {
                return Divider(height: 1);
              },
              itemCount: items.length,
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
