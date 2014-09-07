// Generated by CoffeeScript 1.7.1
define(function() {
  var Number;
  return Number = (function() {
    function Number(value, x, y) {
      this.value = value;
      this.x = x;
      this.y = y;
      this.merged = false;
    }

    Number.prototype.getColor = function() {
      if (this.value <= 4) {
        return '#776e65';
      } else {
        return '#fff';
      }
    };

    Number.prototype.getBgColor = function() {
      switch (this.value) {
        case 0:
          return 'transparent';
        case 2:
          return '#eee4da';
        case 4:
          return '#ede0c8';
        case 8:
          return '#f2b179';
        case 16:
          return '#f59563';
        case 32:
          return '#f67c5f';
        case 64:
          return '#f65e3b';
        case 128:
          return '#edcf72';
        case 256:
          return '#edcc61';
        case 512:
          return '#9c0';
        case 1024:
          return '#33b5e5';
        case 2048:
          return '#09c';
        case 4096:
          return '#a6c';
        case 8192:
          return '#93c';
        case 16384:
          return '#2E4E7E';
        case 32768:
          return '#FF2121';
      }
    };

    Number.prototype.getText = function() {
      switch (this.value) {
        case 2:
          return '夏';
        case 4:
          return '商';
        case 8:
          return '周';
        case 16:
          return '秦';
        case 32:
          return '汉';
        case 64:
          return '三国';
        case 128:
          return '晋';
        case 256:
          return '隋';
        case 512:
          return '唐';
        case 1024:
          return '宋';
        case 2048:
          return '元';
        case 4096:
          return '明';
        case 8192:
          return '清';
        case 16384:
          return '民国';
        case 32768:
          return 'PRC';
      }
    };

    Number.prototype.getFontSize = function() {
      if (this.value === 64 || this.value === 16384) {
        return 49;
      } else {
        return 60;
      }
    };

    Number.prototype.toString = function() {
      return this.value;
    };

    return Number;

  })();
});
