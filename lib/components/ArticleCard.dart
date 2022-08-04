import 'package:flutter/material.dart';
import 'package:witcher_guide/API/URLs.dart';
import 'package:witcher_guide/components/PreviewImage.dart';
import 'package:witcher_guide/models/PreviewEntityModel.dart';
import 'package:witcher_guide/screens/CharacterViewScreen.dart';

class ArticleCard extends StatelessWidget {
  const ArticleCard({Key? key, required this.item}) : super(key: key);

  final PreviewEntityModel item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CharacterViewScreen(
                  id: item.id,
                )));
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.black12)),
        child: Column(
          children: [
            if (item.images.isNotEmpty)
              PreviewImage(
                image: item.images.first,
                isSmall: true,
                isFixedHeight: true,
              )
            else
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: const SizedBox(
                  width: 100,
                  height: 100,
                  child: Image(
                    fit: BoxFit.cover,
                    image: NetworkImage(defaultImagesUrl),
                  ),
                ),
              ),
            SizedBox(child: Text(item.name)),
          ],
        ),
      ),
    );
  }
}
