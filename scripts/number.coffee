define () ->
	'use strict';
	# 用对象存放数据
	dynasty = ['', '夏', '商', '周', '秦', '汉', '三国', '晋', '隋', '唐', '宋', '元', '明', '清', '民国', 'PRC']
	bgColors = ['transparent', '#eee4da', '#ede0c8', '#f2b179', '#f59563', '#f67c5f', '#f65e3b', '#edcf72', '#edcc61', '#9c0', '#33b5e5', '#09c', '#a6c', '#93c', '#2E4E7E', '#FF2121']
	class Number
		# 对象的属性: value、x、y、merged
		constructor: (@value, @x, @y) ->
			 @merged = false
		
		getColor: () ->
			if @value <= 4 then '#776e65' else '#fff';
		
		# 根据数值，返回背景色
		getBgColor: () ->
			bgColors[Math.ceil Math.log2(@value)]
		# 根据数据值返回文本
		getText: () ->
			dynasty[Math.ceil Math.log2(@value)]
		getFontSize: () ->
			if @value is 64 or @value is 16384 then 49 else 60
		# 当对象需要转换为字符串时, 调用该方法
		toString: () ->
			# 属性merge的值的改变是在两次滑动动作之间，因此在结构上看到的永远是false
			JSON.stringify(@)
		