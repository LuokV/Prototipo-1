require ("escenario")
require ("jugador")
require ("notasmusicales")

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

atrapado = false
depurar = true

---------------------------- FUNCIONES -----------------------------------

-- COLISIONES

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

function comprobarColision(jugador,nota)
 
    x1 = jugador.hitbox_x
    y1 = jugador.hitbox_y
    ancho1 = jugador.ancho
    alto1 = jugador.alto

    x2 = nota.hitbox_x
    y2= nota.hitbox_y
    ancho2 = nota.ancho
    alto2 = nota.alto

    return x1 < x2 + ancho2 and
           x2 < x1 + ancho1 and
           y1 < y2 + alto2 and
           y2 < y1 + alto1
end


-- REDONDEO ya que se trabaja con pixel art
function redondear(n)
    return math.floor(n + 0.5)
end


-- DEBUG
function debugUI()
    love.graphics.setColor(0, 1, 0)
    love.graphics.print("FPS: "..love.timer.getFPS(), 10, 10)
    if atrapado then
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

    --Iniciar Notas
    nota_roja = NotasMusicales:Nueva(130, 130, "img/Rojo.png", 10, 0.75, 1)
    nota_verde = NotasMusicales:Nueva(130,130, "img/Verde.png", 70, 0.75, 2)

    -- Posiciones de notas musicales
    math.randomseed(os.time())
    nota_roja:PosicionarNota()
    nota_verde:PosicionarNota()

    CrearEscenario()
end

-- ACTUALIZACION
function love.update(dt)
    world:update(dt)

    jugador.Actualizar(dt)

    nota_roja:Actualizar(jugador.cuerpo:getX(), jugador.cuerpo:getY(), jugador.ancho, jugador.alto, dt)
    nota_verde:Actualizar(jugador.cuerpo:getX(), jugador.cuerpo:getY(), jugador.ancho, jugador.alto, dt)

    atrapado = comprobarColision(jugador,nota_roja)
    atrapado = comprobarColision(jugador,nota_verde)
    
end

-- RENDER
function love.draw()
    love.graphics.setCanvas(lienzo)
    love.graphics.clear()

    DibujarEscenario()
    jugador:Dibujar()

    nota_roja:Dibujar()
    nota_verde:Dibujar()

    if depurar then
        debugHitboxes()
    end

    love.graphics.setCanvas()

    love.graphics.draw(lienzo, 0, 0, 0, ventana.escala, ventana.escala)

       if depurar then
        debugUI()
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