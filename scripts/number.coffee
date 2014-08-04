class Number
	constructor: (@value, @x, @y) ->
		 @merged = false
	
	getColor: () ->
		if @value <= 4 then '#776e65' else '#fff';
	
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
			else '#000'