package stanosky.swaptris.game.bricks;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */
class BrickRed extends SimpleBrick
{

	public function new(size:Int) 
	{
		
		super(size, FlxColor.RED);
		
	}
	
	override private function initBrick():Void {
		loadGraphic(AssetPaths.brickRed__png);
		setGraphicSize(_size, _size);
		updateHitbox();
	}
	
}