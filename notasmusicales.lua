-- Objetivo y "enemigo" del juego 
NotasMusicales = Class {}

--Inicializacion

function NotasMusicales:init(ruta, velocidad, escala, ruta_sonido, ataque_jugador)

    self.x = 0
    self.y = 0
    self.escala = escala
    self.sprite = love.graphics.newImage(ruta)
    self.ancho = self.sprite:getWidth()
    self.alto = self.sprite:getHeight()
    self.origen_x = self.ancho/2 
    self.origen_y = self.alto/2 
    self.hitbox_x = 0
    self.hitbox_y = 0
    self.hitbox_ancho = 0
    self.hitbox_alto = 0
    self.velocidad = velocidad
    self.atrapado = false
    self.sonido =  love.audio.newSource(ruta_sonido, "static")
    self.debil_a = ataque_jugador
   
end

-- FUNCIONES DE COMPORTAMIENTO

function NotasMusicales:Colisiones(jugador)
    local x1 = jugador.hitbox_x
    local y1 = jugador.hitbox_y
    local ancho1 = jugador.ancho
    local alto1 = jugador.alto

    local x2 = self.hitbox_x
    local y2= self.hitbox_y
    local ancho2 = self.ancho
    local alto2 = self.alto

    return x1 < x2 + ancho2 and
           x2 < x1 + ancho1 and
           y1 < y2 + alto2 and
           y2 < y1 + alto1
end

function NotasMusicales:PosicionarNota()
    local borde = math.random(1,4)
    if borde == 1 then
        self.x = math.random(0, ventana.ancho)
        self.y = -5
    elseif borde == 2 then
        self.x = math.random(0, ventana.ancho)
        self.y = ventana.alto +5
    elseif borde == 3 then
        self.x = -5
        self.y = math.random(0, ventana.alto)
    elseif borde == 4 then
        self.x = ventana.ancho +5
        self.y = math.random(0, ventana.alto)
    end
end

-- En caso de colision, controla el cambio de los valores de las variables dependiendo de quien recibio el golpe
function NotasMusicales:Golpe(jugador)
    
    if self.atrapado then
        if self.debil_a.activado then
            jugador.notas = jugador.notas + 1
            love.audio.play(self.sonido)
            if jugador.notas == jugador.cancion then
                victoria = true
                love.audio.stop(sonidos.musica)
                love.audio.play(sonidos.victoria)
            end
        else jugador.vidas = jugador.vidas - 1
             love.audio.play(sonidos.sfx_hit)
             if jugador.vidas == 0 then
                derrota = true
                maquina_EstadoGlobal:cambiar('derrota')
                love.audio.stop(sonidos.musica)
                love.audio.play(sonidos.derrota)
             end
        end
    end
end

function Listado_Notas(jugador)
    local notas_posibles = {
        {ruta = "img/Rojo.png", escala = 1, ruta_sonido = "sounds/cortar.wav", ataque_jugador = jugador.ataque},
        {ruta = "img/Verde.png", escala =  1, ruta_sonido = "sounds/colision.wav", ataque_jugador = jugador.ataque2},
        {ruta =  "img/Azul.png", escala = 1, ruta_sonido = "sounds/espada.wav", ataque_jugador = jugador.ataque3},
        {ruta = "img/Amarillo.png", escala = 1, ruta_sonido = "sounds/pium.mp3", ataque_jugador = jugador.ataque4}
    }
    return notas_posibles
end


------ ACTUALIZACION --------

function NotasMusicales:Actualizar(x, y, a, al, dt)
       --Persecución
    local dist_x = math.abs(self.x - x)
    local dist_y = math.abs(self.y - y)

    if dist_x > dist_y then
        if dist_x > a then
            if self.x < x then
                self.x = self.x + (self.velocidad * dt)
            elseif self.x > x then
                self.x = self.x - (self.velocidad * dt)
            end
        end
    else
        if dist_y > al then
            if self.y < y then
                self.y = self.y + (self.velocidad * dt)
            elseif self.y > y then
                self.y = self.y - (self.velocidad * dt)
            end
        end
    end

    self.hitbox_ancho = self.ancho * self.escala
    self.hitbox_alto = self.alto * self.escala

    self.hitbox_x = self.x - (self.hitbox_ancho/2)
    self.hitbox_y = self.y - (self.hitbox_alto/2)
end

------ RENDER --------

function NotasMusicales:Dibujar()
    love.graphics.draw(self.sprite,redondear(self.x),redondear(self.y), 0, self.escala, self.escala, self.origen_x, self.origen_y)
end

------ DEBUG --------

function NotasMusicales:Debug()
    love.graphics.rectangle("line", redondear(self.hitbox_x), redondear(self.hitbox_y), self.hitbox_ancho, self.hitbox_alto)
    love.graphics.circle("fill", redondear(self.x), redondear(self.y), 1)
end