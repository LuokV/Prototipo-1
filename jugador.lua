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
    acople = nil
}

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

    jugador.acople:setFriction(1)
    jugador.cuerpo:setLinearDamping(1)

end

function jugador.Actualizar(dt)

     if love.keyboard.isDown("right") then
        jugador.cuerpo:applyForce(15, 0)
    elseif love.keyboard.isDown("left") then
        jugador.cuerpo:applyForce(-15, 0)
   -- elseif love.keyboard.isDown("down") then
       -- jugador.y = jugador.y + (jugador.velocidad * dt)
    end

    if love.keyboard.isDown("up") then
        jugador.cuerpo:applyLinearImpulse(0, -5)
    end

end

function jugador.Dibujar()
    love.graphics.draw(jugador.sprite, jugador.cuerpo:getX(), jugador.cuerpo:getY(), 0, 1, 1, jugador.origen_x, jugador.origen_y)
end