MaquinaEstadoGlobal = Class{}

function MaquinaEstadoGlobal:init(estados_globales)
    self.base = {
        dibujar = function() end,
        actualizar = function() end,
        ingresar = function() end,
        salir = function() end,
    }

    self.estados_globales = estados_globales or {}
    self.actual = self.base
end

function MaquinaEstadoGlobal:cambiar(nombreEstado, parametrosIniciales)
    assert(self.estados_globales[nombreEstado])
    self.actual:salir()
    self.actual = self.estados_globales [nombreEstado] ()
    self.actual:ingresar (parametrosIniciales)
    self.nombre_actual = nombreEstado
end

function MaquinaEstadoGlobal:actualizar(dt)
    self.actual:actualizar(dt)
end

function MaquinaEstadoGlobal:dibujar()
    self.actual:dibujar()
end