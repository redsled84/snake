local snake = {}

function love.load()
	for i = 1, 5 do
		snake[#snake+1] = {x=(5-i), y=0, dir="right", prevDir = "right"}
	end
end

local tilesize = 16
local widthRange = (love.graphics.getWidth() / tilesize) - (love.graphics.getWidth() % tilesize)
local heightRange = (love.graphics.getHeight() / tilesize) - (love.graphics.getHeight() % tilesize)
local food = {
	x = math.random(0, widthRange),
	y = math.random(0, heightRange),
	width = tilesize,
	height = tilesize
}

local timerMax = .5
local timer = timerMax
local dead = false
function love.update(dt)
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
			if i >= 2 then
				block.prevDir = block.dir
				block.dir = snake[i-1].prevDir
			end
		end
		-- check if snake collided with itself
		for i = 2, #snake do
			local firstBlock = snake[1]
			local block = snake[i]
			if firstBlock.x == block.x and firstBlock.y == block.y then
				dead = true
			end
		end
	end
	if dead then
		love.graphics.setBackgroundColor(255,0,0)
		dead = false
	end
end

function love.draw()
	for i = 1, #snake do
		love.graphics.rectangle("fill", snake[i].x *tilesize+2, snake[i].y*tilesize+2, tilesize - 4, tilesize - 4)
	end
end

function love.keypressed(key)
	if key == "right" or key == "left" or key == "up" or key == "down" then
		if  not (snake[1].dir == "right" and key == "left" )
		and not (snake[1].dir == "left"  and key == "right")
		and not (snake[1].dir == "up"    and key == "down" )
		and not (snake[1].dir == "down"  and key == "up"   ) then
			snake[1].dir = key
		end
		snake[1].prevDir = snake[1].dir
	end
end