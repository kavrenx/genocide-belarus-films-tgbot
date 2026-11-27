FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1
WORKDIR /app
COPY --chmod=644 app.zip /tmp/app.zip
RUN --mount=type=secret,id=pip_cert \
    if [ -s /run/secrets/pip_cert ]; then export PIP_CERT=/run/secrets/pip_cert; fi \
    && python -m zipfile -e /tmp/app.zip /app \
    && rm /tmp/app.zip \
    && pip install --no-cache-dir . \
    && chmod 755 /app /app/data \
    && chmod 644 /app/data/films.json \
    && useradd --system --no-create-home bot
USER bot
CMD ["genocide-films"]
