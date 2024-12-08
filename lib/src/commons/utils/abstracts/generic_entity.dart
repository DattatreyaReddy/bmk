import 'json_abstract.dart';

abstract class GenericEntity<T> extends JsonAbstract {
  T get id;
}
