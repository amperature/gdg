function love.load()
    pausedText = 'Paused'
    paused = false
    bgmusic1 = love.audio.newSource("BROOKLINE.mp3", "stream")
    droppiece = love.audio.newSource("placePiece.wav", "static")
    clearLines = love.audio.newSource("clearLines.wav", "static")
    bgmusic1:setVolume(0.2)   
    droppiece:setVolume(0.3)
    clearLines:setVolume(0.3)
    backgrounds = {
        love.graphics.newImage('0.png'),
        love.graphics.newImage('1.png'),
        love.graphics.newImage('2.png'),
        love.graphics.newImage('3.png'),
        love.graphics.newImage('4.png'),     
    }
    math.randomseed(os.time())
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()
    numbers = love.graphics.setNewFont(40)
    texts = love.graphics.setNewFont(20)
    background = backgrounds[1]
    x = 5 -- xcoords in cells
    y = 2
    das = 0 -- delay auto shift
    arr = 6 -- there be treasure (auto repeat rate)
    linesCleared = 0 -- keeps track of lines
    levels = 0 -- TGM LEVELS! go watch my video on tgm please itll explain everything
    dasdirection = 'right' -- which way das is going
    board = love.graphics.newImage("tetgrand.png")
    rotation = 1
    gravity = 0
    lockDelay = 30
    piecenames = {'j', 'i', 'z', 'l', 'o', 't', 's',} -- the bag
    pieces = {
        i = {
            {{-1, 0}, {0, 0}, {1, 0}, {2, 0}},
            {{0, -1}, {0, 0}, {0, 1}, {0, 2}},
            {{-2, 0}, {-1, 0}, {0, 0}, {1, 0}},
            {{0, -2}, {0, -1}, {0, 0}, {0, 1}},
        },
        o = {
            {{0, 0}, {1, 0}, {0, 1}, {1, 1}},
            {{0, 0}, {1, 0}, {0, 1}, {1, 1}},
            {{0, 0}, {1, 0}, {0, 1}, {1, 1}},
            {{0, 0}, {1, 0}, {0, 1}, {1, 1}},
        },
        j = {
            {{-1, -1}, {-1, 0}, {0, 0}, {1, 0}},
            {{1, -1}, {0, -1}, {0, 0}, {0, 1}},
            {{-1, 0}, {0, 0}, {1, 0}, {1, 1}},
            {{0, -1}, {0, 0}, {0, 1}, {-1, 1}},
        },
        l = {
            {{1, -1}, {-1, 0}, {0, 0}, {1, 0}},
            {{0, -1}, {0, 0}, {0, 1}, {1, 1}},
            {{-1, 0}, {0, 0}, {1, 0}, {-1, 1}},
            {{0, -1}, {0, 0}, {0, 1}, {-1, -1}},
        },
        t = {
            {{0, -1}, {-1, 0}, {0, 0}, {1, 0}},
            {{0, -1}, {0, 0}, {0, 1}, {1, 0}},
            {{-1, 0}, {0, 0}, {1, 0}, {0, 1}},
            {{0, -1}, {0, 0}, {0, 1}, {-1, 0}},
        },        
        s = {
            {{1, -1}, {0, -1}, {0, 0}, {-1, 0}},
            {{0, -1}, {0, 0}, {1, 0}, {1, 1}},
            {{1, 0}, {0, 0}, {0, 1}, {-1, 1}},
            {{-1, -1}, {-1, 0}, {0, 0}, {0, 1}},
        },
        z = {
            {{-1, -1}, {0, -1}, {0, 0}, {1, 0}},
            {{1, -1}, {1, 0}, {0, 0}, {0, 1}},
            {{-1, 0}, {0, 0}, {0, 1}, {1, 1}},
            {{0, -1}, {0, 0}, {-1, 0}, {-1, 1}},
        }
    }
    grid = {
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        -- the grid. 0 = unoccupied, 1 = occupied                    
    }
    currentPiece = randomizer()
    nextPiece = randomizer()
end

local clock = os.clock
function sleep(n)  -- seconds
  local t0 = clock()
  while clock() - t0 <= n do end
end -- i borrowed this from lua-users.org

function randomizer() --randomizes stuff
    local bag = {"l", "j", "s", "z", "t", "i", "o"}
    return pieces[bag[math.random(1, #bag)]]
    --return queue[1] --  the math
end

-- function holdPiece()
--     local hold = {}
--     table.insert(hold, currentPiece)
--     --print(hold)
-- end

function renderGrid()
    for i = 1, 20 do
        for j = 1, 10 do
            if grid[i][j] == 1 then
                love.graphics.rectangle("fill", j * 25 + 250, i * 25, 25, 25)
            end
        end
    end
end

function clearLine()
    for j = 1, 20 do -- scans rows with j
        local hasHole = false -- tracks holes
        for i = 1, 10 do -- scans columns
            if grid[j][i] == 0 then
                hasHole = true
            end
        end
        if hasHole == false then -- clears lines and then reinserts them based on j many lines
            table.remove(grid, j)
            table.insert(grid, 1, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
            linesCleared = linesCleared + 1
            levels = levels + 1
            clearLines:play()
        end
    end
end

function applyPiece(piece)
    for i, v in ipairs(piece[rotation]) do
        grid[math.floor(y + v[2])][math.floor(x + v[1])] = 1 --
    end
    currentPiece = nextPiece -- assigns currentpiece to next piece
    nextPiece = randomizer() -- chooses next piece
    --print(nextPiece)
    x = 5 -- back to spawn
    y = 2
    rotation = 1
    levels = levels + 1
end



function getBackground()
    return backgrounds[math.floor(levels/100) % 4 + 1]
end


function isValidPiece(piece, offsetX, offsetY, newRotation)
    offsetX = offsetX or 0 --translateX
    offsetY = offsetY or 0 --translateY
    newRotation = newRotation or rotation --new rotation
    for i, v in ipairs(piece[newRotation]) do
        if math.floor(y + v[2] + offsetY) > 20 
        or math.floor(y + v[2] + offsetY) < 1 
        or math.floor(x + v[1] + offsetX) > 10
        or math.floor(x + v[1] + offsetX) < 1
        -- setting boundaries for movement
        then
            return false
        end
        if grid[math.floor(y + v[2] + offsetY)][math.floor(x + v[1] + offsetX)] == 1 then
            return false -- basically checking offsets and if they are occupied.
        end
    end
    return true
end

function renderPiece(piece)
    for i, v in ipairs(piece[rotation]) do
        love.graphics.rectangle(
            "fill", 
            math.floor(x + v[1]) * 25 + 250, -- x
            math.floor(y + v[2]) * 25, -- y
            25, -- width
            25 -- height
        )
    end 
end

function renderNext(piece)
    for i, v in ipairs(piece[1]) do
        love.graphics.rectangle("fill", v[1] * 25 + 550, v[2] * 25 + 80, 25, 25)
    end
end

function movePiece(piece, offsetX, offsetY)
    if isValidPiece(piece, offsetX, offsetY) then
        x = x + offsetX
        y = y + offsetY
    end
end

function rotatePiece()
    newRotation = rotation % 4 + 1
    if isValidPiece(currentPiece, 0, 0, newRotation) then
        rotation = newRotation 
    end
end

function movementControls()
    if love.keyboard.isDown('left') then
        dasdirection = 'left'
        if dasdirection == 'left' then
            das = das + 1 
            if das > 15 then
                movePiece(currentPiece, -1, 0)
                das = das - arr
            elseif das == 1 then
                movePiece(currentPiece, -1, 0)
            end
        end
    elseif love.keyboard.isDown('right') then
        dasdirection = 'right'
        if dasdirection == 'right' then
            das = das + 1 --this is right
            if das > 15 then
                movePiece(currentPiece, 1, 0)
                das = das - arr
            elseif das == 1 then
                movePiece(currentPiece, 1, 0)
            end
        end
    else 
        das = 0
    end
    if love.keyboard.isDown('down') then
        addGravity(30)
    end
end

function getSpeed()
    return math.min(math.max(1, math.floor(levels/40)), 60)
end

function addGravity(speed)
    gravity = gravity + speed
    while gravity >= 60 do
        movePiece(currentPiece, 0, 1)  
        gravity = gravity - 60
    end
    lockPiece()
end

function lockPiece()
    if isValidPiece(currentPiece) then
        if not isValidPiece(currentPiece, 0, 1) then
            lockDelay = lockDelay - 1
            if lockDelay == 0 then 
                applyPiece(currentPiece) -- "freezes" piece
                lockDelay = 30
                droppiece:play()
            end
        end
        if not isValidPiece(currentPiece, 0, 0) then
            sleep(2)
            love.event.quit('restart')
        end
    end
end

function love.keypressed(key, scancode, isrepeat)
    if key == 'up' then
        rotatePiece()
    end
    -- if key == 'space' then
    --     holdPiece()
    -- end
    if key == 'p' then
        if paused == false then 
            paused = true
        elseif paused == true then
            paused = false
        end
    end
end

function love.update()
    if paused == false then
        addGravity(getSpeed())
        movementControls()
        clearLine()
    end
end

function gameRunning()
    if paused == false then
        bgmusic1:play()
        renderGrid()
        renderPiece(currentPiece)
        renderNext(nextPiece)
    elseif paused == true then
        love.graphics.print(pausedText, 320, 240)
        bgmusic1:pause()
    end
end
 
function love.draw()
    love.graphics.draw(getBackground())
    love.graphics.draw(board, 0, 0)
    gameRunning()
    love.graphics.setFont(texts)
    love.graphics.print('LINES', 270, 575)
    love.graphics.print('SPEED', 465, 575)
    --below is debug stuff
    --love.graphics.print(das, 0, 0)
    --love.graphics.print(x, 100, 30)
    --love.graphics.print(y, 100, 50)
    --love.graphics.print(rotation, 100, 70)
    --love.graphics.print(lockDelay, 100, 90)
    love.graphics.setFont(numbers)
    love.graphics.print(linesCleared, 270, 530)
    love.graphics.print(levels, 460, 530)
end