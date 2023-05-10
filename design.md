# Design Document

Let me begin by saying I had gotten a lot of help from 🦞🎮, the creator of the well known arcade stacker Cambridge, and Oshisaure, another game developer and content creator on the game. They helped me through learning Lua and LOVE2D in less than a month and I am very grateful for their help.

I will be breaking down the code in order to accompany the comments I have made in the code.
Before that, however, I need to explain how coding in LOVE2D works.

There are 3 essential callback functions that are required: 

```love.load```
is the function where you load objects.

```love.update```
is the function that runs every frame.

```love.draw```
is the function that handles graphics.

There are many other functions that are used in this game, but each of those functions all go into either one of these 3, mostly love.draw.

## Tetraminos

### How it Works
There are 7 Tetraminos in the game: 
I, J, L, O, Z, S and T. Each of these Tetraminos is made up of 4 different individual "minos" which are 25x25 squares. Along with these 4 pieces, there are 4 rotation states for each system which are defined.

That's right, the game isn't really rotating the pieces. Instead, it's just repositioning the pieces so that it looks like it's rotating. This is how many Tetris clones deal with rotating, and its how people are able to create different ways of rotating the Tetraminos in other games.

Right now, I am using the Super Rotation System, which is used in a variety of modern Tetris games, but there are plenty of other ways to rotate pieces! I could go into more detail later on in video format but for now, let's move on.

### Defining Pieces

The way the game calls the different rotations (and by extension, the pieces themselves), is through a table called **pieces** that is defined in love.load containing all 7 tetraminos.


Here's what the I piece looks like in the code:
```        
    i = {
            {{-1, 0}, {0, 0}, {1, 0}, {2, 0}},
            {{0, -1}, {0, 0}, {0, 1}, {0, 2}},
            {{-2, 0}, {-1, 0}, {0, 0}, {1, 0}},
            {{0, -2}, {0, -1}, {0, 0}, {0, 1}},
        },
```

As you can see, there are 4 different rotation states provided, which I call using the rotation variable 

### Rendering Pieces

Now that I've defined the pieces, it's time to render them! This is the function **renderPiece()**, which renders the piece as it comes into the grid.

```function renderPiece(piece)
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
```

For reference, **x and y** are the coordinates of the pieces, which are controlled by the movementControls function (which I will explain later).

The for loop essentially cycles through all the minos **i** times using **v** that are declared until it runs out. This is useful if I want to add more stuff.

This function is also used when rendering the nextPiece, although it calls a different piece through the randomizer (which will be talked about later)

## Board
The board is represented by a 10x20 table of 0s and 1s called "grid". Each value represents a place on the board, as shown by this diagram here below.

The 0 means that the cell is unoccupied, while the 1 means it's occupied. Pretty simple.

The process of figuring out when its occupied and unoccupied only happens when it's applied to the board using applyPiece, which I will get to later. For now..

## Movement
It's time to move!  Well, almost.

Like a good healthy relationship, we need to set some boundaries first before we take things fast. 

### Piece Application
First, we need to apply the piece to the board.

Here's what I did in applyPiece:

```
    for i, v in ipairs(piece[rotation]) do
        grid[math.floor(y + v[2])][math.floor(x + v[1])] = 1 --
    end
end
```
Basically, it takes the argument "piece" (which is the most current piece) and runs it through the for loop, and assigns the coordinates of the piece into the grid, then sets the value of them to 1 meaning that they're occupied now.

Once that's done, it's time to render the grid to update this change using renderGrid():

```
function renderGrid()
    for i = 1, 20 do
        for j = 1, 10 do
            if grid[i][j] == 1 then
                love.graphics.rectangle("fill", j * 25 + 250, i * 25, 25, 25)
            end
        end
    end
end
```
This cycles through every single cell, and if said cell is 1 then it renders those cells to be onto the board as garbage.

### Piece Validity
Now we need to validate the pieces. Validating is the process of making sure that the pieces are locking in the first place, as well as not breaking the boundaries of the grid.

Here's the function that handles piece validity, called isValidPiece()

```
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
```

**offsetX and offsetY** are basically the translate functions of the whole piece, not just the individual minos. These are used to not only move the pieces left and right, but also to check the space around the piece.

The first if statement in the loop is setting the boundaries so that the pieces dont escape the 10x20 grid.

The second if statement is checking if the offests are occupied already: we do this by checking if the value is 1 or not, which we did using applyPiece()

### Piece Lock
Now it's time to lock and load. Here's what lockPiece() looks like: 

```
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
            paused = true
            love.event.quit('restart')
        end
    end
end
```

The outer if statement is where isValidPiece is called in to check if the piece is valid. If it is, then it checks 2 specific states:

The first state is if it's colliding with another piece. If it does, then the piece is applied to the grid and is cemented it's place on the board, unable to move.

The second state is if it collides with itself, which only happens when you top out.

### Movement (for real)
To do this, we first use movePiece to link x and y to offsetX and offsetY.

Then, it's time for the player to take control of the pieces. We do this using the function movementControls(). Here's the first section:

```
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
```
Here, you'll see a few terms which might not make sense to those who are not familiar with Tetris.

ARR is basically how fast the piece moves horizontally, while DAS is how long you have to hold left are right before ARR starts.

Here, the DAS caps off at 15. Once it's at 15, ARR kicks in until you let go of holding the piece. The higher the DAS & ARR values, the quicker the pieces move, and vice versa.

This isn't the only movement we need to deal with however, because we also need to figure out how to make the piece move down. Otherwise, it would stay in place forever. This is where gravity comes into play.

## Gravity
Gravity in Tetris is basically the act of the piece moving by itself. This can be used as a way to make the game more difficult over time and can push the limits of what makes Tetris difficult.

Gravity is measured in Gs, which isn't related to the real world speed of gravity, but rather how fast it drops frame by frame. 1G is 1 cell per frame, meaning 0.1G is 1 cell per 10 frames, and 20G (the fastest you can go in Tetris) is 20 cells per frame.

In Brookline, the gravity goes up linearly over the course of the game, and is handled by speed, (which is internally referred to as levels akin to the TGM series).

Here's the function converting the level counter to speed.

```
function getSpeed()
    return math.min(math.max(1, math.floor(levels/40)), 60)
end
```

Once that's done, then we need to actually add gravity to the piece, using addGravity():

```
function addGravity(speed)
    gravity = gravity + speed
    while gravity >= 60 do
        movePiece(currentPiece, 0, 1)  
        gravity = gravity - 60
    end
    lockPiece()
end
```

All that was left is to put getSpeed() into addGravity() and I was able to make the pieces move down by themselves!

Additionally, if you hit down while playing, you can make the piece go faster. This was just an effort of putting in a fixed value for addGravity, in case 30.

## Randomizer
Setting up a randomizer is one thing I wish I put more time into because the one that's currently in Brookline is a little harsh. This is because in modern Tetris games, the randomizer isn't actually random, it's randomized in clusters of 7, which makes the game a lot more predictable and easier. Simon Laroche made a [very good article that goes into more depth on the history of randomizers](https://simon.lc/the-history-of-tetris-randomizers), which I tried to implement into my game, but had some trouble with. This is why I ended up resorting to using a truly random randomizer, where it's fair game as to what piece you'll get.

Setting this up was simple; I made a randomizer function that creates a bag and then fully randomizes whatever comes next using math.random. 

```
function randomizer() --randomizes stuff
    local bag = {"l", "j", "s", "z", "t", "i", "o"}
    return pieces[bag[math.random(1, #bag)]]
    --return queue[1] --  the math
end
```

I then assigned the randomizer to the currentPiece variable and the nextPiece variable in love.load so the game can right away start off with a random piece as opposed to a set one every time.

Then, it's a matter of setting the currentPiece to nextPiece and setting the nextPiece to whatever the randomizer has, so that nextPiece is always one step ahead to show you what's coming up.

### Clearing Lines
Clearing lines in Tetris is an integral part of the game. If it wasn't there then the game would end easily. 

Here's how I approached it:

```
function clearLine()
    for j = 1, 20 do -- scans rows with j
        local hasHole = false -- tracks holes
        for i = 1, 10 do -- scans columns
            if grid[j][i] == 0 then
                hasHole = true
            end
        end
        if hasHole == false then
            table.remove(grid, j)
            table.insert(grid, 1, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
            linesCleared = linesCleared + 1
            levels = levels + 1
        end
    end
end
```

Basically, the function scans each cell to see if any rows are horizontally full by checking if there are any unoccupied spaces in the row (hence hasHoles, but this applies to empty rows too). This is checked row by row separately by setting hasHole to be false.

The if statement is then actually clearing lines and reinserting them based on how many lines were listed as having no holes, which is j.

## UI
UI was not super hard to implement. For the backgrounds, I pulled some images that I had made in paint.net and I made the checkered board in Photoshop. I then made a function called getBackground which would cycle through the backgrounds (named 0-3) every 100 levels.

```
function getBackground()
    return backgrounds[math.floor(levels/100) % 4 + 1]
end
```

## Sounds
I made the soundtrack of 1 song in 3 hours with a lot of Analog Lab V and Serum. It was also easy to implement since LOVE2D 