EstadoCorrer = Class {__includes = EstadoJugador}

function EstadoCorrer:init(jugador)
    self.jugador = jugador
end   

function EstadoCorrer:ingresar()
    if self.jugador.puede_saltar and not self.jugador.caminar_sonido:isPlaying() then
        love.audio.play(self.jugador.caminar_sonido)
        self.jugador.caminar_sonido:setVolume(0.2)
        self.jugador.caminar_sonido:setLooping(true)
    end
end

function EstadoCorrer:salir()
    if self.jugador.caminar_sonido:isPlaying() then
        love.audio.stop(self.jugador.caminar_sonido)
    end

    self.jugador.correr_der.activado = false
    self.jugador.correr_izq.activado = false
end

function EstadoCorrer:actualizar(dt)
    local dx, dy = self.jugador.cuerpo:getLinearVelocity()
    dx=0 -- Evita que el jugador se deslice por el piso

    if love.keyboard.isDown("right") then
        dx = self.jugador.velocidad_x
        self.jugador.correr_der.activado = true
        self.jugador.correr_izq.activado = false
    elseif love.keyboard.isDown("left") then
        dx = -self.jugador.velocidad_x
        self.jugador.correr_der.activado = false
        self.jugador.correr_izq.activado = true
    else
        self.jugador.maquinaEstados_jugador:cambiar("idle")
        return
    end

    if (love.keyboard.isDown("up") and self.jugador.puede_saltar) or not self.jugador.puede_saltar then
        self.jugador.maquinaEstados_jugador:cambiar("saltar")
        return
    end

    self.jugador.cuerpo:setLinearVelocity(dx,dy)

    ActualizarAnimacion(self.jugador.correr_der, dt, false)
    ActualizarAnimacion(self.jugador.correr_izq, dt, false)
end

function EstadoCorrer:dibujar()
    DibujarAnimacion(self.jugador.correr_der, 
    redondear(self.jugador.cuerpo:getX()), 
    redondear(self.jugador.cuerpo:getY()), 
    self.jugador.origen_x, self.jugador.origen_y)

    DibujarAnimacion(self.jugador.correr_izq, 
    redondear(self.jugador.cuerpo:getX()), 
    redondear(self.jugador.cuerpo:getY()), 
    self.jugador.origen_x, self.jugador.origen_y)
end

