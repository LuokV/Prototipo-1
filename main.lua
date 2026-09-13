require 'dependencias'

-- VENTANA     (pensado para un juego pixel art)
ventana = {
ancho = 240,
alto = 200,
escala = 3.5
}

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

notas_musicales = {}

---------------------------- FUNCIONES -----------------------------------

-- COLISIONES

-- Por cuerpo físico
function iniciarContacto(a,b,col)

    contacto = true
    nx,ny = col:getNormal()

    if a:getUserData() == "jugador" or b:getUserData() == "jugador" then
        jugador.encontacto = jugador.encontacto + 1
    end
      
    if a:getUserData() == "jugador" and b:getUserData() == "Piso" or
       a:getUserData() == "jugador" and b:getUserData() == "Plataforma"  then
       if ny > 0.5 then -- Soloe permite saltar si esta en la parte SUPERIOR
        jugador.puede_saltar = true
       end 
    end

    entidad1 = a:getUserData()
    entidad2 = b:getUserData()
  
end

function terminarContacto(a,b,col)
    contacto = false

    if a:getUserData() == "jugador" or b:getUserData() == "jugador" then
        jugador.encontacto = jugador.encontacto - 1
    end

    if jugador.encontacto == 0 then
    jugador.puede_saltar = false -- Evita saltar "en caida"
    end

    entidad1 = nil
    entidad2 = nil
end

---------------------------------------------------------------

-- REDONDEO ya que se trabaja con pixel art
function redondear(n)
    return math.floor(n + 0.5)
end


-- DEBUG
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


-- INTERACCION INPUT
function love.keypressed(key, scancode, isrepeat)
    if key == "f1" then
        depurar = not depurar
    elseif key == "q" and not jugador.ataque.activado then
        jugador.ataque.activado =true
        love.audio.play(sonidos.sfx_whoosh)
    elseif key == "w" and not jugador.ataque2.activado then
        jugador.ataque2.activado =true
        love.audio.play(sonidos.sfx_whoosh)
    elseif key == "e" and not jugador.ataque3.activado then
        jugador.ataque3.activado =true
        love.audio.play(sonidos.sfx_whoosh)
    elseif key == "r" and not jugador.ataque4.activado then
        jugador.ataque4.activado =true
        love.audio.play(sonidos.sfx_whoosh)
    end 
end

------------------------ INICIAR - ACTUALIZAR - RENDERIZAR ----------------------

-- INICIALIZACION
function love.load()

    --Inicializacion del mundo fisico
    love.physics.setMeter(32)
    world = love.physics.newWorld(0,9.81*16,true)
    world:setCallbacks(iniciarContacto, terminarContacto)

    --Inicializacion de la ventana
    love.window.setMode (ventana.ancho * ventana.escala, ventana.alto * ventana.escala )
    love.graphics.setDefaultFilter("nearest", "nearest")

    --MUSICA
    sonidos.musica:setLooping(true)
    sonidos.musica:setVolume(0.40) -- 0 a 1
    love.audio.play(sonidos.musica)

    -- Incializacion del Canvas
    lienzo = love.graphics.newCanvas(ventana.ancho, ventana.alto)

    --Inicializacion del Jugador
    jugador = Jugador(ventana.ancho/2, 70)

    --Iniciar Notas 
    table.insert(notas_musicales, NotasMusicales(130, 130, "img/Rojo.png", 10, 1, "sounds/cortar.wav", jugador.ataque))
    table.insert(notas_musicales, NotasMusicales(130,130, "img/Verde.png", 20, 1, "sounds/colision.wav", jugador.ataque2))
    table.insert(notas_musicales, NotasMusicales(130,130, "img/Azul.png", 10, 1, "sounds/espada.wav", jugador.ataque3))
    table.insert(notas_musicales, NotasMusicales(130,130, "img/Amarillo.png", 10, 1, "sounds/pium.mp3", jugador.ataque4))

    -- Posiciones de notas musicales
    math.randomseed(os.time())
    for i, notas in ipairs(notas_musicales) do
        notas:PosicionarNota()
    end

    CrearEscenario()
end

-- ACTUALIZACION
function love.update(dt)
    
     if derrota or victoria then
        return
    end

    world:update(dt)

    jugador:Actualizar(dt)

    --Movimiento de las notas musicales
    for i, notas in ipairs(notas_musicales) do
        notas:Actualizar(jugador.cuerpo:getX(), jugador.cuerpo:getY(), jugador.ancho, jugador.alto, dt)
    end

    --Verificación de colision de las notas musicales con el juegador
    for i, notas in ipairs(notas_musicales) do
        notas.atrapado = notas:Colisiones()
    end

   --Función que verifica quien recibio el golpe y las condiciones de derrota/victoria
    for i, notas in ipairs(notas_musicales) do
        notas:Golpe()
    end

end

-- RENDER
function love.draw()
    love.graphics.setCanvas(lienzo)
    love.graphics.clear()

    DibujarEscenario()

    jugador:Dibujar()

    for i, notas in ipairs(notas_musicales) do
        notas:Dibujar()
    end


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

    love.graphics.setColor(1, 1, 0)
    love.graphics.print ("Presiona Q W E R para golpear las notas segun su color correspondiente",100,500 + 20)
    love.graphics.setColor(1, 1, 1)
    
end