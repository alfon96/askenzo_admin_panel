# # 1
# # Stage 1 - Install dependencies and build the app
# FROM debian:bookworm AS builder

# RUN apt-get update
# RUN apt-get install -y bash curl file git unzip xz-utils zip libglu1-mesa
# RUN apt-get clean

# # Clone the flutter repo
# RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

# # Check out the specific version
# RUN cd /usr/local/flutter && git checkout tags/3.12.0-10.0.pre

# # Set flutter path
# ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# # Enable web capabilities
# RUN flutter config --enable-web
# RUN flutter pub global activate webdev

# # Install additional dependencies for building and running a web app with Flutter
# RUN flutter config --enable-web && flutter precache

## 2
# Use the previously created image as the base
FROM alfo96/flutter-debian-webapp:latest as builder

WORKDIR /app
COPY . /app

RUN flutter pub get
RUN flutter build web --dart-define=SERVER=SERVER

FROM nginx:stable-alpine AS runner


COPY default.conf /etc/nginx/conf.d
COPY --from=builder /app/build/web /usr/share/nginx/html