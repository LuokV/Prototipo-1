MaquinaEstadoJugador = Class{}

function MaquinaEstadoJugador:init(estados_globales)
    self.base = {
        dibujar = function() end,
        actualizar = function() end,
        ingresar = function() end,
        salir = function() end,
    }

    self.estados_globales = estados_globales or {}
    self.actual = self.base
end

function MaquinaEstadoJugador:cambiar(nombreEstado, parametrosIniciales)
    assert(self.estados_globales[nombreEstado])
    self.actual:salir()
    self.actual = self.estados_globales [nombreEstado] ()
    self.actual:ingresar (parametrosIniciales)
    self.nombre_actual = nombreEstado
end

function MaquinaEstadoJugador:actualizar(dt)
    self.actual:actualizar(dt)
end

function MaquinaEstadoJugador:dibujar()
    self.actual:dibujar()
end