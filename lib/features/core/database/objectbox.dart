import 'package:path_provider/path_provider.dart';

// ! Use Only for generating the ObjectBox model. Do not use in your app.
// ignore: unnecessary_import
import 'package:objectbox/objectbox.dart';

import '../../../objectbox.g.dart';

class ObjectBox {
  static Store? _store;
  late final Store store;

  ObjectBox._create(this.store);

  static Future<ObjectBox> create() async {
    final dir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: '${dir.path}/objectbox');

    return ObjectBox._create(store);
  }

  // Close the store when the app is disposed
  static Future<void> close() async {
    _store?.close();
    _store = null;
  }
}

// ! Used only to generate the ObjectBox model. Do not use in your app.
@Entity()
class Person {
  @Id()
  int id = 0;

  Person();
}
