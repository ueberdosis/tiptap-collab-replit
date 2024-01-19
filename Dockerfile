FROM node:20-bookworm-slim AS builder
LABEL maintainer "Patrick Baber <patrick.baber@tiptap.dev>"

# Upgrade Debian packages
RUN apt-get update \
    && apt-get upgrade -y --no-install-recommends \
    && rm -r /var/lib/apt/lists/*

# Copy files
COPY . /var/www
WORKDIR /var/www/

# Install NPM packages
RUN --mount=type=secret,id=npmrc,target=/var/www/.npmrc,required=true \
    npm install \
    && npm run build

FROM nginx:1.25

COPY --from=builder /var/www/dist /usr/share/nginx/html