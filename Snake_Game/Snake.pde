
//The class for a snake.
public class Snake {
  
  //The "Body" ArrayList contains all the Cells that the Snake is present on.
  //I can't use a normal Array here, because it is vital that the body can grow dynamicaly.
  ArrayList<Cell> Body = new ArrayList<Cell>();
  //The "direction" String contains the direction that the Snake is going. It can be either "up", "down", "left", or "right".
  String direction;
  //The "alive" Bool stores whether or not the snake has died.
  Boolean alive;
  //The "name" String is the name of the snake. It will be either "snake 1" or "snake 2".
  //Each Snake needs a unique name, so it can be drawn with a unique color.
  String name;
  
  //The snake is initialized with a "head" Cell, a set of "tail" Cells, and a Name String.
  public Snake(Cell head, Cell[] tail, String Name) {
    //I add the head to the Body.
    Body.add(head);
    //I set the head Cell to be occupied by this snake.
    head.occupation = Name;
    //I add the tail Cells to the Body, and set the occupation of these Cells to be this Snake.
    //I know that the input tail is always 4 Cells long.
    for (int i=0; i<4; i++) {
      Body.add(tail[i]);
      tail[i].occupation = Name;
    }
    
    //The Snakes direction is always initialized as "up".
    direction = "up";
    //The Snake starts out being alive.
    alive = true;
    //name is initialized.
    name = Name;
  }
  
  
}
