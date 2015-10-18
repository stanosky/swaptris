package stanosky.swaptris.game.anim;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import stanosky.swaptris.game.bricks.IBrick;

/**
 * ...
 * @author Krzysztof Stano
 */
class AnimManager
{

	private var _queue:Array<FlxTween>;
	
	public function new() {
		_queue = [];
	}
	
	public static function moveAnimation(brick:IBrick, x:Float, y:Float):Void {
		var sprite:FlxSprite = cast(brick, FlxSprite);
		trace(sprite);
		FlxTween.tween(sprite, { "x":x, "y":y }, .2, {ease:FlxEase.quadInOut } );
	}
}