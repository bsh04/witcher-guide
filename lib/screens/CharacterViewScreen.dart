import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:witcher_guide/API/URLs.dart';
import 'package:witcher_guide/API/httpManager.dart';
import 'package:witcher_guide/components/ArticleDescriptionBlock.dart';
import 'package:witcher_guide/components/PreviewImage.dart';
import 'package:witcher_guide/models/CharacterModel.dart';

class CharacterViewScreenArgs {
  final String id;

  CharacterViewScreenArgs(this.id);
}

class CharacterViewScreen extends StatefulWidget {
  final String? id;

  const CharacterViewScreen({Key? key, this.id}) : super(key: key);

  @override
  State<CharacterViewScreen> createState() => _CharacterViewScreenState();
}

class _CharacterViewScreenState extends State<CharacterViewScreen> {
  late CharacterModel data;
  late bool isLoading = true;

  void _handleFetchCharacter() async {
    if (widget.id != null) {
      RequestParams params = RequestParams();
      params.url = getUrl(entityViewUrl, {"id": widget.id});
      params.method = Method.GET;

      Response response = await request(params);

      if (response.status == 200) {
        setState(() {
          data = CharacterModel.fromJson(response.data);
        });
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _handleFetchCharacter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Character page"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SizedBox(
              height: double.maxFinite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        data.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  if (data.images.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Text(
                                  "Images",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                              Text(
                                data.images.length.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 150,
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: data.images.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      index == 0 ? 10 : 0, 0, 10, 0),
                                  child: PreviewImage(
                                    image: data.images[index],
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  if (data.description.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.description.length,
                          itemBuilder: (context, index) {
                            return ArticleDescriptionBlock(
                              item: data.description[index],
                            );
                          }),
                    ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 20, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(Icons.remove_red_eye),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            data.viewCount.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
