// Generated by CoffeeScript 1.7.1
var Board;

Board = (function() {
  var maxNumber;

  maxNumber = 32768;

  function Board() {
    var i, j, _i, _j;
    this.numberCells = [];
    this.numberCellHelper = [];
    this.topNumberValue = 0;
    this.score = 0;
    this.addScore = 0;
    for (i = _i = 0; _i < 4; i = ++_i) {
      this.numberCells[i] = [];
      for (j = _j = 0; _j < 4; j = ++_j) {
        this.numberCells[i][j] = new Number(0, i, j);
      }
    }
  }

  Board.prototype.generateOneNumber = function(showNumberAnimate) {
    var availCellNum, randNumberCell;
    availCellNum = this.numberCellHelper.length;
    if (availCellNum === 0) {
      return false;
    }
    randNumberCell = this.numberCellHelper[(Math.random() * availCellNum) | 0];
    randNumberCell.value = Math.random() < 0.9 ? 2 : 4;
    if (typeof showNumberAnimate === "function") {
      showNumberAnimate(randNumberCell);
    }
    return true;
  };

  Board.prototype.updateAllcells = function(showOneNumber) {
    var cell, rowCells, _i, _j, _len, _len1, _ref;
    this.numberCellHelper = [];
    this.addScore = 0;
    _ref = this.numberCells;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      rowCells = _ref[_i];
      for (_j = 0, _len1 = rowCells.length; _j < _len1; _j++) {
        cell = rowCells[_j];
        cell.merged = false;
        if (cell.value === 0) {
          this.numberCellHelper.push(cell);
        }
        showOneNumber(cell);
      }
    }
  };

  Board.prototype.updateCell = function(fx, fy, tx, ty, moveCellAnimate) {
    var isSameCell, startCell, targetCell;
    startCell = this.numberCells[fx][fy];
    targetCell = this.numberCells[tx][ty];
    isSameCell = startCell.value === targetCell.value;
    if (targetCell.value === 0 || isSameCell) {
      if (!this.noBlock(fx, fy, tx, ty)) {
        return false;
      }
      if (isSameCell) {
        if (targetCell.merged) {
          return false;
        }
        this.addScore += startCell.value;
        targetCell.merged = true;
      }
      moveCellAnimate(startCell, targetCell);
      targetCell.value += startCell.value;
      startCell.value = 0;
      if (isSameCell && this.topNumberValue < targetCell.value) {
        this.topNumberValue = targetCell.value;
      }
      return true;
    }
    return false;
  };

  Board.prototype.updateScore = function(updateScoreView) {
    if (this.addscore !== 0) {
      this.score += this.addScore;
      updateScoreView(this.score);
    }
  };

  Board.prototype.noBlock = function(x1, y1, x2, y2) {
    var x, y, _i, _j;
    if (y1 === y2) {
      if (x1 < x2) {
        x1 += 1;
      } else {
        x1 -= 1;
      }
      for (x = _i = x1; x1 <= x2 ? _i < x2 : _i > x2; x = x1 <= x2 ? ++_i : --_i) {
        if (this.numberCells[x][y1].value !== 0) {
          return false;
        }
      }
    } else {
      if (y1 < y2) {
        y1 += 1;
      } else {
        y1 -= 1;
      }
      for (y = _j = y1; y1 <= y2 ? _j < y2 : _j > y2; y = y1 <= y2 ? ++_j : --_j) {
        if (this.numberCells[x1][y].value !== 0) {
          return false;
        }
      }
    }
    return true;
  };

  Board.prototype.canMoveLeft = function() {
    var curCell, i, j, nextCell, _i, _j;
    for (i = _i = 0; _i < 4; i = ++_i) {
      for (j = _j = 1; _j < 4; j = ++_j) {
        curCell = this.numberCells[i][j];
        if (curCell.value !== 0) {
          nextCell = this.numberCells[i][j - 1];
          if (nextCell.value === 0 || curCell.value === nextCell.value) {
            return true;
          }
        }
      }
    }
    return false;
  };

  Board.prototype.canMoveRight = function() {
    var curCell, i, j, nextCell, _i, _j;
    for (i = _i = 0; _i < 4; i = ++_i) {
      for (j = _j = 3; _j > 0; j = --_j) {
        curCell = this.numberCells[i][j - 1];
        if (curCell.value !== 0) {
          nextCell = this.numberCells[i][j];
          if (nextCell.value === 0 || curCell.value === nextCell.value) {
            return true;
          }
        }
      }
    }
    return false;
  };

  Board.prototype.canMoveUp = function() {
    var curCell, i, j, nextCell, _i, _j;
    for (j = _i = 0; _i < 4; j = ++_i) {
      for (i = _j = 1; _j < 4; i = ++_j) {
        curCell = this.numberCells[i][j];
        if (curCell.value !== 0) {
          nextCell = this.numberCells[i - 1][j];
          if (nextCell.value === 0 || curCell.value === nextCell.value) {
            return true;
          }
        }
      }
    }
    return false;
  };

  Board.prototype.canMoveDown = function() {
    var curCell, i, j, nextCell, _i, _j;
    for (j = _i = 0; _i < 4; j = ++_i) {
      for (i = _j = 3; _j > 0; i = --_j) {
        curCell = this.numberCells[i - 1][j];
        if (curCell.value !== 0) {
          nextCell = this.numberCells[i][j];
          if (nextCell.value === 0 || curCell.value === nextCell.value) {
            return true;
          }
        }
      }
    }
    return false;
  };

  Board.prototype.moveLeft = function(moveCellAnimate) {
    var i, j, k, _i, _j, _k;
    if (!this.canMoveLeft()) {
      return false;
    }
    for (i = _i = 0; _i < 4; i = ++_i) {
      for (j = _j = 1; _j < 4; j = ++_j) {
        if (this.numberCells[i][j].value !== 0) {
          for (k = _k = 0; 0 <= j ? _k < j : _k > j; k = 0 <= j ? ++_k : --_k) {
            if (this.updateCell(i, j, i, k, moveCellAnimate)) {
              break;
            }
          }
        }
      }
    }
    return true;
  };

  Board.prototype.moveRight = function(moveCellAnimate) {
    var i, j, k, _i, _j, _k;
    if (!this.canMoveRight()) {
      return false;
    }
    for (i = _i = 0; _i < 4; i = ++_i) {
      for (j = _j = 2; _j >= 0; j = --_j) {
        if (this.numberCells[i][j].value !== 0) {
          for (k = _k = 3; 3 <= j ? _k < j : _k > j; k = 3 <= j ? ++_k : --_k) {
            if (this.updateCell(i, j, i, k, moveCellAnimate)) {
              break;
            }
          }
        }
      }
    }
    return true;
  };

  Board.prototype.moveUp = function(moveCellAnimate) {
    var i, j, k, _i, _j, _k;
    if (!this.canMoveUp()) {
      return false;
    }
    for (j = _i = 0; _i < 4; j = ++_i) {
      for (i = _j = 1; _j < 4; i = ++_j) {
        if (this.numberCells[i][j].value !== 0) {
          for (k = _k = 0; 0 <= i ? _k < i : _k > i; k = 0 <= i ? ++_k : --_k) {
            if (this.updateCell(i, j, k, j, moveCellAnimate)) {
              break;
            }
          }
        }
      }
    }
    return true;
  };

  Board.prototype.moveDown = function(moveCellAnimate) {
    var i, j, k, _i, _j, _k;
    if (!this.canMoveDown()) {
      return false;
    }
    for (j = _i = 0; _i < 4; j = ++_i) {
      for (i = _j = 2; _j >= 0; i = --_j) {
        if (this.numberCells[i][j].value !== 0) {
          for (k = _k = 3; 3 <= i ? _k < i : _k > i; k = 3 <= i ? ++_k : --_k) {
            if (this.updateCell(i, j, k, j, moveCellAnimate)) {
              break;
            }
          }
        }
      }
    }
    return true;
  };

  Board.prototype.gameOver = function(gameOverView) {
    if (this.topNumberValue === maxNumber) {
      return gameOverView(true, this.score);
    }
    if (!this.canMoveLeft() && !this.canMoveRight() && !this.canMoveUp() && !this.canMoveDown()) {
      return gameOverView(false, this.score);
    }
  };

  return Board;

})();
