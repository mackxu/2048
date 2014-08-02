// Generated by CoffeeScript 1.7.1
var Number;

Number = (function() {
  function Number(value, x, y) {
    this.value = value;
    this.x = x;
    this.y = y;
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
      default:
        return '#000';
    }
  };

  return Number;

})();
