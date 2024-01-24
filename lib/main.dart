import 'package:flutter/material.dart';
import 'TabContent.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notki',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyTabs(),
    );
  }
}

class MyTabs extends StatefulWidget {
  @override
  _MyTabsState createState() => _MyTabsState();
}

class _MyTabsState extends State<MyTabs> {
  List<TabContentData> tabDataList = [TabContentData()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notki'),
        backgroundColor: const Color.fromARGB(255, 170, 113, 27),
        foregroundColor: Colors.white,
        actions: const [
          Icon(
            Icons.inventory_outlined,
            size: 50,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: tabDataList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(tabDataList[index].title.isNotEmpty
                          ? tabDataList[index].title
                          : 'Notka ${index + 1}'),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            tabDataList.removeAt(index);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(10),
                        ),
                        child: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          // Pass the function to update title
                          return TabContent(
                            tabContentData: tabDataList[index],
                            updateTitle: (newTitle) {
                              setState(() {
                                tabDataList[index].title = newTitle;
                              });
                            },
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                tabDataList.add(TabContentData());
              });
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 170, 113, 27)),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
            child: const Text('Dodaj zakładkę'),
          ),
        ],
      ),
    );
  }
}
