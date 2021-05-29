import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_sync/bloc/objects_bloc.dart';
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
    bloc = ObjectsBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      loadingStream: bloc.loadingStream,
      child: StreamBuilder<List<Object>>(
        stream: bloc.objectsStream,
        initialData: [],
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) => Container(
              child: CachedNetworkImage(
                imageUrl: snapshot.data![index].attributes.url,
                httpHeaders: ObjectRepository().getHeaders,
              ),
            ),
          );
        },
      ),
    );
  }
}
