
//This class is used to build the game field.
//The game field will be build using a bunch of these Cells in a grid pattern
public class Cell {
  
  //the "coordinates" PVector store the Cell's location on the grid
  PVector coordinates;
  //The "occupation" String stores what the Cell contains.
  //It can be either "wall", "snake 1", "snake 2", "food", or "empty"
  String occupation;
  
  //These four values stores the Cells adjacent to the Cell.
  //If the cell is on the edge of the grid, some of these values will be null.
  Cell up;
  Cell down;
  Cell left;
  Cell right;
  
  //These three values are used by the AI to navigate the grid.
  //The AI looks over the entire grid once every move.
  //For every Cell, it calculates the shortest route between itself and that Cell.
  //The "visited" Bool determines if the shortest route to this Cell has already been found. It is reset every move.
  Boolean visited;
  //The "cost" value contains the distance between the AI and the cell. It is recalcualted every move.
  int cost;
  //The "direction" String determines what direction the AI must go on its next move, in order to make its way to this Cell.
  String direction;
  
  //A Cell is initialized with only the coordinates and occupation values.
  public Cell(PVector coords, String occ) {
    coordinates = coords;
    occupation = occ;
    
    //The neighbours are initialized as null. They are instead calculated once the whole grid has already been initialized.
    up = null;
    down = null;
    left = null;
    right = null;
    
    //These values are also not needed until after the whole grid of Cells has been initialized,
    //and thus they are initialized as null.
    visited = false;
    cost = 0;
    direction = "";
  }
  
}
