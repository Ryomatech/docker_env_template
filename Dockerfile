FROM pytorch/pytorch:latest

RUN apt update && apt install -y zsh

WORKDIR /workspace

COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install -r requirements.txt
