import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../models/place.dart';
import '../helpers/db_helper.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  void addPlace(
    String pickedTitle,
    File pickedImage,
  ) {
    final newPlace = Place(
      id: DateTime.now().toString(),
      title: pickedTitle,
      location: null,
      image: pickedImage,
    );
    _items.add(newPlace);
    notifyListeners();
    DBHelper.insert(
      'places',
      {
        'id': newPlace.id,
        'title': newPlace.title,
        'image': newPlace.image.path,
      },
    );
  }

  Future<void> fetchData() async {
    final dataList = await DBHelper.getData('places');
    _items = dataList
        .map(
          (e) => Place(
            id: e['id'],
            title: e['title'],
            location: null,
            image: File(e['image']),
          ),
        )
        .toList();
    notifyListeners();
  }
}
