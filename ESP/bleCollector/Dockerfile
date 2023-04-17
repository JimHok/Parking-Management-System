FROM python:3.9-bullseye

RUN apt-get update && \
    apt-get install -y mosquitto mosquitto-clients libglib2.0-0 libgl1-mesa-glx supervisor && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app
COPY requirements.txt ./
COPY image/Ohio_License_Plate.jpg ./
COPY parking-android-app-firebase-adminsdk-tcjkk-9046d67b09.json ./
COPY ENGcharacter_weightFinal.h5 ./
COPY mosquitto.conf /etc/mosquitto/mosquitto.conf
COPY mosquitto.conf ./
RUN pip install -r requirements.txt
COPY . .
EXPOSE 8080 1883

CMD ["python", "-u", "./app.py"]


