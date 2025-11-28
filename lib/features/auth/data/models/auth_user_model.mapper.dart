// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'auth_user_model.dart';

class AuthUserModelMapper extends ClassMapperBase<AuthUserModel> {
  AuthUserModelMapper._();

  static AuthUserModelMapper? _instance;
  static AuthUserModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AuthUserModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AuthUserModel';

  static String _$id(AuthUserModel v) => v.id;
  static const Field<AuthUserModel, String> _f$id = Field('id', _$id);
  static String _$name(AuthUserModel v) => v.name;
  static const Field<AuthUserModel, String> _f$name = Field('name', _$name);
  static String _$email(AuthUserModel v) => v.email;
  static const Field<AuthUserModel, String> _f$email = Field('email', _$email);

  @override
  final MappableFields<AuthUserModel> fields = const {
    #id: _f$id,
    #name: _f$name,
    #email: _f$email,
  };

  static AuthUserModel _instantiate(DecodingData data) {
    return AuthUserModel(
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      email: data.dec(_f$email),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AuthUserModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AuthUserModel>(map);
  }

  static AuthUserModel fromJson(String json) {
    return ensureInitialized().decodeJson<AuthUserModel>(json);
  }
}

mixin AuthUserModelMappable {
  String toJson() {
    return AuthUserModelMapper.ensureInitialized().encodeJson<AuthUserModel>(
      this as AuthUserModel,
    );
  }

  Map<String, dynamic> toMap() {
    return AuthUserModelMapper.ensureInitialized().encodeMap<AuthUserModel>(
      this as AuthUserModel,
    );
  }

  AuthUserModelCopyWith<AuthUserModel, AuthUserModel, AuthUserModel>
  get copyWith => _AuthUserModelCopyWithImpl<AuthUserModel, AuthUserModel>(
    this as AuthUserModel,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return AuthUserModelMapper.ensureInitialized().stringifyValue(
      this as AuthUserModel,
    );
  }

  @override
  bool operator ==(Object other) {
    return AuthUserModelMapper.ensureInitialized().equalsValue(
      this as AuthUserModel,
      other,
    );
  }

  @override
  int get hashCode {
    return AuthUserModelMapper.ensureInitialized().hashValue(
      this as AuthUserModel,
    );
  }
}

extension AuthUserModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AuthUserModel, $Out> {
  AuthUserModelCopyWith<$R, AuthUserModel, $Out> get $asAuthUserModel =>
      $base.as((v, t, t2) => _AuthUserModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AuthUserModelCopyWith<$R, $In extends AuthUserModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? name, String? email});
  AuthUserModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AuthUserModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AuthUserModel, $Out>
    implements AuthUserModelCopyWith<$R, AuthUserModel, $Out> {
  _AuthUserModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AuthUserModel> $mapper =
      AuthUserModelMapper.ensureInitialized();
  @override
  $R call({String? id, String? name, String? email}) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (name != null) #name: name,
      if (email != null) #email: email,
    }),
  );
  @override
  AuthUserModel $make(CopyWithData data) => AuthUserModel(
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
    email: data.get(#email, or: $value.email),
  );

  @override
  AuthUserModelCopyWith<$R2, AuthUserModel, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AuthUserModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

