// Generated by CoffeeScript 1.7.1
define(['jQuery', 'board'], function($, Board) {
  'use strict';
  var App;
  return App = (function() {
    var endx, endy, gameProgress, localCurScore, localTimer, localTopScore, startx, starty, _ref;

    _ref = ['gameProgress', 'top-score', 'cur-score'], gameProgress = _ref[0], localTopScore = _ref[1], localCurScore = _ref[2];

    localTimer = null;

    startx = starty = endx = endy = 0;

    function App(level) {
      this.level = level;
      this.$loading = $('#J_loading');
      this.$gridContainer = $('#grid-container');
      this.$gridCells = $('.grid-cell');
      this.$gridGameOver = $('#J_gameover');
      this.$numberCellViews = $('.number-cell');
      this.$scoreView = $('#J_cur-score');
      this.$topScore = $('#J_top-score');
      this.$gameover = $('#J_gamestart');
      this.gridContainerWidth = 500;
      this.cellSideLength = 100;
      this.cellSpace = 20;
      this.borderRadius = 10;
      this.cellFontSize = 60;
      this.$loading.fadeOut();
      this.createResponeBoard();
      this.initEvent();
    }

    App.prototype.createResponeBoard = function() {
      var documentWidth, i, j, _i, _j;
      documentWidth = window.innerWidth;
      if (documentWidth < 500) {
        this.gridContainerWidth = documentWidth;
        this.cellSideLength = 0.2 * documentWidth;
        this.cellSpace = 0.04 * documentWidth;
        this.borderRadius = 0.02 * documentWidth;
        this.cellFontSize = 40;
        this.$gridContainer.css({
          width: this.gridContainerWidth,
          height: this.gridContainerWidth
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

    App.prototype.initEvent = function() {
      $(document).on('keydown', (function(_this) {
        return function(e) {
          switch (e.which) {
            case 37:
              e.preventDefault();
              return _this.moveCell('moveLeft');
            case 38:
              e.preventDefault();
              return _this.moveCell('moveUp');
            case 39:
              e.preventDefault();
              return _this.moveCell('moveRight');
            case 40:
              e.preventDefault();
              return _this.moveCell('moveDown');
            default:
              return false;
          }
        };
      })(this));
      this.$gridContainer.on({
        touchstart: (function(_this) {
          return function(e) {
            var touches, _ref1;
            touches = e.originalEvent.targetTouches[0];
            _ref1 = [touches.pageX, touches.pageY], startx = _ref1[0], starty = _ref1[1];
          };
        })(this),
        touchend: (function(_this) {
          return function(e) {
            var deltax, deltay, noMoveWidth, touches, _ref1, _ref2;
            touches = e.originalEvent.changedTouches[0];
            _ref1 = [touches.pageX, touches.pageY], endx = _ref1[0], endy = _ref1[1];
            _ref2 = [endx - startx, endy - starty], deltax = _ref2[0], deltay = _ref2[1];
            noMoveWidth = 0.3 * _this.gridContainerWidth;
            if (Math.abs(deltax) < noMoveWidth && Math.abs(deltay) < noMoveWidth) {
              return false;
            }
            if (Math.abs(deltax) >= Math.abs(deltay)) {
              _this.moveCell(deltax > 0 ? 'moveRight' : 'moveLeft');
            } else {
              _this.moveCell(deltay > 0 ? 'moveDown' : 'moveUp');
            }
          };
        })(this),
        touchmove: function(e) {
          e.preventDefault();
        }
      });
      this.$gameover.on('startGame', (function(_this) {
        return function(event, clicked) {
          _this.startGame(clicked);
        };
      })(this)).on('click', function() {
        $(this).trigger('startGame', [true]);
      }).trigger('startGame');
    };

    App.prototype.weixinEvent = function() {};

    App.prototype.startGame = function(clicked) {
      var history;
      this.isGameOver = false;
      clicked && this.$gridGameOver.hide();
      this.topScoreValue = localStorage.getItem(localTopScore) | 0;
      if (this.topScoreValue !== 0) {
        this.$topScore.text(this.topScoreValue);
      }
      history = JSON.parse(localStorage.getItem(gameProgress));
      if (clicked === true || history === null || +localStorage.getItem('isGameOver') === 1) {
        this.board = new Board(this.level);
        this.updateBoardView();
        this.showOneNumber();
        this.showOneNumber();
      } else {
        this.board = new Board(this.level, history);
        this.updateBoardView();
      }
      localStorage.setItem('isGameOver', 0);
    };

    App.prototype.updateBoardView = function() {
      this.board.updateScore((function(_this) {
        return function(score) {
          _this.$scoreView.text(score);
        };
      })(this));
      this.board.updateAllcells((function(_this) {
        return function(numberCell) {
          var cellNode, fontSize, posX, posY, value, x, y, _ref1;
          x = numberCell.x, y = numberCell.y, value = numberCell.value;
          cellNode = $(_this.$numberCellViews[x * 4 + y]);
          _ref1 = [_this.getPosLeft(x, y), _this.getPosTop(x, y)], posX = _ref1[0], posY = _ref1[1];
          if (value === 0) {
            return cellNode.css({
              width: 0,
              height: 0,
              lineHeight: 'normal',
              top: posY + _this.cellSideLength / 2,
              left: posX + _this.cellSideLength / 2,
              color: 'inherit',
              backgroundColor: 'transparent'
            }).text('');
          } else {
            fontSize = value === 64 || value === 16384 ? 0.8 * _this.cellFontSize : _this.cellFontSize;
            return cellNode.css({
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
        };
      })(this));
    };

    App.prototype.showOneNumber = function() {
      this.board.generateOneNumber((function(_this) {
        return function(numberCell, progress) {
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
          clearTimeout(localTimer);
          localTimer = setTimeout(function() {
            return localStorage.setItem(gameProgress, JSON.stringify(progress));
          }, 1000);
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
          localStorage.setItem('isGameOver', 1);
        };
      })(this));
    };

    return App;

  })();
});
