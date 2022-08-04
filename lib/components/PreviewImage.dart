import 'package:flutter/material.dart';
import 'package:witcher_guide/API/URLs.dart';
import 'package:witcher_guide/models/ImageModel.dart';

class PreviewImage extends StatelessWidget {
  const PreviewImage(
      {Key? key,
      required this.image,
      this.handleRemove,
      this.isSmall = false,
      this.isFixedHeight = false,
      this.height,
      this.isRounded = true})
      : super(key: key);

  final ImageModel image;
  final bool isSmall;
  final bool isRounded;
  final bool isFixedHeight;
  final double? height;
  final void Function(String)? handleRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ClipRRect(
        borderRadius:
            isRounded ? BorderRadius.circular(10.0) : BorderRadius.circular(0),
        child: SizedBox(
          width: isSmall ? 100 : 200,
          height: isSmall ? 100 : 200,
          child: FadeInImage.assetNetwork(
            placeholder: 'assets/loading.png',
            fit: BoxFit.cover,
            image: imagesBaseUrl + image.fullFileName(),
          ),
        ),
      ),
      if (handleRemove != null)
        Positioned(
            right: 0,
            top: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10)),
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  onPressed: () => handleRemove!(image.id),
                ),
              ),
            )),
    ]);
  }
}
