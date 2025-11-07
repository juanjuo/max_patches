class Number {
  float x;
  float y;
  int val;
  int val_temp;
  int shuffle_rate;
  int shuffle_time;
  Boolean shuffle;
  Boolean active;

  Number(float x_, float y_, int val_, Boolean active_) {
    x = x_;
    y = y_;
    val = val_;
    active = active_;
    shuffle = false;
    shuffle_rate = (int) random(10, 50);
  }

  void display() {
    if (active) {
      if (shuffle) {
        //println(millis() % shuffle_rate);
        if (millis() > shuffle_time) {
          shuffle_time = millis() + shuffle_rate;
          shuffle_rate = shuffle_rate + 15;
          val_temp = (int) random(1, 5);
        }
        text(str(val_temp), x, y);
      } else {
        text(str(val), x, y);
      }
    }
  }

  void turnOff() {
    active = false;
  }

  void turnOn() {
    active = true;
  }
}
