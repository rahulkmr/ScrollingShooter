
playerImg = nil

function love.load(arg)
    playerImg = love.graphics.newImage('assets/plane.png')
end


function love.update(delta)

end


function love.draw(delta)
    love.graphics.draw(playerImg, 100, 100)
end