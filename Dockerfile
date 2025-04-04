FROM python:3.11.4

RUN apt update && apt install -y zsh

WORKDIR /workspace

COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install -r requirements.txt
