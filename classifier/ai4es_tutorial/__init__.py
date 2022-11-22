import os

try:
    import coloredlogs

    level = os.getenv("LOG_LEVEL", "DEBUG")
    coloredlogs.install(level=level)
except:
    pass
