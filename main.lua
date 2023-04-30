function love.load()
    x = 4
    y = 1
    das = 0
    arr = 6
    dasdirection = 'right'
    bgImage = love.graphics.newImage("tetgrand.png")
    rotation = 1
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
                            
    }
    currentPiece = pieces.i
end


function renderGrid()
    for i = 1, 20 do
        for j = 1, 10 do
            if grid[i][j] == 1 then
                love.graphics.rectangle("line", j * 25 + 250, i * 25, 25, 25)
            end
        end
    end
end

function rotatePiece()
    rotation = rotation % 4 + 1
end

function lockPiece(piece)
    for i, v in ipairs(piece[rotation]) do
        grid[math.floor(y + v[2])][math.floor(x + v[1])] = 1
    end
end

function isValidPiece(piece, offsetX, offsetY)
    offsetX = offsetX or 0
    offsetY = offsetY or 0
    for i, v in ipairs(piece[rotation]) do
        if math.floor(y + v[2] + offsetY) > 20 
        or math.floor(y + v[2] + offsetY) < 1 
        or math.floor(x + v[1] + offsetX) > 10
        or math.floor(x + v[1] + offsetX) < 1
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
        love.graphics.rectangle("fill", math.floor(x + v[1]) * 25 + 250, math.floor(y + v[2]) * 25, 25, 25)
    end
    
end

function movePiece(piece, offsetX, offsetY)
    if isValidPiece(piece, offsetX, offsetY) then
        x = x + offsetX
        y = y + offsetY
    end
end

function movementControls()
    if love.keyboard.isDown('left') then
        dasdirection = 'left'
        if dasdirection == 'left' then
            das = das + 1 --this is right
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
        movePiece(currentPiece, 0, 0.4)
    end
end

function love.keypressed(key, scancode, isrepeat)
    if key == 'space' then
        if isValidPiece(currentPiece) then
            lockPiece(currentPiece)
            x = 4
            y = 1
        end
    elseif key == 'up' then
        rotatePiece()
    end
end

--function horizontalControls()

--end

function love.update()
    movementControls()
end


function love.draw()
    love.graphics.draw(bgImage, 0, 0)
    --love.graphics.draw(dave, x, y)
    renderGrid()
    renderPiece(currentPiece)
    love.graphics.print(dasdirection, 0, 0)
    love.graphics.print(das, 0, 30)
    love.graphics.print(x, 100, 30)
    love.graphics.print(y, 100, 50)
    love.graphics.print(rotation, 100, 70)
end