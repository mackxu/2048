class Board
	maxNumber = 32768
	constructor: (localData) ->
		@numberCells = []				# 存放二维数组
		@numberCellHelper = []			# 一维数组, 动态存放值为0的数据块
		@topNumberValue = 0				# 记录数据块最大值
		
		@score = 0						# 总分数
		@addScore = 0					# 存储一次滑动得到的分数
		
		# 初始化棋盘数字
		if localData
			@score = localData.curScore	# 本地的分数
			for rowCells, i in localData.numberCells
				@numberCells[i] = []
				for cell, j in rowCells
					@numberCells[i][j] = new Number cell.value, i, j
		else
			for i in [0...4]
				@numberCells[i] = []
				for j in [0...4]
					@numberCells[i][j] = new Number 0, i, j 

	generateOneNumber: (showNumberAnimate) ->
		availCellNum = @numberCellHelper.length
		
		# 当数字块排满的时
		return false if availCellNum is 0
		# 获取随机位置(Math.random() * availCellNum) | 0
		randNumberCell = @numberCellHelper[(Math.random() * availCellNum) | 0]
		# 在随机位置上显示随机数字
		randNumberCell.value = if Math.random() < 0.9 then 2 else 4
		
		showNumberAnimate? randNumberCell, @numberCells, @score
		return true
	
	# 把每个数据在数据块内显示
	updateAllcells: (showOneNumber) ->
		@numberCellHelper = []							# 清空之前的内容
		@addScore = 0									# 清空上次滑动获得的分数
		for rowCells in @numberCells
			for cell in rowCells
				cell.merged = false
				# 存放值为0的数字块对象
				@numberCellHelper.push(cell) if cell.value is 0
				showOneNumber cell
		return
	
	updateCell: (fx, fy, tx, ty, moveCellAnimate) ->
		# 如果两个数字块相等
		startCell = @numberCells[fx][fy]
		targetCell = @numberCells[tx][ty]
		isSameCell = startCell.value is targetCell.value
		if targetCell.value is 0 or isSameCell
			# 数据块之间有障碍物, 返回false
			return false if not @noBlock fx, fy, tx, ty		

			if isSameCell								# 两个数字块的值相等			
				return false if targetCell.merged 		# 如果已经有合并, 本目标元素不合适
				@addScore += startCell.value			# 数字合并, 奖励分数
				targetCell.merged = true				# 标记本航道已经有数字相加了
			
			moveCellAnimate startCell, targetCell
			targetCell.value += startCell.value
			startCell.value = 0
			# 更新数据块最大值
			@topNumberValue = targetCell.value if isSameCell and @topNumberValue < targetCell.value			
			return true
		return false
	
	updateScore: (updateScoreView) ->
		# 更新战绩榜
		if @addscore isnt 0
			@score += @addScore
			updateScoreView @score
		return
	
	noBlock: (x1, y1, x2, y2) ->
		if y1 is y2
			if x1 < x2 then x1 += 1 else x1 -= 1
			for x in [x1...x2]
				# 如果不为0, 此路不通
				return false if @numberCells[x][y1].value isnt 0
		else
			if y1 < y2 then y1 += 1 else y1 -=1
			for y in [y1...y2]
				return false if @numberCells[x1][y].value isnt 0
		return true

	canMoveLeft: () ->
		# 向左滑动前，检查是否能滑动
		# 滑动规定：1. 2.
		for i in [0...4]
			for j in [1...4]		
				curCell = @numberCells[i][j]
				if curCell.value isnt 0
					nextCell = @numberCells[i][j-1]
					if nextCell.value is 0 or curCell.value is nextCell.value
						return true 
		return false
					
	canMoveRight: () ->
		for i in [0...4]
			for j in [3...0]
				curCell = @numberCells[i][j-1]
				if curCell.value isnt 0
					nextCell = @numberCells[i][j]
					if nextCell.value is 0 or curCell.value is nextCell.value
						return true 
		return false
	canMoveUp: () ->
		for j in [0...4]
			for i in [1...4]			
				curCell = @numberCells[i][j]
				if curCell.value isnt 0
					nextCell = @numberCells[i-1][j]
					if nextCell.value is 0 or curCell.value is nextCell.value
						return true
		return false
	canMoveDown: () ->
		for j in [0...4]
			for i in [3...0]			
				curCell = @numberCells[i-1][j]
				if curCell.value isnt 0
					nextCell = @numberCells[i][j]
					if nextCell.value is 0 or curCell.value is nextCell.value
						return true
		return false
	
	moveLeft: (moveCellAnimate) ->	
		return false unless @canMoveLeft()
		
		for i in [0...4]			
			for j in [1...4]			
				# 寻找值不为0的数据块, 并显示滑动动画
				if @numberCells[i][j].value isnt 0					
					for k in [0...j]					
						# 如果数字块能更新成功, 跳出该层循环
						# 寻找下一个值不为0的数字块
						break if @updateCell i, j, i, k, moveCellAnimate			
		return true
	
	moveRight: (moveCellAnimate) ->
		return false unless @canMoveRight()

		for i in [0...4]
			for j in [2..0]	
				if @numberCells[i][j].value isnt 0			# 待滑动数字块
					for k in [3...j]
						# 如果数字块能更新成功, 跳出该层循环
						# 寻找下一个值不为0的数字块
						break if @updateCell i, j, i, k, moveCellAnimate
		return true
	
	moveUp: (moveCellAnimate) ->
		return false unless @canMoveUp()

		for j in [0...4]			
			for i in [1...4]
				if @numberCells[i][j].value isnt 0					
					for k in [0...i]					
						# 如果数字块能更新成功, 跳出该层循环
						# 寻找下一个值不为0的数字块
						break if @updateCell i, j, k, j, moveCellAnimate
		return true

	moveDown: (moveCellAnimate) ->
		return false unless @canMoveDown()

		for j in [0...4]			
			for i in [2..0]
				if @numberCells[i][j].value isnt 0					
					for k in [3...i]					
						# 如果数字块能更新成功, 跳出该层循环
						# 寻找下一个值不为0的数字块
						break if @updateCell i, j, k, j, moveCellAnimate
		return true

	gameOver: (gameOverView) ->
		
		# 数字达到最大时, 赢得比赛。优于棋盘移动判断
		return gameOverView true, @score if @topNumberValue is maxNumber
		# 不能移动，比赛失败
		return gameOverView false, @score if not @canMoveLeft() and not @canMoveRight() and not @canMoveUp() and not @canMoveDown()
		return
		
						




					
			
		


		
	
