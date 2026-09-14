require 'dependencias'

-- VENTANA     (pensado para un juego pixel art)
ventana = {
ancho = 240,
alto = 200,
escala = 3.5
}

--SONIDOS
sonidos = {
    musica = love.audio.newSource("sounds/musica.ogg", "stream"),
    victoria = love.audio.newSource("sounds/victoria.wav", "stream"),
    derrota = love.audio.newSource("sounds/derrota.wav", "stream"),
    sfx_hit = love.audio.newSource("sounds/hit.wav", "static"),
    sfx_whoosh = love.audio.newSource("sounds/whoosh.wav", "static"),
}

fuente = nil
fuente_small = nil

---------------------------- FUNCIONES -----------------------------------

-- REDONDEO ya que se trabaja con pixel art
function redondear(n)
    return math.floor(n + 0.5)
end

-- INTERACCION INPUT
function love.keypressed(key, scancode, isrepeat)

    if key == "return" and maquina_EstadoGlobal.nombre_actual ~= 'jugar' then
        maquina_EstadoGlobal:cambiar('jugar')
        return  
    end

    if key == "escape" then
        maquina_EstadoGlobal:cambiar('titulo')
        return
    end

    if maquina_EstadoGlobal and maquina_EstadoGlobal.actual then
        if type (maquina_EstadoGlobal.actual.keypressed) == "function" then -- verifica si el estado actual posee dicha funcion
            maquina_EstadoGlobal.actual:keypressed(key)
        end
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

    fuente = love.graphics.newFont('fuentes/font.ttf', 40)
    fuente_small = love.graphics.newFont('fuentes/font.ttf', 30)

    maquina_EstadoGlobal = MaquinaEstadoGlobal {
        ['jugar'] = function () return EstadoJugar()end,
        ['titulo'] = function () return EstadoTitulo()end,
        ['derrota'] = function () return EstadoDerrota()end,
    }

    maquina_EstadoGlobal:cambiar('titulo')
end

-- ACTUALIZACION
function love.update(dt)
    
   maquina_EstadoGlobal:actualizar(dt)

end

-- RENDER
function love.draw()

    maquina_EstadoGlobal:dibujar()
    
end