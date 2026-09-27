EstadoIdle = Class {__includes = EstadoJugador}

function EstadoIdle:init(jugador)
    self.jugador = jugador
end   

function EstadoIdle:ingresar()
    self.jugador.correr_der.activado = false
    self.jugador.correr_izq.activado = false
    self.jugador.salto.activado = false

    local _, dy = self.jugador.cuerpo:getLinearVelocity() --- "_" es para guardar dx, que no se va a usar
    self.jugador.cuerpo:setLinearVelocity(0,dy) --- 0 para que no se mueva horizontalmente
end

function EstadoIdle:salir() end

function EstadoIdle:actualizar(dt)
    local _, dy = self.jugador.cuerpo:getLinearVelocity()

    if love.keyboard.isDown("right") or love.keyboard.isDown("left") then
        self.jugador.maquinaEstados_jugador:cambiar("correr")
        return
    end

    if (love.keyboard.isDown("up") and self.jugador.puede_saltar) or not self.jugador.puede_saltar then
        self.jugador.maquinaEstados_jugador:cambiar("saltar")
        return
    end

    self.jugador.cuerpo:setLinearVelocity(0,dy)
end

function EstadoIdle:dibujar()
    if not self.jugador.correr_der.activado and not self.jugador.correr_izq.activado and not self.jugador.salto.activado then
    love.graphics.draw(self.jugador.sprite,
    redondear(self.jugador.cuerpo:getX()),
    redondear(self.jugador.cuerpo:getY()),
    0,1,1, self.jugador.origen_x, self.jugador.origen_y)
    end
end

