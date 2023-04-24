function love.load()
    x = 400
    y = 50
    das = 0
    arr = 6
    dasdirection = 'right'
    bgImage = love.graphics.newImage("tetgrand.png")
end

function board()
    love.graphics.rectangle("fill", 300, 200, 200, 200)
end

function verticalControls()
    if love.keyboard.isDown('left') then
        dasdirection = 'left'
        if dasdirection == 'left' then
            das = das + 1 --this is right
            if das > 15 then
                x = x - 25
                das = das - arr
            elseif das == 1 then
                x = x - 25
            end
        end
    elseif love.keyboard.isDown('right') then
        dasdirection = 'right'
        if dasdirection == 'right' then
            das = das + 1 --this is right
            if das > 15 then
                x = x + 25
                das = das - arr
            elseif das == 1 then
                x = x + 25
            end
        end
    else 
        das = 0
    end
    --if love.keyboard.isDown('down') then
    --    y = y + 10
    --end
end

function board()
    if x > 500 then
        x = 500
    elseif x < 275 then
        x = 500
    if y > 520 then
        y > 520
end

function horizontalControls()
    if love.keyboard.isDown('down') then
        y = y + 10
    end
end

function daveMovement()
    
end

function love.update()
    verticalControls()
    horizontalControls()
end


function love.draw()
    love.graphics.draw(bgImage, 0, 0)
    --love.graphics.draw(dave, x, y)
    board()
    love.graphics.print(dasdirection, 0, 0)
    love.graphics.print(das, 0, 30)
    love.graphics.print(x, 100, 30)
    love.graphics.print(y, 100, 50)
    dave = love.graphics.rectangle("line", x, y, 25, 25)
end