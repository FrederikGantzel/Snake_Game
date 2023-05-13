
//The World class contains everything we need to draw the game field.
public class World {
  
  //These two values are the width and height of the grid, which is 52x52 in this build.
  int world_width = width/cell_size;
  int world_height = height/cell_size;
  //This Array of Cells is the game field. It is a 52x52 grid.
  Cell[][] Field = new Cell[world_width][world_height];
  //This ArrayList contains the Snakes.
  //There will be either 1 or 2 snakes, and thus i found it simplest to use an ArrayList so it could be dynamically resized.
  ArrayList<Snake> Snakes = new ArrayList<Snake>();
  //This "AI" String is used to determine what the difficulty of the AI is. The string will say "None" if the AI is turned off.
  String AI;
  
  //The world is initialized with the requested number of Snakes, and difficulty of the AI (or "None" if the AI is turned off).
  public World(int n_snakes, String ArtInt) {
    
    //This for-loop is used to initialize the game field.
    //All Cells are initialized as "empty", except all the Cells at the edges of the field,
    //which are set to "wall". Thus, the game field will be lined with an inpenetrable wall,
    //so the players can't move the Snakes off-screen.
    for (int i=0; i<world_width; i++) {
      for (int ii=0; ii<world_height; ii++) {
        if (i == 0 || ii == 0 || i == world_width-1 || ii == world_height-1) {
          Field[i][ii] = new Cell(new PVector(i, ii), "wall");
        } else {
          Field[i][ii] = new Cell(new PVector(i, ii), "empty");
        }
      }
    }
    
    //After the whole grid has been initialized, we set the neighbors for all Cells in the grid.
    for (int i=0; i<world_width; i++) {
      for (int ii=0; ii<world_height; ii++) {
        if (i > 0) {
          Field[i][ii].left = Field[i-1][ii];
        }
        
        if (i < world_width-1) {
          Field[i][ii].right = Field[i+1][ii];
        }
        
        if (ii > 0) {
          Field[i][ii].up = Field[i][ii-1];
        }
        
        if (ii < world_height-1) {
          Field[i][ii].down = Field[i][ii+1];
        }
      }
    }
    
    //I create either one or two snakes with the Create_snake() function.
    for (int i=0; i<n_snakes; i++) {
      String snakename;
      if (i == 0) {
        snakename = "snake 1";
      } else {
        snakename = "snake 2";
      }
      
      //I input the starting point or "head" of the Snake into the Create_snake() function.
      //The heads the Snakes will have the same y-coordinate,
      //but will be evenly spaced along the x-coordinate.
      //Thus, if only one snake is created, it will be created in the middle of the screen,
      //but if two Snakes are created, they will be created in between the middle of the screen, and the left and right walls.
      //If more than two Snakes were to be created, they would also be evenly spaced along the horizontal middle of the screen,
      //but currently, a maximum of two Snakes can be created.
      Create_snake(Field[(world_width/(n_snakes+1))*(i+1)][world_height/2], snakename);
    }
    
    //I use the Create_food() function to create one food for each Snake.
    for (int i=0; i<Snakes.size(); i++) {
      Create_food();
    }
    
    //The AI String is initialized.
    AI = ArtInt;
    
  }
  
  //This function is used to create a Snake.
  //It takes the starting "head" Cell, and the Snake name as input.
  public void Create_snake (Cell head, String name) {
    
    //I know that a Snake is always initialized with it's direction being "up",
    //so we create a tail going down 4 Cells from the head.
    Cell[] tail = new Cell[4];
    for (int i=0; i<4; i++) {
      tail[i] = Field[(int)head.coordinates.x][((int)head.coordinates.y)+i+1];
    }
    
    //I create the Snake, and add it to the Snakes list.
    Snake snake = new Snake(head, tail, name);
    Snakes.add(snake);
  }
  
  
  //This function moves an input Snake along the direction it is going.
  public void Move_snake(Snake snake) {
    
    //I get the snakes head in a seperate variable, for convenience.
    Cell snake_head = snake.Body.get(0);
    
    //I determine what Cell the Snakes head will end up on, after moving.
    Cell incoming_cell;
    if(snake.direction == "up") {
      incoming_cell = snake_head.up;
    } else if (snake.direction == "down") {
      incoming_cell = snake_head.down;
    } else if (snake.direction == "left") {
      incoming_cell = snake_head.left;
    } else {
      incoming_cell = snake_head.right;
    }
    
    //If the incoming cell is a food cell, I insert that Cell onto the Snakes Body,
    //on spot number 0, making it the Snakes new head.
    //I then set the occupation of this Cell to be this Snake.
    //I also create a new food somewhere on the game field, using the Create_food() function.
    if(incoming_cell.occupation == "food") {
      snake.Body.add(0, incoming_cell);
      incoming_cell.occupation = snake.name;
      Create_food();
    //If the incoming Cell is empty, I move the head to this Cell,
    //and then move every other body part onto the Cell that was previously in front of it.
    } else if (incoming_cell.occupation == "empty") {
      //In order to move the Snake's Body correctly, I need a copy of the old Body.
      //Thus, I create a copy of the Body in this old_body ArrayList.
      ArrayList<Cell> old_body = new ArrayList<Cell>();
      for(int i=0; i<snake.Body.size(); i++) {
        old_body.add(snake.Body.get(i));
      }
      
      //I move the head of the Snake onto the incoming Cell, and set the occupation of this Cell to be the Snake.
      snake.Body.set(0, incoming_cell);
      incoming_cell.occupation = snake.name;
      //The rest of the Body parts gets moved onto the Cell that was previouslt in front of it.
      for(int i=1; i<snake.Body.size(); i++) {
        snake.Body.set(i, old_body.get(i-1));
      }
      
      //The occupation of the last Cell on the body is set to empty and removed from the body,
      //and thus the whole Snake has been moved one Cell.
      old_body.get(old_body.size()-1).occupation = "empty";
      old_body.remove(old_body.size()-1);
    } else {
      //If the Snake is moving into a Cell that is not empty or food, it will die,
      //and thus its alive status is set to false.
      snake.alive = false;
    }
    
  }
  
  //The Move_all() function is used to move all snakes on the board at once.
  public void Move_all() {
    //If AI is turned on, I will first calculate the direction of the Second (AI controlled) snake,
    //using the directionAI() function.
    if(AI != "None") {
      Snakes.get(1).direction = directionAI(Snakes.get(1));
    }
    
    //I then call the Move_snake() function once for each snake.
    for (int i=0; i<Snakes.size(); i++) {
      Move_snake(Snakes.get(i));
    }
  }
  
  //This function is used to create a new food Cell on the game field.
  public void Create_food() {
    //I pick a random Cell on the grid. If the Cell is not empty we pick another one,
    //until an empty Cell has been found. I then set the occupation of that Cell to be "food".
    Boolean creating_food = true;
    while(creating_food) {
      int random_x = (int)random(0, world_width);
      int random_y = (int)random(0, world_height);
      
      if(Field[random_x][random_y].occupation == "empty") {
        Field[random_x][random_y].occupation = "food";
        creating_food = false;
      }
    }
  }
  
  //This is the fuction I use to draw the entire game field.
  public void Draw_world() {
    
    //The game field consists of a 52x52 grid of Cells,
    //that will be drawn as different colored squares, depending on the occupation of the Cell.
    for (int i=0; i<world_width; i++) {
      for (int ii=0; ii<world_height; ii++) {
        Cell cell = Field[i][ii];
        
        //I go over each of the Cells in the grid, and draw a square on that Cell.
        //The square will be black for a "wall", green for a "food", red for "snake 1", blue for "snake 2, and white for "empty".
        if (cell.occupation == "wall") {
          stroke(0);
          fill(0);
        } else if (cell.occupation == "food") {
          stroke(50, 200, 0);
          fill(50, 200, 0);
        } else if (cell.occupation == "snake 1") {
          stroke(200, 25, 25);
          fill(200, 25, 25);
        } else if (cell.occupation == "snake 2") {
          stroke(50, 50, 225);
          fill(50, 50, 225);
        } else {
          stroke(255);
          fill(255);
        }
        
        //I use the coordinates of the Cell to determine where to draw the suqare.
        square(cell.coordinates.x*cell_size, cell.coordinates.y*cell_size, cell_size);
        
      }
    }
  }
  
  //This Change_snakedirection() function is used to change directions of the Snake,
  //when using the keyboard (arrow keys or WASD keys).
  //The function simply checks if the requested direction is the opposite direction of the current direction of the Snake,
  //and if not, it changes the current direction of the Snake to the requested direction.
  //I do this to prevent the Snake from turning around 180 degrees and landing on it's own body when it moves.
  public void Change_snake_direction(int what_snake, String new_direction, String old_direction) {
    if (old_direction == "up" && new_direction != "down") {
      Snakes.get(what_snake).direction = new_direction;
    } else if (old_direction == "down" && new_direction != "up") {
      Snakes.get(what_snake).direction = new_direction;
    } else if (old_direction == "left" && new_direction != "right") {
      Snakes.get(what_snake).direction = new_direction;
    } else if (old_direction == "right" && new_direction != "left") {
      Snakes.get(what_snake).direction = new_direction;
    }
  }
  
  //This function Alive_status() is used to determine if a snake has died,
  //and thus, when to change the scene to "Death_screen".
  //The function also returns the message to be displayed on the "Death_screen" scene.
  public String Alive_Status() {
    //If there is only one Snake, I check only that snake and return an empty string when it has died.
    if (Snakes.size() == 1) {
      if (Snakes.get(0).alive) {
        return "Snake is alive";
      } else {
        return "";
      }
    } else {
      if(Snakes.get(0).alive && Snakes.get(1).alive) {
        return "Both Snakes Alive";
      //If Snake 2 is dead, Player 1 wins.
      } else if (Snakes.get(0).alive && !Snakes.get(1).alive) {
        return "Player 1 wins!";
      //If Snake 1 is dead, Player 2 wins.
      } else if (!Snakes.get(0).alive && Snakes.get(1).alive) {
        return "Player 2 wins!";
      //If both Snakes died at the same time, the game is tied.
      } else {
        return "It's a tie!";
      }
    }
     
  }
  
  //This is the function that determines what direction an AI controlled snake will go.
  //The goal of the AI is to move the Snake along the most optimal path to the closest food Cell,
  //or if no food Cell can be reached from the Snakes current position,
  //to survive as long as possible.
  public String directionAI (Snake snake) {
    
    //First off, depending on the difficulty setting,
    //there is a random chance that the AI controlled Snake will just go in a random valid direction.
    String finalDirection;
    int cutoff = 0;
    
    //On "Easy" setting, the AI has a 25% chance of going in a random direction.
    //On "Medium", there is a 10% chance, and on "Hard" there is a 0% chance.
    if (AI == "Easy") {
      cutoff = 25;
    } else if (AI == "Medium") {
      cutoff = 10;
    } else if (AI == "Hard") {
      cutoff = 0;
    }
    
    //I pick a random number between 0 and 100. If it is lower than the difficulty cutoff, I pick a random direction.
    int randomNoise = (int)random(100);
    if(randomNoise < cutoff) {
      finalDirection = randomDirection(snake);
    } else {
      
      //First, I reset the "visited" status of all Cells on the grid, marking them all as unvisited.
      for (int i=0; i<world_width; i++) {
        for (int ii=0; ii<world_height; ii++) {
          Field[i][ii].visited = false;
        }
      }
      
      //I get the starting Cell of the Snake, which is the Snakes head.
      Cell start = snake.Body.get(0);
      //I mark the head Cell as visited.
      start.visited = true;
      //I need to keep looking for Cells until we find a food Cell, and thus I need this "potentials" ArrayList,
      //that will contail all Cells that I have visited, but that has unvisited neighbors.
      ArrayList<Cell> potentials = new ArrayList<Cell>();
      
      //I start by checking each of the neighbors of the starting Cell.
      //If the neighbor Cell is empty or food, I mark it as visited,
      //set the cost to 1 (that is, the neighbor is 1 move away from the starting Cell),
      //set the direction of that Cell to be the direction from the starting Cell,
      //and add the Cell to the potentials ArrayList.
      if (start.right.occupation == "empty" || start.right.occupation == "food") {
        start.right.visited = true;
        start.right.cost = 1;
        start.right.direction = "right";
        potentials.add(start.right);
      }
      if (start.left.occupation == "empty" || start.left.occupation == "food") {
        start.left.visited = true;
        start.left.cost = 1;
        start.left.direction = "left";
        potentials.add(start.left);
      }
      if (start.up.occupation == "empty" || start.up.occupation == "food") {
        start.up.visited = true;
        start.up.cost = 1;
        start.up.direction = "up";
        potentials.add(start.up);
      }
      if (start.down.occupation == "empty" || start.down.occupation == "food") {
        start.down.visited = true;
        start.down.cost = 1;
        start.down.direction = "down";
        potentials.add(start.down);
      }
      
      //If at least one of the neighbors of the starting Cell was a valid movement option,
      //the size of the potentials list will be more than 0, and thus I will start going through the potentials list.
      if (potentials.size() > 0) {
        //I create this "current" Cell variable to keep track of the current Cell I'm looking at
        Cell current = potentials.get(0);
        
        //This while-loop keeps on going until a food Cell has been found,
        //or until I have looked at all possible Cells that can be traveled to from the AI controlled Snakes current position.
        Boolean Found_Food = false;
        while(Found_Food == false && potentials.size() > 0) {
          
          //Every loop, I look at the closest (that is, lowest cost) Cell to the starting Cell,
          //that still has unvisited neighbors.
          current = potentials.get(0);
          for (int i=0; i<potentials.size(); i++) {
            if (potentials.get(i).cost < current.cost) {
              current = potentials.get(i);
            }
          }
          
          //If this current Cell is a food Cell, we have found the closest food that we were looking for,
          //and thus I can break out of the while-loop.
          if (current.occupation == "food") {
            Found_Food = true;
            break;
          }
          
          //I check all the neighbors of the current Cell that are either "empty" or "food",
          //and that have not been visited.
          //I then mark them as visited, set their cost to be the cost of the current cell + 1,
          //since the distance from the starting Cell to this Cell will be one more than the distance from the stating Cell to the current Cell.
          //I also set their direction to be that of the current Cell,
          //and then finally add the Cell to the potentials list.
          //Notice that I do not calculate a full set of directions from the starting Cell to this Cell,
          //but instead i simply determine a direction that the AI controlled Snake can move,
          //in order to move one Cell closer to this Cell.
          //Since the game field changes every time the Snakes move, the optimal paths to a specific Cell might change every move,
          //and thus I need to recalculate movement of the AI controlled Snake every move.
          //It would thus be redundant to calculate the entire path to a specific Cell, since the path might just change next move,
          //and thus it is sufficient to simply determine a direction the AI controlled snake can move,
          //in order to get one step closer to the Cell
          
          if (current.right.occupation == "empty" || current.right.occupation == "food") {
            if (current.right.visited != true) {
              current.right.visited = true;
              current.right.cost = current.cost + 1;
              current.right.direction = current.direction;
              potentials.add(current.right);
            }
          }
          if (current.left.occupation == "empty" || current.left.occupation == "food") {
            if (current.left.visited != true) {
              current.left.visited = true;
              current.left.cost = current.cost + 1;
              current.left.direction = current.direction;
              potentials.add(current.left);
            }
          }
          if (current.left.occupation == "empty" || current.left.occupation == "food") {
            if (current.up.visited != true) {
              current.up.visited = true;
              current.up.cost = current.cost + 1;
              current.up.direction = current.direction;
              potentials.add(current.up);
            }
          }
          if (current.left.occupation == "empty" || current.left.occupation == "food") {
            if (current.down.visited != true) {
              current.down.visited = true;
              current.down.cost = current.cost + 1;
              current.down.direction = current.direction;
              potentials.add(current.down);
            }
          }
      
          for (int i=0; i<potentials.size(); i++) {
            if(potentials.get(i).coordinates.x == current.coordinates.x &&
              potentials.get(i).coordinates.y == current.coordinates.y) {
              potentials.remove(i);
            }
          }
        
        }
        
        //Once we are out of the for loop, we set the final direction to be the direction towards the current Cell.
        //At this point, the current Cell will be the closest food Cell,
        //or the Cell furthest away from the starting Cell (if no food Cell could be reached from the starting Cell).
        //This fits well with the goals of the AI,
        //since it will either determine a direction that will take the snake one step closer to a food Cell,
        //or if no food Cells can be reached, determine a direction that will allow the Snake to survive another move,
        //and hopefully a path towards a food Cell will have opened up by then.
        //With the current implementation, when no food Cells can be reached,
        //the AI will not always chose the path that allows it to survive the longest,
        //but will instead move towards the Cell that is furthest away.
        //I velieve that this is a fair approximation however.
        finalDirection = current.direction;
      
      } else {
        //If there are 0 Cells in the potentials ArrayList,
        //it means that the starting Cell is completely surrounded by occupied Cells,
        //and thus the AI controlled Snake should simply move one Cell along its current direction and die.
        finalDirection = snake.direction;
      }
      
    }
    
    //We return the direction determined by the AI.
    return finalDirection;
  }
  
  //This function returns a random valid direction, based on an input direction.
  //The function thus will not return a direction that is directly opposite of the input direction.
  public String randomDirection (Snake snake) {
    
    String[] possible_directions = new String[3];
    
    if (snake.direction == "up") {
      possible_directions[0] = "up";
      possible_directions[1] = "left";
      possible_directions[2] = "right";
    } else if (snake.direction == "down") {
      possible_directions[0] = "down";
      possible_directions[1] = "left";
      possible_directions[2] = "right";
    } else if (snake.direction == "left") {
      possible_directions[0] = "up";
      possible_directions[1] = "left";
      possible_directions[2] = "down";
    } else {
      possible_directions[0] = "up";
      possible_directions[1] = "right";
      possible_directions[2] = "down";
    }
    
    int rando = (int)random(3);
    
    return (possible_directions[rando]);
    
  }
  
  
}
