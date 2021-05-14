package {
  import flash.display.MovieClip;
  
  public class the_snake_mc extends MovieClip {
    public function the_snake_mc(px:uint,py:uint,frm:uint) {
      x=px;
      y=py;
      gotoAndStop(frm);
    }
	public function moveHead (dir:uint, pixels:uint) :void {
		switch (dir) {
			case 0:
				x-=pixels;
				break;
			case 1:
				y-=pixels;
				break;
			case 2:
				x+=pixels;
				break;
			case 3:
				y+=pixels;
				break;
		}
		gotoAndStop(dir+1);
	}
  }
}