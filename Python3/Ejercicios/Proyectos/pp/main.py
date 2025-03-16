from GeneradorDeLetras import *

def main():
    artista = input("Ingrese el nombre del artista: ")
    cancion = input("Ingrese el nombre de la canción: ")
    
    letra_obtenida = conectarConAPI(artista, cancion)
    
    print(letra_obtenida)


if __name__ == "__main__":
    main()
