FROM python:3.8-slim-buster

WORKDIR /app

COPY requirements.txt requirements.txt
COPY /usr/local/code/app.py app.py
RUN pip3 install -r requirements.txt
COPY . .
CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]