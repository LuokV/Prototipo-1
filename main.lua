require "escenario"
require "jugador"
require "notasmusicales"

-- VENTANA     (pensado para un juego pixel art)
ventana = {
ancho = 160,
alto = 144,
escala = 4
}

-- Primero se cargan los parametros para la inicializacion
function love.load()

    --Inicializacion del mundo fisico
    love.physics.setMeter(32)
    world = love.physics.newWorld(0,9.81*32,true)

    --Inicializacion de la ventana
    love.window.setMode (ventana.ancho * ventana.escala, ventana.alto * ventana.escala )
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- Incializacion del Canvas
    lienzo = love.graphics.newCanvas(ventana.ancho, ventana.alto)

    CrearEscenario()
end

-- ACTUALIZACION
function love.update(dt)
    world:update(dt)
end

-- RENDER
function love.draw()
    love.graphics.setCanvas(lienzo)
    love.graphics.clear()

    DibujarEscenario()

    love.graphics.setCanvas()

    love.graphics.draw(lienzo, 0, 0, 0, ventana.escala, ventana.escala)
    
end