let Abundance = {}

const width = 20;
const height = 20;
const size = 1;
const scale = 25;


Abundance.cells = new Array(width * height).fill(0);

Abundance.calcBoard = (cells) => {
    var paths = [];

    cells.forEach(function(cell, i) {
        paths.push(drawRec(i, cell, width, height, size, scale));
    })
    
    return paths
}

function drawRec(indx, val, numXCells, numYCells, cellSize, cellScale) {
	var y = Math.floor(indx / numYCells);
	var x = indx % numXCells;
	var size = cellSize * cellScale;
    return {
        x: x * size,
        y: y * size,
        size: size,
        col: val == 0 ? '#F2EDEC' : '#FF5733',
        indx: indx,
		val: val 
    }
}

Abundance.updateBoard = (cells, cell) => {
	cells[cell] = cells[cell] == 0 ? 1 : 0;
	return cells;
}

Abundance.stepForward = (cells) => {
	cells.forEach(function(cell, indx) {
		var neighbours = Abundance.calcNeighbours(indx, cells)
		if(cells[indx] != 0 && (neighbours == 2 || neighbours == 3)) {
			return
		} else if(cells[indx] == 0 && neighbours == 3) {
			cells[indx] = 1;
		} else {
			cells[indx] = 0;
		}
	})
	return cells
}

Abundance.sendGridEvent = (ele, cells) => {
    var event = new CustomEvent(
        "newSnapshot",
        {
            detail: {
                cells: cells
            },
            bubbles: true,
            cancelable: true
        }
    );
    ele.dispatchEvent(event)
}

Abundance.calcNeighbours = (indx, cells) => {
	var numYCells = height;
	var numXCells = width; 
	var y = Math.floor(indx / numYCells);
	var x = indx % numXCells;

	// conditions
	var canLeft = x > 0
	var canRight = x < numXCells
	var canUp = y > 0
	var canDown = y < numYCells - 1


	var upln = canLeft && canUp ? cells[indx - (numXCells - 1)] : 0
	var upn = canUp ? cells[indx - numXCells] : 0
	var uprn = canRight && canUp ? cells[indx - (numXCells + 1)] : 0
	var ln = canLeft ? cells[indx - 1] : 0
	var rn = canRight ? cells[indx + 1] : 0
	var downln = canDown && canLeft ? cells[indx + (numXCells - 1)] : 0
	var downn = canDown ? cells[indx + numXCells] : 0
	var downrn = canDown && canRight ? cells[indx + (numXCells + 1)] : 0

	return upn + ln + rn + downn + upln + uprn + downln + downrn
}


export default Abundance