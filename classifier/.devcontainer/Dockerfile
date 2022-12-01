ARG VARIANT=3-bullseye
FROM --platform=linux/amd64 mcr.microsoft.com/devcontainers/python:0-${VARIANT}

USER vscode

RUN /usr/local/bin/python -m pip install -U pip && \
    pip install -U poetry