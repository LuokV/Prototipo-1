EstadoVictoria = Class {__includes = Estado}

function EstadoVictoria:init() end   
function EstadoVictoria:ingresar() end
function EstadoVictoria:salir() end
function EstadoVictoria:actualizar(dt) end

function EstadoVictoria:dibujar()
    love.graphics.setFont(fuente)
    love.graphics.setColor(0,0,1)
    love.graphics.printf('VICTORIA!', 0, 250, ventana.ancho * ventana.escala, 'center')
    love.graphics.printf('Esc : Titulo', 0, 350, ventana.ancho * ventana.escala, 'center')
    love.graphics.printf('ENTER: Reiniciar Juego', 0, 400, ventana.ancho * ventana.escala, 'center')
end

