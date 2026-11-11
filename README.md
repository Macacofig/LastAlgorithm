# LAST ALGORITHM

## Conocimientos

### TailMap : Trabajo con tails (sprites) para entorno
- Recomendable hacerlo Scene : Para ser reutilizado
- Para manejo de Colisiones se usa (Physics Layers)
> TileMapPlayer -> TileSet (select objet added) -> Physics Layers (Solido, Daño, Coleccionable, Personaje)
- Para Aplicar
> TileSet (down bar) -> Seleccionar -> Seleccionar unaa Tile -> Physics

### CharacterBody2d : Trabajo con objetos animados (Jugador, Monstruos)

## Arquitectura

res

|

| assets -> Assets de entrada

| assetsWorks -> Sprites guardados para trabajo

| scenes -> Scenas para el juego

| | Bordes -> Bordes de pantalla (20x32)

| | Nivel1 -> Primer Boceto
