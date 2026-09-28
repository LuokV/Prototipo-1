Jugador = Class {}

function Jugador:keypressed(key)

    if key == "q" and not self.ataque.activado then
        self.ataque.activado =true
        love.audio.play(sonidos.sfx_whoosh)
    elseif key == "w" and not self.ataque2.activado then
        self.ataque2.activado =true
        love.audio.play(sonidos.sfx_whoosh)
    elseif key == "e" and not self.ataque3.activado then
        self.ataque3.activado =true
        love.audio.play(sonidos.sfx_whoosh)
    elseif key == "r" and not self.ataque4.activado then
        self.ataque4.activado =true
        love.audio.play(sonidos.sfx_whoosh)
    end
end

--INICIALIZACIÓN
function Jugador:init(x, y, world)

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
    self.notas = 0
    self.color = {1,1,1,1}

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
 
    -- Particula al agarrar nota
    self.img_particula = love.graphics.newImage('img/Particula.png')
    self.particula = love.graphics.newParticleSystem(self.img_particula, 32)
    self.particula:setParticleLifetime(0.3, 0.6) 
	self.particula:setEmissionRate(0)
	self.particula:setSizeVariation(0)
	self.particula:setLinearAcceleration(-120, -120, 120, 120) 
	self.particula:setColors(1, 1, 0, 1,   1, 0.5, 0, 0)
    self.particula:setSizes(0.05, 0.1)

    self.acople:setUserData("jugador")

    self.cuerpo:setFixedRotation(true)

    --Sonidos
    self.salto_sonido = love.audio.newSource("sounds/jump.wav", "static")
    self.caminar = love.audio.newSource("sounds/pasos.wav", "static")

    --Flag para determinar si el jugador puede saltar
    self.puede_saltar = false

    --Eventos
    love.event.push('actualizarVidas', self.vidas)
    self.signal_herido = Signal.register ("jugador_herido", function() self:Herido() end)
    self.signal_nota_obtenida = Signal.register ("jugador_nota", function() self:ObtenerNota() end)

    self.maquinaEstados_jugador = MaquinaEstadoJugador{
        ["idle"] =   EstadoIdle(self),
        ["correr"] = EstadoCorrer(self),
        ["saltar"] = EstadoSaltar(self) 
    }

    self.maquinaEstados_jugador:cambiar("idle") 
end


--ACTUALIZAR
function Jugador:Actualizar(dt)
    
self.maquinaEstados_jugador:actualizar(dt)

self.particula:update(dt)

-- Hitbox para colision con Notas Musicales 
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
love.graphics.setColor(1, 1, 1, 1)
love.graphics.draw(self.particula)

love.graphics.setColor(self.color) 
self.maquinaEstados_jugador:dibujar()

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

function Jugador:ObtenerNota()
    self.color = {1,0,1,1}
    self.notas = self.notas + 1

    if self.cuerpo and not self.cuerpo:isDestroyed() then
        local dx, dy = self.cuerpo:getPosition() 
        self.particula:setPosition(dx, dy)
        self.particula:emit(10) 
    end

    Timer.after(0.3, function () 
                    self.color = {1, 1, 1, 1}
                end)

end

function Jugador:Herido()
    self.color = {1,0,0,0.5}
    love.audio.play(sonidos.sfx_hit)
    self.vidas = self.vidas - 1
    love.event.push('actualizarVidas', self.vidas)

    Timer.after(0.3, function () 
                    self.color = {1, 1, 1, 1}
                end)
end