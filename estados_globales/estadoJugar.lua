EstadoJugar = Class {__includes = Estado}

-- Variables globales

    derrota = false
    victoria = false

    
-- COLISIONES 
-- Por cuerpo físico
function EstadoJugar:iniciarContacto(a,b,col)

    if not self.jugador or not self.jugador.cuerpo or not col or col:isDestroyed() then
        return
    end

    if a:isDestroyed() or b:isDestroyed() then
        return
    end

    self.contacto = true

    local nx, ny = col:getNormal()
    if not nx or not ny then return end

    if a:getUserData() == "jugador" or b:getUserData() == "jugador" then
        self.jugador.encontacto = self.jugador.encontacto + 1
    end

    local toco_piso = false
      
    if a:getUserData() == "jugador" and b:getUserData() == "Piso" or
       a:getUserData() == "jugador" and b:getUserData() == "Plataforma"  then
       if ny > 0.5 then -- Solo permite saltar si esta en la parte SUPERIOR
        toco_piso = true
       end 
       elseif b:getUserData() == "jugador" and (a:getUserData() == "Piso" or a:getUserData() == "Plataforma") then
        if ny < -0.5 then 
            toco_piso = true 
        end
    end

    if toco_piso then
        self.jugador.puede_saltar = true
    end

    self.entidad1 = a:getUserData()
    self.entidad2 = b:getUserData()
  
end

function EstadoJugar:terminarContacto(a,b,col)

     if not self.jugador then
        return
    end

    self.contacto = false

    if a:getUserData() == "jugador" or b:getUserData() == "jugador" then
        self.jugador.encontacto = self.jugador.encontacto - 1
    end

    if self.jugador.encontacto == 0 then
    self.jugador.puede_saltar = false -- Evita saltar "en caida"
    end

    self.entidad1 = nil
    self.entidad2 = nil
end

-- DEBUG
function EstadoJugar:debugUI()
    love.graphics.setColor(0, 1, 0)
    love.graphics.print("FPS: "..love.timer.getFPS(), 350, 650)

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

-- INPUT
function EstadoJugar:keypressed(key)

    if key == "f1" then
        self.depurar = not self.depurar
    end

    self.jugador:keypressed(key) -- Pasa la tecla al jugador para que su funcion se encargue si coinciden
 
end

-- Reiniciar EstadoJugar

function EstadoJugar:reiniciar()

    self.world:setCallbacks(nil,nil,nil,nil)

    self.world:destroy()

    self.world = nil

    collectgarbage("collect")

    derrota = false
    victoria = false

    self.world = love.physics.newWorld(0,9.81*16,true)

    self.jugador = Jugador(ventana.ancho/2, 70, self.world)

    self.escenario = CrearEscenario(self.world)

    self.world:setCallbacks(
        function (a, b, col) self:iniciarContacto(a,b,col)end,
        function (a, b, col) self:terminarContacto(a,b,col)end
    )

    self.notas_musicales = nil

    self.notas_musicales = {}

    table.insert(self.notas_musicales, NotasMusicales(130, 130, "img/Rojo.png", 10, 1, "sounds/cortar.wav", self.jugador.ataque))
    table.insert(self.notas_musicales, NotasMusicales(130,130, "img/Verde.png", 20, 1, "sounds/colision.wav", self.jugador.ataque2))
    table.insert(self.notas_musicales, NotasMusicales(130,130, "img/Azul.png", 10, 1, "sounds/espada.wav", self.jugador.ataque3))
    table.insert(self.notas_musicales, NotasMusicales(130,130, "img/Amarillo.png", 10, 1, "sounds/pium.mp3", self.jugador.ataque4))

    math.randomseed(os.time())
    for i, notas in ipairs(self.notas_musicales) do
        notas:PosicionarNota()
    end

end

---INICIALIZAR

function EstadoJugar:init()

    self.entidad1 = nil
    self.entidad2 = nil
    self.contacto = false

    self.depurar = true

    --Inicializacion del mundo fisico
    love.physics.setMeter(32)
    self.world = love.physics.newWorld(0,9.81*16,true)

    --Inicializacion del Jugador
    self.jugador = Jugador(ventana.ancho/2, 70, self.world)
    CrearEscenario(self.world)

    self.world:setCallbacks(
        function (a, b, col) self:iniciarContacto(a,b,col)end,
        function (a, b, col) self:terminarContacto(a,b,col)end
    )

    --MUSICA
    sonidos.musica:setLooping(true)
    sonidos.musica:setVolume(0.40) -- 0 a 1
    love.audio.play(sonidos.musica)

    self.notas_musicales = {}

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
   
end   

-- Cada vez que se entra al juego desde el titulo luego de ganar o perder, se reinicia
function EstadoJugar:ingresar()
    
    self:reiniciar()

end

function EstadoJugar:salir() end

-- ACTUALIZAR

function EstadoJugar:actualizar(dt)

    if derrota or victoria then
        if love.keyboard.isDown ("r") then
            self:reiniciar()
            return
        end
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

-- DIBUJAR

function EstadoJugar:dibujar()

    love.graphics.setCanvas(lienzo)
    love.graphics.clear()

    love.graphics.setFont(fuente_small)

    DibujarEscenario()

    self.jugador:Dibujar()

    for i, notas in ipairs(self.notas_musicales) do
        notas:Dibujar()
    end

    if self.depurar then
       self:debugHitboxes()
    end

    love.graphics.setCanvas()

    love.graphics.draw(lienzo, 0, 0, 0, ventana.escala, ventana.escala)

   if self.depurar then
       self:debugUI()
    end

    if not derrota then
        love.graphics.print("Vidas "..self.jugador.vidas, 60, 10)
    end

    if not victoria then
        love.graphics.print("Objetivo Notas "..self.jugador.notas.."/"..self.jugador.cancion, 450 ,10)
    end

    love.graphics.setColor(1, 0, 0)
    if self.contacto then
        love.graphics.print("CHOQUE", 650/2,220)
        love.graphics.print(self.entidad1, 650/2,260)
        love.graphics.print(self.entidad2, 650/2,300)
        love.graphics.print(self.jugador.encontacto, 650/2,330)
    end
    love.graphics.setColor(1, 1, 1)

end
