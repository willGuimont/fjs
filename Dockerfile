FROM nimlang/nim:latest

ADD . /app
WORKDIR /app

RUN nimble build -y
CMD ["nimble", "run"]
