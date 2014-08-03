class Board
	# defaultNumber = {
	# 	value: 0,
	# 	size: 100,
	# 	posX: 0,
	# 	posY: 0
	# }
	constructor: (opts) ->
		@numberCells = []
		@score = 0
		# @numberCellPerp = $.extend([], defaultNumber, opts)
		# 初始化棋盘数字
		for i in [0...4]
			@numberCells[i] = []
			for j in [0...4]
				@numberCells[i][j] = new Number(0, i, j)

	generateOneNumber: () ->
		return false if (@noSpace())
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
		console.log times + 'times'
		# 在随机位置上显示随机数字
		randNumberCell.value = if Math.random() < 0.5 then 2 else 4
		return randNumberCell
	noSpace: () ->
		# 判断是否有空位显示新数字
		for i in [0...4]
			for j in [0...4]
				return true if @numberCells[i][j] is 0
		return false
	canMoveLeft: () ->
		# 向左滑动前，检查是否能滑动
		# 滑动规定：1. 2.
		for i in [0...4]
			for j in [1...4]
				if @numberCells[i][j].value != 0
					if @numberCells[i][j-1].value is 0 or @numberCells[i][j-1].value is @numberCells[i][j].value
						return true 
		return false
					
	canMoveRight: () ->
		for rowCells in @numberCells
			for j in [3...0]
				# rowCells[j-1]是否能向右移动
				if rowCells[j-1].value isnt 0
					if rowCells[j].value is 0 or rowCells[j] is rowCells[j-1]
						return true 
		return false
	canMoveUp: () ->
		for j in [0...4]
			for i in [1...4]			
				prevCell = @numberCells[i-1][j]
				curCell = @numberCells[i][j]
				if prevCell is 0 or prevCell.value is curCell.value
					return true
		return false
	canMoveDown: () ->
		for j in [0...4]
			for i in [3...0]			
				prevCell = @numberCells[i][j]
				curCell = @numberCells[i-1][j]
				if prevCell is 0 or prevCell.value is curCell.value
					return true
		return false
	noBlock: (start, end) ->
		if start.x is end.x
			# 水平方向上的通路
			for y in [start.y...end.y]
				return @numberCells[start.x][y] isnt 0
		else 
			# 判断垂直方向是否通路
			for x in [start.x...end.x]
				return @numberCells[x][start.y] isnt 0
		return true
	noMove: () ->
		# 不能移动，游戏结束

	moveLeft: () ->
		moveCells = []
		return false unless @canMoveLeft()

		for i in [0...4]			
			merged = false					# 保证每个航道最多有一个数字相加
			for j in [1...4]
				startCell = @numberCells[i][j]			
				# console.log i, j
				if startCell.value != 0					
					for k in [0...j]					
						targetCell = @numberCells[i][k]
						isSameCell = targetCell.value is startCell.value
						if targetCell.value is 0 or isSameCell
							if @noBlock startCell, targetCell		
								# 此时可以移动
								if isSameCell					# 两个数字块的值相等			
									continue if merged			# 如果已经有合并, 进入下次循环
									@score += startCell.value	# 数字合并, 奖励分数
									merged = true				# 标记本航道已经有数字相加了
								targetCell.value += startCell.value
								startCell.value = 0
								moveCells.push(					# 记录该数字块的滑动目标,
									startCell: startCell
									endCell: targetCell
									)
								
								break							# 然后寻找本滑道下一个数字块														
		if moveCells.length isnt 0 then moveCells else false
	moveRight: () ->
		moveCells = []
		return false unless @canMoveRight()

		# 找到移动目标
		for rowCells in @numberCells
			merged = false
			for j in [3...0]
				startCell = rowCells[j-1]
				if startCell.value isnt 0			# 待滑动数字块
					for k in [3...j]
						targetCell = rowCells[k]
						isSameCell = targetCell.value is startCell.value
						if targetCell.value is 0 or isSameCell
							# 判断两者能否连通
							if @noBlock targetCell, startCell
								if isSameCell
									continue if merged
									@score += startCell.value	# 数字合并, 奖励分数
									merged = true				# 标记本航道已经有数字相加了
								targetCell.value += startCell.value
								startCell.value = 0
								moveCells.push(					# 记录该数字块的滑动目标,
									startCell: startCell
									endCell: targetCell
									)
								break

		if moveCells.length isnt 0 then moveCells else false
	moveUp: () ->
		moveCells = []
		return false unless @canMoveLeft()

		for j in [0...4]			
			merged = false					# 保证每个航道最多有一个数字相加
			for i in [1...4]
				startCell = @numberCells[i][j]			
				# console.log i, j
				if startCell.value != 0					
					for k in [0...i]					
						targetCell = @numberCells[k][j]
						isSameCell = targetCell.value is startCell.value
						if targetCell.value is 0 or isSameCell
							if @noBlock startCell, targetCell		
								# 此时可以移动
								if isSameCell					# 两个数字块的值相等			
									continue if merged			# 如果已经有合并, 进入下次循环
									@score += startCell.value	# 数字合并, 奖励分数
									merged = true				# 标记本航道已经有数字相加了
								targetCell.value += startCell.value
								startCell.value = 0
								moveCells.push(					# 记录该数字块的滑动目标,
									startCell: startCell
									endCell: targetCell
									)
								
								break							# 然后寻找本滑道下一个数字块														
		if moveCells.length isnt 0 then moveCells else false
	moveDown: () ->
		moveCells = []
		return false unless @canMoveDown()

		for j in [0...4]			
			merged = false					# 保证每个航道最多有一个数字相加
			for i in [3...0]
				startCell = @numberCells[i-1][j]			
				# console.log i, j
				if startCell.value != 0					
					for k in [3...i]					
						targetCell = @numberCells[k][j]
						isSameCell = targetCell.value is startCell.value
						if targetCell.value is 0 or isSameCell
							if @noBlock startCell, targetCell		
								# 此时可以移动
								if isSameCell					# 两个数字块的值相等			
									continue if merged			# 如果已经有合并, 进入下次循环
									@score += startCell.value	# 数字合并, 奖励分数
									merged = true				# 标记本航道已经有数字相加了
								targetCell.value += startCell.value
								startCell.value = 0
								moveCells.push(					# 记录该数字块的滑动目标,
									startCell: startCell
									endCell: targetCell
									)
								
								break							# 然后寻找本滑道下一个数字块														
		if moveCells.length isnt 0 then moveCells else false




					
			
		


		
	
