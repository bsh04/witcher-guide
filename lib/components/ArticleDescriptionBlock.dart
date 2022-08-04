import 'package:flutter/material.dart';
import 'package:witcher_guide/models/DescriptionModel.dart';

class ArticleDescriptionBlock extends StatelessWidget {

  final DescriptionModel item;

  const ArticleDescriptionBlock({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (item.title != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(item.title!, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, fontStyle: FontStyle.italic),),
              ),
              Container(width: 200, color: Colors.black, height: 1,),
            ],
          ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(item.content),
        )
      ],
    );
  }
}
