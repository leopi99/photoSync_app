import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_sync/global/methods.dart';
import 'package:photo_sync/repository/object_repository.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_sync/models/object.dart';

///Shows a single image in fullscreen

class SingleImagePage extends StatefulWidget {
  final Object object;
  final Uint8List? image;

  const SingleImagePage({
    required this.object,
    this.image,
  });

  @override
  _SingleImagePageState createState() => _SingleImagePageState();
}

class _SingleImagePageState extends State<SingleImagePage> {
  @override
  initState() {
    GlobalMethods.setStatusBarColor(Colors.black, true);
    super.initState();
  }

  @override
  void dispose() {
    GlobalMethods.setStatusBarColorAsScaffoldBackground();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          tag: widget.object.attributes.creationDate,
          child: widget.image != null
              ? PhotoView(
                  imageProvider: MemoryImage(widget.image!),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.contained * 4,
                )
              : PhotoView(
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.contained * 4,
                  imageProvider: CachedNetworkImageProvider(
                    widget.object.attributes.url!,
                    headers: ObjectRepository().getHeaders,
                  ),
                ),
        ),
      ),
    );
  }
}
