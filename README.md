# LAST ALGORITHM

## Conocimientos

### TailMap : Trabajo con tails (sprites) para entorno
- Recomendable hacerlo Scene : Para ser reutilizado
- Para manejo de Colisiones se usa (Physics Layers)
> TileMapPlayer -> TileSet (select objet added) -> Physics Layers (Solido, Daño, Coleccionable, Personaje)
- Para Aplicar
> TileSet (down bar) -> Seleccionar -> Seleccionar unaa Tile -> Physics

### CharacterBody2d : Trabajo con objetos animados (Jugador, Monstruos)
- Se puede utilizar con movimiento (AnimatedSprite2D)
> Para un primero usamos new SpriteFrames -> Lo guardamos (preferible en la misma carpeta del character)
- Se debe agregar animaciones respecto a movimientos (Caminar, Estatico (siempre) , Saltar)
> Seleccionar SpiteFrame -> Animaciones (default) -> Cambiar Nombre -> Rejilla (Agrega sprites para animacion)

Nota : Para 2D pixel art se prefiere que Texture Filter este en Nearest
> Proyect -> Proyect Settings -> Rendering -> Textureres -> Default Texture Fitlers

## Arquitectura

res

|

| assets -> Assets de entrada

| assetsWorks -> Sprites guardados para trabajo

| scenes -> Scenas para el juego

| | Bordes -> Bordes de pantalla (20x32)

| | Nivel1 -> Primer Boceto


## Capas colision

|   #   |   Nombre          |   Qué lo usa                      |
| --- | --- | --- |
|   1   |	terreno	        |   Paredes y obstáculos del mapa   |
|   2   |	jugador	        |   Cuerpo del jugador              |
|   3   |	dron	        |   Cuerpo de l dron recolector     |
|   4   |	enemigos        |   Cuerp o del enemigo             |
|   5   |	torretas	    |   Cuerp o de las torretas         |
|   6   |	minerales	    |   Recursos recolectables          |
|   7   |	proyectiles	    |   Balas de las torretas           |
|   8   |	hitbox_enemigo  |   El AreaDano del enemigo         |
