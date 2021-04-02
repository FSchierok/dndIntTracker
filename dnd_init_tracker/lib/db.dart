class Char {
  String name;
  int init;
  bool incapacitated = false;
  int maxHp;
  int hp;

  Char(String name, int init, int maxHp) {
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
