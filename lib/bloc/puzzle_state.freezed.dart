// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'puzzle_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$PuzzleStateTearOff {
  const _$PuzzleStateTearOff();

  _PuzzleState call(Puzzle puzzle, {ui.Image? image}) {
    return _PuzzleState(
      puzzle,
      image: image,
    );
  }
}

/// @nodoc
const $PuzzleState = _$PuzzleStateTearOff();

/// @nodoc
mixin _$PuzzleState {
  Puzzle get puzzle => throw _privateConstructorUsedError;
  ui.Image? get image => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PuzzleStateCopyWith<PuzzleState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PuzzleStateCopyWith<$Res> {
  factory $PuzzleStateCopyWith(
          PuzzleState value, $Res Function(PuzzleState) then) =
      _$PuzzleStateCopyWithImpl<$Res>;
  $Res call({Puzzle puzzle, ui.Image? image});
}

/// @nodoc
class _$PuzzleStateCopyWithImpl<$Res> implements $PuzzleStateCopyWith<$Res> {
  _$PuzzleStateCopyWithImpl(this._value, this._then);

  final PuzzleState _value;
  // ignore: unused_field
  final $Res Function(PuzzleState) _then;

  @override
  $Res call({
    Object? puzzle = freezed,
    Object? image = freezed,
  }) {
    return _then(_value.copyWith(
      puzzle: puzzle == freezed
          ? _value.puzzle
          : puzzle // ignore: cast_nullable_to_non_nullable
              as Puzzle,
      image: image == freezed
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as ui.Image?,
    ));
  }
}

/// @nodoc
abstract class _$PuzzleStateCopyWith<$Res>
    implements $PuzzleStateCopyWith<$Res> {
  factory _$PuzzleStateCopyWith(
          _PuzzleState value, $Res Function(_PuzzleState) then) =
      __$PuzzleStateCopyWithImpl<$Res>;
  @override
  $Res call({Puzzle puzzle, ui.Image? image});
}

/// @nodoc
class __$PuzzleStateCopyWithImpl<$Res> extends _$PuzzleStateCopyWithImpl<$Res>
    implements _$PuzzleStateCopyWith<$Res> {
  __$PuzzleStateCopyWithImpl(
      _PuzzleState _value, $Res Function(_PuzzleState) _then)
      : super(_value, (v) => _then(v as _PuzzleState));

  @override
  _PuzzleState get _value => super._value as _PuzzleState;

  @override
  $Res call({
    Object? puzzle = freezed,
    Object? image = freezed,
  }) {
    return _then(_PuzzleState(
      puzzle == freezed
          ? _value.puzzle
          : puzzle // ignore: cast_nullable_to_non_nullable
              as Puzzle,
      image: image == freezed
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as ui.Image?,
    ));
  }
}

/// @nodoc

class _$_PuzzleState implements _PuzzleState {
  _$_PuzzleState(this.puzzle, {this.image});

  @override
  final Puzzle puzzle;
  @override
  final ui.Image? image;

  @override
  String toString() {
    return 'PuzzleState(puzzle: $puzzle, image: $image)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PuzzleState &&
            const DeepCollectionEquality().equals(other.puzzle, puzzle) &&
            const DeepCollectionEquality().equals(other.image, image));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(puzzle),
      const DeepCollectionEquality().hash(image));

  @JsonKey(ignore: true)
  @override
  _$PuzzleStateCopyWith<_PuzzleState> get copyWith =>
      __$PuzzleStateCopyWithImpl<_PuzzleState>(this, _$identity);
}

abstract class _PuzzleState implements PuzzleState {
  factory _PuzzleState(Puzzle puzzle, {ui.Image? image}) = _$_PuzzleState;

  @override
  Puzzle get puzzle;
  @override
  ui.Image? get image;
  @override
  @JsonKey(ignore: true)
  _$PuzzleStateCopyWith<_PuzzleState> get copyWith =>
      throw _privateConstructorUsedError;
}
