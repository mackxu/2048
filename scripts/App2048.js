// Generated by CoffeeScript 1.7.1
var App;

App = (function() {
  function App($gridContainer) {
    var $gridCellViews, i, j, _i, _j;
    this.$gridContainer = $gridContainer;
    this.createResponeBoard();
    this.$numberCellViews = $('.number-cell');
    $gridCellViews = $('.grid-cell');
    for (i = _i = 0; _i < 4; i = ++_i) {
      for (j = _j = 0; _j < 4; j = ++_j) {
        $($gridCellViews[4 * i + j]).css({
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
    this.isGameOver = false;
    this.$gridGameOver.css({
      display: 'none'
    });
    this.updateBoardView();
    this.showOneNumber();
    this.showOneNumber();
  };

  App.prototype.createResponeBoard = function() {
    var documentWidth;
    this.gridContainerWidth = 460;
    this.cellSideLength = 100;
    this.cellSpace = 20;
    this.borderRadius = 10;
    documentWidth = window.screen.availWidth;
    this.$gridGameOver = $('#J_gameover');
    if (documentWidth < 500) {
      this.gridContainerWidth = 0.92 * documentWidth;
      this.cellSideLength = 0.2 * documentWidth;
      this.cellSpace = 0.04 * documentWidth;
      this.borderRadius = 0.02 * documentWidth;
      this.$gridContainer.css({
        width: this.gridContainerWidth,
        height: this.gridContainerWidth,
        borderRadius: this.borderRadius
      });
      this.$gridGameOver.css({
        lineHeight: this.gridContainerWidth
      });
    }
  };

  App.prototype.updateBoardView = function() {
    this.board.updateAllcells((function(_this) {
      return function(numberCell) {
        var cellNode, posX, posY, value, x, y, _ref;
        x = numberCell.x, y = numberCell.y, value = numberCell.value;
        cellNode = $("#number-cell-" + x + "-" + y).css('display', 'none');
        _ref = [_this.getPosLeft(x, y), _this.getPosTop(x, y)], posX = _ref[0], posY = _ref[1];
        if (value === 0) {
          cellNode.css({
            width: 0,
            height: 0,
            lineHeight: 0,
            top: posY + _this.cellSideLength / 2,
            left: posX + _this.cellSideLength / 2,
            color: 'inherit',
            backgroundColor: 'transparent'
          }).text('');
        } else {
          cellNode.css({
            width: _this.cellSideLength,
            height: _this.cellSideLength,
            lineHeight: _this.cellSideLength + 'px',
            top: posY,
            left: posX,
            color: numberCell.getColor(),
            backgroundColor: numberCell.getBgColor()
          }).text(value);
        }
        return cellNode.css('display', 'block');
      };
    })(this));
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
          _this.showOneNumber();
        };
      })(this), 300);
      setTimeout((function(_this) {
        return function() {
          _this.gameOver();
        };
      })(this), 380);
    }
  };

  App.prototype.showOneNumber = function() {
    this.board.generateOneNumber((function(_this) {
      return function(numberCell) {
        var value, x, y;
        x = numberCell.x, y = numberCell.y, value = numberCell.value;
        $(_this.$numberCellViews[x * 4 + y]).css({
          lineHeight: _this.cellSideLength + 'px',
          color: numberCell.getColor(),
          backgroundColor: numberCell.getBgColor()
        }).text(value).animate({
          width: _this.cellSideLength,
          height: _this.cellSideLength,
          top: _this.getPosTop(x, y),
          left: _this.getPosLeft(x, y)
        }, 50);
      };
    })(this));
  };

  App.prototype.showMoveNumber = function(moveCells) {
    var end, start;
    start = moveCells[0];
    end = moveCells[1];
    $(this.$numberCellViews[4 * start.x + start.y]).animate({
      top: this.getPosTop(end.x, end.y),
      left: this.getPosLeft(end.x, end.y)
    }, 200);
  };

  App.prototype.getPosLeft = function(i, j) {
    return this.cellSpace + j * (this.cellSpace + this.cellSideLength);
  };

  App.prototype.getPosTop = function(i, j) {
    return this.cellSpace + i * (this.cellSpace + this.cellSideLength);
  };

  App.prototype.gameOver = function() {
    this.board.gameOver((function(_this) {
      return function(goodWork) {
        _this.$gridGameOver.css({
          display: 'block'
        }).text(goodWork ? 'You Win!' : 'You Lose!');
      };
    })(this));
  };

  return App;

})();

$(function() {
  var $gridContainer, appGame;
  $gridContainer = $('#grid-container');
  appGame = new App($gridContainer);
  $(document).on('keydown', function(e) {
    e.preventDefault();
    switch (e.which) {
      case 37:
        return appGame.moveCell('moveLeft');
      case 38:
        return appGame.moveCell('moveUp');
      case 39:
        return appGame.moveCell('moveRight');
      case 40:
        return appGame.moveCell('moveDown');
      default:
        return false;
    }
  });
  appGame.startGame();
  $('#newgamebutton').click(function() {
    return appGame.startGame();
  });
});
