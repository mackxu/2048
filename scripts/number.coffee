define () ->
	class Number
		constructor: (@value, @x, @y) ->
			 @merged = false
		
		getColor: () ->
			if @value <= 4 then '#776e65' else '#fff';
		
		# 根据数值，返回背景色
		getBgColor: () ->
			switch @value
				when 0 then 'transparent'
				when 2 then '#eee4da'
				when 4 then '#ede0c8'
				when 8 then '#f2b179'
				when 16 then '#f59563'
				when 32 then '#f67c5f'
				when 64 then '#f65e3b'
				when 128 then '#edcf72'
				when 256 then '#edcc61'
				when 512 then '#9c0'
				when 1024 then '#33b5e5'
				when 2048 then '#09c'
				when 4096 then '#a6c'
				when 8192 then '#93c'
				when 16384 then '#2E4E7E'
				when 32768 then '#FF2121'

		# 根据数据值返回文本
		getText: () ->
			switch @value
				when 2 then '夏'
				when 4 then '商'
				when 8 then '周'
				when 16 then '秦'
				when 32 then '汉'
				when 64 then '三国'
				when 128 then '晋'
				when 256 then '隋'
				when 512 then '唐'
				when 1024 then '宋'
				when 2048 then '元'
				when 4096 then '明'
				when 8192 then '清'
				when 16384 then '民国'
				when 32768 then 'PRC'
		getFontSize: () ->
			if @value is 64 or @value is 16384 then 49 else 60
		# 当对象需要转换为字符串时, 调用该方法
		toString: () ->
			@value
		