let Abundance = {}

Abundance.calcBoard = (cells) => {
    var paths = [];

    cells.forEach(function(cell, i) {
        paths.push(drawRec(i, cell, 10, 10, 1, 50));
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
	return Abundance.calcBoard(cells);
}

	//
	//console.log(hitResult)
	//var cell = path.index;
	// Abundance.calcNeighbours(cell);
	// if(cells[cell] == 0) {
	   // Abundance.turnOnCell(path, cell, cells)
	// }
	//sendGridEvent();

Abundance.calcNeighbours = (indx) => {
	var y = Math.floor(indx / numYCells);
	var x = indx % numXCells;

	// conditions
	var canLeft = x > 0
	var canRight = x < numXCells
	var canUp = y > 0
	var canDown = y < numYCells - 1


	upln = canLeft && canUp ? cells[indx - (numXCells - 1)] : 0
	upn = canUp ? cells[indx - numXCells] : 0
	uprn = canRight && canUp ? cells[indx - (numXCells + 1)] : 0
	ln = canLeft ? cells[indx - 1] : 0
	rn = canRight ? cells[indx + 1] : 0
	downln = canDown && canLeft ? cells[indx + (numXCells - 1)] : 0
	downn = canDown ? cells[indx + numXCells] : 0
	downrn = canDown && canRight ? cells[indx + (numXCells + 1)] : 0

	return upn + ln + rn + downn + upln + uprn + downln + downrn
}

Abundance.turnOffCell = (path, cell, cells) => {
	path.fillColor = 'white'
	cells[cell] = 0
}

Abundance.turnOnCell = (path, cell, cells) => {
	path.fillColor = 'black'
	cells[cell] = playerNum
}

export default Abundance

// function sendGridEvent() {
//     var event = new CustomEvent(
//         "newSnapshot",
//         {
//             detail: {
//                 cells: cells
//             },
//             bubbles: true,
//             cancelable: true
//         }
//     );
//     document.getElementById('myCanvas').dispatchEvent(event)
// }




// window.updateBoard = updateBoard





// function onFrame(event) {
// 	if (isOn && frame % 10 == 0) {
// 		updateCells()
// 	}
// 	frame++
// }



// document.getElementById('flipState').onclick = function () {
// 	isOn = !isOn
// }

// function onMouseDown(event) {
// 	segment = path = null;
// 	var hitResult = project.hitTest(event.point, {
// 		segments: true,
// 		stroke: true,
// 		fill: true,
// 		tolerance: 5
// 	});
// 	var path = hitResult.item

// 	var cell = path.index;
// 	calcNeighbours(cell);
// 	if(cells[cell] == 0) {
// 	    turnOnCell(path, cell)
// 	}
// 	sendGridEvent();
// }



// function updateBoard(newCells) {
//     newCells.map((x, cell) => {
//         paths[cell].fillColor = cols[x];
//         cells[cell] = x;
//     })
// }



// function updateCells() {
// 	cells.forEach(function(cal, cell) {
// 		var neighbours = calcNeighbours(cell)
// 		if(cells[cell] != 0 && (neighbours == 2 || neighbours == 3)) {
// 			return
// 		} else if(cells[cell] == 0 && neighbours == 3) {
// 			turnOnCell(paths[cell], cell)
// 		} else {
// 			turnOffCell(paths[cell], cell)
// 		}
// 	})
// }

// function turnOffCell(path, cell) {
// 	path.fillColor = offCol
// 	cells[cell] = 0
// }

// function turnOnCell(path, cell) {
// 	path.fillColor = onCol
// 	cells[cell] = playerNum
// }


// function calcNeighbours(indx) {
// 	var y = Math.floor(indx / numYCells);
// 	var x = indx % numXCells;

// 	// conditions
// 	var canLeft = x > 0
// 	var canRight = x < numXCells
// 	var canUp = y > 0
// 	var canDown = y < numYCells - 1


// 	upln = canLeft && canUp ? cells[indx - (numXCells - 1)] : 0
// 	upn = canUp ? cells[indx - numXCells] : 0
// 	uprn = canRight && canUp ? cells[indx - (numXCells + 1)] : 0
// 	ln = canLeft ? cells[indx - 1] : 0
// 	rn = canRight ? cells[indx + 1] : 0
// 	downln = canDown && canLeft ? cells[indx + (numXCells - 1)] : 0
// 	downn = canDown ? cells[indx + numXCells] : 0
// 	downrn = canDown && canRight ? cells[indx + (numXCells + 1)] : 0

// 	return upn + ln + rn + downn + upln + uprn + downln + downrn
// }