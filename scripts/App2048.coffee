class App

	constructor: (@$gridContainer) ->
		@cellSideLength = 100
		@cellSpace = 20
		@borderRadius = 10
		# 准备响应式的面板
		@createResponeBoard()

		# 动态生成棋盘格
		for i in [0...4]
			for j in [0...4]
				$("#grid-cell-#{i}-#{j}").css(
					width: @cellSideLength
					height: @cellSideLength
					borderRadius: @borderRadius
					top: @getPosTop(i, j)
					left: @getPosLeft(i, j)
				)
		
	startGame: () -> 
		@board = new Board()
		@numberCells = @board.numberCells
		@updateBoardView()

		setTimeout(=>
			@showOneNumber()
		, 25)
		setTimeout(=>
			@showOneNumber()
		, 25)
		return
	updateBoardView: () ->
		$('.number-cell').remove()
		for i in [0...4]
			for j in [0...4]
				numberCell = @numberCells[i][j]
				cellSideLength = @cellSideLength
				posX = @getPosLeft(i, j)
				posY = @getPosTop(i, j)
				if numberCell.value is 0
					posX += @cellSideLength / 2
					posY += @cellSideLength / 2
					cellSideLength = 0 

				$("<div class=\"number-cell\" id=\"number-cell-#{i}-#{j}\"></div>")
					.text(numberCell.value or '')
					.css({
						width: cellSideLength
						height: cellSideLength
						borderRadius: @borderRadius
						top: posY
						left: posX
						color: numberCell.getColor()
						backgroundColor: numberCell.getBgColor()
					}).appendTo(@$gridContainer)
		return
	
	createResponeBoard: () ->
		documentWidth = window.screen.availWidth
		if documentWidth > 499 
			documentWidth = 500
		gridContainerWidth = 0.92 * documentWidth
		@cellSideLength = 0.2 * documentWidth
		@cellSpace = 0.04 * documentWidth
		@borderRadius = 0.02 * documentWidth

		@$gridContainer.css({
			width: gridContainerWidth
			height: gridContainerWidth
			borderRadius: @borderRadius
		})
		return
	
	moveLeft: () -> 
		if(moveCells = @board.moveLeft())
			# 执行有滑动任务的数字块
			@showMoveNumber moveCell for moveCell in moveCells
			# 显示一个新的数字块
			# @showOneNumber()
			
			# 刷新棋盘格
			setTimeout( =>
				@updateBoardView()
			, 200)

			setTimeout( => 
				@showOneNumber()
			, 250)

			setTimeout( => 
				@isGameOver()
			, 300)
		return
	
	moveRight: () ->
		if(moveCells = @board.moveRight())
			# 执行有滑动任务的数字块
			@showMoveNumber moveCell for moveCell in moveCells
			# 显示一个新的数字块
			# @showOneNumber()
			
			# 刷新棋盘格
			setTimeout( =>
				@updateBoardView()
			, 200)

			setTimeout( => 
				@showOneNumber()
			, 250)

			setTimeout( => 
				@isGameOver()
			, 300)
		return 
	
	moveUp: () ->
		if(moveCells = @board.moveUp())
			# 执行有滑动任务的数字块
			@showMoveNumber moveCell for moveCell in moveCells
			# 显示一个新的数字块
			# @showOneNumber()
			
			# 刷新棋盘格
			setTimeout( =>
				@updateBoardView()
			, 200)

			setTimeout( => 
				@showOneNumber()
			, 250)

			setTimeout( => 
				@isGameOver()
			, 300)
		return 
	moveDown: () ->
		if(moveCells = @board.moveDown())
			# 执行有滑动任务的数字块
			@showMoveNumber moveCell for moveCell in moveCells
			# 显示一个新的数字块
			# @showOneNumber()
			
			# 刷新棋盘格
			setTimeout( =>
				@updateBoardView()
			, 200)

			setTimeout( => 
				@showOneNumber()
			, 250)

			setTimeout( => 
				@isGameOver()
			, 300)
		return 
	showOneNumber: () ->
		# console.log RandNumberCell = @board.generateOneNumber()
		if(RandNumberCell = @board.generateOneNumber())
			i = RandNumberCell.randX
			j = RandNumberCell.randY
			numberCell = RandNumberCell.numberCell
			bgColor = numberCell.getBgColor()
			color = numberCell.getColor()
			# console.log bgColor, color
			$("#number-cell-#{i}-#{j}")
				.css({
					color: color
					backgroundColor: bgColor
				})
				.text(numberCell.value)
				.animate({
					width: @cellSideLength
					height: @cellSideLength
					top: @getPosTop(i, j)
					left: @getPosLeft(i, j)
				}, 50) 
		return
	showMoveNumber: (moveCells) ->
		start = moveCells.startCell
		end = moveCells.endCell
		# console.log start, end
		$("#number-cell-#{start.x}-#{start.y}")
			# .animate({
			# 	top: @getPosTop(end.x, end.y)
			# 	left: @getPosLeft(end.x, end.y)
			# 	}, 200)
			.css({
				top: @getPosTop(end.x, end.y)
				left: @getPosLeft(end.x, end.y)
				})
		return
	getPosLeft: (i, j) ->
		@cellSpace + j * (@cellSpace + @cellSideLength) 
	getPosTop: (i, j) -> 
		@cellSpace + i * (@cellSpace + @cellSideLength)
	isGameOver: () ->
		#

# 执行程序
$ -> 
	$gridContainer = $('#grid-container')
	appGame = new App($gridContainer)
	$(document).on('keydown', (e) ->
		console.log e.which
		e.preventDefault()
		switch e.which
			when 37
				appGame.moveLeft()
			when 38
				appGame.moveUp()
			when 39
				appGame.moveRight()
			when 39
				appGame.moveDown()
			else 
				false	
	)
	appGame.startGame()

	$('#newgamebutton').click () ->
		appGame.startGame()
	return