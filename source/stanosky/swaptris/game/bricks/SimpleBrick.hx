package stanosky.swaptris.game.bricks;
import flixel.util.FlxStringUtil;
import openfl.display.BlendMode;
import stanosky.swaptris.game.bricks.IBrick;
import flixel.FlxSprite;
import flixel.util.FlxColor;

/**
 * ...
 * @author Krzysztof Stano
 */
class SimpleBrick extends FlxSprite implements IBrick
{
	private var _size:Int;
	private var _color:Int;
	private var _group:Int = -1;
	private var _tempGroup:Int = -1;
	private var _sides:Int = 4;
	private var _column:Int = -1;
	private var _row:Int = -1;
	private var ANIM_IDLE:String = "idle";
	private var ANIM_SELECTED:String = "selected";
	
	public function new(size:Int, color:Int) {
		super(0, 0);
		_size = size;
		_color = color;
		useColorTransform = true;
		initBrick();
	}
	
	private function initBrick():Void {
		//makeGraphic(_size, _size, _color);
		loadGraphic(AssetPaths.bricksSpriteSheet__png, _size, _size);
		animation.add(ANIM_IDLE, [_color], 6);
		animation.add(ANIM_SELECTED, [_color + 5], 6);
		//setGraphicSize(_size, _size);
		setSize(_size, _size);
		updateHitbox();
		animation.play(ANIM_IDLE);
	}
	
	public function moveBrickTo(X:Float = 0, Y:Float = 0):Void {
		this.x = X;
		this.y = Y;
	}
	
	public function setGroup(id:Int):Void {
		_group = id;
		_tempGroup = -1;
		if (id >= 0) {
			//set_blend(BlendMode.ADD);
			animation.play(ANIM_SELECTED);
		} else {
			//set_blend(BlendMode.NORMAL);
			animation.play(ANIM_IDLE);
		}
		//makeGraphic(_size, _size, FlxColor.YELLOW);
	}
	
	public function getGroup():Int {
		return _group;
	}

	public function setTempGroup(id:Int):Void {
		_tempGroup = id;
	}
	
	public function getTempGroup():Int {
		return _tempGroup;
	}
	
	public function getColor():Int {
		return _color;
	}
	
	public function setCell(columnIndex:Int, rowIndex:Int):Void {
		_column = columnIndex;
		_row = rowIndex;
	}
	
	public function getCol():Int {
		return _column;
	}
	
	public function getRow():Int {
		return _row;
	}
	
	override public function destroy():Void {
		//uzupełnij
		super.destroy();
	}
	
	override public function toString():String {
		return FlxStringUtil.getDebugString([
			LabelValuePair.weak("col", _column),
			LabelValuePair.weak("row", _row)
			]);
	}
}