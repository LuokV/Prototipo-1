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

-- Importar Maquinas de Estdos
require "maquinas_de_estado.maquinaEstadosGlobal"