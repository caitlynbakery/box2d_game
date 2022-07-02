import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(GameWidget(
    game: MyGame(),
  ));
}

class MyGame extends Forge2DGame {
  MyGame() : super(gravity: Vector2(0, 12.0));
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    Vector2 gameSize = screenToWorld(camera.viewport.effectiveSize);
    print(gameSize);
    add(Ground(gameSize));
    add(Player(
        position: Vector2(20, 10), sprite: await loadSprite('greendino.webp')));
    add(Player(
        position: Vector2(27, 5), sprite: await loadSprite('pinkdino.webp')));
    add(Player(
        position: Vector2(32, 2),
        sprite: await loadSprite('dinosaur-cute.png')));
    add(Player(
        position: Vector2(17, 2), sprite: await loadSprite('triceratops.png')));
  }
}

class Player extends BodyComponent {
  final Vector2 position;
  final Sprite sprite;

  Player({required this.position, required this.sprite});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    renderBody = false;
    add(SpriteComponent(
        sprite: sprite, size: Vector2.all(12), anchor: Anchor.center));
  }

  @override
  Body createBody() {
    final shape = CircleShape()..radius = 6;
    final fixtureDef =
        FixtureDef(shape, density: 1.0, restitution: .4, friction: 0.5);
    final bodyDef = BodyDef(position: position, type: BodyType.dynamic);
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class Ground extends BodyComponent {
  final Vector2 gameSize;

  Ground(this.gameSize);

  @override
  Body createBody() {
    final shape = EdgeShape()
      ..set(Vector2(0, gameSize.y - 3), Vector2(gameSize.x, gameSize.y - 3));
    final fixtureDef = FixtureDef(shape, friction: 0.3);
    final bodyDef = BodyDef(userData: this, position: Vector2.zero());
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
