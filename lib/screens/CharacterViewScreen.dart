import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:witcher_guide/API/URLs.dart';
import 'package:witcher_guide/API/httpManager.dart';
import 'package:witcher_guide/components/PreviewImage.dart';
import 'package:witcher_guide/types/index.dart';

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
  late CharacterI data;
  late bool isLoading = true;

  void _handleFetchCharacter() async {
    if (widget.id != null) {
      RequestParams params = RequestParams();
      params.url = getUrl(characterViewUrl, {"id": widget.id});
      params.method = Method.GET;

      Response response = await request(params);

      if (response.status == 200) {
        setState(() {
          isLoading = false;
          data = CharacterI.fromJson(response.data);
        });
      }
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
      appBar: AppBar(title: const Text("Character page")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Text(data.name),
                if (data.images != null && data.images!.isNotEmpty)
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                        child: Text("Images " + data.images!.length.toString()),
                      ),
                      SizedBox(
                        height: 150,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: data.images!.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      EdgeInsets.only(left: index == 0 ? 0 : 8),
                                  child: PreviewImage(
                                    image: data.images![index],
                                  ),
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
                Row(
                  children: [
                    const Text("View count: "),
                    Text(data.viewCount.toString())
                  ],
                ),
              ],
            ),
    );
  }
}
