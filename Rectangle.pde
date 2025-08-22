/**
 * Abstract Class: Rectangle  
 * Represents a rectangular game object with position, size, speed, and image.
 * pre: Requires valid initial position (x, y), dimensions (w, h), speed, and image.  
 * post: Creates a Rectangle object or subclass instance with basic properties.
 */
abstract class Rectangle{
  float x, y, w, h, speed;
  PImage img;
  /**
   * Constructor: Rectangle  
   * Initializes the rectangle with position, size, speed, and image.
   * pre: x, y, w, h, speed are valid float values; img is a loaded PImage.  
   * post: Rectangle object initialized with given attributes.
   */
  Rectangle(float x, float y, float w, float h, float speed, PImage img){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.speed = speed;
    this.img = img;
  }
  
  /**
   * Method: display  
   * Draws the rectangle’s image at its current position and size.
   * pre: img is loaded and ready for display.  
   * post: Image is drawn on the screen at (x, y) with dimensions (w, h).
   */
  void display(){
    image(img, x, y, w, h);
  }
  
  /**
   * Abstract Method: move  
   * Defines how the rectangle moves each frame.  
   * pre: Implemented by subclasses.  
   * post: Updates position according to subclass-specific behavior.
   */
  abstract void move();
  
  /**
   * Method: collidesWith  
   * Checks whether this rectangle overlaps with another rectangle.
   * pre: other is a non-null Rectangle object.  
   * post: Returns true if rectangles intersect, false otherwise.
   */
  boolean collidesWith(Rectangle other){
  return !(x+w<other.x || 
           x > other.x + other.w || 
           y + h < other.y || 
           y > other.y + other.h);
         }
}
