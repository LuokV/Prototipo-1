-- Librerias
Class = require 'lib.class'

-- Importar Clases
require ("escenario")
require ("jugador")
require ("notasmusicales")
require ("animaciones")

-- Importar Estados Globales
require "estados_globales.estado"
require "estados_globales.estadoJugar"
require "estados_globales.estadoTitulo"
require "estados_globales.estadoDerrota"
require "estados_globales.estadoVictoria"

--Importar Estados Jugador
require "estados_jugador.estadoJugador"
require "estados_jugador.estadoAtacar"
require "estados_jugador.estadoCorrer"
require "estados_jugador.estadoIdle"
require "estados_jugador.estadoSaltar"

-- Importar Maquinas de Estdos
require "maquinas_de_estado.maquinaEstadosGlobal"
require "maquinas_de_estado.maquinaEstadosJugador"