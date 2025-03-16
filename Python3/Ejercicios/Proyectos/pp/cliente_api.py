from requests import *

API_URL = "https://api.lyrics.ovh/v1"

def obtenerCancion(artista : str , cancion : str) -> str:
        
        url = f"{API_URL}/{artista}/{cancion}"
        letra_de_cancion = requests.get(url)
        
        if letra_de_cancion.status_code == 200:
            data = letra_de_cancion.json()
            return data.get("Lyrics", "Letra no encontrada")
        else: return f"Error {letra_de_cancion.status_code}: No se pudo obtener la letra."
        
        
    
    

