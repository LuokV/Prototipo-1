EstadoSaltar = Class {__includes = EstadoJugador}

function EstadoSaltar:init(jugador)
    self.jugador = jugador
end   

function EstadoSaltar:ingresar()
    local dx, dy = self.jugador.cuerpo:getLinearVelocity()

    dy = -self.jugador.velocidad_y
    love.audio.play(self.jugador.salto_sonido)
    
    self.jugador.puede_saltar = false

    self.jugador.salto.activado = true

    self.jugador.cuerpo:setLinearVelocity(dx, dy)
end

function EstadoSaltar:salir()
    self.jugador.salto.activado = false
end

function EstadoSaltar:actualizar(dt)
    local dx, dy = self.jugador.cuerpo:getLinearVelocity()

    if love.keyboard.isDown("right") then
        dx = self.jugador.velocidad_x
    elseif love.keyboard.isDown("left") then
        dx = -self.jugador.velocidad_x
    else
        dx = 0
    end

-- Envita que salte fuera de la ventana
    if self.jugador.cuerpo:getY() < 5 then
        dy = 0
    end

    self.jugador.cuerpo:setLinearVelocity(dx, dy)
    ActualizarAnimacion(self.jugador.salto,dt, false)

    if self.jugador.puede_saltar then
        if love.keyboard.isDown("right") or love.keyboard.isDown("left") then
            self.jugador.maquinaEstados_jugador:cambiar("correr")
            return
        else
            self.jugador.maquinaEstados_jugador:cambiar("idle")
            return
        end
    end
end

function EstadoSaltar:dibujar()
    DibujarAnimacion(self.jugador.salto, 
    redondear(self.jugador.cuerpo:getX()), 
    redondear(self.jugador.cuerpo:getY()), 
    self.jugador.origen_x, self.jugador.origen_y)
end

