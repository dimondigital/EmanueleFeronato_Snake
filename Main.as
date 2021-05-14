package {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	
	public class Main extends Sprite {
		private const FIELD_WIDTH:uint=16;
        private const FIELD_HEIGHT:uint=12;
    	private const TILE_SIZE:uint=40;
    	private var the_snake:the_snake_mc;
   	 	private var snakeDirection:uint;
    	private var snakeContainer:Sprite= new Sprite();
    	private var bg:bg_mc=new bg_mc();
		private var fruit:fruit_mc;
		private var justEaten:uint = 0;
		private var obstacle:obstacle_mc;
		
		public function Main() {
			addChild(bg);
			placeSnake();
			placeStuff();
			addEventListener(Event.ENTER_FRAME, onEnterFr);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyD);
		}
		private function placeSnake():void {
			addChild(snakeContainer);
			var col:uint=Math.floor(Math.random()*(FIELD_WIDTH-10))+5;
  			var row:uint=Math.floor(Math.random()*(FIELD_HEIGHT-10))+5;
			var tmpCol,tmpRow,evenDir:uint;
  			snakeDirection=Math.floor(Math.random()*4);
 		 	the_snake=new the_snake_mc(col*TILE_SIZE,row*TILE_SIZE,snakeDirection+1);
  			snakeContainer.addChild(the_snake);
			for  (var i:uint=1;  i<=2; i++) {
				 evenDir = snakeDirection%2;
    			 tmpCol = col+i*(1-evenDir)*(1-snakeDirection);
  				 tmpRow = row+i*(2-snakeDirection)*evenDir;
   				 the_snake = new the_snake_mc(tmpCol*TILE_SIZE,tmpRow*TILE_SIZE,6-evenDir);
    			 snakeContainer.addChild(the_snake);
			}
		}
		//Moving up
		private function is_up (from:the_snake_mc,to:the_snake_mc):Boolean {
  				return to.y<from.y&&from.x==to.x;
		}
		//Moving down
		private function is_down (from:the_snake_mc, to:the_snake_mc):Boolean {
			return to.y>from.y&&from.x==to.x;
		}
		//Moving left
		private function is_left (from:the_snake_mc,to:the_snake_mc):Boolean {
			return to.x<from.x&&from.y==to.y;
		}
		//Moving right
		private function is_right (from:the_snake_mc,to:the_snake_mc):Boolean {
			return to.x>from.x&&from.y==to.y;
		}
		private function onEnterFr (e:Event) {
			var the_head:the_snake_mc=snakeContainer.getChildAt(0) as the_snake_mc;
  			var new_piece:the_snake_mc=new the_snake_mc(the_head.x,the_head.y,1);
			new_piece.name="snake body";
  			snakeContainer.addChildAt(new_piece,1);
  			var the_body:the_snake_mc=snakeContainer.getChildAt(2) as the_snake_mc;
  			var p:uint=snakeContainer.numChildren;
  			var the_tail:the_snake_mc=snakeContainer.getChildAt(p-1) as the_snake_mc;
  			var the_new_tail:the_snake_mc=snakeContainer.getChildAt(p-2) as the_snake_mc;
  			the_head.moveHead(snakeDirection,TILE_SIZE);
			//brute force
			if (is_up(new_piece,the_head)&&is_down(new_piece,the_body)) {
    			new_piece.gotoAndStop(5);
  			}
  			if (is_down(new_piece,the_head)&&is_up(new_piece,the_body)) {
    			new_piece.gotoAndStop(5);
  			}
  			if (is_left(new_piece,the_head)&&is_right(new_piece,the_body)) {
    			new_piece.gotoAndStop(6);
  			}
  			if (is_right(new_piece,the_head)&&is_left(new_piece,the_body)) {
    			new_piece.gotoAndStop(6);
  			}
			if (is_left(new_piece,the_head)&&is_up(new_piece,the_body)) {
   				new_piece.gotoAndStop(7);
			}
			if (is_up(new_piece,the_head)&&is_left(new_piece,the_body)) {
				new_piece.gotoAndStop(7);
			}
			if (is_up(new_piece,the_head)&&is_right(new_piece,the_body)) {
				new_piece.gotoAndStop(8);
			}
			if (is_right(new_piece,the_head)&&is_up(new_piece,the_body)) {
				new_piece.gotoAndStop(8);
			}
			if (is_right(new_piece,the_head)&&is_down(new_piece,the_body)) {
 				new_piece.gotoAndStop(9);
			}
			if (is_down(new_piece,the_head)&&is_right(new_piece,the_body)) {
  				new_piece.gotoAndStop(9);
			}
			if (is_left(new_piece,the_head)&&is_down(new_piece,the_body)) {
  				new_piece.gotoAndStop(10);
			}
			if (is_down(new_piece,the_head)&&is_left(new_piece,the_body)) {
  				new_piece.gotoAndStop(10);
			}
  			// end of brute force
			//snakeContainer.removeChild(the_tail);
			//eating fruits
			var point_to_watch:Point=new Point(the_head.x+TILE_SIZE/2,the_head.y+TILE_SIZE/2);
			var children_in_that_point:Array=stage.getObjectsUnderPoint(point_to_watch);
			for (var i:uint=0; i<children_in_that_point.length; i++) {
				switch (children_in_that_point[i].parent.name) {
					case "fruit" :
						justEaten=1;
						removeChild(fruit);
						placeStuff();
						break;
					case "snake body":
					case "obstacle":
						die();
						break;
				}
			}
			if (justEaten == 0) {
				snakeContainer.removeChild(the_tail);
			}else{
				justEaten--;
			}
			if (the_head.x<0) {
  				die();
			}
			if (the_head.x>=stage.stageWidth) {
  				die();
			}
			if (the_head.y<0) {
  				die();
			}
			if (the_head.y>=stage.stageHeight) {
  				die();
			}
		}
		//controlling the snake
		private function onKeyD (e:KeyboardEvent):void {
			if (e.keyCode>=37&&e.keyCode<=40) {
				snakeDirection=e.keyCode-37;
			}
		}
		private function manhattan_dist(x1:uint,x2:uint,y1:uint,y2:uint):uint {
 			 return Math.abs(x1-x2)+Math.abs(y1-y2);
		}
		private function placeStuff():void {
  			var the_head:the_snake_mc=snakeContainer.getChildAt(0) as  the_snake_mc;
  			var placed:Boolean=false;
  			var col:uint;
  			var row:uint;
  			var point_to_watch:Point;
  			var children:Array;
  			while (!placed) {
    			col=Math.floor(Math.random()*FIELD_WIDTH)*TILE_SIZE;
    			row=Math.floor(Math.random()*FIELD_HEIGHT)*TILE_SIZE;
    			point_to_watch=new Point(col+TILE_SIZE/2,row+TILE_SIZE/2);
    			children=stage.getObjectsUnderPoint(point_to_watch);
    			if (children.length<2&&manhattan_dist(the_head.x,col, the_head.y,row)>60) {
      				placed=true;
    			}
 		    }
		    fruit = new fruit_mc();
			fruit.x = col;
			fruit.y = row;
			addChild(fruit);
			fruit.name = "fruit";
			placed=false;
 			 while (!placed) {
    				col=Math.floor(Math.random()*FIELD_WIDTH)*TILE_SIZE;
    				row=Math.floor(Math.random()*FIELD_HEIGHT)*TILE_SIZE;
    				point_to_watch=new Point(col+TILE_SIZE/2,row+TILE_SIZE/2);
    				children=stage.getObjectsUnderPoint(point_to_watch);
    				if (children.length<2&&manhattan_dist(the_head.x,col, the_head.y,row)>60) {
      					placed=true;
    				}
  			}
  			obstacle =new obstacle_mc();
  			obstacle.x=col;
  			obstacle.y=row;
  			addChild(obstacle);
  			obstacle.name="obstacle";
		}
		private function die():void {
			removeEventListener(Event.ENTER_FRAME, onEnterFr);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyD);
			var game_over:game_over_mc = new game_over_mc();
			addChild(game_over);
		}
	}
}
