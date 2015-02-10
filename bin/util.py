import random
from termcolor import cprint


COLORS = 'red yellow blue magenta cyan'.split()


def color():
    ncolors = len(COLORS)
    i = random.randint(0, ncolors - 1)
    while True:
        yield COLORS[i]
        i = (i + 1) % ncolors


color = color()
next(color)


def rcprint(text):
    """Print text in a random color"""
    cprint(text, next(color))
