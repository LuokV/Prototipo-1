EstadoJugar = Class {__includes = Estado}

-- Variables globales

    derrota = false
    victoria = false

    tiempo_spawn = 0
    intervalo_spawn = 1.5

------------------------------------- COLISIONES 
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

------------------------------------------ DEBUG
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

-------------------------------------------- INPUT TECLADO
function EstadoJugar:keypressed(key)

    if key == "f1" then
        self.depurar = not self.depurar
    end

    self.jugador:keypressed(key) -- Pasa la tecla al jugador para que su funcion se encargue si coinciden
 
end

------------------------------------------------- GENERACION de NotasMusicales ALEATORIAS

function EstadoJugar:generarNotaMusical()
    local notas_posibles = Listado_Notas(self.jugador)
    local nota_elegida = notas_posibles[math.random(#notas_posibles)]
    local velocidad_nota = math.random(5,30)
    local nueva_notamusical = NotasMusicales(
            nota_elegida.ruta, 
            velocidad_nota, 
            nota_elegida.escala, 
            nota_elegida.ruta_sonido,
            nota_elegida.ataque_jugador
        )
    nueva_notamusical:PosicionarNota()
    table.insert(self.notas_musicales, nueva_notamusical)
end

-------------------- Reiniciar EstadoJugar

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

    self:generarNotaMusical()

end

----------------------INICIALIZAR-------------------------

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

    math.randomseed(os.time())
   
end   

-- Cada vez que se entra al juego desde el titulo luego de ganar o perder, se reinicia
function EstadoJugar:ingresar()
    
    self:reiniciar()

end

function EstadoJugar:salir() end

----------------------ACTUALIZAR-------------------------

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

    tiempo_spawn = tiempo_spawn + dt
    if tiempo_spawn >= intervalo_spawn then
        self:generarNotaMusical()
        tiempo_spawn = 0
    end

    --Movimiento de las notas musicales
    for i = #self.notas_musicales, 1, -1 do
        local notas = self.notas_musicales [i]
        notas:Actualizar(self.jugador.cuerpo:getX(), self.jugador.cuerpo:getY(), self.jugador.ancho, self.jugador.alto, dt)
        --Verificación de colision de las notas musicales con el jugador
        notas.atrapado = notas:Colisiones(self.jugador)
        --Función que verifica quien recibio el golpe y las condiciones de derrota/victoria
        notas:Golpe(self.jugador)
        if notas.atrapado then
            table.remove(self.notas_musicales, i)
        end
    end
end

----------------------DIBUJAR-------------------------

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
       love.graphics.print("Notas: " .. #self.notas_musicales, 40, ventana.alto/2)
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
    if self.contacto and self.depurar then
        love.graphics.print("CHOQUE", 650/2,220)
        love.graphics.print(self.entidad1, 650/2,260)
        love.graphics.print(self.entidad2, 650/2,300)
        love.graphics.print(self.jugador.encontacto, 650/2,330)
    end
    love.graphics.setColor(1, 1, 1)

end
