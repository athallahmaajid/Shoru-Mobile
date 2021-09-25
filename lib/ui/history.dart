import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:flutter/services.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  Future<Widget>? _createList() async {
    var result = await Future<Widget>.delayed(Duration.zero, () async {
      List<Widget> rows = [];
      var urlBox = await Hive.openBox("urls");
      var urls = urlBox.values.toList();
      for (int i = 0; i < urls.length && i < 50; i++) {
        rows.add(
          SizedBox(
            height: 150,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      (i + 1).toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Url:",
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Text(
                            urls[i].url!,
                            style: const TextStyle(color: Colors.white),
                            // overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "Actual Url:",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          urls[i].actualUrl!,
                          style: const TextStyle(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(text: urls[i].url),
                        ).then(
                          (_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("URL copied to clipboard"),
                              ),
                            );
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.copy,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                // const Divider(
                //   color: Colors.white,
                // ),
              ],
            ),
          ),
        );
      }
      return ListView(shrinkWrap: true, children: rows);
    });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Align(
          alignment: Alignment.topCenter,
          child: Text(
            "History",
            style: TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        FutureBuilder<Widget>(
          future: _createList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!;
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ],
    );
  }
}
