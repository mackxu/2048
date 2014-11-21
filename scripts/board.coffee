define ['number'], (Number) ->
	'use strict';
	class Board
		maxNumber = 32768
		gameLevel = level0: 0.1, level1: 0.5, level2: 0.9

		constructor: (@level, localData) ->
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
						# 把此处的初始值为0改为1
						# 用于获取用数组存储的数据 Math.log2(1) === 0
						@numberCells[i][j] = new Number 1, i, j 			 

		# generateOneNumber 职责不单一, 待优化
		generateOneNumber: (showNumberAnimate) ->
			# 剩余的数字块的长度
			availCellNum = @numberCellHelper.length
			# 当没有剩余数字块时
			return false if availCellNum is 0

			# 获取随机位置(Math.random() * availCellNum) | 0
			randomCell = @numberCellHelper[(Math.random() * availCellNum) | 0]
			# 在随机位置上显示随机数字(2或4)
			randomCell.value = if Math.random() < gameLevel[@level] then 2 else 4
			
			# 传递随机数字块和游戏进度(数字分布和当前得分)
			showNumberAnimate? randomCell, numberCells: @numberCells, curScore: @score
			return true
		
		# 把每个数据在数据块内显示
		updateAllcells: (showOneNumber) ->
			@numberCellHelper = []							# 清空之前的内容
			@addScore = 0									# 清空上次滑动获得的分数
			for rowCells in @numberCells
				for cell in rowCells
					cell.merged = false
					# 存放值为1的数字块对象
					@numberCellHelper.push(cell) if cell.value is 1
					showOneNumber cell
			return
		
		updateCell: (fx, fy, tx, ty, moveCellAnimate) ->
			# 如果两个数字块相等
			startCell = @numberCells[fx][fy]
			targetCell = @numberCells[tx][ty]
			isSameCell = startCell.value is targetCell.value
			if targetCell.value is 1 or isSameCell
				# 数据块之间有障碍物, 返回false
				return false if not @noBlock fx, fy, tx, ty		

				if isSameCell								# 两个数字块的值相等			
					return false if targetCell.merged 		# 如果已经有合并, 本目标元素不合适
					@addScore += startCell.value			# 数字合并, 奖励分数
					targetCell.merged = true				# 标记本航道已经有数字相加了
				
				moveCellAnimate startCell, targetCell
				targetCell.value += startCell.value
				startCell.value = 1
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
		
		noBlock: (fx, fy, tx, ty) ->
			if fy is ty
				if fx < tx then fx += 1 else fx -= 1
				for x in [fx...tx]
					# 如果不为1, 此路不通
					return false if @numberCells[x][fy].value isnt 1
			else
				if fy < ty then fy += 1 else fy -= 1
				for y in [fy...ty]
					return false if @numberCells[fx][y].value isnt 1
			return true

		canMoveLeft: () ->
			# 向左滑动前，检查是否能滑动
			# 滑动规定：1. 2.
			for i in [0...4]
				for j in [1...4]		
					curCell = @numberCells[i][j]
					if curCell.value isnt 1
						nextCell = @numberCells[i][j-1]
						if nextCell.value is 1 or curCell.value is nextCell.value
							return true 
			return false
						
		canMoveRight: () ->
			for i in [0...4]
				for j in [3...0]
					curCell = @numberCells[i][j-1]
					if curCell.value isnt 1
						nextCell = @numberCells[i][j]
						if nextCell.value is 1 or curCell.value is nextCell.value
							return true 
			return false
		canMoveUp: () ->
			for j in [0...4]
				for i in [1...4]			
					curCell = @numberCells[i][j]
					if curCell.value isnt 1
						nextCell = @numberCells[i-1][j]
						if nextCell.value is 1 or curCell.value is nextCell.value
							return true
			return false
		canMoveDown: () ->
			for j in [0...4]
				for i in [3...0]			
					curCell = @numberCells[i-1][j]
					if curCell.value isnt 1
						nextCell = @numberCells[i][j]
						if nextCell.value is 1 or curCell.value is nextCell.value
							return true
			return false
		
		moveLeft: (moveCellAnimate) ->	
			return false unless @canMoveLeft()
			
			for i in [0...4]			
				for j in [1...4]			
					# 寻找值不为1的数据块, 并显示滑动动画
					if @numberCells[i][j].value isnt 1					
						for k in [0...j]					
							# 如果数字块能更新成功, 跳出该层循环
							# 寻找下一个值不为0的数字块
							break if @updateCell i, j, i, k, moveCellAnimate			
			return true
		
		moveRight: (moveCellAnimate) ->
			return false unless @canMoveRight()

			for i in [0...4]
				for j in [2..0]	
					if @numberCells[i][j].value isnt 1			# 待滑动数字块
						for k in [3...j]
							# 如果数字块能更新成功, 跳出该层循环
							# 寻找下一个值不为0的数字块
							break if @updateCell i, j, i, k, moveCellAnimate
			return true
		
		moveUp: (moveCellAnimate) ->
			return false unless @canMoveUp()

			for j in [0...4]			
				for i in [1...4]
					if @numberCells[i][j].value isnt 1					
						for k in [0...i]					
							# 如果数字块能更新成功, 跳出该层循环
							# 寻找下一个值不为1的数字块
							break if @updateCell i, j, k, j, moveCellAnimate
			return true

		moveDown: (moveCellAnimate) ->
			return false unless @canMoveDown()

			for j in [0...4]			
				for i in [2..0]
					if @numberCells[i][j].value isnt 1					
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