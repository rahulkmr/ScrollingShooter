
player = { x = 200, y = 710, speed = 150, img = nil }

canShoot = true
canShootTimerMax = 0.2
canShootTimer = canShootTimerMax

bulletImg = nil
bullets = {}

function love.load(arg)
    player.img = love.graphics.newImage('assets/plane.png')
    bulletImg = love.graphics.newImage('assets/bullet.png')
end


function handleEvents(delta)
    if love.keyboard.isDown('escape') then
        love.event.push('quit')
    end

    if love.keyboard.isDown('left', 'a') then
        if player.x > 0 then
            player.x = player.x - (player.speed * delta)
        end
    elseif love.keyboard.isDown('right', 'd') then
        if player.x < (love.graphics.getWidth() - player.img:getWidth()) then
            player.x = player.x + (player.speed * delta)
        end
    end

    if love.keyboard.isDown('space', 'rctrl', 'lctrl') and canShoot then
        newBullet = {
            x = player.x + (player.img:getWidth() / 2),
            y = player.y,
            img = bulletImg
        }
        table.insert(bullets, newBullet)
        canShoot = false
        canShootTimer = canShootTimerMax
    end
end


function resetShootTimer(delta)
    canShootTimer = canShootTimer - (1 * delta)
    if canShootTimer < 0 then
        canShoot = true
    end
end


function updateBulletPosition(delta)
    for idx, bullet in ipairs(bullets) do
        bullet.y = bullet.y - (250 * delta)
        if bullet.y < 0 then
            table.remove(bullets, idx)
        end
    end
end


function love.update(delta)
    resetShootTimer(delta)
    updateBulletPosition(delta)
    handleEvents(delta)
end


function love.draw(delta)
    love.graphics.draw(player.img, player.x, player.y)

    for idx, bullet in ipairs(bullets) do
        love.graphics.draw(bullet.img, bullet.x, bullet.y)
    end
end