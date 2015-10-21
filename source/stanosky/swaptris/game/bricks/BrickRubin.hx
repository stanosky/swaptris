package stanosky.swaptris.game.bricks;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */
class BrickRubin extends SimpleBrick
{

	public function new(size:Int) 
	{
		
		super(size, FlxColor.PURPLE);
		
	}
	
	override private function initBrick():Void {
		loadGraphic(AssetPaths.brickRubin__png);
		setGraphicSize(_size, _size);
		updateHitbox();
	}
	
}