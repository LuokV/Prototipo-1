jugador = {
    x= 0,
    y = 0,
    velocidad = 70,
    ancho = 0,
    alto = 0,
    origen_x = 0,
    origen_y = 0,
    sprite = nil,
    cuerpo = nil,
    forma = nil,
    acople = nil,
    encontacto = 0
}


local tag = "jugador"

--Inicializacion

function jugador.Crear(x, y)

    jugador.x = x
    jugador.y = y
    jugador.sprite = love.graphics.newImage("img/Goat.png")
    jugador.ancho = jugador.sprite:getWidth()
    jugador.alto = jugador.sprite:getHeight()
    jugador.origen_x = jugador.ancho/2
    jugador.origen_y = jugador.alto/2
    jugador.cuerpo = love.physics.newBody(world, x, y, "dynamic")
    jugador.forma = love.physics.newRectangleShape(jugador.sprite:getWidth(), jugador.sprite:getHeight())
    jugador.acople = love.physics.newFixture(jugador.cuerpo, jugador.forma)

    jugador.acople:setUserData(tag)

    jugador.cuerpo:setFixedRotation(true)
end

function jugador.Actualizar(dt)

local dx, dy = jugador.cuerpo:getLinearVelocity()
dx=0

    if love.keyboard.isDown("right") then
        dx = jugador.velocidad
        if contacto and  nx > 0.5 and ny < 0.5 then
            dx = 0
        end
    elseif love.keyboard.isDown("left") then
        dx = - jugador.velocidad
          if contacto and nx < 0.5 and ny < 0.5 then
            dx = 0
        end
    end

    if jugador.encontacto > 0 then

       if love.keyboard.isDown("up") then
        dy = - jugador.velocidad
       end

    end

    jugador.cuerpo:setLinearVelocity(dx,dy)

end

function jugador.Dibujar()
    --love.graphics.polygon("fill", jugador.cuerpo:getWorldPoints(jugador.forma:getPoints()))
    love.graphics.draw(jugador.sprite, jugador.cuerpo:getX(), jugador.cuerpo:getY(), 0, 1, 1, jugador.origen_x, jugador.origen_y)
end