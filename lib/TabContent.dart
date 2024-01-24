import 'package:flutter/material.dart';

class TabContentData {
  List<TextEditingController> textControllers = [];
  List<String> imageUrls = [];
  TextEditingController urlController = TextEditingController();
  String title = '';
}

class TabContent extends StatefulWidget {
  final TabContentData tabContentData;
  final Function(String) updateTitle;

  TabContent({required this.tabContentData, required this.updateTitle});

  @override
  _TabContentState createState() => _TabContentState();
}

class _TabContentState extends State<TabContent> {
  TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.tabContentData.title.isNotEmpty
              ? widget.tabContentData.title
              : 'Nowa Notatka'),
          backgroundColor: const Color.fromARGB(255, 170, 113, 27),
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                _showTitleInputDialog();
              },
            ),
          ],
          bottom: const TabBar(
            unselectedLabelStyle: TextStyle(color: Colors.grey),
            labelStyle: TextStyle(color: Colors.white),
            tabs: [
              Tab(
                text: 'Tekst',
                icon: Icon(Icons.text_fields),
              ),
              Tab(
                text: 'Zdjęcia',
                icon: Icon(Icons.image),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.tabContentData.textControllers.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: TextField(
                          maxLines: null,
                          controller:
                              widget.tabContentData.textControllers[index],
                          decoration: const InputDecoration(
                            hintText: 'Wprowadź Tekst',
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          widget.tabContentData.textControllers
                              .add(TextEditingController());
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 170, 113, 27)),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      child: const Text('Dodaj Pole Tekstowe'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (widget
                              .tabContentData.textControllers.isNotEmpty) {
                            widget.tabContentData.textControllers.removeLast();
                          }
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 170, 113, 27)),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      child: const Text('Usuń Pole Tekstowe'),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: widget.tabContentData.urlController,
                    decoration: InputDecoration(
                      labelText: 'Wprowadź Url Obrazu',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: addImage,
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                  itemCount: widget.tabContentData.imageUrls.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Image.network(
                              widget.tabContentData.imageUrls[index],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey,
                                  child: const Center(
                                    child: Text(
                                      'Error loading image',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.cancel),
                              onPressed: () {
                                removeImage(index);
                              },
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void addImage() {
    String imageUrl = widget.tabContentData.urlController.text;

    if (imageUrl.isNotEmpty) {
      Uri? uri = Uri.tryParse(imageUrl);

      if (uri != null && uri.isAbsolute) {
        setState(() {
          widget.tabContentData.imageUrls.add(imageUrl);
          widget.tabContentData.urlController.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nieprawidłowy Url Obrazu'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void removeImage(int index) {
    setState(() {
      if (index >= 0 && index < widget.tabContentData.imageUrls.length) {
        widget.tabContentData.imageUrls.removeAt(index);
      }
    });
  }

  void _showTitleInputDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Nadaj Tytuł Zakładki'),
          content: TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Tytuł'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Anuluj'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  widget.tabContentData.title = titleController.text;

                  widget.updateTitle(titleController.text);
                });
                Navigator.pop(context);
              },
              child: const Text('Zapisz'),
            ),
          ],
        );
      },
    );
  }
}
