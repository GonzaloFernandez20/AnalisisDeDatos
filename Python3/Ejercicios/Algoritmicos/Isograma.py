""" Un isograma es una palabra que no tiene letras repetidas. Consideraciones Adicionales:

Un string vacío es un isograma.
La función tiene que ser case insensitive e ignorar acentos.
Si el string tiene mas de una palabra retornar false.
Se tiene que hacer clean up del string antes de comparar. """

import unicodedata
import unittest


# ---------------------------------------------------- FUNCIONES PRINCIPALES


def analizar_palabra(palabra):
    cant_palabras = len(palabra.split())
    
    if cant_palabras < 1:
        print("No se permiten strings vacios")
        return
    
    if cant_palabras > 1:
        print("Debe ingresar una unica palabra")
        return
    
    # Si paso estos dos filtros entonces la palabra es apta

    palabra_limpia = limpiar_palabra(palabra)
    
    if es_isograma(palabra_limpia):
        print("La palabra es un isograma")
    else: 
        print("La palabra no es un isograma")

def limpiar_palabra(palabra):
    return eliminar_acentos(palabra.lower())
    
def pertenece_al_historial(historial_letras, letra):
    for letra_h in historial_letras:
            if letra_h == letra:
                return True

def agregar_al_historial(historial_letras, letra):
    historial_letras.append(letra)

def es_isograma(palabra):
    historial_letras = list()
    
    for letra in palabra:
        if pertenece_al_historial(historial_letras, letra):
            return False
        else:
            agregar_al_historial(historial_letras, letra)
    return True



# ---------------------------------------------------- FUNCIONES AUXILIARES
def eliminar_acentos(texto: str) -> str:
    return ''.join(
        c for c in unicodedata.normalize('NFD', texto)
        if unicodedata.category(c) != 'Mn'
    )
    
    
palabra = input("Escribí una palabra: ")
analizar_palabra(palabra)




# ----------------- TESTS -----------------
# Test, queda por mejorar 
class TestEsIsograma(unittest.TestCase):
    
    def test_isograma_simple(self):
        self.assertTrue(analizar_palabra("gato"))
    
    def test_ignora_acentos(self):
        self.assertTrue(analizar_palabra("Murciélago"))
    
    def test_ignora_mayusculas(self):
        self.assertFalse(analizar_palabra("Casa"))
        self.assertFalse(analizar_palabra("PeRrO"))
        self.assertTrue(analizar_palabra("GaTo"))

if __name__ == "__main__":
    unittest.main()