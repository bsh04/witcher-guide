// import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:witcher_guide/API/URLs.dart';
import 'package:witcher_guide/API/httpManager.dart';
import 'package:witcher_guide/components/PreviewImage.dart';
import 'package:witcher_guide/types/index.dart';

class CharacterParagraph {
  late TextEditingController? title = null;
  late TextEditingController content;

  CharacterParagraph({required this.content});

  void onAddTitle() {
    this.title = TextEditingController();
  }

  void onAddContent() {
    content = TextEditingController();
  }
}

class CharacterEditScreen extends StatefulWidget {
  const CharacterEditScreen({Key? key}) : super(key: key);

  @override
  State<CharacterEditScreen> createState() => _CharacterEditScreenState();
}

class _CharacterEditScreenState extends State<CharacterEditScreen> {
  final TextEditingController _characterNameController =
      TextEditingController();
  final List<CharacterParagraph> _paragraphControllers = [];
  final PageController _pageController = PageController();
  late List<ImageI> images = [];
  late int _paragraphsCount = 0;

  void _handleAddParagraph() {
    setState(() {
      _paragraphControllers
          .add(CharacterParagraph(content: TextEditingController()));
      _paragraphsCount += 1;
    });
  }

  void _handleStartUploadImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
    } else {}

    if (result != null) {
      var request = http.MultipartRequest('POST', getUrl(uploadFileUrl));
      request.files.add(http.MultipartFile(
          'picture',
          File(result.files.first.path!).readAsBytes().asStream(),
          File(result.files.first.path!).lengthSync(),
          filename: result.files.first.path!.split("/").last));
      var res = await request.send();
      res.stream.transform(utf8.decoder).listen((value) {
        setState(() {
          images.add(ImageI.fromJson(jsonDecode(value)));
        });
      });
    }
  }

  void _handleAddTitle() {
    setState(() {});
  }

  void _handleSaveCharacter() async {
    RequestParams params = RequestParams();
    params.url = getUrl(characterAddUrl);
    params.body = {
      "name": _characterNameController.value.text,
      "description": _paragraphControllers
          .map((e) =>
              ({"title": e.title?.value.text, "content": e.content.value.text}))
          .toList(),
      "images": images.map((e) => e.toJson()).toList()
    };
    Response response = await request(params);
    if (response.status == 200) {
      Navigator.pushNamed(context, '/');
    }
  }

  void _handleRemoveImage(String id) {
    setState(() {
      images = images.where((element) => element.id != id).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: const Text("Add character")),
      body: SizedBox(
        height: double.maxFinite,
        child: PageView(controller: _pageController, children: [
          Column(
            children: [
              images.isNotEmpty
                  ? Container(
                      margin: const EdgeInsets.only(top: 20),
                      height: 150,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: images.length,
                          itemBuilder: (context, index) {
                            return Padding(
                                padding: EdgeInsets.fromLTRB(
                                    index == 0 ? 10 : 0, 0, 10, 0),
                                child: PreviewImage(
                                  handleRemove: _handleRemoveImage,
                                  image: images[index],
                                ));
                          }),
                    )
                  : const Text(""),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextButton(
                    onPressed: _handleStartUploadImages,
                    child: const Text("Upload image")),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: TextField(
                  controller: _characterNameController,
                  decoration: const InputDecoration(
                    hintText: "Character name",
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _paragraphsCount,
                itemBuilder: (context, index) {
                  bool titleIsExist =
                      _paragraphControllers[index].title != null;
                  return Column(
                    children: [
                      titleIsExist
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: TextField(
                                controller: _paragraphControllers[index].title,
                                decoration: const InputDecoration(
                                  hintText: "Enter title...",
                                ),
                              ),
                            )
                          : const Center(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: TextField(
                          controller: _paragraphControllers[index].content,
                          decoration: InputDecoration(
                            hintText: "Enter content...",
                            suffixIcon: !titleIsExist
                                ? IconButton(
                                    onPressed: () {
                                      _paragraphControllers[index].onAddTitle();
                                      _handleAddTitle();
                                    },
                                    icon: const Icon(Icons.add))
                                : null,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              TextButton(
                  onPressed: _handleAddParagraph,
                  child: const Text("Add paragraph")),
              const Spacer(),
              TextButton(
                  onPressed: _handleSaveCharacter,
                  child: const Text("Save character")),
            ],
          ),
        ]),
      ),
    );
  }
}
