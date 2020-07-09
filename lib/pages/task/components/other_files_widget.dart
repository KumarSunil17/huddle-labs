import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:huddlelabs/utils/enums.dart';

///
///Created By Sunil Kumar at 26/05/2020
///
class ChoosedFileWidget extends StatelessWidget {
  final FileType type;
  final Uint8List image;
  final String name;
  const ChoosedFileWidget(this.type, {this.image, this.name});

  @override
  Widget build(BuildContext context) {
    if (type == FileType.jpgImage || type == FileType.pngImage)
      return Material(
        elevation: 8,
        shadowColor: Colors.black,
        color: Colors.white,
        child: Image.memory(this.image),
      );
    else {
      return Material(
        elevation: 8,
        shadowColor: Colors.black,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: type.assetName.isNotEmpty
                    ? Image.asset(type.assetName)
                    : Container(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('$name'),
            ),
          ],
        ),
      );
    }
  }
}
