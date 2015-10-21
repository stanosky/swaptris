package stanosky.swaptris.game.bricks;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */
class BrickYellow extends SimpleBrick
{

	public function new(size:Int) 
	{
		
		super(size, FlxColor.YELLOW);
		
	}
	
	override private function initBrick():Void {
		loadGraphic(AssetPaths.brickYellow__png);
		setGraphicSize(_size, _size);
		updateHitbox();
	}
	
}