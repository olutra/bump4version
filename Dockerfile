FROM debian:bullseye-slim

RUN apt update && apt-get install -y --no-install-recommends git-core mercurial

# The installer requires curl (and certificates) to download the release archive
RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates

RUN curl -L https://astral.sh/uv/0.7.9/install.sh | bash

ENV PATH="/root/.local/bin/:$PATH"

ENV UV_LINK_MODE=copy

RUN --mount=type=cache,target=/root/.cache/uv \
    uv python install 3.8 && \
    uv python install 3.9 && \
    uv python install 3.10 && \
    uv python install 3.11 && \
    uv python install 3.12 && \
    uv python install 3.13 && \
    uv python install pypy3.8 && \
    uv python install pypy3.9 && \
    uv python install pypy3.10 && \
    uv python install pypy3.11 && \
    uv tool install nox

# prevent *.pyc files
ENV PYTHONDONTWRITEBYTECODE=1
ENV NOX_DEFAULT_VENV_BACKEND=uv

WORKDIR /code
COPY noxfile.py .
RUN nox --install-only

COPY . .
ENTRYPOINT ["nox", "-R"]
