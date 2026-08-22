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

    --Inicializacion de la ventana
    love.window.setMode (ventana.ancho * ventana.escala, ventana.alto * ventana.escala )
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- Incializacion del Canvas
    lienzo = love.graphics.newCanvas(ventana.ancho, ventana.alto)
end

-- ACTUALIZACION
function love.update()
    
end

-- RENDER
function love.draw()
    love.graphics.setCanvas(lienzo)
    love.graphics.clear()

    love.graphics.setCanvas()

    love.graphics.draw(lienzo, 0, 0, 0, ventana.esscala, ventana.escala)
    
end