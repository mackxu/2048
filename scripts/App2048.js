// Generated by CoffeeScript 1.7.1
var App;

App = (function() {
  function App($gridContainer) {
    this.$gridContainer = $gridContainer;
    this.$gridCells = $('.grid-cell');
    this.$gridGameOver = $('#J_gameover');
    this.$numberCellViews = $('.number-cell');
    this.$scoreView = $('#J_cur-score');
    this.$topScore = $('#J_top-score');
    this.gridContainerWidth = 460;
    this.cellSideLength = 100;
    this.cellSpace = 20;
    this.borderRadius = 10;
    this.cellFontSize = 60;
    this.createResponeBoard();
    this.startGame();
  }

  App.prototype.startGame = function() {
    this.board = new Board();
    this.isGameOver = false;
    this.$gridGameOver.css({
      display: 'none'
    });
    this.topScoreValue = localStorage.getItem('top-score') | 0;
    if (this.topScoreValue) {
      this.$topScore.text(this.topScoreValue);
    }
    this.updateBoardView();
    this.showOneNumber();
    this.showOneNumber();
  };

  App.prototype.createResponeBoard = function() {
    var documentWidth, i, j, _i, _j;
    documentWidth = window.screen.availWidth;
    if (documentWidth < 500) {
      this.gridContainerWidth = 0.92 * documentWidth;
      this.cellSideLength = 0.2 * documentWidth;
      this.cellSpace = 0.04 * documentWidth;
      this.borderRadius = 0.02 * documentWidth;
      this.cellFontSize = 40;
      this.$gridContainer.css({
        width: this.gridContainerWidth,
        height: this.gridContainerWidth,
        borderRadius: this.borderRadius
      });
      this.$gridCells.css({
        width: this.cellSideLength,
        height: this.cellSideLength,
        borderRadius: this.borderRadius
      });
      this.$gridGameOver.css({
        lineHeight: this.gridContainerWidth + 'px',
        borderRadius: this.borderRadius
      });
    }
    for (i = _i = 0; _i < 4; i = ++_i) {
      for (j = _j = 0; _j < 4; j = ++_j) {
        $(this.$gridCells[4 * i + j]).css({
          top: this.getPosTop(i, j),
          left: this.getPosLeft(i, j)
        });
      }
    }
  };

  App.prototype.updateBoardView = function() {
    this.board.updateScore((function(_this) {
      return function(score) {
        _this.$scoreView.text(score);
      };
    })(this));
    this.board.updateAllcells((function(_this) {
      return function(numberCell) {
        var cellNode, fontSize, posX, posY, value, x, y, _ref;
        x = numberCell.x, y = numberCell.y, value = numberCell.value;
        cellNode = $(_this.$numberCellViews[x * 4 + y]);
        _ref = [_this.getPosLeft(x, y), _this.getPosTop(x, y)], posX = _ref[0], posY = _ref[1];
        if (value === 0) {
          cellNode.css({
            width: 0,
            height: 0,
            lineHeight: 'normal',
            top: posY + _this.cellSideLength / 2,
            left: posX + _this.cellSideLength / 2,
            color: 'inherit',
            backgroundColor: 'transparent'
          }).text('');
        } else {
          fontSize = value === 64 || value === 16384 ? _this.cellFontSize * 0.8 : _this.cellFontSize;
          cellNode.css({
            width: _this.cellSideLength,
            height: _this.cellSideLength,
            lineHeight: _this.cellSideLength + 'px',
            fontSize: fontSize,
            top: posY,
            left: posX,
            color: numberCell.getColor(),
            backgroundColor: numberCell.getBgColor()
          }).text(numberCell.getText());
        }
        return cellNode.css('display', 'block');
      };
    })(this));
  };

  App.prototype.showOneNumber = function() {
    this.board.generateOneNumber((function(_this) {
      return function(numberCell) {
        var x, y;
        x = numberCell.x, y = numberCell.y;
        $(_this.$numberCellViews[x * 4 + y]).css({
          lineHeight: _this.cellSideLength + 'px',
          fontSize: _this.cellFontSize,
          color: numberCell.getColor(),
          backgroundColor: numberCell.getBgColor()
        }).text(numberCell.getText()).animate({
          width: _this.cellSideLength,
          height: _this.cellSideLength,
          top: _this.getPosTop(x, y),
          left: _this.getPosLeft(x, y)
        }, 50);
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
      return function(goodWork, curScoreValue) {
        if (curScoreValue > _this.topScoreValue) {
          localStorage.setItem('top-score', curScoreValue);
          _this.$topScore.text(curScoreValue);
        }
        _this.$gridGameOver.css({
          display: 'block'
        }).text(goodWork ? 'You Win!' : 'You Lose!');
      };
    })(this));
  };

  return App;

})();

$(function() {
  var $gridContainer, appGame, endx, endy, startx, starty;
  $gridContainer = $('#grid-container');
  appGame = new App($gridContainer);
  startx = starty = endx = endy = 0;
  $(document).on('keydown', function(e) {
    switch (e.which) {
      case 37:
        e.preventDefault();
        return appGame.moveCell('moveLeft');
      case 38:
        e.preventDefault();
        return appGame.moveCell('moveUp');
      case 39:
        e.preventDefault();
        return appGame.moveCell('moveRight');
      case 40:
        e.preventDefault();
        return appGame.moveCell('moveDown');
      default:
        return false;
    }
  });
  $gridContainer.on({
    touchstart: function(e) {
      var touches, _ref;
      touches = e.originalEvent.targetTouches[0];
      return _ref = [touches.pageX, touches.pageY], startx = _ref[0], starty = _ref[1], _ref;
    },
    touchend: function(e) {
      var deltax, deltay, noMoveWidth, touches, _ref, _ref1;
      touches = e.originalEvent.changedTouches[0];
      _ref = [touches.pageX, touches.pageY], endx = _ref[0], endy = _ref[1];
      _ref1 = [endx - startx, endy - starty], deltax = _ref1[0], deltay = _ref1[1];
      noMoveWidth = 0.3 * appGame.gridContainerWidth;
      if (Math.abs(deltax) < noMoveWidth && Math.abs(deltay) < noMoveWidth) {
        return false;
      }
      if (Math.abs(deltax) >= Math.abs(deltay)) {
        appGame.moveCell(deltax > 0 ? 'moveRight' : 'moveLeft');
      } else {
        appGame.moveCell(deltay > 0 ? 'moveDown' : 'moveUp');
      }
    },
    touchmove: function(e) {
      return e.preventDefault();
    }
  });
  $('#J_gamestart').click(function() {
    return appGame.startGame();
  });
});
