/**
 * Class: Bullet
 * A projectile shot by the player or the boss in the CodeBreaker game.
 * pre: Requires x and y coordinates, image of the bullet, and optionally a flag indicating if it’s from the boss.
 * post: Creates a Bullet object with position, size, speed, image, and boss ownership status.
 */
class Bullet extends Rectangle {
  boolean isBossBullet;

  /**
   * Constructor: Bullet
   * Initializes a player bullet at the given position with a given image.
   * pre: x, y are float coordinates; img is a loaded PImage.
   * post: Bullet is initialized as a non-boss bullet.
   */
  Bullet(float x, float y, PImage img) {
    super(x, y, 20, 40, 3, img);
    this.isBossBullet = false;
  }

  /**
   * Constructor: Bullet
   * Initializes a bullet at the given position with a given image and source identifier.
   * pre: x, y are float coordinates; img is a loaded PImage; isBossBullet is a boolean.
   * post: Bullet is initialized with source ownership (boss/player).
   */
  Bullet(float x, float y, PImage img, boolean isBossBullet) {
    super(x, y, 20, 40, 3, img);
    this.isBossBullet = isBossBullet;
  }

  /**
   * Method: move
   * Moves the bullet vertically based on its type and speed.
   * pre: Bullet must be initialized; backgroundSpeed must be defined globally.
   * post: Bullet's y-position is updated.
   */
  void move() {
    if (isBossBullet) y += (speed+backgroundSpeed);
    else y += speed;
  }

  /**
   * Method: isOffScreen
   * Checks whether the bullet has exited the screen bounds.
   * pre: Bullet must have valid y and height values.
   * post: Returns true if the bullet is outside the visible screen area.
   */
  boolean isOffScreen() {
    return (y+h<0 || y > height);
  }
}
