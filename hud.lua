HUD = Class {}

function HUD:init()
    self.texto_vida = ""
    self.texto_nivel = ""
    self.texto_objetivos = ""
    self.depurar = false
    self.timer_atrapado = 0
    
    love.handlers.modoDebug = function () self:DebugToogle() end
    love.handlers.actualizarVidas = function (vidas) self:ActualizarVidas(vidas) end
    love.handlers.actualizarNivel = function (nivel) self:ActualizarNivel(nivel) end
    love.handlers.actualizarObjetivos = function (jugador_notas, objetivos) self:ActualizarObjetivos(jugador_notas, objetivos) end
end

function HUD:Draw(nivel_timer)
    love.graphics.setFont(fuente_small)
    love.graphics.print(self.texto_vida, 60, 10)
    love.graphics.print(self.texto_nivel, 250, 10)
    love.graphics.print(self.texto_objetivos, 450, 10)

    
    love.graphics.setFont(fuente)
    if nivel_timer > 0 then
        local tiempo_redondeado = redondear(nivel_timer)
        love.graphics.printf(tiempo_redondeado, 0, 250, ventana.ancho * ventana.escala, 'center')
    end
end

function HUD:DrawGameData(notas_musicales, contacto, entidad1, entidad2, jugador)
    love.graphics.setFont(fuente_small)
    if not self.depurar then return end
    
    love.graphics.setColor(0, 1, 0)
    love.graphics.print("FPS: "..love.timer.getFPS(), 350, 650)

    if self.timer_atrapado > 0 then
        love.graphics.print("ATRAPADO", 350, 450)
    end

    love.graphics.setColor(1, 1, 1)

    love.graphics.print("Notas: " .. #notas_musicales, 40, ventana.alto/2)

    love.graphics.setColor(1, 0, 0)
    if contacto then
        love.graphics.print("CHOQUE", 650/2,220)
        love.graphics.print(entidad1, 650/2,260)
        love.graphics.print(entidad2, 650/2,300)
        love.graphics.print(jugador.encontacto, 650/2,330)
    end
    love.graphics.setColor(1, 1, 1)

end

function HUD:DrawHitboxes(jugador, notas_musicales)
    if not self.depurar then return end

    love.graphics.setColor(0, 1, 0)
    jugador:Debug()
      
    for i, notas in ipairs(notas_musicales) do
        if notas then notas:Debug() end
    end

    love.graphics.setColor(1, 1, 1)
end

function HUD:DebugToogle()
    self.depurar = not self.depurar
end

function HUD:ActualizarVidas(vidas)
    self.texto_vida = "Vidas: "..vidas
end

function HUD:ActualizarNivel(nivel)
    self.texto_nivel= "Nivel "..nivel
end

function HUD:ActualizarObjetivos(jugador_notas, objetivos)
    self.texto_objetivos = "Objetivo Notas "..jugador_notas.."/"..objetivos
end