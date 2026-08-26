require ("escenario")
require ("jugador")
require ("notasmusicales")
require ("animaciones")

-- VENTANA     (pensado para un juego pixel art)
ventana = {
ancho = 160,
alto = 144,
escala = 4
}

entidad1 = nil
entidad2 = nil
contacto = false
nx, ny = nil

depurar = true

ataque = nil
ataque2 = nil
ataque3 = nil
ataque4 = nil
color = nil

derrota = false
victoria = false

---------------------------- FUNCIONES -----------------------------------

-- COLISIONES

-- Por cuerpo físico
function iniciarContacto(a,b,col)
    contacto = true

    if a:getUserData() == "jugador" or b:getUserData() == "jugador" then
        jugador.encontacto = jugador.encontacto + 1
    end

    entidad1 = a:getUserData()
    entidad2 = b:getUserData()

    nx,ny = col:getNormal()
end

function terminarContacto(a,b,col)
    contacto = false

    if a:getUserData() == "jugador" or b:getUserData() == "jugador" then
        jugador.encontacto = jugador.encontacto - 1
    end

    entidad1 = nil
    entidad2 = nil
end


-- REDONDEO ya que se trabaja con pixel art
function redondear(n)
    return math.floor(n + 0.5)
end


-- DEBUG
function debugUI()
    love.graphics.setColor(0, 1, 0)
    love.graphics.print("FPS: "..love.timer.getFPS(), 10, 10)
    if nota_roja.atrapado or nota_verde.atrapado then
        love.graphics.print("ATRAPADO", 100, 10)
    end
    love.graphics.setColor(1, 1, 1)
end

function debugHitboxes()
        love.graphics.setColor(0, 1, 0)
        jugador.Debug()
        nota_roja:Debug()
        nota_verde:Debug()
        love.graphics.setColor(1, 1, 1)
end


-- INTERACCION INPUT
function love.keypressed(key, scancode, isrepeat)
    if key == "f1" then
        depurar = not depurar
    elseif key == "q" and not ataque.activado then
        ataque.activado =true
    elseif key == "w" and not ataque2.activado then
        ataque2.activado =true
    elseif key == "e" and not ataque3.activado then
        ataque3.activado =true
    elseif key == "r" and not ataque4.activado then
        ataque4.activado =true
    end 
end

-- Quien recibio el golpe, el jugador o la nota
function Golpe(nota, tipoataque)
    if nota.atrapado then
        nota:PosicionarNota()
        if tipoataque.activado then
            jugador.notas = jugador.notas + 1
        else jugador.vidas = jugador.vidas - 1
        end
    end
end

------------------------ INICIAR - ACTUALIZAR - RENDERIZAR ----------------------

-- INICIALIZACION
function love.load()

    --Inicializacion del mundo fisico
    love.physics.setMeter(32)
    world = love.physics.newWorld(0,9.81*4,true)
    world:setCallbacks(iniciarContacto, terminarContacto)

    --Inicializacion de la ventana
    love.window.setMode (ventana.ancho * ventana.escala, ventana.alto * ventana.escala )
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- Incializacion del Canvas
    lienzo = love.graphics.newCanvas(ventana.ancho, ventana.alto)

    --Inicializacion del Jugador
    jugador.Crear(ventana.ancho/2, 130)

    --Iniciar Notas // ARREGLAR BUG DEL ESCALADO
    nota_roja = NotasMusicales:Nueva(130, 130, "img/Rojo.png", 10, 1, 1)
    nota_verde = NotasMusicales:Nueva(130,130, "img/Verde.png", 30, 1, 2)
    nota_azul = NotasMusicales:Nueva(130,130, "img/Azul.png", 30, 1, 2)
    nota_amarilla = NotasMusicales:Nueva(130,130, "img/Amarillo.png", 30, 1, 2)

    -- Ataques musicales
    ataque = CrearAnimacion("img/CortarSprites.png",3,32,32,12, false)
    ataque.activado = false

    ataque2 = CrearAnimacion("img/AuraSprites.png",4,25,24,12, false)
    ataque2.activado = false

    ataque3 = CrearAnimacion("img/AuraSprites.png",4,25,24,12, false)
    ataque3.activado = false

    ataque4 = CrearAnimacion("img/AuraSprites.png",4,25,24,12, false)
    ataque4.activado = false

    -- Posiciones de notas musicales
    math.randomseed(os.time())
    nota_roja:PosicionarNota()
    nota_verde:PosicionarNota()
    nota_azul:PosicionarNota()
    nota_amarilla:PosicionarNota()

    CrearEscenario()
end

-- ACTUALIZACION
function love.update(dt)
    world:update(dt)

    if derrota or victoria then
        return
    end

    jugador.Actualizar(dt)

    nota_roja:Actualizar(jugador.cuerpo:getX(), jugador.cuerpo:getY(), jugador.ancho, jugador.alto, dt)
    nota_verde:Actualizar(jugador.cuerpo:getX(), jugador.cuerpo:getY(), jugador.ancho, jugador.alto, dt)
    nota_azul:Actualizar(jugador.cuerpo:getX(), jugador.cuerpo:getY(), jugador.ancho, jugador.alto, dt)
    nota_amarilla:Actualizar(jugador.cuerpo:getX(), jugador.cuerpo:getY(), jugador.ancho, jugador.alto, dt)

    nota_roja.atrapado = nota_roja:Colisiones()
    nota_verde.atrapado = nota_verde:Colisiones()
    nota_azul.atrapado = nota_azul:Colisiones()
    nota_amarilla.atrapado = nota_amarilla:Colisiones()

    ActualizarAnimacion(ataque,dt, true)
    ActualizarAnimacion(ataque2,dt, true)
    ActualizarAnimacion(ataque3,dt, true)
    ActualizarAnimacion(ataque4,dt, true)

    Golpe(nota_roja, ataque)
    Golpe(nota_verde, ataque2)
    Golpe(nota_azul, ataque3)
    Golpe(nota_amarilla, ataque4)

end

-- RENDER
function love.draw()
    love.graphics.setCanvas(lienzo)
    love.graphics.clear()

    DibujarEscenario()

    jugador:Dibujar()

    love.graphics.setColor(1, 0, 0)
    DibujarAnimacion(ataque, redondear(jugador.cuerpo:getX()), redondear(jugador.cuerpo:getY()), jugador.origen_x + 8, jugador.origen_y + 8)
    love.graphics.setColor(0, 1, 0)
    DibujarAnimacion(ataque2, redondear(jugador.cuerpo:getX()), redondear(jugador.cuerpo:getY()), jugador.origen_x + 5, jugador.origen_y + 5)
    love.graphics.setColor(0, 0, 1)
    DibujarAnimacion(ataque3, redondear(jugador.cuerpo:getX()), redondear(jugador.cuerpo:getY()), jugador.origen_x + 5, jugador.origen_y + 5)
    love.graphics.setColor(1, 1, 0)
    DibujarAnimacion(ataque4, redondear(jugador.cuerpo:getX()), redondear(jugador.cuerpo:getY()), jugador.origen_x + 5, jugador.origen_y + 5)
    love.graphics.setColor(1, 1, 1)

    nota_roja:Dibujar()
    nota_verde:Dibujar()
    nota_azul:Dibujar()
    nota_amarilla:Dibujar()

    if depurar then
        debugHitboxes()
    end

    love.graphics.setCanvas()

    love.graphics.draw(lienzo, 0, 0, 0, ventana.escala, ventana.escala)

       if depurar then
        debugUI()
    end

    if not derrota then
        love.graphics.print("Vidas "..jugador.vidas, 60, 10)
    end

    if not victoria then
        love.graphics.print("Objetivo Notas "..jugador.notas.."/"..jugador.cancion, 450 ,10)
    end

    love.graphics.setColor(1, 0, 0)
    if contacto then
        love.graphics.print("CHOQUE", 650/2,200 + 20)
        love.graphics.print(entidad1, 650/2,200 + 30)
        love.graphics.print(entidad2, 650/2,200 + 40)
        love.graphics.print(jugador.encontacto, 650/2,200 + 50)
    end
    love.graphics.setColor(1, 1, 1)
    
end