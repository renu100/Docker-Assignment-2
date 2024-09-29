FROM python:3.8-slim

WORKDIR /app

COPY . /app

RUN pip install flask

EXPOSE 8080

ENV FLASK_APP=app.py

CMD ["flask", "run", "--host=0.0.0.0", "--port=8080"]
