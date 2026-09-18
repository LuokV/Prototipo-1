EstadoDerrota = Class {__includes = Estado}

function EstadoDerrota:init()
    self.nivel = 0
end   
function EstadoDerrota:ingresar(nivel)
    self.nivel = nivel
end
function EstadoDerrota:salir() end
function EstadoDerrota:actualizar(dt) end

function EstadoDerrota:dibujar()
    love.graphics.setFont(fuente)
    love.graphics.setColor(1,0,0)
    love.graphics.printf('GAME OVER', 0, 250, ventana.ancho * ventana.escala, 'center')
    love.graphics.printf('Nivel alcanzado: '..self.nivel, 0, 350, ventana.ancho * ventana.escala, 'center')
    love.graphics.printf('Continuar, reinicio: ENTER', 0, 450, ventana.ancho * ventana.escala, 'center')
end

