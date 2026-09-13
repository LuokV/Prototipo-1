EstadoTitulo = Class {__includes = Estado}

function EstadoTitulo:init() end   
function EstadoTitulo:ingresar() end
function EstadoTitulo:salir() end
function EstadoTitulo:actualizar(dt) end

function EstadoTitulo:dibujar()
    love.graphics.printf ('CONCIERTO', 0, 64, ventana.ancho * ventana.escala, 'center')
    love.graphics.printf ('Presiona Enter para comenzar', 0, 100, ventana.ancho * ventana.escala, 'center')
    love.graphics.printf ('Q - W - E - R para eliminar las notas', 0, 200, ventana.ancho * ventana.escala, 'center')
    love.graphics.printf ('Q = ROJO', 0, 250, ventana.ancho * ventana.escala, 'center')
    love.graphics.printf ('W = VERDE', 0, 300, ventana.ancho * ventana.escala, 'center')
    love.graphics.printf ('E = AZUL', 0, 350, ventana.ancho * ventana.escala, 'center')
    love.graphics.printf ('R = AMARILLO', 0, 400, ventana.ancho * ventana.escala, 'center')
end
