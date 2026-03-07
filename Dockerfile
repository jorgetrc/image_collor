FROM nginx:alpine

# Define que o Docker aceitará um argumento chamado APP_VERSION
ARG APP_VERSION=v0.0.0

COPY index.html /usr/share/nginx/html/index.html

# Substitui {{VERSION}} pelo valor da variável APP_VERSION no arquivo final
RUN sed -i "s/{{VERSION}}/${APP_VERSION}/g" /usr/share/nginx/html/index.html

EXPOSE 80