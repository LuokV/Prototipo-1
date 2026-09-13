require 'dependencias'

-- VENTANA     (pensado para un juego pixel art)
ventana = {
ancho = 240,
alto = 200,
escala = 3.5
}

estado= nil

entidad1 = nil
entidad2 = nil
contacto = false
nx, ny = nil

depurar = true

derrota = false
victoria = false


--SONIDOS
sonidos = {
    musica = love.audio.newSource("sounds/musica.ogg", "stream"),
    victoria = love.audio.newSource("sounds/victoria.wav", "stream"),
    derrota = love.audio.newSource("sounds/derrota.wav", "stream"),
    sfx_hit = love.audio.newSource("sounds/hit.wav", "static"),
    sfx_whoosh = love.audio.newSource("sounds/whoosh.wav", "static"),
}

---------------------------- FUNCIONES -----------------------------------

-- COLISIONES
--[[
-- Por cuerpo físico
function iniciarContacto(a,b,col)

    contacto = true
    nx,ny = col:getNormal()

    if a:getUserData() == "jugador" or b:getUserData() == "jugador" then
        estado.jugador.encontacto = estado.jugador.encontacto + 1
    end
      
    if a:getUserData() == "jugador" and b:getUserData() == "Piso" or
       a:getUserData() == "jugador" and b:getUserData() == "Plataforma"  then
       if ny > 0.5 then -- Soloe permite saltar si esta en la parte SUPERIOR
        estado.jugador.puede_saltar = true
       end 
    end

    entidad1 = a:getUserData()
    entidad2 = b:getUserData()
  
end

function terminarContacto(a,b,col)
    contacto = false

    if a:getUserData() == "jugador" or b:getUserData() == "jugador" then
        estado.jugador.encontacto = estado.jugador.encontacto - 1
    end

    if estado.jugador.encontacto == 0 then
    estado.jugador.puede_saltar = false -- Evita saltar "en caida"
    end

    entidad1 = nil
    entidad2 = nil
end
]]
---------------------------------------------------------------

-- REDONDEO ya que se trabaja con pixel art
function redondear(n)
    return math.floor(n + 0.5)
end

-- DEBUG
--[[
function debugUI()
    love.graphics.setColor(0, 1, 0)
    love.graphics.print("FPS: "..love.timer.getFPS(), 10, 10)

    for i, notas in ipairs(notas_musicales) do
       if notas.atrapado then
        love.graphics.print("ATRAPADO", 100, 10)
       end
    end

    love.graphics.setColor(1, 1, 1)
end

function debugHitboxes()
        love.graphics.setColor(0, 1, 0)
        jugador:Debug()
      
        for i, notas in ipairs(notas_musicales) do
            notas:Debug()
        end

        love.graphics.setColor(1, 1, 1)
end
]]

-- INTERACCION INPUT
function love.keypressed(key, scancode, isrepeat)
    if key == "f1" then
        depurar = not depurar
    elseif key == "q" and not estado.jugador.ataque.activado then
        estado.jugador.ataque.activado =true
        love.audio.play(sonidos.sfx_whoosh)
    elseif key == "w" and not estado.jugador.ataque2.activado then
        estado.jugador.ataque2.activado =true
        love.audio.play(sonidos.sfx_whoosh)
    elseif key == "e" and not estado.jugador.ataque3.activado then
        estado.jugador.ataque3.activado =true
        love.audio.play(sonidos.sfx_whoosh)
    elseif key == "r" and not estado.jugador.ataque4.activado then
        estado.jugador.ataque4.activado =true
        love.audio.play(sonidos.sfx_whoosh)
    end
    
    if key == "return" then
        estado = EstadoJugar()
    end

    if key == "escape" then
        estado = EstadoTitulo()
    end
end

------------------------ INICIAR - ACTUALIZAR - RENDERIZAR ----------------------

-- INICIALIZACION
function love.load()

    --Inicializacion de la ventana
    love.window.setMode (ventana.ancho * ventana.escala, ventana.alto * ventana.escala )
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- Incializacion del Canvas
    lienzo = love.graphics.newCanvas(ventana.ancho, ventana.alto)

    estado = EstadoTitulo()
end

-- ACTUALIZACION
function love.update(dt)
    
    estado:actualizar(dt)

end

-- RENDER
function love.draw()

    estado:dibujar()
    
end