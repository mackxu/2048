class Board
	constructor: (opts) ->
		@numberCells = []
		@score = 0

		# 初始化棋盘数字
		for i in [0...4]
			@numberCells[i] = []
			for j in [0...4]
				@numberCells[i][j] = new Number(0, i, j)

	generateOneNumber: () ->
		# return false if (@noSpace())
		times = 0
		# 获取随机位置
		randX = +Math.floor(Math.random() * 4)
		randY = +Math.floor(Math.random() * 4)
		randNumberCell = @numberCells[randX][randY]
		while(true)
			times += 1
			if randNumberCell.value is 0 
				break
			randX = +Math.floor(Math.random() * 4)
			randY = +Math.floor(Math.random() * 4)
		# console.log times + 'times'
		# 在随机位置上显示随机数字
		randNumberCell.value = if Math.random() < 0.9 then 2 else 4
		return randNumberCell
	
	# 更新numberCells, 并用回调显示到界面里
	updateNumbercells: (showOneNumber) ->
		for rowCells in @numberCells
			for cell in rowCells
				cell.merged = false
				showOneNumber cell
		return
	
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
				prevCell = @numberCells[i][j-1]
				curCell = @numberCells[i][j]
				
				if prevCell.value is 0 or curCell.value is prevCell.value
					return true 
		return false
					
	canMoveRight: () ->
		for i in [0...4]
			for j in [3...0]
				prevCell = @numberCells[i][j]
				curCell = @numberCells[i][j-1]

				if prevCell.value is 0 or curCell.value is prevCell.value
					return true 
		return false
	canMoveUp: () ->
		for j in [0...4]
			for i in [1...4]			
				prevCell = @numberCells[i-1][j]
				curCell = @numberCells[i][j]

				if prevCell.value is 0 or curCell.value is prevCell.value
					return true
		return false
	canMoveDown: () ->
		for j in [0...4]
			for i in [3...0]			
				prevCell = @numberCells[i][j]
				curCell = @numberCells[i-1][j]
				if prevCell.value is 0 or curCell.value is prevCell.value
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

	moveCell: (fx, fy, tx, ty, moveCellAnimate) ->
		# 如果两个数字块相等
		startCell = @numberCells[fx][fy]
		targetCell = @numberCells[tx][ty]
		isSameCell = startCell.value is targetCell.value
		if targetCell.value is 0 or isSameCell
			# 数据块之间有障碍物, 返回false
			# return false if not @noBlock startCell, targetCell		

			if isSameCell								# 两个数字块的值相等			
				return false if targetCell.merged 		# 如果已经有合并, 本目标元素不合适
				@score += startCell.value				# 数字合并, 奖励分数
				targetCell.merged = true				# 标记本航道已经有数字相加了
			
			targetCell.value += startCell.value
			startCell.value = 0
			# console.log startCell, targetCell
			# moveCellAnimate startCell, targetCell
			return true
		return false

	moveLeft: (moveCellAnimate) ->	
		# return false unless @canMoveLeft()

		for i in [0...4]			
			for j in [1...4]
				startCell = @numberCells[i][j]			
				if startCell.value isnt 0					
					for k in [0...j]					
						targetCell = @numberCells[i][k]
						# 如果数字块滑动成功
						if @moveCell i, j, i, k, moveCellAnimate then break else continue			
		return true
	
	moveRight: (moveCellAnimate) ->
		# return false unless @canMoveRight()

		for i in [0...4]
			for j in [2..0]
				startCell = @numberCells[i][j]
				if startCell.value isnt 0			# 待滑动数字块
					for k in [3...j]
						targetCell = @numberCells[i][k]
						if @moveCell i, j, i, k, moveCellAnimate then break else continue
		return true
	
	moveUp: (moveCellAnimate) ->
		return false unless @canMoveLeft()

		for j in [0...4]			
			for i in [1...4]
				startCell = @numberCells[i][j]			
				if startCell.value isnt 0					
					for k in [0...i]					
						targetCell = @numberCells[k][j]
						if @moveCell i, j, k, j, moveCellAnimate then break else continue
		return true

	moveDown: (moveCellAnimate) ->
		moveCells = []
		return false unless @canMoveDown()

		for j in [0...4]			
			for i in [2..0]
				startCell = @numberCells[i][j]			
				if startCell.value isnt 0					
					for k in [3...i]					
						targetCell = @numberCells[k][j]
						if @moveCell i, j, k, j, moveCellAnimate then break else continue
		return true
						




					
			
		


		
	
