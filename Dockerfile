FROM ubuntu:latest
WORKDIR /app
COPY . .
RUN chmod +x main.sh
ENTRYPOINT [ "bash"]