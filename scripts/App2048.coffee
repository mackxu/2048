class App
	constructor: (@$gridContainer) ->
		@cellSideLength = 100
		@cellSpace = 20
		@borderRadius = 10
		# 准备响应式的面板
		@createResponeBoard()

		
		@$numberCellViews = $('.number-cell');			# 获取所有数字块

		# 动态生成棋盘格
		$gridCellViews = $('.grid-cell');
		for i in [0...4]
			for j in [0...4]
				$($gridCellViews[4 * i + j]).css(
					width: @cellSideLength
					height: @cellSideLength
					borderRadius: @borderRadius
					top: @getPosTop(i, j)
					left: @getPosLeft(i, j)
				)
		
	startGame: () -> 
		@board = new Board()
		@updateBoardView()

		@showOneNumber()
		@showOneNumber()
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

	updateBoardView: () ->
		@board.updateAllcells( (numberCell) => 
			{ x, y, value } = numberCell
			cellNode = $("#number-cell-#{x}-#{y}").css('display', 'none')
			# cellNode = $(@$numberCellViews[x * 4 + y])
			[posX, posY] = [@getPosLeft(x, y), @getPosTop(x, y)]
			console.log posX, posY, value
			
			if value is 0
				cellNode.css({
					width: 0
					height: 0
					top: posY + @cellSideLength / 2
					left: posX + @cellSideLength / 2
					color: 'inherit'
					backgroundColor: 'transparent'
				}).text('')
			else 
				cellNode.css({
					width: @cellSideLength
					height: @cellSideLength
					lineHeight: @cellSideLength + 'px'
					top: posY
					left: posX
					color: numberCell.getColor()
					backgroundColor: numberCell.getBgColor() 
				}).text(value)
			cellNode.css('display', 'block')
		)
		return
	
	moveCell: (moveAction) ->
		canMove = @board[moveAction]( => 
			@showMoveNumber arguments
			return
		)
		if canMove
			# 每次滑动后, 刷新棋盘格并生成新数字块
			setTimeout( =>
				@updateBoardView()
				@showOneNumber()			
			, 300)	
		return
			
	
	showOneNumber:() ->
		@board.generateOneNumber( (numberCell) =>
			# 动画显示一个数字块
			{ x, y, value } = numberCell
			
			$(@$numberCellViews[x * 4 + y])
				.css({
					color: numberCell.getColor()
					backgroundColor: numberCell.getBgColor()
				})
				.text( value )
				.animate({
					width: @cellSideLength
					height: @cellSideLength
					top: @getPosTop(x, y)
					left: @getPosLeft(x, y)
				}, 50) 
			return
		)
		return

	showMoveNumber: (moveCells) ->
		start = moveCells[0]
		end = moveCells[1]
		
		$(@$numberCellViews[4 * start.x + start.y])
			.animate({
				top: @getPosTop(end.x, end.y)
				left: @getPosLeft(end.x, end.y)
			}, 200)
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