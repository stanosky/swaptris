package stanosky.swaptris.game.bricks;
import flixel.util.FlxColor;

/**
 * ...
 * @author Krzysztof Stano
 */
class PatternBrickFactory extends AbstractBrickFactory
{

	private var _pattern:Array<Array<Int>>;
	
	public function new(brickSize:Int) 	{
		super(brickSize);
	}
	
	public function setPattern(pattern:Array<Array<Int>>):Void {
		_pattern = pattern;
	}
	
	override public function getBrick(column:Int, row:Int):IBrick {
		if (row >= _pattern.length) return null;
		if (column >= _pattern[row].length) return null;
		var value:Int = _pattern[row][column];
		var brick:IBrick;
		switch (value) 
		{
			case 0:
				//brick = new SimpleBrick(_brickSize, FlxColor.YELLOW);
				brick = null;
			case 1:
				brick = new SimpleBrick(_brickSize, FlxColor.RED);
			default:
				brick = null;
		}
		return brick;
	}
	
}