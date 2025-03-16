from fastapi import FastAPI
from cliente_api import obtenerCancion

app = FastAPI()

@app.get("/lyrics/{artist}/{song}")

def conectarConAPI(artista: str, cancion:str) -> str:
    return {
            "Artista: ": artista, 
            "Cancion: ": cancion, 
            "Letra: ": obtenerCancion(artista, cancion)
        } 