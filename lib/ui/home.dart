import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'dart:convert';
import 'package:shoru_mobile/model/url.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? mode = "Random";
  TextEditingController urlController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  Map<String, String> result = {};

  Future<void> requestApi(String url, String name) async {
    var response = await http.post(
      Uri.parse("https://shoru.herokuapp.com/api/add"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: (name != "")
          ? jsonEncode(<String, String>{"url": url, "name": name})
          : jsonEncode(<String, String>{"url": url}),
    );
    var data = jsonDecode(response.body);
    result = Map<String, String>.from(data);
  }

  void checkUrl(String rawUrl) async {
    if (mode == "Random") {
      nameController = TextEditingController();
    }
    if (Uri.parse(rawUrl).isAbsolute) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
              backgroundColor: Color(0xFF1e1e1e),
              title: Text(
                "Loading...",
                style: TextStyle(color: Colors.white),
              ),
              content: SizedBox(
                  width: 1, height: 1, child: LinearProgressIndicator()));
        },
      );
      await requestApi(rawUrl, nameController.text);
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color(0xFF1e1e1e),
            content: (result["message"] == "success!")
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Url:",
                        style: TextStyle(color: Colors.white),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Text(
                              result['url']!,
                              style: const TextStyle(color: Colors.white),
                              // overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(text: result['url']!),
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
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        "Actual Url:",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          rawUrl,
                          style: const TextStyle(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  )
                : Text(
                    "${result['message']}",
                    style: TextStyle(color: Colors.white),
                  ),
          );
        },
      );
      if (result["message"] == "success!") {
        var urlBox = await Hive.openBox("urls");
        urlBox.add(Url(result['name']!, rawUrl, result['url']!));
      }
    } else if (mode == "Custom" && (nameController.text == "")) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              content:
                  Text("Mohon Isi nama", style: TextStyle(color: Colors.white)),
            );
          });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              backgroundColor: Color(0xFF1e1e1e),
              content:
                  Text("Invalid URL", style: TextStyle(color: Colors.white)),
            );
          });
    }
  }

  @override
  void dispose() {
    urlController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: const Color(0xFF1e1e1e),
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                offset: Offset(1, 1),
              ),
            ],
          ),
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Generated URL",
                    style: TextStyle(color: Colors.white),
                  ),
                  DropdownButton(
                    selectedItemBuilder: (BuildContext context) {
                      return <String>['Random', "Custom"]
                          .map(
                            (String value) => Text(
                              mode!,
                              style: const TextStyle(color: Colors.white),
                            ),
                          )
                          .toList();
                    },
                    value: mode,
                    items: <String>["Random", "Custom"]
                        .map<DropdownMenuItem<String>>(
                      (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      },
                    ).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        mode = value;
                      });
                    },
                  ),
                ],
              ),
              (mode == "Custom")
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "name",
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          cursorColor: Colors.white,
                          controller: nameController,
                          style: const TextStyle(color: Colors.white),
                          onChanged: (String string) {
                            setState(() {});
                          },
                        ),
                        Text(
                          "https://shoru.vercel.app/${nameController.text}",
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    )
                  : Container(),
              TextField(
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  labelText: "url",
                  labelStyle: TextStyle(color: Colors.white),
                ),
                cursorColor: Colors.white,
                controller: urlController,
                style: const TextStyle(color: Colors.white),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF1e1e1e), elevation: 5.0),
                onPressed: () {
                  checkUrl(urlController.text);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.cloud_upload),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "SHORTEN",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
