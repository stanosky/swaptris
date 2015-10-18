package stanosky.swaptris.game.bricks;
import flixel.util.FlxColor;

/**
 * ...
 * @author Krzysztof Stano
 */
class RandomBrickFactory extends AbstractBrickFactory
{
	
	private var _brickTypes:Array<BrickType>;
	
	public function new(brickSize:Int) 
	{
		super(brickSize);
		_brickTypes = BrickType.createAll();
		
	}
	
	private function getRandomBrickType():BrickType {
		var typesLen:Int = _brickTypes.length;
		var randIndex:Int = Math.floor(Math.random() * typesLen);
		return cast(_brickTypes[randIndex],BrickType);
	}
	
	override public function getBrick(column:Int,row:Int):IBrick {
		return createBrick(getRandomBrickType());
	}
	
	private function createBrick(type:BrickType):IBrick {
		var brick:IBrick;
		switch (type) 
		{
			case BrickType.Blue:
				brick = new SimpleBrick(_brickSize, FlxColor.BLUE);
			case BrickType.Green:
				brick = new SimpleBrick(_brickSize, FlxColor.GREEN);
			case BrickType.Red:
				brick = new SimpleBrick(_brickSize, FlxColor.RED);
			case BrickType.Yellow:
				brick = new SimpleBrick(_brickSize, FlxColor.YELLOW);				
			case BrickType.Gray:
				brick = new SimpleBrick(_brickSize, FlxColor.GRAY);				
			default:
				brick = null;
		}
		return brick;
	}
	
}