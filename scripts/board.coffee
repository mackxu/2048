class Board
	constructor: (opts) ->
		@numberCells = []
		@score = 0

		# 初始化棋盘数字
		for i in [0...4]
			@numberCells[i] = []
			for j in [0...4]
				@numberCells[i][j] = new Number(0, i, j)

	generateOneNumber: (showNumberAnimate) ->
		return false if (@noSpace())
		# 获取随机位置
		randX = +Math.floor(Math.random() * 4)
		randY = +Math.floor(Math.random() * 4)		
		while(true)
			randNumberCell = @numberCells[randX][randY]
			# 如果获取的位置为空, 结束循环
			break if randNumberCell.value is 0 

			randX = +Math.floor(Math.random() * 4)
			randY = +Math.floor(Math.random() * 4)

		# 在随机位置上显示随机数字
		randNumberCell.value = if Math.random() < 0.9 then 2 else 4
		showNumberAnimate? randNumberCell
		return true
	
	# 把每个数据在数据块内显示
	updateAllcells: (showOneNumber) ->
		for rowCells in @numberCells
			for cell in rowCells
				cell.merged = false
				showOneNumber cell
		return
	
	updateCell: (fx, fy, tx, ty, moveCellAnimate) ->
		# 如果两个数字块相等
		startCell = @numberCells[fx][fy]
		targetCell = @numberCells[tx][ty]
		isSameCell = startCell.value is targetCell.value
		if targetCell.value is 0 or isSameCell
			# 数据块之间有障碍物, 返回false
			return false if not @noBlock startCell, targetCell		

			if isSameCell								# 两个数字块的值相等			
				return false if targetCell.merged 		# 如果已经有合并, 本目标元素不合适
				@score += startCell.value				# 数字合并, 奖励分数
				targetCell.merged = true				# 标记本航道已经有数字相加了
			
			targetCell.value += startCell.value
			startCell.value = 0
			# console.log startCell, targetCell
			moveCellAnimate startCell, targetCell
			return true
		return false

	updateCell: (fx, fy, tx, ty, moveCellAnimate) ->
		startCell = @numberCells[fx][fy]
		targetCell = @numberCells[tx][ty]

		if targetCell.value is 0 and @noBlock startCell, targetCell
			moveCellAnimate startCell, targetCell
			targetCell.value = startCell.value
			startCell.value = 0
			return true
		else if targetCell.value is startCell.value and @noBlock startCell, targetCell and not targetCell.merged
			moveCellAnimate startCell, targetCell
			targetCell.value += startCell.value
			targetCell.merged = true
			@score += startCell.value		
			startCell.value = 0
			return true
		return false
	noSpace: () ->
		# 判断是否有空位显示新数字
		for i in [0...4]
			for j in [0...4]
				return false if @numberCells[i][j].value is 0
		return true
	canMoveLeft: () ->
		# 向左滑动前，检查是否能滑动
		# 滑动规定：1. 2.
		for i in [0...4]
			for j in [1...4]
				nextCell = @numberCells[i][j-1]
				curCell = @numberCells[i][j]
				
				if nextCell.value is 0 or curCell.value is nextCell.value
					return true 
		return false
					
	canMoveRight: () ->
		for i in [0...4]
			for j in [3...0]
				nextCell = @numberCells[i][j]
				curCell = @numberCells[i][j-1]

				if nextCell.value is 0 or curCell.value is nextCell.value
					return true 
		return false
	canMoveUp: () ->
		for j in [0...4]
			for i in [1...4]			
				nextCell = @numberCells[i-1][j]
				curCell = @numberCells[i][j]

				if nextCell.value is 0 or curCell.value is nextCell.value
					return true
		return false
	canMoveDown: () ->
		for j in [0...4]
			for i in [3...0]			
				nextCell = @numberCells[i][j]
				curCell = @numberCells[i-1][j]
				if nextCell.value is 0 or curCell.value is nextCell.value
					return true
		return false
	noBlock: (start, end) ->
		if start.x is end.x
			# 判断水平方向上是否通路
			x = start.x
			if start.y < end.y
				y1 = start.y + 1
				y2 = end.y
			else 
				y1 = end.y + 1
				y2 = start.y

			for y in [y1...y2]
				return @numberCells[x][y] isnt 0
		else 
			# 判断垂直方向是否通路
			y = start.y
			if start.x < end.x
				x1 = start.x + 1
				x2 = end.x
			else
				x1 = end.x + 1
				x2 = start.x
			
			for x in [x1...x2]
				return @numberCells[x][y] isnt 0

		return true
	noMove: () ->
		# 不能移动，游戏结束
		if @canMoveLeft or @canMoveRight or @canMoveUp or @canMoveDown then false else true
	
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
						




					
			
		


		
	
