# LAST ALGORITHM

## Conocimientos

* TailMap : Trabajo con tails (sprites) para entorno
- Recomendable hacerlo Scene : Para ser reutilizado

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
