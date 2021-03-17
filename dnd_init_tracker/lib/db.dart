import 'package:flutter/material.dart';

class Char2 {
  String name;
  double init;

  Char(String name, double init) {
    this.name = name;
    this.init = init;
  }
}

class Char {
  String name;
  double init;
  bool blinded = false;
  bool charmed = false;
  bool deafend = false;
  bool frightend = false;
  bool grappled = false;
  bool incapacitated = false;
  bool invisible = false;
  bool paralyzed = false;
  bool petrified = false;
  bool poisoned = false;
  bool prone = false;
  bool restrained = false;
  bool stunned = false;
  bool unconscious = false;
  int exhaustion = 0;
  int maxHp;
  int hp;

  Char(String name, double init, int maxHp) {
    this.name = name;
    this.init = init;
    this.maxHp = maxHp;
    this.hp = maxHp;
  }

  void takeDmg(int dmg) {
    if (dmg >= this.hp) {
      this.hp = 0;
      this.incapacitated = true;
    } else {
      this.hp = this.hp - dmg;
    }
  }

  void getHealed(int heal) {
    if (this.maxHp - this.hp <= heal) {
      this.hp = this.maxHp;
    } else {
      this.hp = this.hp + heal;
    }
    if (incapacitated) {
      incapacitated = false;
    }
  }
}
