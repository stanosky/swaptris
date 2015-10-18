package stanosky.swaptris.game;
import stanosky.swaptris.game.bricks.IBrick;
import openfl.errors.RangeError;

/**
 * ...
 * @author Krzysztof Stano
 */
 
class Grid
{

	private var _columns:Int;
	private var _rows:Int;
	private var _grid:Array<Array<IBrick>>;
	
	public function new(columns:Int,rows:Int) 
	{
		_columns = columns;
		_rows = rows;
		_grid = [];
		
		for (c in 0..._columns) {
			var _col:Array<IBrick> = [];
			for (r in 0..._rows) {
				_col.push(null);
			}
			_grid.push(_col);
		}
	}
	
	public function addBrick(brick:IBrick, col:Int,row:Int):Void {
		if (!cellExists(col,row)) return;
		removeBrick(col, row);
		brick.setCell(col, row);
		_grid[col][row] = brick;
	}
	
	public function removeBrick(col:Int,row:Int):Void {
		if (!cellExists(col,row)) return;
		var brick:IBrick = _grid[col][row];
		if (brick != null) {
			_grid[col][row] = null;
			brick.destroy();
		}
	}
	
	public function getBrick(col:Int,row:Int):IBrick {
		return _grid[col][row];
	}
	
	public function pickBrick(col:Int, row:Int):IBrick {
		if (!cellExists(col, row)) return null;
		var brick:IBrick = _grid[col][row];
		_grid[col][row] = null;
		return brick;
	}
	
	public function isCellOccupied(col:Int, row:Int):Bool {
		if (!cellExists(col, row)) return false;
		return _grid[col][row] != null;
	}
	
	public function cellExists(col:Int, row:Int):Bool {
		return !(col > _columns - 1 || col < 0 || row > _rows - 1 || row < 0);
	}
}