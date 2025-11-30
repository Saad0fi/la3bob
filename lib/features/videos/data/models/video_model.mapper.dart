// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'video_model.dart';

class VideoModelMapper extends ClassMapperBase<VideoModel> {
  VideoModelMapper._();

  static VideoModelMapper? _instance;
  static VideoModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = VideoModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'VideoModel';

  static String _$id(VideoModel v) => v.id;
  static const Field<VideoModel, String> _f$id = Field('id', _$id);
  static String _$title(VideoModel v) => v.title;
  static const Field<VideoModel, String> _f$title = Field('title', _$title);
  static String _$link(VideoModel v) => v.link;
  static const Field<VideoModel, String> _f$link = Field('link', _$link);

  @override
  final MappableFields<VideoModel> fields = const {
    #id: _f$id,
    #title: _f$title,
    #link: _f$link,
  };

  static VideoModel _instantiate(DecodingData data) {
    return VideoModel(
      id: data.dec(_f$id),
      title: data.dec(_f$title),
      link: data.dec(_f$link),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static VideoModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<VideoModel>(map);
  }

  static VideoModel fromJson(String json) {
    return ensureInitialized().decodeJson<VideoModel>(json);
  }
}

mixin VideoModelMappable {
  String toJson() {
    return VideoModelMapper.ensureInitialized().encodeJson<VideoModel>(
      this as VideoModel,
    );
  }

  Map<String, dynamic> toMap() {
    return VideoModelMapper.ensureInitialized().encodeMap<VideoModel>(
      this as VideoModel,
    );
  }

  VideoModelCopyWith<VideoModel, VideoModel, VideoModel> get copyWith =>
      _VideoModelCopyWithImpl<VideoModel, VideoModel>(
        this as VideoModel,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return VideoModelMapper.ensureInitialized().stringifyValue(
      this as VideoModel,
    );
  }

  @override
  bool operator ==(Object other) {
    return VideoModelMapper.ensureInitialized().equalsValue(
      this as VideoModel,
      other,
    );
  }

  @override
  int get hashCode {
    return VideoModelMapper.ensureInitialized().hashValue(this as VideoModel);
  }
}

extension VideoModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, VideoModel, $Out> {
  VideoModelCopyWith<$R, VideoModel, $Out> get $asVideoModel =>
      $base.as((v, t, t2) => _VideoModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class VideoModelCopyWith<$R, $In extends VideoModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? title, String? link});
  VideoModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _VideoModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, VideoModel, $Out>
    implements VideoModelCopyWith<$R, VideoModel, $Out> {
  _VideoModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<VideoModel> $mapper =
      VideoModelMapper.ensureInitialized();
  @override
  $R call({String? id, String? title, String? link}) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (title != null) #title: title,
      if (link != null) #link: link,
    }),
  );
  @override
  VideoModel $make(CopyWithData data) => VideoModel(
    id: data.get(#id, or: $value.id),
    title: data.get(#title, or: $value.title),
    link: data.get(#link, or: $value.link),
  );

  @override
  VideoModelCopyWith<$R2, VideoModel, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _VideoModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

