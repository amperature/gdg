function love.load()
    x = 400
    y = 50
    das = 0
    arr = 6
    dasdirection = 'right'
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
                x = x - 40
                das = das - arr
            elseif das == 1 then
                x = x - 40
            end
        end
    elseif love.keyboard.isDown('right') then
        dasdirection = 'right'
        if dasdirection == 'right' then
            das = das + 1 --this is right
            if das > 15 then
                x = x + 40
                das = das - arr
            elseif das == 1 then
                x = x + 40
            end
        end
    else 
        das = 0
    end
    --if love.keyboard.isDown('down') then
    --    y = y + 10
    --end
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
    dave = love.graphics.rectangle("line", x, y, 40, 40)
    board()
    love.graphics.print(dasdirection, 0, 0)
    love.graphics.print(das, 0, 30)
end