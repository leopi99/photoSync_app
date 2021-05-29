import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_sync/bloc/objects_bloc.dart';
import 'package:photo_sync/global/methods.dart';
import 'package:photo_sync/models/object.dart';
import 'package:photo_sync/repository/object_repository.dart';
import 'package:photo_sync/screens/base_page/base_page.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late ObjectsBloc bloc;

  @override
  void initState() {
    bloc = ObjectsBloc()..getObjectListFromApi();
    GlobalMethods.setStatusBarColorAsScaffoldBackground();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      loadingStream: bloc.loadingStream,
      usePadding: true,
      child: StreamBuilder<List<Object>>(
        stream: bloc.objectsStream,
        initialData: [],
        builder: (context, snapshot) {
          return GridView.builder(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 8),
            itemCount: snapshot.data!.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) => FutureBuilder<bool>(
              initialData: false,
              future: snapshot.data![index].isDownloaded,
              builder: (context, futureSnapshot) {
                return Container(
                  child: futureSnapshot.data!
                      ? Image.file(
                          File(snapshot.data![index].attributes.localPath),
                          height: 128,
                          width: 128,
                        )
                      : CachedNetworkImage(
                          imageUrl: snapshot.data![index].attributes.url,
                          httpHeaders: ObjectRepository().getHeaders,
                          height: 128,
                          width: 128,
                        ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
