package stanosky.swaptris.game.bricks;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */
class BrickGreen extends SimpleBrick
{

	public function new(size:Int) 
	{
		
		super(size, FlxColor.GREEN);
		
	}
	
	override private function initBrick():Void {
		loadGraphic(AssetPaths.brickGreen__png);
		setGraphicSize(_size, _size);
		updateHitbox();
	}
	
}