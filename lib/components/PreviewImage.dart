import 'package:flutter/material.dart';
import 'package:witcher_guide/API/URLs.dart';
import 'package:witcher_guide/types/index.dart';

class PreviewImage extends StatelessWidget {
  const PreviewImage(
      {Key? key,
      required this.image,
      this.handleRemove,
      this.isSmall = false,
      this.isFixedHeight = false,
      this.isRounded = true})
      : super(key: key);

  final ImageI image;
  final bool isSmall;
  final bool isRounded;
  final bool isFixedHeight;
  final void Function(String)? handleRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ClipRRect(
        borderRadius:
            isRounded ? BorderRadius.circular(10.0) : BorderRadius.circular(0),
        child: SizedBox(
          width: isSmall ? 100 : 220,
          height: isFixedHeight ? 70 : null,
          child: Image(
            fit: isFixedHeight ? BoxFit.fill : BoxFit.contain,
            image: NetworkImage(imagesBaseUrl + image.fullFileName()),
          ),
        ),
      ),
      handleRemove != null
          ? Positioned(
              right: 0,
              top: 0,
              child: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => handleRemove!(image.id),
              ))
          : const Center(),
    ]);
  }
}
