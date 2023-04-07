FROM python:3.9-bullseye

WORKDIR /usr/src/app
COPY requirements.txt ./
COPY image/Ohio_License_Plate.jpg ./
COPY parking-android-app-firebase-adminsdk-tcjkk-9046d67b09.json ./
COPY ENGcharacter_weightFinal.h5 ./
RUN pip install -r requirements.txt
RUN apt-get update && apt-get install -y libglib2.0-0 libgl1-mesa-glx && rm -rf /var/lib/apt/lists/*
COPY . .
EXPOSE 8080
CMD ["python", "-u", "./app.py"]
