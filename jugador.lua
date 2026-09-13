Jugador = Class {}

local tag = "jugador"

--INICIALIZACIÓN
function Jugador:init(x, y)

    self.x = x
    self.y = y
    self.velocidad_x = 60
    self.velocidad_y = 120
    self.sprite = love.graphics.newImage("img/Ninja.png")
    self.ancho = self.sprite:getWidth()
    self.alto = self.sprite:getHeight()
    self.hitbox_x = 0
    self.hitbox_y = 0
    self.origen_x = self.ancho/2
    self.origen_y = self.alto/2
    self.cuerpo = love.physics.newBody(world, x, y, "dynamic")
    self.forma = love.physics.newRectangleShape(self.sprite:getWidth(), self.sprite:getHeight())
    self.acople = love.physics.newFixture(self.cuerpo, self.forma)

    self.encontacto = 0

    self.vidas = 3
    self.cancion = 10
    self.notas = 0

    ----Tipos de ataques musicales de jugador
  
    self.ataque = CrearAnimacion("img/CortarSprites.png",3,32,32,12, false, 32, 0)
    self.ataque.activado = false

    self.ataque2 = CrearAnimacion("img/AuraSprites.png",4,25,24,12, false, 25, 0)
    self.ataque2.activado = false

    self.ataque3 = CrearAnimacion("img/AuraSprites.png",4,25,24,12, false, 25, 0)
    self.ataque3.activado = false

    self.ataque4 = CrearAnimacion("img/AuraSprites.png",4,25,24,12, false, 25, 0)
    self.ataque4.activado = false

    --Animaciones
    self.correr_der = CrearAnimacion("img/NinjaSprites.png",3,16,16,12, true, 48, 16)
    self.correr_izq = CrearAnimacion("img/NinjaSprites.png",3,16,16,12, true, 32, 16)
    self.salto = CrearAnimacion("img/NinjaSprites.png",0,16,16,2, false, 16, 96)
    -----------

    self.acople:setUserData(tag)

    self.cuerpo:setFixedRotation(true)

    --Sonidos
    self.salto_sonido = love.audio.newSource("sounds/jump.wav", "static")
    self.caminar = love.audio.newSource("sounds/pasos.wav", "static")

    --Flag para determinar si el jugador puede saltar
    self.puede_saltar = false
end


--ACTUALIZAR
function Jugador:Actualizar(dt)

local dx, dy = self.cuerpo:getLinearVelocity()
dx=0 -- Evita que el jugador se deslice por el piso

    if love.keyboard.isDown("right") then
        dx = self.velocidad_x
        
        if not self.puede_saltar then
            love.audio.stop(self.caminar)
            else love.audio.play(self.caminar)
        end

        self.correr_der.activado = true
        self.correr_izq.activado = false
        self.salto.activado = false
    
    elseif love.keyboard.isDown("left") then
        dx = - self.velocidad_x
        
        if not self.puede_saltar then
            love.audio.stop(jugador.caminar)
            else love.audio.play(self.caminar)
        end
        
        self.correr_izq.activado = true
        self.salto.activado = false


        --IDLE -- esto podría ser una función que devuelva booleanos para verificar si se esta moviendo
    else self.correr_der.activado = false
         self.correr_izq.activado = false
         self.salto.activado = false
         if self.caminar:isPlaying()then
            love.audio.stop(self.caminar)
         end
    end

    if  love.keyboard.isDown("up")  then
        if self.puede_saltar then
            dy = - self.velocidad_y
            love.audio.play(self.salto_sonido)
            self.puede_saltar = false
        end
    end
 
    if not self.puede_saltar then
        self.salto.activado = true
    end

-- Envita que salte fuera de la ventana
    if self.cuerpo:getY() < 5 then
        dy = 0
    end

self.cuerpo:setLinearVelocity(dx,dy)

ActualizarAnimacion(self.correr_der,dt, false)
ActualizarAnimacion(self.correr_izq,dt, false)
ActualizarAnimacion(self.salto,dt, false)

-- Hitbox para colision con Notas Musicales (posiblemente se cambie mas adelante)
self.hitbox_x = self.cuerpo:getX() - self.origen_x
self.hitbox_y = self.cuerpo:getY() - self.origen_y

-- Animaciones de ataque del juegaor
ActualizarAnimacion(self.ataque,dt, true)
ActualizarAnimacion(self.ataque2,dt, true)
ActualizarAnimacion(self.ataque3,dt, true)
ActualizarAnimacion(self.ataque4,dt, true)

end

--DIBUJAR
function Jugador:Dibujar()
    
DibujarAnimacion(self.correr_der, redondear(self.cuerpo:getX()), redondear(self. cuerpo:getY()), self.origen_x, self.origen_y)
DibujarAnimacion(self.correr_izq, redondear(self.cuerpo:getX()), redondear(self. cuerpo:getY()), self.origen_x, self.origen_y)
DibujarAnimacion(self.salto, redondear(self.cuerpo:getX()), redondear(self. cuerpo:getY()), self.origen_x, self.origen_y)

  if not self.correr_der.activado and not self.correr_izq.activado and not self.salto.activado then
        love.graphics.draw(self.sprite, redondear(self.cuerpo:getX()), redondear(self.cuerpo:getY()), 0,1,1, self.origen_x, self.origen_y)
    end

------ Dibujar Ataque 
love.graphics.setColor(1, 0, 0)
DibujarAnimacion(self.ataque, redondear(self.cuerpo:getX()), redondear(self.cuerpo:getY()), self.origen_x + 8, self.origen_y + 8)
love.graphics.setColor(0, 1, 0)
DibujarAnimacion(self.ataque2, redondear(self.cuerpo:getX()), redondear(self.cuerpo:getY()), self.origen_x + 5, self.origen_y + 5)
love.graphics.setColor(0, 0, 1)
DibujarAnimacion(self.ataque3, redondear(self.cuerpo:getX()), redondear(self.cuerpo:getY()), self.origen_x + 5, self.origen_y + 5)
love.graphics.setColor(1, 1, 0)
DibujarAnimacion(self.ataque4, redondear(self.cuerpo:getX()), redondear(self.cuerpo:getY()), self.origen_x + 5, self.origen_y + 5)
love.graphics.setColor(1, 1, 1)

end

--DEBUG
function Jugador:Debug()
    love.graphics.rectangle("line", redondear(self.hitbox_x), redondear(self.hitbox_y), self.ancho, self.alto)
    love.graphics.circle("fill", redondear(self.cuerpo:getX()), redondear(self.cuerpo:getY()), 1)
end