package stanosky.swaptris.game.bricks;

/**
 * ...
 * @author Krzysztof Stano
 */
class BrickGroup
{
	private static var UNIQUE_COUNTER:Int = 0;
	private var _cells:Array<Cell>;
	private var _id:Int;
	

	public function new() {
		_cells = [];
		_id = UNIQUE_COUNTER++;
	}
	
	public function getId():Int {
		return _id;
	}
	
	public function addCell(cell:Cell):Void {
		_cells.push(cell);
	}
	
	public function getCells():Array<Cell> {
		return _cells;
	}
	
	public function destroy():Void {
		_cells = null;
	}
}