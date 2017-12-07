math.randomseed(os.time())
local snake = {}

function loadSnake()
	for i = 1, 5 do
		snake[#snake+1] = {x=(5-i), y=0, dir="right", prevDir = "right"}
	end
end

function love.load()
	loadSnake()
end

local tilesize = 20
local widthRange = (love.graphics.getWidth() / tilesize) - 1
local heightRange = (love.graphics.getHeight() / tilesize) - 1

local function getRandomGridPoint()
	return math.random(0, widthRange), math.random(0, heightRange)
end

local fx, fy = getRandomGridPoint()
local food = {
	x = fx,
	y = fy,
	width = tilesize,
	height = tilesize
}

local timerMax = .08
local timer = timerMax
local dead = false

function addSnakePiece(x, y, dir)
	snake[#snake+1] = {
		x = x,
		y = y,
		dir = dir,
		prevDir = dir
	}
end

local canMove = true
function love.update(dt)
	love.window.setTitle("snake | score: " .. #snake)
	local firstBlock = snake[1]
	if timer > 0 then
		timer = timer - dt
	else
		timer = timerMax
		-- move snake blocks and change their directions
		for i = 1, #snake do
			local block = snake[i]
			if block.dir == "right" then
				block.x = block.x + 1
			elseif block.dir == "left" then
				block.x = block.x - 1
			elseif block.dir == "up" then
				block.y = block.y - 1
			elseif block.dir == "down" then
				block.y = block.y + 1
			end
			-- change every snake piece in the previous direction 
			-- of the piece in front of it
			if i >= 2 then
				block.prevDir = block.dir
				block.dir = snake[i-1].prevDir
			end
		end
		-- check if snake collided with itself
		for i = 2, #snake do
			local block = snake[i]
			if firstBlock.x == block.x and firstBlock.y == block.y then
				dead = true
			end
		end
		-- check if snake head collided with food
		if firstBlock.x == food.x and firstBlock.y == food.y then
			local lastBlock = snake[#snake]
			if lastBlock.dir == "right" then
				addSnakePiece(lastBlock.x - 1, lastBlock.y, "right")
			elseif lastBlock.dir == "left" then
				addSnakePiece(lastBlock.x + 1, lastBlock.y, "left")
			elseif lastBlock.dir == "up" then
				addSnakePiece(lastBlock.x, lastBlock.y + 1, "up")
			elseif lastBlock.dir == "down" then
				addSnakePiece(lastBlock.x, lastBlock.y - 1, "down")
			end
			food.x, food.y = getRandomGridPoint()
			love.timer.sleep(.5)
		end
		canMove = true
	end
	if dead or firstBlock.x < 0
	or firstBlock.x > widthRange
	or firstBlock.y < 0
	or firstBlock.y > heightRange then
		dead = false
		snake = {}
		love.timer.sleep(1.25)
		loadSnake()
		food.x, food.y = getRandomGridPoint()
		timerMax = timerMax - .005
		if timerMax < .03 then
			timerMax = .03
		end
	end
end

function love.draw()
	-- draw snake pieces with negative padding
	for i = 1, #snake do
		if i == 1 then
			love.graphics.setColor(35, 245, 100)
		else
			love.graphics.setColor(220,220,255)
		end
		love.graphics.rectangle("fill", snake[i].x *tilesize+3, snake[i].y*tilesize+3, tilesize - 6, tilesize - 6)
	end
	love.graphics.setColor(235, 250, 90)
	love.graphics.rectangle("fill", food.x * tilesize + 3, food.y * tilesize + 3, tilesize - 6, tilesize - 6)

	love.graphics.setColor(255, 255, 255, 10)
	for y = 0, heightRange * tilesize, tilesize do
		for x = 0, widthRange * tilesize, tilesize do
			love.graphics.rectangle("line", x+1, y+1, tilesize-2, tilesize-2)
		end
	end
end

function love.keypressed(key)
	if ( key == "right" or key == "left" or key == "up" or key == "down" ) and canMove then
		if  not (snake[1].dir == "right" and key == "left" )
		and not (snake[1].dir == "left"  and key == "right")
		and not (snake[1].dir == "up"    and key == "down" )
		and not (snake[1].dir == "down"  and key == "up"   ) then
			snake[1].dir = key
		end
		snake[1].prevDir = snake[1].dir
		canMove = false
	end
	if key == "escape" then
		love.event.quit()
	end
end