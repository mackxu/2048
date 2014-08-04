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
	
	# updateBoardView: () ->
	# 	# 动画后, 根据最新数值重绘所有数字块
	# 	for rowCells, i in @numberCells
	# 		for cell, j in rowCells
	# 			cellNode = $("#number-cell-#{i}-#{j}").css('display', 'none')
	# 			number = cell.value
	# 			if number is 0
	# 				cellNode.css({
	# 					width: 0
	# 					height: 0
	# 					top: @getPosTop(i, j) + @cellSideLength / 2
	# 					left: @getPosLeft(i, j) + @cellSideLength / 2
	# 				}).text('')
	# 			else 
	# 				cellNode.css({
	# 					width: @cellSideLength
	# 					height: @cellSideLength
	# 					lineHeight: @cellSideLength + 'px'
	# 					top: @getPosTop(i, j)
	# 					left: @getPosLeft(i, j)
	# 					color: cell.getColor()
	# 					backgroundColor: cell.getBgColor() 
	# 				}).text(number)
	# 			cellNode.css('display', 'block')
	# 	return
	updateBoardView: () ->
		@board.updateNumbercells( (numberCell) => 
			{ x, y } = numberCell
			cellNode = $("#number-cell-#{x}-#{y}").css('display', 'none')
			number = numberCell.value
			if number is 0
				cellNode.css({
					width: 0
					height: 0
					top: @getPosTop(x, y) + @cellSideLength / 2
					left: @getPosLeft(x, y) + @cellSideLength / 2
				}).text('')
			else 
				cellNode.css({
					width: @cellSideLength
					height: @cellSideLength
					lineHeight: @cellSideLength + 'px'
					top: @getPosTop(x, y)
					left: @getPosLeft(x, y)
					color: numberCell.getColor()
					backgroundColor: numberCell.getBgColor() 
				}).text(number)
			cellNode.css('display', 'block')
			return
		)
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
	
	
	moveCell: (moveAction) ->
		canMove = @board[moveAction]( => 
			@showMoveNumber arguments
			return
		)
		if canMove
			# 刷新棋盘格
			setTimeout( =>
				@updateBoardView()
				return 
			, 500)

			setTimeout( => 
				@showOneNumber()
				return
			, 750)
		return
			
	
	showOneNumber: () ->
		# console.log RandNumberCell = @board.generateOneNumber()
		if(numberCell = @board.generateOneNumber())
			i = numberCell.x
			j = numberCell.y

			$("#number-cell-#{i}-#{j}")
				.css({
					color: numberCell.getColor()
					backgroundColor: numberCell.getBgColor()
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
		start = moveCells[0]
		end = moveCells[1]
		# console.log start, end
		$("#number-cell-#{start.x}-#{start.y}")
			.animate({
				top: @getPosTop(end.x, end.y)
				left: @getPosLeft(end.x, end.y)
				}, 200)
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
				appGame.moveCell('moveLeft')
				setTimeout( -> 
					appGame.isGameOver()
					return
				, 300)
				return
			when 38
				appGame.moveCell('moveUp')
				setTimeout( -> 
					appGame.isGameOver()
					return
				, 300)
				return
			when 39
				appGame.moveCell('moveRight')
				setTimeout( -> 
					appGame.isGameOver()
					return
				, 300)
				return
			when 40
				appGame.moveCell('moveDown')
				setTimeout( -> 
					appGame.isGameOver()
					return
				, 300)
				return
			else 
				false	
	)
	appGame.startGame()

	$('#newgamebutton').click () ->
		appGame.startGame()
	return