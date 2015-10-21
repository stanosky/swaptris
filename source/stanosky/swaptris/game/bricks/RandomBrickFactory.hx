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
				brick = new BrickBlue(_brickSize);
			case BrickType.Green:
				brick = new BrickGreen(_brickSize);
			case BrickType.Red:
				brick = new BrickRed(_brickSize);
			case BrickType.White:
				brick = new BrickWhite(_brickSize);				
			case BrickType.Yellow:
				brick = new BrickYellow(_brickSize);				
			default:
				brick = null;
		}
		return brick;
	}
	
}