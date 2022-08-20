// import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:witcher_guide/API/URLs.dart';
import 'package:witcher_guide/API/httpManager.dart';
import 'package:witcher_guide/components/EntityTypeSelect.dart';
import 'package:witcher_guide/components/PreviewImage.dart';
import 'package:witcher_guide/enums/index.dart';
import 'package:witcher_guide/models/ImageModel.dart';

class CharacterParagraph {
  late TextEditingController? title = null;
  late TextEditingController content;

  CharacterParagraph({required this.content});

  void onAddTitle() {
    this.title = TextEditingController();
  }

  void onRemoveTitle() {
    this.title = null;
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
  final List<CharacterParagraph> _paragraphsList = [];
  late List<ImageModel> images = [];
  late int _paragraphsCount = 0;
  late EntityType _entityType = EntityType.CHARACTER;
  late String _nameFieldError = "";

  void _handleAddParagraph() {
    setState(() {
      _paragraphsList.add(CharacterParagraph(content: TextEditingController()));
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
          images.add(ImageModel.fromJson(jsonDecode(value)));
        });
      });
    }
  }

  void _handleAddTitle() {
    setState(() {});
  }

  void _handleSaveCharacter() async {
    if (_characterNameController.value.text.isEmpty) {
      setState(() {
        _nameFieldError = "Name is required";
      });
      return;
    }
    RequestParams params = RequestParams();
    params.url = getUrl(entityAddUrl);
    params.body = {
      "name": _characterNameController.value.text,
      "description": _paragraphsList
          .map((e) =>
              ({"title": e.title?.value.text, "content": e.content.value.text}))
          .toList(),
      "images": images.map((e) => e.toJson()).toList(),
      "type": _entityType.name
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
      body: Scrollbar(
        child: ListView(
          children: [
            if (images.isNotEmpty)
              Container(
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
              ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextButton(
                  onPressed: _handleStartUploadImages,
                  child: const Text("Upload image")),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: TextField(
                controller: _characterNameController,
                onChanged: (_) {
                  if (_nameFieldError.isNotEmpty) {
                    setState(() {
                      _nameFieldError = "";
                    });
                  }
                },
                decoration: InputDecoration(
                    hintText: "Name",
                    errorText:
                        _nameFieldError.isNotEmpty ? _nameFieldError : null),
              ),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Select entity type",
                      style: TextStyle(color: Colors.black38),
                    ),
                    EntityTypeSelect(
                      entityType: _entityType,
                      handleSelect: (EntityType value) {
                        setState(() {
                          _entityType = value;
                        });
                      },
                    )
                  ],
                )),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _paragraphsCount,
                itemBuilder: (context, index) {
                  bool titleIsExist = _paragraphsList[index].title != null;
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (titleIsExist)
                          SizedBox(
                            width: 200,
                            child: TextField(
                              controller: _paragraphsList[index].title,
                              decoration: const InputDecoration(
                                hintText: "Enter title...",
                              ),
                            ),
                          ),
                        Row(
                          children: [
                            SizedBox(
                              width: width - 70,
                              child: TextField(
                                controller: _paragraphsList[index].content,
                                decoration: InputDecoration(
                                  hintText: "Enter content...",
                                  suffixIcon: !titleIsExist
                                      ? IconButton(
                                          onPressed: () {
                                            _paragraphsList[index].onAddTitle();
                                            _handleAddTitle();
                                          },
                                          icon: const Icon(Icons.add))
                                      : IconButton(
                                          onPressed: () {
                                            _paragraphsList[index]
                                                .onRemoveTitle();
                                            _handleAddTitle();
                                          },
                                          icon: const Icon(Icons.remove)),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                // _paragraphsList.removeAt(index); // TODO
                                // setState(() {
                                //   _paragraphsList = _paragraphsList;
                                // });
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            TextButton(
                onPressed: _handleAddParagraph,
                child: const Text("Add paragraph")),
            SizedBox(
              height: 50,
              width: double.maxFinite,
              child: TextButton(
                  onPressed: _handleSaveCharacter,
                  child: const Text("Save character")),
            ),
          ],
        ),
      ),
    );
  }
}
