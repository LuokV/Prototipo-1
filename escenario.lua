escenario = {}

local tag1 = "Pared"
local tag2 = "Piso"
local tag3 = "Plataforma"

function CrearEscenario()
columna = {}

columna.sprite = love.graphics.newImage("img/Wall.png")
columna.cuerpo = love.physics.newBody(world, 6, 144/2 )
columna.forma = love.physics.newRectangleShape(columna.sprite:getWidth()*0.75, columna.sprite:getHeight())
columna.acople = love.physics.newFixture(columna.cuerpo, columna.forma)
columna.acople:setFriction(0.5)
columna.acople:setUserData(tag1)

end

--NOTA: El cuerpo FISICO se origina desde el centro, mientras que los SPRITES desde la esquina superior izq
function DibujarEscenario()
    love.graphics.polygon("fill", columna.cuerpo:getWorldPoints(columna.forma:getPoints()))
    love.graphics.draw(columna.sprite, columna.cuerpo:getX(), columna.cuerpo:getY(), 0, 0.75, 1, columna.sprite:getWidth()/2,columna.sprite:getHeight()/2)
end