
player = { x = 200, y = 710, speed = 150, img = nil }
isAlive = true
score = 0

canShoot = true
canShootTimerMax = 0.2
canShootTimer = canShootTimerMax

bulletImg = nil
bullets = {}

createEnemyTimerMax = 0.4
createEnemyTimer = createEnemyTimerMax

enemyImg = nil
enemies = {}

function isColliding(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and
        x2 < x1 + w1 and
        y1 < y2 + h2 and
        y2 < y1 + h1
end


function love.load(arg)
    player.img = love.graphics.newImage('assets/player.png')
    bulletImg = love.graphics.newImage('assets/bullet.png')
    enemyImg = love.graphics.newImage('assets/enemy.png')
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

    if love.keyboard.isDown('r') and not isAlive then
        resetGame(delta)
    end
end


function resetGame(delta)
    if not isAlive and love.keyboard.isDown('r') then
        bullets = {}
        enemies = {}

        canShootTimer = canShootTimerMax
        createEnemyTimer = createEnemyTimerMax

        player.x = 50
        player.y = 710

        score = 0
        isAlive = true
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


function createEnemy(delta)
    createEnemyTimer = createEnemyTimer - (1 * delta)
    if createEnemyTimer < 0 then
        createEnemyTimer = createEnemyTimerMax

        randomNumber = math.random(10, love.graphics.getWidth() - 10)
        newEnemy = { x = randomNumber, y = -10, img = enemyImg }
        table.insert(enemies, newEnemy)
    end
end


function updateEnemyPosition(delta)
    for idx, enemy in ipairs(enemies) do
        enemy.y = enemy.y + (200 * delta)
        if enemy.y > 850 then
            table.remove(enemies, idx)
        end
    end
end


function detectCollisions(delta)
    for enemy_idx, enemy in ipairs(enemies) do
        for bullet_idx, bullet in ipairs(bullets) do
            if isColliding(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(),
                bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight()) then
                    table.remove(bullets, bullet_idx)
                    table.remove(enemies, enemy_idx)
                    score = score + 1
            end
        end

        if isColliding(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(),
            player.x, player.y, player.img:getWidth(), player.img:getHeight()) and isAlive then
                table.remove(enemies, enemy_idx)
                isAlive = false
        end
    end
end


function love.update(delta)
    resetShootTimer(delta)
    createEnemy(delta)
    updateBulletPosition(delta)
    updateEnemyPosition(delta)
    detectCollisions(delta)
    handleEvents(delta)
end


function love.draw(delta)
    if isAlive then
        love.graphics.draw(player.img, player.x, player.y)
    else
        love.graphics.print("Press 'R' to restart",
            love.graphics.getWidth() / 2 - 50,
            love.graphics.getHeight() / 2 - 10)
    end

    for idx, bullet in ipairs(bullets) do
        love.graphics.draw(bullet.img, bullet.x, bullet.y)
    end

    for idx, enemy in ipairs(enemies) do
        love.graphics.draw(enemy.img, enemy.x, enemy.y)
    end
end