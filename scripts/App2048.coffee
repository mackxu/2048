define ['jQuery', 'board'], ($, Board) ->
	'use strict';
	class App
		# 私有变量
		[gameProgress, localTopScore, localCurScore] = ['gameProgress', 'top-score', 'cur-score']
		localTimer = null 			# 本地存储游戏进度的定时器

		startx = starty = endx = endy = 0
		# $$ = 
		# 	gameover: $('#J_gamestart')
		# 	gridContainer: $('#grid-container')

		# 获取页面元素, 添加事件监听器
		constructor: (@level) ->
		
			@$gridContainer = $('#grid-container')
			@$gridCells = $('.grid-cell')					# 所有棋盘格集合
			@$gridGameOver = $('#J_gameover')				# 游戏结束的遮罩
			@$numberCellViews = $('.number-cell');			# 获取所有数字块
			@$scoreView = $('#J_cur-score')					# 得分视图
			@$topScore = $('#J_top-score');					# 最高得分, 每次从本地存储中获取
			@$gameover = $('#J_gamestart')

			# 默认视图尺寸
			@gridContainerWidth = 500
			@cellSideLength = 100
			@cellSpace = 20
			@borderRadius = 10

			@cellFontSize = 60

			# 准备响应式的面板
			@createResponeBoard()
			# 添加事件监听器
			@initEvent()
		
		# 让数字块自适应设备
		createResponeBoard: () ->
			documentWidth = window.screen.availWidth

			# 移动设备的参数, 调整视图
			if documentWidth < 500 
				@gridContainerWidth = documentWidth
				@cellSideLength = 0.2 * documentWidth
				@cellSpace = 0.04 * documentWidth
				@borderRadius = 0.02 * documentWidth

				@cellFontSize = 40
				# 棋盘外围框架
				@$gridContainer.css({
					width: @gridContainerWidth
					height: @gridContainerWidth
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

			# 动态生成棋盘格
			for i in [0...4]
				for j in [0...4]
					$(@$gridCells[4 * i + j]).css(
						top: @getPosTop(i, j)
						left: @getPosLeft(i, j)
					)

			return

		# 添加监听事件
		initEvent: () ->
			# PC端使用上下左右键盘
			$(document).on('keydown', (e) =>
				switch e.which
					when 37
						e.preventDefault()
						@moveCell('moveLeft')
					when 38
						e.preventDefault()
						@moveCell('moveUp')
					when 39
						e.preventDefault()
						@moveCell('moveRight')
					when 40
						e.preventDefault()
						@moveCell('moveDown')
					else 
						false
			)
			# 为移动端添加touch事件
			@$gridContainer.on(
				touchstart: (e) =>
					#
					touches = e.originalEvent.targetTouches[0]
					[startx, starty] = [touches.pageX, touches.pageY]
					return

				touchend: (e) =>
					#
					touches = e.originalEvent.changedTouches[0]
					[endx, endy] = [touches.pageX, touches.pageY]

					# 判断滑动方向, 并执行滑动
					[deltax, deltay] = [endx - startx, endy - starty]
					# 过滤不成功的滑动
					noMoveWidth = 0.3 * @gridContainerWidth
					return false if Math.abs(deltax) < noMoveWidth and Math.abs(deltay) < noMoveWidth
					if Math.abs(deltax) >= Math.abs(deltay)
						@moveCell if deltax > 0 then 'moveRight' else 'moveLeft'
					else
						@moveCell if deltay > 0 then 'moveDown' else 'moveUp'
					return
				touchmove: (e) ->
					e.preventDefault()
					return
			)

			# 游戏从这里开始的, 用事件监听游戏开始
			@$gameover
				.on('startGame', ( event, clicked ) =>
					@startGame clicked
					return
				)
				.on('click', ->
					$(this).trigger 'startGame', [ true ]
					return
				).trigger 'startGame'						# 页面加载时, 游戏开始
			return

		weixinEvent: () ->
			return

		# 游戏开始
		startGame: ( clicked ) -> 
			
			@isGameOver = false
			# 玩家点击开始游戏时, 隐藏遮罩
			clicked and @$gridGameOver.css display: 'none'
			
			# 如果存在本地存储的最高得分记录, 就显示出来
			@topScoreValue = localStorage.getItem(localTopScore) | 0
			@$topScore.text @topScoreValue if @topScoreValue isnt 0
			
			# 获取游戏存档
			history = JSON.parse localStorage.getItem gameProgress
			# 判断是否是新开始的游戏
			if clicked is true or history is null or +localStorage.getItem('isGameOver') is 1
				@board = new Board @level
				@updateBoardView()
				@showOneNumber()
				@showOneNumber()
			else 
				@board = new Board @level, history
				@updateBoardView()

			# 解决由于本地存储带来的当用户重新打开游戏结束界面时没有提示游戏结束的信息问题.
			# 方案是, 如果游戏结束标记为1. 当上次游戏结束了再次打开界面时，重新开始游戏
			# 每次游戏开始, 标识游戏在进行0, 游戏失败为1
			localStorage.setItem 'isGameOver', 0 
			return

		updateBoardView: () ->
			# 刷新战绩榜
			@board.updateScore((score) =>
				@$scoreView.text(score)
				return
			)
			# 校正数据块视图
			@board.updateAllcells( (numberCell) => 
				{ x, y, value } = numberCell
				cellNode = $(@$numberCellViews[x * 4 + y]).css('display', 'none')
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
					# 设置内容有2个汉字的数字块的字体大小26px 
					fontSize = if value is 64 or value is 16384 then 0.8 * @cellFontSize else @cellFontSize
					cellNode.css({
						width: @cellSideLength
						height: @cellSideLength
						lineHeight: @cellSideLength + 'px'
						fontSize: fontSize
						top: posY
						left: posX
						color: numberCell.getColor()
						backgroundColor: numberCell.getBgColor() 
					}).text(numberCell.getText())
				cellNode.css('display', 'block')
			)
			return
		
		showOneNumber:() ->
			# numberCell 要显示的数字块
			# progress 将要存储到本地的游戏进度
			@board.generateOneNumber( (numberCell, progress) =>
				# 动画显示一个数字块
				{ x, y } = numberCell
				$(@$numberCellViews[x * 4 + y])
					.css({
						lineHeight: @cellSideLength + 'px'
						fontSize: @cellFontSize
						color: numberCell.getColor()
						backgroundColor: numberCell.getBgColor()
					})
					.text( numberCell.getText() )
					.animate({
						width: @cellSideLength
						height: @cellSideLength
						top: @getPosTop(x, y)
						left: @getPosLeft(x, y)
					}, 50)
				# 本地定时存储当前进度和当前得分 numberCells、curScore
				clearTimeout localTimer					# 清除还没执行的定时器, localTimer是私有属性
				localTimer = setTimeout( =>
					localStorage.setItem gameProgress, JSON.stringify progress
				, 1000)
				return
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
			@board.gameOver( (goodWork, curScoreValue) =>
				# 记录最高得分到本地
				if curScoreValue > @topScoreValue
					localStorage.setItem('top-score', curScoreValue)
					@$topScore.text curScoreValue
				# 显示结束界面
				@$gridGameOver
					.css( display: 'block' )
					.text if goodWork then 'You Win!' else 'You Lose!'
				localStorage.setItem 'isGameOver', 1
				return
			)
			return
