import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:huddlelabs/utils/enums.dart';
import 'package:intl/intl.dart';

///
///Created By Sunil Kumar at 26/05/2020
///
class ChatMessageWidget extends StatelessWidget {
  final String message, imageUrl, dateTime;
  final FileType fileType;
  final bool isSender;
  const ChatMessageWidget.sender(
      {required this.dateTime,
      required this.fileType,
      required this.imageUrl,
      required this.message})
      : isSender = true;
  const ChatMessageWidget.receiver(
      {required this.dateTime,
      required this.fileType,
      required this.imageUrl,
      required this.message})
      : isSender = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              width: 210,
              decoration: BoxDecoration(
                  color: isSender ? Color(0xff4facfe) : Colors.black12,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft:
                        isSender ? Radius.circular(12) : Radius.circular(0),
                    bottomRight:
                        isSender ? Radius.circular(0) : Radius.circular(12),
                  )),
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (fileType != FileType.noMedia) ...[
                    if (fileType.toInt == FileType.jpgImage.toInt)
                      GestureDetector(
                        onTap: () {
                          html.window.open(imageUrl, imageUrl);
                        },
                        child: Container(
                          height: 170,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: NetworkImage(imageUrl),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                    if (fileType == FileType.pdf)
                      _OtherImageWidget('assets/pdf.png', imageUrl),
                    if (fileType == FileType.doc)
                      _OtherImageWidget('assets/docx.png', imageUrl),
                    if (fileType == FileType.video)
                      _OtherImageWidget('assets/mp4.png', imageUrl),
                    if (fileType == FileType.sheet)
                      _OtherImageWidget('assets/xlsx.png', imageUrl),
                    if (fileType == FileType.audio)
                      _OtherImageWidget('assets/mp3.png', imageUrl),
                    if (fileType == FileType.ppt)
                      _OtherImageWidget('assets/pptx.png', imageUrl),
                    SizedBox(height: 4),
                  ],
                  if (message != null && message.isNotEmpty)
                    Text(
                      '$message',
                      style: TextStyle(
                          color: isSender ? Colors.white : Colors.black),
                    ),
                ],
              ),
            ),
            SizedBox(height: 2),
            Text(
                DateFormat('dd/MM/yyyy hh:mm a')
                    .format(DateTime.parse(dateTime)),
                style: Theme.of(context).textTheme.caption)
          ],
        ),
      ],
    );
  }
}

class _OtherImageWidget extends StatelessWidget {
  final String assetPath, url;
  const _OtherImageWidget(this.assetPath, this.url);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(url);
        html.window.open(url, url);
      },
      child: Container(
          height: 170,
          width: 210,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: Image.asset(assetPath))),
    );
  }
}
