Estructuras = Class {}

local tag1 = "Pared"
local tag2 = "Piso"
local tag3 = "Plataforma"

function Estructuras:init(x, y, ruta, tag, escalax, escalay, world)

    self.sprite = love.graphics.newImage(ruta)
    self.cuerpo = love.physics.newBody(world, x, y)
    self.escala_x = escalax
    self.escala_y = escalay
    self.forma = love.physics.newRectangleShape(self.sprite:getWidth()*self.escala_x, self.sprite:getHeight()*self.escala_y)
    self.acople = love.physics.newFixture(self.cuerpo, self.forma)
    self.acople:setUserData(tag)

    self.acople:setFriction (0) -- Evita que el jugador pueda agarrarse a las estructuras

end

---- FUNCION PARA CREAR PARTES DEL ESCENARIO

function Estructuras:DibujarPlataforma()
    love.graphics.draw(self.sprite, self.cuerpo:getX(), self.cuerpo:getY(), 0, self.escala_x, self.escala_y, self.sprite:getWidth()/2, self.sprite:getHeight()/2)
end

---- FUNCIONES PARA CARGAR y DIBUJAR EL ESCENARIO RESPECTIVAMENTE

function CrearEscenario(world)
    columnaizquieda = Estructuras(ventana.ancho-(ventana.ancho-6), ventana.alto/2, "img/Wall.png", tag1, 0.75, 1.38, world)
    columnaderecha = Estructuras(ventana.ancho-6,ventana.alto/2,"img/Wall.png", tag1, 0.75, 1.38, world)

    piso = Estructuras(ventana.ancho/2, ventana.alto-5, "img/Floor.png", tag2, 1.5, 1, world)

    --plataformas sin sprites
    centro = Estructuras(ventana.ancho/2, ventana.alto/2 + 5, "img/Floor.png", tag3, 0.25, 0.50, world)

    superior_izq = Estructuras(50, 60, "img/Floor.png", tag3, 0.20, 0.50, world)
    superior_der = Estructuras(190, 60, "img/Floor.png", tag3, 0.20, 0.50, world)
    inferior_izq = Estructuras(50, 150, "img/Floor.png", tag3, 0.20, 0.50, world)
    inferior_der = Estructuras(190, 150, "img/Floor.png", tag3, 0.20, 0.50, world)
end

--NOTA: El cuerpo FISICO se origina desde el centro, mientras que los SPRITES desde la esquina superior izq
function DibujarEscenario()
    columnaizquieda:DibujarPlataforma()
    columnaderecha:DibujarPlataforma()

    piso:DibujarPlataforma()

    --plataformas sin sprite
    love.graphics.setColor(0,1,0)
    centro:DibujarPlataforma()

    superior_izq:DibujarPlataforma()
    superior_der:DibujarPlataforma()
    inferior_izq:DibujarPlataforma()
    inferior_der:DibujarPlataforma()
    love.graphics.setColor(1,1,1)
end