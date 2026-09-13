EstadoJugar = Class {__includes = Estado}

-- COLISIONES 
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

-- DEBUG
function EstadoJugar:debugUI()
    love.graphics.setColor(0, 1, 0)
    love.graphics.print("FPS: "..love.timer.getFPS(), 10, 10)

    for i, notas in ipairs(self.notas_musicales) do
       if notas.atrapado then
        love.graphics.print("ATRAPADO", 100, 10)
       end
    end

    love.graphics.setColor(1, 1, 1)
end

function EstadoJugar:debugHitboxes()
        love.graphics.setColor(0, 1, 0)
        self.jugador:Debug()
      
        for i, notas in ipairs(self.notas_musicales) do
            notas:Debug()
        end

        love.graphics.setColor(1, 1, 1)
end

function EstadoJugar:init()

    --Inicializacion del mundo fisico
    love.physics.setMeter(32)
    self.world = love.physics.newWorld(0,9.81*16,true)
    self.world:setCallbacks(iniciarContacto, terminarContacto)

    --MUSICA
    sonidos.musica:setLooping(true)
    sonidos.musica:setVolume(0.40) -- 0 a 1
    love.audio.play(sonidos.musica)

    self.notas_musicales = {}

    --Inicializacion del Jugador
    self.jugador = Jugador(ventana.ancho/2, 70, self.world)

    --Iniciar Notas 
    table.insert(self.notas_musicales, NotasMusicales(130, 130, "img/Rojo.png", 10, 1, "sounds/cortar.wav", self.jugador.ataque))
    table.insert(self.notas_musicales, NotasMusicales(130,130, "img/Verde.png", 20, 1, "sounds/colision.wav", self.jugador.ataque2))
    table.insert(self.notas_musicales, NotasMusicales(130,130, "img/Azul.png", 10, 1, "sounds/espada.wav", self.jugador.ataque3))
    table.insert(self.notas_musicales, NotasMusicales(130,130, "img/Amarillo.png", 10, 1, "sounds/pium.mp3", self.jugador.ataque4))

    -- Posiciones de notas musicales
    math.randomseed(os.time())
    for i, notas in ipairs(self.notas_musicales) do
        notas:PosicionarNota()
    end

    CrearEscenario(self.world)
end   

function EstadoJugar:ingresar() end
function EstadoJugar:salir() end

function EstadoJugar:actualizar(dt)

    if derrota or victoria then
        return
    end

    self.world:update(dt)

    self.jugador:Actualizar(dt)

    --Movimiento de las notas musicales
    for i, notas in ipairs(self.notas_musicales) do
        notas:Actualizar(self.jugador.cuerpo:getX(), self.jugador.cuerpo:getY(), self.jugador.ancho, self.jugador.alto, dt)
    end

    --Verificación de colision de las notas musicales con el juegador
    for i, notas in ipairs(self.notas_musicales) do
        notas.atrapado = notas:Colisiones(self.jugador)
    end

   --Función que verifica quien recibio el golpe y las condiciones de derrota/victoria
    for i, notas in ipairs(self.notas_musicales) do
        notas:Golpe(self.jugador)
    end

end

function EstadoJugar:dibujar()

    love.graphics.setCanvas(lienzo)
    love.graphics.clear()

    DibujarEscenario()

    self.jugador:Dibujar()

    for i, notas in ipairs(self.notas_musicales) do
        notas:Dibujar()
    end

    if depurar then
       self:debugHitboxes()
    end

    love.graphics.setCanvas()

    love.graphics.draw(lienzo, 0, 0, 0, ventana.escala, ventana.escala)

   if depurar then
       self:debugUI()
    end

    if not derrota then
        love.graphics.print("Vidas "..self.jugador.vidas, 60, 10)
    end

    if not victoria then
        love.graphics.print("Objetivo Notas "..self.jugador.notas.."/"..self.jugador.cancion, 450 ,10)
    end

    love.graphics.setColor(1, 0, 0)
    if contacto then
        love.graphics.print("CHOQUE", 650/2,200 + 20)
        love.graphics.print(entidad1, 650/2,200 + 30)
        love.graphics.print(entidad2, 650/2,200 + 40)
        love.graphics.print(self.jugador.encontacto, 650/2,200 + 50)
    end

    love.graphics.setColor(1, 1, 0)
    love.graphics.print ("Presiona Q W E R para golpear las notas segun su color correspondiente",100,500 + 20)
    love.graphics.setColor(1, 1, 1)

end
