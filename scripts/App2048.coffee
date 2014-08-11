class App
	constructor: (@$gridContainer) ->
	
		@$gridCells = $('.grid-cell')					# 所有棋盘格集合
		@$gridGameOver = $('#J_gameover')				# 游戏结束的遮罩
		@$numberCellViews = $('.number-cell');			# 获取所有数字块
		@$scoreView = $('#J_score')						# 得分视图

		# 默认视图尺寸
		@gridContainerWidth = 460
		@cellSideLength = 100
		@cellSpace = 20
		@borderRadius = 10

		@cellFontSize = 60

		# 准备响应式的面板
		@createResponeBoard()
		
		# 游戏开始
		@startGame()
		
	startGame: () -> 
		@board = new Board()
		@isGameOver = false
		# 玩家gameover时, 隐藏遮罩
		@$gridGameOver.css display: 'none'
		
		@updateBoardView()
		@showOneNumber()
		@showOneNumber()
		return
	
	createResponeBoard: () ->
		documentWidth = window.screen.availWidth

		# 动态生成棋盘格
		for i in [0...4]
			for j in [0...4]
				$(@$gridCells[4 * i + j]).css(
					
					top: @getPosTop(i, j)
					left: @getPosLeft(i, j)
				)

		# 移动设备的参数, 调整视图
		if documentWidth < 500 
			@gridContainerWidth = 0.92 * documentWidth
			@cellSideLength = 0.2 * documentWidth
			@cellSpace = 0.04 * documentWidth
			@borderRadius = 0.02 * documentWidth

			@cellFontSize = 40
			# 棋盘外围框架
			@$gridContainer.css({
				width: @gridContainerWidth
				height: @gridContainerWidth
				borderRadius: @borderRadius
			})
			# 棋盘格
			@$gridCells.css(
				width: @cellSideLength
				height: @cellSideLength
				borderRadius: @borderRadius
			)
			# 调整遮罩的行高和圆角大小
			@$gridGameOver.css(
				lineHeight: @gridContainerWidth + 'px'
				borderRadius: @borderRadius
			) 
		return

	updateBoardView: () ->
		# 刷新战绩榜
		@board.updateScore((score) =>
			@$scoreView.text(score)
			return
		)
		@board.updateAllcells( (numberCell) => 
			{ x, y, value } = numberCell
			cellNode = $("#number-cell-#{x}-#{y}").css('display', 'none')
			# cellNode = $(@$numberCellViews[x * 4 + y])
			[posX, posY] = [@getPosLeft(x, y), @getPosTop(x, y)]
			
			if value is 0
				cellNode.css({
					width: 0
					height: 0
					lineHeight: 'normal'
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
					fontSize: @cellFontSize
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
				@showOneNumber()			# 拥有50ms的动画
				return			
			, 300)
			setTimeout( =>
				@gameOver()
				return			
			, 380)	
		return
				
	showOneNumber:() ->
		@board.generateOneNumber( (numberCell) =>
			# 动画显示一个数字块
			{ x, y, value } = numberCell
			
			$(@$numberCellViews[x * 4 + y])
				.css({
					lineHeight: @cellSideLength + 'px'
					fontSize: @cellFontSize
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
	gameOver: () ->
		# 不管成功或失败, 显示游戏结束时的视图
		@board.gameOver( (goodWork) =>
			@$gridGameOver
				.css( display: 'block' )
				.text if goodWork then 'You Win!' else 'You Lose!'
			return
		)
		return

# 执行程序
$ -> 
	$gridContainer = $('#grid-container')
	appGame = new App($gridContainer)
	startx = starty = endx = endy = 0
	$(document).on('keydown', (e) ->
		switch e.which
			when 37
				e.preventDefault()
				appGame.moveCell('moveLeft')
			when 38
				e.preventDefault()
				appGame.moveCell('moveUp')
			when 39
				e.preventDefault()
				appGame.moveCell('moveRight')
			when 40
				e.preventDefault()
				appGame.moveCell('moveDown')
			else 
				false
	)

	$gridContainer.on(
		touchstart: (e) ->
			#
			touches = e.originalEvent.targetTouches[0]
			[startx, starty] = [touches.pageX, touches.pageY]

		touchend: (e) ->
			#
			touches = e.originalEvent.changedTouches[0]
			[endx, endy] = [touches.pageX, touches.pageY]

			# 判断滑动方向, 并执行滑动
			[deltax, deltay] = [endx - startx, endy - starty]
			# 过滤不成功的滑动
			return false if Math.abs(deltax) < 0.3 * appGame.gridContainerWidth and Math.abs(deltay) < 0.3 * appGame.gridContainerWidth
			if Math.abs(deltax) >= Math.abs(deltay)
				appGame.moveCell if deltax > 0 then 'moveRight' else 'moveLeft'
			else
				appGame.moveCell if deltay > 0 then 'moveDown' else 'moveUp'
			return
		touchmove: (e) ->
			e.preventDefault()
	)

	$('#J_gamestart').click () ->
		appGame.startGame()
	return