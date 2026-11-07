# LAST ALGORITHM

## Guía de componentes de Godot 4.7.2 para el juego 2D

**Motor:** Godot 4.7.2 · **Lenguaje interno:** GDScript · **Estilo:** 2D
isométrico / pixel art estilizado / ciencia ficción.

## 1. Propósito

Este documento reúne los nodos, clases y herramientas de Godot que
recomendamos para desarrollar Last Algorithm. Está enfocado en el mapa,
el robot explorador, el dron, la recolección de recursos, las torretas,
los enemigos, la interfaz y el editor de programación.

Los enlaces apuntan a la documentación oficial de Godot 4.7,
correspondiente a la misma rama mayor y menor que 4.7.2.

## 2. Conceptos fundamentales de Godot

-   **Nodo (`Node`):** componente básico con una responsabilidad
    concreta.
-   **Escena (`PackedScene` / `.tscn`):** árbol de nodos guardado como
    unidad reutilizable. Una escena puede representar un personaje,
    torreta, enemigo, menú o nivel.
-   **Árbol de escenas:** jerarquía de nodos activos.
-   **Señal (`Signal`):** evento que permite que un nodo notifique a
    otros sin acoplarlos directamente.

**Regla para el proyecto:** crear escenas independientes para entidades
reutilizables: `Player.tscn`, `Enemy.tscn`, `BasicTurret.tscn`,
`ResourcePickup.tscn` y `CodePanel.tscn`.

Documentación: [Conceptos
clave](https://docs.godotengine.org/en/4.7/getting_started/introduction/key_concepts_overview.html)
· [Tutorial paso a
paso](https://docs.godotengine.org/en/4.7/getting_started/step_by_step/).

## 3. Componentes 2D

### 3.1 Mundo, sprites y dibujo

  -----------------------------------------------------------------------
  Nodo / clase            Función                 Aplicación en Last
                                                  Algorithm
  ----------------------- ----------------------- -----------------------
  `Node2D`                Base para objetos 2D    Raíz del mapa, gestores
                          con transformaciones.   y puntos de aparición.

  `Sprite2D`              Muestra una textura.    Robot, dron, enemigos,
                                                  torretas y recursos.

  `AnimatedSprite2D`      Reproduce animaciones   Caminar, disparar, daño
                          por frames.             y explosiones.

  `Polygon2D`             Dibuja polígonos 2D.    Efectos, áreas
                                                  coloreadas y prototipos
                                                  visuales.

  `Line2D`                Dibuja líneas con       Láseres, líneas de
                          grosor.                 selección y depuración.

  `Parallax2D`            Desplaza capas a        Fondo con profundidad
                          distintas velocidades.  visual.

  `CanvasModulate`        Modula el color de la   Cambios globales de
                          escena 2D.              ambiente.
  -----------------------------------------------------------------------

Empezar con `Sprite2D` y pasar a `AnimatedSprite2D` cuando tengamos
hojas de sprites animadas.

### 3.2 Movimiento, físicas y detección

  -----------------------------------------------------------------------------
  Nodo / clase                  Función                 Aplicación
  ----------------------------- ----------------------- -----------------------
  `CharacterBody2D`             Cuerpo movido por       Robot y enemigos con
                                código con detección de movimiento controlado.
                                colisiones.             

  `StaticBody2D`                Cuerpo físico estático. Muros y obstáculos
                                                        sólidos.

  `RigidBody2D`                 Cuerpo gobernado por    Objetos que deben caer
                                simulación física.      o rebotar; no usarlo
                                                        para todo.

  `Area2D`                      Detecta cuerpos o áreas Recolección, alcance de
                                que entran/salen.       torretas y zonas
                                                        activadoras.

  `CollisionShape2D`            Define una forma de     Colisión del robot,
                                colisión.               obstáculos y radios.

  `CollisionPolygon2D`          Define colisión         Terreno u obstáculos
                                poligonal.              irregulares.

  `RayCast2D`                   Consulta qué hay en una Línea de visión y
                                dirección.              comprobación de
                                                        obstáculos.

  `ShapeCast2D`                 Comprueba la            Detecciones más amplias
                                intersección de una     que un rayo.
                                forma.                  

  `VisibleOnScreenNotifier2D`   Avisa al entrar/salir   Optimizar efectos y
                                de pantalla.            objetos fuera de
                                                        cámara.
  -----------------------------------------------------------------------------

Definir capas y máscaras de colisión desde el principio: por ejemplo
`World`, `Player`, `Enemy`, `Resource` y `Turret`. Una torreta debería
detectar enemigos sin detectar el terreno.

### 3.3 Cámara y orden visual

  -----------------------------------------------------------------------
  Nodo / clase            Función                 Aplicación
  ----------------------- ----------------------- -----------------------
  `Camera2D`              Controla qué parte del  Seguir al robot o
                          mundo se ve.            encuadrar el mapa.

  `CanvasLayer`           Dibuja elementos        HUD, editor, botones y
                          independientemente de   paneles fijos.
                          la cámara del mundo.    

  Ordenación por Y /      Ordena elementos según  Evitar que el robot
  `y_sort_enabled`        su coordenada vertical. aparezca siempre
                                                  delante o detrás de
                                                  árboles y edificios.
  -----------------------------------------------------------------------

En el estilo isométrico, el orden de dibujo es importante. Usar
ordenación por Y cuando corresponda y ajustar `z_index` para excepciones
como efectos, tejados o interfaces.

### 3.4 Mapas, tiles y rutas

  -----------------------------------------------------------------------
  Nodo / clase            Función                 Aplicación
  ----------------------- ----------------------- -----------------------
  `TileMapLayer`          Capa de mapa basada en  Suelo, caminos, agua y
                          cuadrícula y `TileSet`. decoración.

  `TileSet`               Recurso que contiene    Atlas, terrenos
                          tiles y sus             automáticos y
                          propiedades.            colisiones.

  `Path2D`                Define una trayectoria  Camino fijo de las
                          con una curva 2D.       oleadas.

  `PathFollow2D`          Sigue la curva de un    Mover enemigos por el
                          `Path2D`.               camino.

  `NavigationRegion2D`    Define una zona         Movimiento libre
                          navegable.              evitando obstáculos.

  `NavigationAgent2D`     Calcula rutas y puede   Robot o unidades con
                          evitar obstáculos.      navegación dinámica.

  `AStarGrid2D`           Busca rutas en una      Movimiento táctico por
                          cuadrícula.             celdas.
  -----------------------------------------------------------------------

**Importante:** en Godot 4.7 se recomienda `TileMapLayer`; el nodo
`TileMap` está obsoleto/deprecado en favor de capas `TileMapLayer`.

Decisión recomendada: - Mapa: varios `TileMapLayer`. - Enemigos por ruta
fija: `Path2D` + `PathFollow2D`. - Robot controlado por el jugador:
`CharacterBody2D`. - Rutas automáticas: evaluar `AStarGrid2D` o
navegación solo si el diseño las necesita.

## 4. Interfaz de usuario (UI)

La interfaz se construye principalmente con nodos `Control`.

  -----------------------------------------------------------------------
  Nodo / clase            Función                 Aplicación
  ----------------------- ----------------------- -----------------------
  `Control`               Base de elementos UI.   Raíz de paneles.

  `Panel` /               Contenedor visual con   Editor, inventario y
  `PanelContainer`        fondo.                  torretas.

  `MarginContainer`       Añade márgenes          Espaciado de paneles.
                          internos.               

  `VBoxContainer`         Ordena hijos            Listas y mensajes.
                          verticalmente.          

  `HBoxContainer`         Ordena hijos            Barra de vida, monedas
                          horizontalmente.        y oleada.

  `GridContainer`         Ordena elementos en     Catálogo de torretas.
                          cuadrícula.             

  `Button`                Botón interactivo.      Ejecutar, pausar,
                                                  construir y reiniciar.

  `Label`                 Texto simple.           Recursos, costes y
                                                  estado.

  `RichTextLabel`         Texto con formato       Consola y mensajes de
                          BBCode.                 error.

  `TextureRect`           Muestra una textura en  Iconos y miniaturas.
                          UI.                     

  `ProgressBar`           Barra de progreso.      Vida de base y progreso
                                                  de oleada.

  `CodeEdit`              Editor de texto         Editor de programación
                          orientado a código.     del jugador.

  `TextEdit`              Editor multilínea       Consola o campo de
                          general.                texto.

  `ScrollContainer`       Permite desplazar       Historial y
                          contenido.              documentación.

  `TabContainer`          Organiza paneles por    Código del robot /
                          pestañas.               código de torretas /
                                                  ayuda.

  `AcceptDialog`          Diálogo de aviso o      Reinicios y mensajes
                          confirmación.           importantes.
  -----------------------------------------------------------------------

### 4.1 CodeEdit: editor del jugador

`CodeEdit` incluye funciones útiles como números de línea, plegado,
gestión de sangría y autocompletado configurable.

**Pero CodeEdit no ejecuta ni interpreta nuestro lenguaje.** Solo
proporciona la superficie de edición. Last Algorithm necesitará un
intérprete propio que:

1.  Lea el texto escrito.
2.  Lo divida en tokens (lexer).
3.  Analice la estructura (parser).
4.  Construya una representación del programa (AST).
5.  Valide sintaxis y reglas permitidas.
6.  Ejecute instrucciones de forma controlada.
7.  Envíe órdenes al robot o a las torretas.
8.  Muestre errores comprensibles.

No ejecutar código arbitrario del jugador con `eval` ni convertirlo
directamente en GDScript ejecutable. Un intérprete limitado permite
controlar las instrucciones disponibles y la progresión educativa.

## 5. Animación, tiempo, audio y efectos

  -----------------------------------------------------------------------
  Nodo / clase            Función                 Aplicación
  ----------------------- ----------------------- -----------------------
  `AnimationPlayer`       Anima propiedades       Puertas, torretas,
                          mediante pistas.        paneles y transiciones.

  `AnimationTree`         Gestiona estados y      Personajes con
                          mezclas de animación.   animaciones complejas.

  `Timer`                 Emite una señal tras un Cadencia de disparo,
                          intervalo.              oleadas y
                                                  enfriamientos.

  `Tween`                 Anima propiedades desde Aparición de paneles y
                          código.                 efectos de UI.

  `CPUParticles2D`        Partículas procesadas   Chispas, humo y polvo.
                          por CPU.                

  `GPUParticles2D`        Partículas procesadas   Efectos numerosos, si
                          por GPU.                el hardware lo permite.

  `AudioStreamPlayer`     Audio sin posición      Música y sonidos de
                          espacial.               interfaz.

  `AudioStreamPlayer2D`   Audio posicional 2D.    Disparos y explosiones.
  -----------------------------------------------------------------------

Para el primer prototipo, usar `Timer` para la cadencia de disparo y
señales para notificar eventos. Evitar bucles infinitos bloqueantes.

## 6. GDScript y arquitectura

GDScript será el lenguaje con el que el equipo desarrolla el videojuego.
Tiene sintaxis inspirada en Python y está integrado con Godot.

  Elemento            Uso
  ------------------- -------------------------------------------------------
  `extends`           Heredar de un nodo o clase.
  `class_name`        Registrar una clase reutilizable.
  `@export`           Exponer propiedades en el Inspector.
  `@onready`          Obtener referencias cuando el nodo entra en el árbol.
  `signal`            Declarar eventos.
  `enum`              Definir estados o categorías.
  `Resource`          Guardar datos reutilizables.
  `PackedScene`       Cargar e instanciar escenas.
  `await`             Esperar señales o procesos asíncronos.
  Grupos (`groups`)   Consultar nodos por categoría.
  `Autoload`          Mantener gestores globales entre escenas.

Clases/sistemas que probablemente necesitaremos: - `GameManager`: estado
general, pausa y fases. - `WaveManager`: oleadas y aparición de
enemigos. - `ResourceManager`: inventario y costes. - `EnemyData`
(`Resource`): vida, velocidad y recompensa. - `TurretData` (`Resource`):
coste, daño, alcance y cadencia. - `TurretBase`: comportamiento común. -
`BasicTurret`, `IceTurret`, `LaserTurret`: variantes. -
`CodeEditorController`: obtiene texto de `CodeEdit` y solicita
validarlo. - `Lexer`, `Parser`, `Interpreter`: componentes del lenguaje
educativo.

No todo debe ser un Autoload. Los sistemas que pertenecen a un nivel o
entidad pueden vivir dentro de su escena.

### Ejemplo mínimo de una torreta

``` gdscript
extends Node2D
class_name TurretBase

@export var damage: float = 10.0
@export var attack_range: float = 150.0
@export var fire_rate: float = 1.0

var current_target: Node2D = null

func attack() -> void:
    if current_target == null:
        return
    if not is_instance_valid(current_target):
        current_target = null
        return
    # Aquí conectaremos daño y proyectiles.
```

Es solo una estructura inicial: detección, temporizador y proyectiles se
implementarán por separado.

## 7. Qué usar en cada parte del juego

### 7.1 Exploración y recolección

-   Robot: `CharacterBody2D`.
-   Imagen/animación: `AnimatedSprite2D`.
-   Cámara: `Camera2D`.
-   Dron: `Node2D` o `CharacterBody2D`, según necesite colisiones.
-   Recurso: `Area2D` + `Sprite2D` + `CollisionShape2D`.
-   Recolección: señal `body_entered`.
-   Inventario: componente o gestor de datos.
-   Movimiento programado: intérprete que traduce instrucciones a
    acciones del robot.

### 7.2 Tower defense

-   Camino: `Path2D`.
-   Enemigo siguiendo ruta: `PathFollow2D` con la escena del enemigo
    como hijo.
-   Enemigo: `CharacterBody2D` o `Node2D`, según necesite física.
-   Torreta: `Node2D` + `Area2D` para detectar objetivos.
-   Proyectil: `Area2D` o `CharacterBody2D`, según comportamiento.
-   Cadencia: `Timer`.
-   Vida: variables y `ProgressBar`.
-   Oleadas: `WaveManager` y recursos de datos.
-   Construcción: catálogo de escenas/clases y validación de recursos.

Las torretas deben disparar mediante temporizadores o actualizaciones no
bloqueantes, nunca con un bucle infinito que congele el juego.

### 7.3 Lenguaje educativo

-   Editor: `CodeEdit`.
-   Consola: `RichTextLabel`.
-   Ejecutar: `Button`.
-   Lexer + parser + AST.
-   Intérprete con lista blanca de instrucciones.
-   Depuración: línea actual, variables, paso a paso y mensajes.
-   API limitada: por ejemplo `robot.move()`, `robot.collect()` y
    `turret.fire()`.

**Distinción clave:** GDScript implementa el juego; el lenguaje
educativo es el que escribe el jugador dentro de `CodeEdit`.

## 8. Estructura de carpetas sugerida

``` text
res://
├── scenes/
│   ├── main/Main.tscn
│   ├── player/Player.tscn
│   ├── player/Drone.tscn
│   ├── enemies/Enemy.tscn
│   ├── turrets/TurretBase.tscn
│   └── ui/HUD.tscn
├── scripts/
│   ├── player/
│   ├── enemies/
│   ├── turrets/
│   ├── systems/
│   └── language/
├── assets/
│   ├── sprites/
│   ├── tilesets/
│   ├── fonts/
│   └── audio/
├── data/
│   ├── enemies/
│   ├── turrets/
│   └── levels/
└── README.md
```

## 9. Buenas prácticas para el equipo

1.  Una escena por entidad reutilizable.
2.  Separar movimiento, vida, inventario, detección y ataque en
    componentes claros.
3.  Usar señales para eventos: `resource_collected`, `enemy_died`,
    `wave_finished`, `code_execution_finished`.
4.  Usar `Resource` para datos configurables de enemigos, torretas y
    niveles.
5.  Preferir `TileMapLayer` para mapas por tiles.
6.  Usar `CharacterBody2D` para movimiento controlado con colisiones.
7.  Reservar `RigidBody2D` para objetos que requieran simulación física.
8.  No ejecutar código arbitrario del jugador: crear un intérprete
    limitado.
9.  Probar cada sistema en una escena pequeña antes de integrarlo.
10. Mantener al equipo en la misma versión de Godot y utilizar Git.

## 10. Orden de implementación recomendado

  -----------------------------------------------------------------------
  Fase                    Objetivo                Componentes
  ----------------------- ----------------------- -----------------------
  1                       Mapa simple, robot      `Node2D`, `Sprite2D`,
                          visible y cámara.       `CharacterBody2D`,
                                                  `Camera2D`

  2                       Tiles, camino,          `TileMapLayer`,
                          obstáculos y recursos.  `TileSet`,
                                                  `StaticBody2D`,
                                                  `Area2D`

  3                       Enemigos y oleadas.     `Path2D`,
                                                  `PathFollow2D`, `Timer`

  4                       Torretas y ataques.     `Area2D`, `Timer`,
                                                  `PackedScene`,
                                                  `Resource`

  5                       HUD, inventario y panel `CanvasLayer`,
                          de construcción.        `Control`,
                                                  contenedores, `Button`

  6                       Editor de código.       `CodeEdit`,
                                                  `RichTextLabel`, lexer
                                                  y parser

  7                       Intérprete para el      AST, intérprete,
                          robot.                  señales y API de
                                                  acciones

  8                       Clases y objetos de     Clases GDScript y
                          torretas.               modelo POO del lenguaje
                                                  educativo

  9                       Pulido.                 `AnimationPlayer`,
                                                  partículas, audio y
                                                  `Tween`
  -----------------------------------------------------------------------

## 11. Glosario

-   **Escena:** archivo reutilizable que contiene nodos.
-   **Nodo:** componente básico de una escena.
-   **Instancia:** objeto creado a partir de una escena o clase.
-   **Señal:** evento para comunicar nodos.
-   **Tile:** pieza gráfica de una cuadrícula.
-   **TileSet:** conjunto de tiles y propiedades.
-   **Colisión:** forma usada para detectar o bloquear interacciones.
-   **Autoload:** nodo/script global disponible entre escenas.
-   **Intérprete:** programa que analiza y ejecuta instrucciones de un
    lenguaje.
-   **AST:** árbol de sintaxis abstracta que representa la estructura de
    un programa.
-   **POO:** programación orientada a objetos.

## 12. Documentación oficial Godot 4.7

-   [Documentación principal](https://docs.godotengine.org/en/4.7/)
-   [Referencia de
    clases](https://docs.godotengine.org/en/4.7/classes/index.html)
-   [Características del
    motor](https://docs.godotengine.org/en/4.7/about/list_of_features.html)
-   [Conceptos
    clave](https://docs.godotengine.org/en/4.7/getting_started/introduction/key_concepts_overview.html)
-   [Señales](https://docs.godotengine.org/en/4.7/getting_started/step_by_step/signals.html)
-   [CodeEdit](https://docs.godotengine.org/en/4.7/classes/class_codeedit.html)
-   [TileMapLayer](https://docs.godotengine.org/en/4.7/classes/class_tilemaplayer.html)
-   [Path2D](https://docs.godotengine.org/en/4.7/classes/class_path2d.html)
-   [CharacterBody2D](https://docs.godotengine.org/en/4.7/classes/class_characterbody2d.html)

------------------------------------------------------------------------

## Decisión técnica inicial

Para el primer prototipo, priorizar:

`Node2D` · `TileMapLayer` · `CharacterBody2D` · `Sprite2D` /
`AnimatedSprite2D` · `Camera2D` · `Area2D` · `Path2D` · `PathFollow2D` ·
`CodeEdit` · `CanvasLayer` · `Control` · `Timer` · señales · `Resource`.

**Principio de desarrollo:** primero lograr que el mundo funcione con
controles normales; después conectar las acciones a nuestro lenguaje
educativo. Así podremos validar el juego por partes sin mezclar desde el
principio el motor, la interfaz y el intérprete.
