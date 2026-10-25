Jugador = Class {}

local teclas_ataque = {
    q = "ataque",
    w = "ataque2",
    e = "ataque3",
    r = "ataque4"
}

function Jugador:keypressed(key)

    if self.invulnerable then --- no permitir que el jugador ataque si fue herido
        return
    end

    local tipo_ataque = teclas_ataque[key]

    if tipo_ataque then
        local ataque = self[tipo_ataque]

        if ataque and not ataque.activado then
            ataque.activado = true
            sonidos.sfx_whoosh:stop()
            love.audio.play(sonidos.sfx_whoosh)
        end
    end
end

function Jugador:corrutina_invulnerabilidad()
   
    self.invulnerable = true
    self.color = {1,0,0,0.5}

    self.rutina_invulnerable = coroutine.create(function()

        for i = 1, 15 do
            self.visible = not self.visible

            local tiempo_transcurrido = 0
            while tiempo_transcurrido < 0.1 do
                local dt = coroutine.yield()
                tiempo_transcurrido = tiempo_transcurrido + dt
            end
        end

        self.visible = true
        self.invulnerable = false
        self.color = {1, 1, 1, 1}
    end)
end

--INICIALIZACIÓN
function Jugador:init(x, y, world)

    self.x = x
    self.y = y
    self.velocidad_x = 60
    self.velocidad_y = 120
    self.sprite = love.graphics.newImage("img/Goat.png")
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

    self.invulnerable = false
    self.visible = true
    self.rutina_invulnerable = nil

    ----Ataques del jugador
    for i = 1, 4 do
        local tipo_ataque = (i == 1) and "ataque" or ("ataque" .. i)
    
        self[tipo_ataque] = CrearAnimacion("img/GolpeSprites.png", 4, 25, 24, 12, false, 25, 0)
        self[tipo_ataque].activado = false
    end

    --Animaciones
    self.correr_der = CrearAnimacion("img/GoatSprites.png",3,16,16,12, true, 32, 16)
    self.correr_izq = CrearAnimacion("img/GoatSprites.png",3,16,16,12, true, 16, 16)
    self.salto = CrearAnimacion("img/GoatSprites.png",0,16,16,2, false, 0, 16)
 
    -- Particula al agarrar nota
    self.img_particula = love.graphics.newImage('img/Estrella.png')
    self.particula = love.graphics.newParticleSystem(self.img_particula, 32)
    self.particula:setParticleLifetime(0.3, 0.6) 
	self.particula:setEmissionRate(0)
	self.particula:setSizeVariation(1)
	self.particula:setLinearAcceleration(-120, -120, 120, 120) 
	self.particula:setColors(1, 1, 1, 1, 1, 1, 1, 0)
    self.particula:setSizes(0.8, 1)

    self.acople:setUserData("jugador")

    self.cuerpo:setFixedRotation(true)

    --Sonidos
    self.salto_sonido = love.audio.newSource("sounds/jump3.ogg", "static")
    self.caminar_sonido = love.audio.newSource("sounds/steps.mp3", "static")

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

if self.rutina_invulnerable and coroutine.status(self.rutina_invulnerable) ~= "dead" then
    local exito = coroutine.resume(self.rutina_invulnerable, dt)
    if not exito then return end
end
    
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

if self.visible then
    love.graphics.setColor(self.color) 
    self.maquinaEstados_jugador:dibujar()
end

------ Dibujar Ataque 
love.graphics.setColor(1, 0, 0)
DibujarAnimacion(self.ataque, redondear(self.cuerpo:getX()), redondear(self.cuerpo:getY()), self.origen_x + 5, self.origen_y + 5)
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
        self.particula:emit(5) 
    end

    Timer.after(0.3, function () 
                    self.color = {1, 1, 1, 1}
                end)

end

function Jugador:Herido()
    self:corrutina_invulnerabilidad();

    love.audio.play(sonidos.sfx_hit)
    self.vidas = self.vidas - 1

end