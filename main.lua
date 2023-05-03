function love.load()
    math.randomseed(os.time())
    numbers = love.graphics.setNewFont(40)
    texts = love.graphics.setNewFont(20)
    x = 5 -- xcoords in cells
    y = 2
    das = 0 -- delay auto shift
    arr = 6 -- there be treasure (auto repeat rate)
    linesCleared = 0 -- keeps track of lines
    levels = 0 -- TGM LEVELS! go watch my video on tgm please itll explain everything
    dasdirection = 'right'
    bgImage = love.graphics.newImage("tetgrand.png")
    rotation = 1
    gravity = 0
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

function randomizer() --randomizes stuff
    local bag = {"l", "j", "s", "z", "t", "i", "o"}
    return pieces[bag[math.random(1, #bag)]]
    --return queue[1] --  the math
end

function holdPiece()
    local hold = {}
    table.insert(hold, currentPiece)
    --print(hold)
end

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
    for j = 1, 20 do -- scans rows
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
        end
    end
end

function applyPiece(piece)
    for i, v in ipairs(piece[rotation]) do
        grid[math.floor(y + v[2])][math.floor(x + v[1])] = 1 --
    end
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
            return false
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

function addGravity(speed)
    gravity = gravity + speed
    while gravity >= 60 do
        movePiece(currentPiece, 0, 1)  
        lockPiece()    
        gravity = gravity - 60
    end
end

function lockDelay()

end

function lockPiece()
    if isValidPiece(currentPiece) then
        if not isValidPiece(currentPiece, 0, 1) then
            applyPiece(currentPiece) -- "freezes" piece
            currentPiece = nextPiece -- assigns currentpiece to next piece
            nextPiece = randomizer() -- chooses next piece
            print(nextPiece)
            x = 5 -- back to spawn
            y = 2
            rotation = 1
            levels = levels + 1
        end
    end
end

function love.keypressed(key, scancode, isrepeat)
    if key == 'up' then
        rotatePiece()
    end
    if key == 'space' then
        holdPiece()
    end
end

function love.update()
    addGravity(1)
    movementControls()
    clearLine()
end


function love.draw()
    love.graphics.draw(bgImage, 0, 0)
    renderGrid()
    renderPiece(currentPiece)
    renderNext(nextPiece)
    love.graphics.setFont(texts)
    love.graphics.print('LINES', 270, 575)
    love.graphics.print('LEVEL', 465, 575)
    love.graphics.print(dasdirection, 0, 0)
    love.graphics.print(das, 0, 30)
    love.graphics.print(x, 100, 30)
    love.graphics.print(y, 100, 50)
    love.graphics.print(rotation, 100, 70)
    love.graphics.print(gravity, 100, 90)
    love.graphics.setFont(numbers)
    love.graphics.print(linesCleared, 275, 530)
    love.graphics.print(levels, 500, 530, align = 'right')
   
end