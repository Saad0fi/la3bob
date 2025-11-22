// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'child_model.dart';

class ChildModelMapper extends ClassMapperBase<ChildModel> {
  ChildModelMapper._();

  static ChildModelMapper? _instance;
  static ChildModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChildModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ChildModel';

  static String _$id(ChildModel v) => v.id;
  static const Field<ChildModel, String> _f$id = Field('id', _$id);
  static String _$name(ChildModel v) => v.name;
  static const Field<ChildModel, String> _f$name = Field('name', _$name);
  static int _$age(ChildModel v) => v.age;
  static const Field<ChildModel, int> _f$age = Field('age', _$age);
  static String _$parentId(ChildModel v) => v.parentId;
  static const Field<ChildModel, String> _f$parentId = Field(
    'parentId',
    _$parentId,
    key: r'parent_id',
  );
  static List<String> _$interests(ChildModel v) => v.interests;
  static const Field<ChildModel, List<String>> _f$interests = Field(
    'interests',
    _$interests,
  );

  @override
  final MappableFields<ChildModel> fields = const {
    #id: _f$id,
    #name: _f$name,
    #age: _f$age,
    #parentId: _f$parentId,
    #interests: _f$interests,
  };

  static ChildModel _instantiate(DecodingData data) {
    return ChildModel(
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      age: data.dec(_f$age),
      parentId: data.dec(_f$parentId),
      interests: data.dec(_f$interests),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ChildModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ChildModel>(map);
  }

  static ChildModel fromJson(String json) {
    return ensureInitialized().decodeJson<ChildModel>(json);
  }
}

mixin ChildModelMappable {
  String toJson() {
    return ChildModelMapper.ensureInitialized().encodeJson<ChildModel>(
      this as ChildModel,
    );
  }

  Map<String, dynamic> toMap() {
    return ChildModelMapper.ensureInitialized().encodeMap<ChildModel>(
      this as ChildModel,
    );
  }

  ChildModelCopyWith<ChildModel, ChildModel, ChildModel> get copyWith =>
      _ChildModelCopyWithImpl<ChildModel, ChildModel>(
        this as ChildModel,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ChildModelMapper.ensureInitialized().stringifyValue(
      this as ChildModel,
    );
  }

  @override
  bool operator ==(Object other) {
    return ChildModelMapper.ensureInitialized().equalsValue(
      this as ChildModel,
      other,
    );
  }

  @override
  int get hashCode {
    return ChildModelMapper.ensureInitialized().hashValue(this as ChildModel);
  }
}

extension ChildModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ChildModel, $Out> {
  ChildModelCopyWith<$R, ChildModel, $Out> get $asChildModel =>
      $base.as((v, t, t2) => _ChildModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ChildModelCopyWith<$R, $In extends ChildModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get interests;
  $R call({
    String? id,
    String? name,
    int? age,
    String? parentId,
    List<String>? interests,
  });
  ChildModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ChildModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ChildModel, $Out>
    implements ChildModelCopyWith<$R, ChildModel, $Out> {
  _ChildModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ChildModel> $mapper =
      ChildModelMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get interests =>
      ListCopyWith(
        $value.interests,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(interests: v),
      );
  @override
  $R call({
    String? id,
    String? name,
    int? age,
    String? parentId,
    List<String>? interests,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (name != null) #name: name,
      if (age != null) #age: age,
      if (parentId != null) #parentId: parentId,
      if (interests != null) #interests: interests,
    }),
  );
  @override
  ChildModel $make(CopyWithData data) => ChildModel(
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
    age: data.get(#age, or: $value.age),
    parentId: data.get(#parentId, or: $value.parentId),
    interests: data.get(#interests, or: $value.interests),
  );

  @override
  ChildModelCopyWith<$R2, ChildModel, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ChildModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

