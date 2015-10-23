package stanosky.swaptris.game;
import stanosky.swaptris.game.bricks.IBrick;
import openfl.errors.RangeError;

/**
 * ...
 * @author Krzysztof Stano
 */
 
class Grid
{

	//Ilość kolumn tablicy
	private var _columns:Int;
	//Ilość wierszy tablicy
	private var _rows:Int;
	//Tablica 2D przechowująca obiekty
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
	
	/**
	 * Dodaje element w komórce wskazanej przez kolumne i wiersz
	 * @param	brick
	 * @param	col
	 * @param	row
	 */
	public function addBrick(brick:IBrick, col:Int,row:Int):Void {
		if (!cellExists(col,row)) return;
		//removeBrick(col, row);
		brick.setCell(col, row);
		_grid[col][row] = brick;
	}
	
	/**
	 * Usuwa element znajdujący sie w komórce wskazanej przez kolumne i wiersz
	 * @param	col
	 * @param	row
	 */
	public function removeBrick(col:Int,row:Int):Void {
		if (!cellExists(col,row)) return;
		var brick:IBrick = _grid[col][row];
		if (brick != null) {
			_grid[col][row] = null;
			brick.destroy();
		}
	}
	
	/**
	 * Pobiera referencje do wybranej kostki w komórce
	 * @param	col
	 * @param	row
	 * @return Element o interfejsie IBrick lub null w przypadku gdy komórka nie jest zajmowana
	 */
	public function getBrick(col:Int,row:Int):IBrick {
		return _grid[col][row];
	}
	
	/**
	 * Usuwa obiekt IBrick z komórki i zwraca go
	 * @param	col
	 * @param	row
	 * @return Element o interfejsie IBrick lub null w przypadku gdy komórka nie jest zajmowana
	 */
	public function pickBrick(col:Int, row:Int):IBrick {
		if (!cellExists(col, row)) return null;
		var brick:IBrick = _grid[col][row];
		_grid[col][row] = null;
		brick.setCell( -1, -1);
		return brick;
	}
	
	/**
	 * Pozwala określić czy wybrana komórka jest zajmowana przez jakiś obiekt
	 * @param	col
	 * @param	row
	 * @return Jeśli komórka posiada zawartość jest zwracana wartość true, w przeciwnym wypadku wartość false
	 */
	public function isCellOccupied(col:Int, row:Int):Bool {
		if (!cellExists(col, row)) return false;
		return _grid[col][row] != null;
	}
	
	/**
	 * Pozwala określić czy wybrana komórka istnieje
	 * @param	col
	 * @param	row
	 * @return Jeśli komórka mieści si w zakresie zdefiniowanym przy inicjacji tablicy jest zwracana wartość true, w przeciwnym wypadku false
	 */
	public function cellExists(col:Int, row:Int):Bool {
		return !(col > _columns - 1 || col < 0 || row > _rows - 1 || row < 0);
	}
}