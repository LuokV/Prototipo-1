escenario = {}

local tag1 = "Pared"
local tag2 = "Piso"
local tag3 =  "Plataforma"

function CrearEscenario()
local columna = {}

columna.cuerpo = love.physics.newBody(world, 0, 120 )
columna.forma = love.physics.newRectangleShape(16,160)
columna.acople = love.physics.newFixture(columna.cuerpo, columna.forma)
columna.acople:setFriction(0.5)
columna.acople:setUserData(tag1)
columna.sprite = love.graphics.newImage("Wall.png")
    
end

function DibujarEscenario()
    love.graphics.draw(columna.sprite, columna.cuerpo:getX(), columna.cuerpo:getY(), 0)
end