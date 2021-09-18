import django_heroku
import os

from .base import *

DEBUG = True

try:
    from .local import *
except ImportError:
    pass

django_heroku.settings(locals())