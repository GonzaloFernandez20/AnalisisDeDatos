"""Functions used in preparing Guido's gorgeous lasagna.

Learn about Guido, the creator of the Python language:
https://en.wikipedia.org/wiki/Guido_van_Rossum

This is a module docstring, used to describe the functionality
of a module and its functions and/or classes.
"""


#TODO: define the 'EXPECTED_BAKE_TIME' constant below.
EXPECTED_BAKE_TIME = 40

#TODO: Remove 'pass' and complete the 'bake_time_remaining()' function below.
def bake_time_remaining(tiempo_transcurrido : int) -> int:
    """Calculate the bake time remaining.

    :param elapsed_bake_time: int - baking time already elapsed.
    :return: int - remaining bake time (in minutes) derived from 'EXPECTED_BAKE_TIME'.

    Function that takes the actual minutes the lasagna has been in the oven as
    an argument and returns how many minutes the lasagna still needs to bake
    based on the `EXPECTED_BAKE_TIME`.
    """
    return EXPECTED_BAKE_TIME - tiempo_transcurrido


#TODO: Define the 'preparation_time_in_minutes()' function below.
# You might also consider defining a 'PREPARATION_TIME' constant.
# You can do that on the line below the 'EXPECTED_BAKE_TIME' constant.
# This will make it easier to do calculations.

def preparation_time_in_minutes(cantidad_capas : int) -> int :
    """Calcula el tiempo de preparacion transcurrido.

    :param cantidad_capas: int - cantidad de capas de la Lasagna.
    :return: int - preparation_time (en minutos)
    """
    preparation_time = 2 * cantidad_capas
    print(preparation_time)
    return preparation_time

#TODO: define the 'elapsed_time_in_minutes()' function below.
def elapsed_time_in_minutes(cantidad_capas : int, tiempo_transcurrido : int) -> int: 
    """Calcula el tiempo transcurrido de coccion teniendo en cuenta las capas.

    :param cantidad_capas: int - capas de la Lasagna.
    :param tiempo_transcurrido: int - tiempo que ya estuvo en coccion.
    :return: int - tiempo que va en el horno (in minutes)
    """
    tiempo_total = preparation_time_in_minutes(cantidad_capas) + tiempo_transcurrido
    print(tiempo_total)
    return tiempo_total
    
# TODO: Remember to go back and add docstrings to all your functions
#  (you can copy and then alter the one from bake_time_remaining.)