import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:photo_sync/global/methods.dart';
import 'package:photo_sync/repository/object_repository.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_sync/models/object.dart';

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
      body: Stack(
        children: [
          Center(
            child: widget.object.attributes.url.isEmpty && widget.image != null
                ? Hero(
                    tag: widget.object.attributes.creationDate,
                    child: PhotoView(
                      imageProvider: MemoryImage(widget.image!),
                    ),
                  )
                : Hero(
                    tag: widget.object.attributes.url,
                    child: PhotoView(
                      imageProvider: CachedNetworkImageProvider(
                        widget.object.attributes.url,
                        headers: ObjectRepository().getHeaders,
                      ),
                    ),
                  ),
          ),
          Align(
            alignment: AlignmentDirectional.topStart,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                FeatherIcons.chevronLeft,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
