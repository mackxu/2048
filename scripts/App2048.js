// Generated by CoffeeScript 1.7.1
var App;

App = (function() {
  function App($gridContainer) {
    var i, j, _i, _j;
    this.$gridContainer = $gridContainer;
    this.cellSideLength = 100;
    this.cellSpace = 20;
    this.borderRadius = 10;
    this.createResponeBoard();
    for (i = _i = 0; _i < 4; i = ++_i) {
      for (j = _j = 0; _j < 4; j = ++_j) {
        $("#grid-cell-" + i + "-" + j).css({
          width: this.cellSideLength,
          height: this.cellSideLength,
          borderRadius: this.borderRadius,
          top: this.getPosTop(i, j),
          left: this.getPosLeft(i, j)
        });
      }
    }
  }

  App.prototype.startGame = function() {
    this.board = new Board();
    this.numberCells = this.board.numberCells;
    this.updateBoardView();
    setTimeout((function(_this) {
      return function() {
        return _this.showOneNumber();
      };
    })(this), 25);
    setTimeout((function(_this) {
      return function() {
        return _this.showOneNumber();
      };
    })(this), 25);
  };

  App.prototype.updateBoardView = function() {
    var cell, cellNode, i, j, number, rowCells, _i, _j, _len, _len1, _ref;
    _ref = this.numberCells;
    for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
      rowCells = _ref[i];
      for (j = _j = 0, _len1 = rowCells.length; _j < _len1; j = ++_j) {
        cell = rowCells[j];
        cellNode = $("#number-cell-" + i + "-" + j).css('display', 'none');
        number = cell.value;
        if (number === 0) {
          cellNode.css({
            width: 0,
            height: 0,
            top: this.getPosTop(i, j) + this.cellSideLength / 2,
            left: this.getPosLeft(i, j) + this.cellSideLength / 2
          }).text('');
        } else {
          cellNode.css({
            width: this.cellSideLength,
            height: this.cellSideLength,
            top: this.getPosTop(i, j),
            left: this.getPosLeft(i, j),
            color: cell.getColor(),
            backgroundColor: cell.getBgColor()
          }).text(number);
        }
        cellNode.css('display', 'block');
      }
    }
  };

  App.prototype.createResponeBoard = function() {
    var documentWidth, gridContainerWidth;
    documentWidth = window.screen.availWidth;
    if (documentWidth > 499) {
      documentWidth = 500;
    }
    gridContainerWidth = 0.92 * documentWidth;
    this.cellSideLength = 0.2 * documentWidth;
    this.cellSpace = 0.04 * documentWidth;
    this.borderRadius = 0.02 * documentWidth;
    this.$gridContainer.css({
      width: gridContainerWidth,
      height: gridContainerWidth,
      borderRadius: this.borderRadius
    });
  };

  App.prototype.moveCell = function(moveAction) {
    var canMove;
    canMove = this.board[moveAction]((function(_this) {
      return function() {
        _this.showMoveNumber(arguments);
      };
    })(this));
    if (canMove) {
      setTimeout((function(_this) {
        return function() {
          _this.updateBoardView();
        };
      })(this), 500);
      setTimeout((function(_this) {
        return function() {
          _this.showOneNumber();
        };
      })(this), 750);
    }
  };

  App.prototype.showOneNumber = function() {
    var bgColor, color, i, j, numberCell;
    if ((numberCell = this.board.generateOneNumber())) {
      i = numberCell.x;
      j = numberCell.y;
      bgColor = numberCell.getBgColor();
      color = numberCell.getColor();
      $("#number-cell-" + i + "-" + j).css({
        color: numberCell.getColor(),
        backgroundColor: numberCell.getBgColor()
      }).text(numberCell.value).animate({
        width: this.cellSideLength,
        height: this.cellSideLength,
        top: this.getPosTop(i, j),
        left: this.getPosLeft(i, j)
      }, 50);
    }
  };

  App.prototype.showMoveNumber = function(moveCells) {
    var end, start;
    start = moveCells[0];
    end = moveCells[1];
    $("#number-cell-" + start.x + "-" + start.y).animate({
      top: this.getPosTop(end.x, end.y),
      left: this.getPosLeft(end.x, end.y)
    }, 200).css({
      top: this.getPosTop(end.x, end.y),
      left: this.getPosLeft(end.x, end.y)
    });
  };

  App.prototype.getPosLeft = function(i, j) {
    return this.cellSpace + j * (this.cellSpace + this.cellSideLength);
  };

  App.prototype.getPosTop = function(i, j) {
    return this.cellSpace + i * (this.cellSpace + this.cellSideLength);
  };

  App.prototype.isGameOver = function() {};

  return App;

})();

$(function() {
  var $gridContainer, appGame;
  $gridContainer = $('#grid-container');
  appGame = new App($gridContainer);
  $(document).on('keydown', function(e) {
    console.log(e.which);
    e.preventDefault();
    switch (e.which) {
      case 37:
        appGame.moveCell('moveLeft');
        setTimeout(function() {
          appGame.isGameOver();
        }, 300);
        break;
      case 38:
        appGame.moveCell('moveUp');
        setTimeout(function() {
          appGame.isGameOver();
        }, 300);
        break;
      case 39:
        appGame.moveCell('moveRight');
        setTimeout(function() {
          appGame.isGameOver();
        }, 300);
        break;
      case 40:
        appGame.moveCell('moveDown');
        setTimeout(function() {
          appGame.isGameOver();
        }, 300);
        break;
      default:
        return false;
    }
  });
  appGame.startGame();
  $('#newgamebutton').click(function() {
    return appGame.startGame();
  });
});
