import paho.mqtt.client as mqtt
import asyncio
import os
from google.cloud import firestore
from datetime import datetime
import json
import matplotlib.pyplot as plt
import cv2
import numpy as np
from tensorflow.keras.models import load_model


import tensorflow as tf
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Flatten, MaxPooling2D, Dropout, Conv2D
from tensorflow.keras import optimizers
from tensorflow.keras.models import load_model
import time



#comp
def update_status(license_number, bluetooth_id):
    # Set up your Firestore credentials
    os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "parking-android-app-firebase-adminsdk-tcjkk-9046d67b09.json"

    # Initialize Firestore client
    db = firestore.Client()

    # Reference the users collection
    users_ref = db.collection("users")
    time_ref = db.collection("time")
    time_doc_ref = time_ref.document("timestamp")

    all_users = users_ref.stream()

    for user in all_users:
        user_data = user.to_dict()

        # Iterate through the vehicle maps
        for key, vehicle in user_data.items():
            if isinstance(vehicle, dict) and vehicle.get("license_plate") == license_number and vehicle.get("bluetooth_id").upper() == bluetooth_id.upper():
                user_id = user.id
                if vehicle.get("status") == "Parked":
                    new_status = "Not Parking"
                else:
                    new_status = "Parked"

                # Update the status value in the Firestore database
                users_ref.document(user_id).update({f"{key}.status": new_status})
                
                # Add a timestamp record to the 'time' collection
                current_time = datetime.utcnow()
                time = current_time.strftime("%Y-%m-%dT%H:%M:%S.%fZ")
                time_data = {"time": time, "license_plate": license_number, "status": new_status}
                time_doc_ref.update({"record": firestore.ArrayUnion([time_data])})
                # time.sleep(3)
                break

#######################################################################################            
#license


# Match contours to license plate or character template
def find_contours(dimensions, img) :

    # Find all contours in the image
    cntrs, _ = cv2.findContours(img.copy(), cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)

    # Retrieve potential dimensions
    lower_width = dimensions[0]
    upper_width = dimensions[1]
    lower_height = dimensions[2]
    upper_height = dimensions[3]
    
    # Check largest 5 or  15 contours for license plate or character respectively
    cntrs = sorted(cntrs, key=cv2.contourArea, reverse=True)[:15]
    
    #ii = cv2.imread('/Users/conniji/aiot/Software-Design-for-AI/ESP/bleCollector/image/Ohio_License_Plate.jpg')
    ii = cv2.imread('captured_photo.png')
    
    x_cntr_list = []
    target_contours = []
    img_res = []
    for cntr in cntrs :
        #detects contour in binary image and returns the coordinates of rectangle enclosing it
        intX, intY, intWidth, intHeight = cv2.boundingRect(cntr)
        
        #checking the dimensions of the contour to filter out the characters by contour's size
        if intWidth > lower_width and intWidth < upper_width and intHeight > lower_height and intHeight < upper_height :
            x_cntr_list.append(intX) #stores the x coordinate of the character's contour, to used later for indexing the contours

            char_copy = np.zeros((44,24))
            #extracting each character using the enclosing rectangle's coordinates.
            char = img[intY:intY+intHeight, intX:intX+intWidth]
            char = cv2.resize(char, (20, 40))
            
            cv2.rectangle(ii, (intX,intY), (intWidth+intX, intY+intHeight), (50,21,200), 2)
            #plt.imshow(ii, cmap='gray')

#             Make result formatted for classification: invert colors
            char = cv2.subtract(255, char)

            # Resize the image to 24x44 with black border
            char_copy[2:42, 2:22] = char
            char_copy[0:2, :] = 0
            char_copy[:, 0:2] = 0
            char_copy[42:44, :] = 0
            char_copy[:, 22:24] = 0

            img_res.append(char_copy) #List that stores the character's binary image (unsorted)
            
    #Return characters on ascending order with respect to the x-coordinate (most-left character first)
            
    plt.show()
    #arbitrary function that stores sorted list of character indeces
    indices = sorted(range(len(x_cntr_list)), key=lambda k: x_cntr_list[k])
    img_res_copy = []
    for idx in indices:
        img_res_copy.append(img_res[idx])# stores character images according to their index
    img_res = np.array(img_res_copy)

    

    return img_res

# Find characters in the resulting images
def segment_characters(image) :

    # Preprocess cropped license plate image
    img_lp = cv2.resize(image, (300, 100))

    # convert to grayscale
    img_gray_lp = cv2.cvtColor(img_lp, cv2.COLOR_BGR2GRAY)

    _, img_binary_lp = cv2.threshold(img_gray_lp, 200, 255, cv2.THRESH_BINARY+cv2.THRESH_OTSU)
    img_binary_lp = cv2.erode(img_binary_lp, (3,3))
    img_binary_lp = cv2.dilate(img_binary_lp, (3,3))

    LP_WIDTH = img_binary_lp.shape[0]
    LP_HEIGHT = img_binary_lp.shape[1]

    # Make borders white
    img_binary_lp[0:3,:] = 255
    img_binary_lp[:,0:3] = 255
    img_binary_lp[72:75,:] = 255
    img_binary_lp[:,330:333] = 255

    # Estimations of character contours sizes of cropped license plates
    dimensions = [LP_WIDTH/6,
                       LP_WIDTH/2,
                       LP_HEIGHT/10,
                       2*LP_HEIGHT/3]
    #plt.imshow(img_binary_lp, cmap='gray')
    plt.show()
    cv2.imwrite('contour.jpg',img_binary_lp)

    # Get contours within cropped license plate
    char_list = find_contours(dimensions, img_binary_lp)

    return char_list

# img = cv2.imread('/Users/conniji/aiot/Software-Design-for-AI/ESP/bleCollector/image/Ohio_License_Plate.jpg')


# for i in range(len(char)):
#     plt.subplot(1, len(char), i+1)
#     plt.imshow(char[i], cmap='gray')
#     plt.axis('off')

"""### Model for characters"""


# tf.enable_eager_execution()
tf.executing_eagerly()


# train_datagen = ImageDataGenerator(rescale=1./255, width_shift_range=0.1, height_shift_range=0.1)
# train_generator = train_datagen.flow_from_directory("/content/drive/MyDrive/EngChar&Num/train", target_size=(28,28), batch_size=1,class_mode='categorical')

# validation_generator = train_datagen.flow_from_directory("/content/drive/MyDrive/EngChar&Num/val", target_size=(28,28), batch_size=1, class_mode='categorical')

model = Sequential()
model.add(Conv2D(32, (24,24), input_shape=(28, 28, 3), activation='relu', padding='same'))
# model.add(Conv2D(32, (20,20), input_shape=(28, 28, 3), activation='relu', padding='same'))
# model.add(Conv2D(32, (20,20), input_shape=(28, 28, 3), activation='relu', padding='same'))
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Dropout(0.4))
model.add(Flatten())
model.add(Dense(128, activation='relu'))
model.add(Dense(36, activation='softmax'))

# model.compile(loss='categorical_crossentropy', optimizer=optimizers.Adam(learning_rate=0.00001), metrics=['accuracy'])

# ACCURACY_THRESHOLD = 0.992
# class stop_training_callback(tf.keras.callbacks.Callback):
#   def on_epoch_end(self, epoch, logs={}):
#     if(logs.get('accuracy') > ACCURACY_THRESHOLD):
# #     if(logs.get('val_accuracy') > ACCURACY_THRESHOLD):
#       self.model.stop_training = True

# import datetime
# # !rm -rf logs
# log_dir="../AI-based-indian-license-plate-detection-master/logs/fit/" + datetime.datetime.now().strftime("%Y%m%d-%H%M%S")
# tensorboard_callback = tf.keras.callbacks.TensorBoard(log_dir=log_dir, histogram_freq=1)

# batch_size = 1
# callbacks = [tensorboard_callback, stop_training_callback()]
# # callbacks = [stop_training_callback()]
# model.fit(train_generator,
#           steps_per_epoch = train_generator.samples // batch_size,
#           validation_data = validation_generator,
#           validation_steps = validation_generator.samples // batch_size,
#           epochs = 80, verbose=1,
#           callbacks=callbacks)


# Load the pre-trained Keras model
#model = load_model('/Users/conniji/aiot/Software-Design-for-AI/ESP/bleCollector/ENGcharacter_weightFinal.h5')
model = load_model('ENGcharacter_weightFinal.h5')

def fix_dimension(img): 
  new_img = np.zeros((28,28,3))
  for i in range(3):
    new_img[:,:,i] = img
  return new_img
  
def show_results(char):
    dic = {}
    characters = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    for i,c in enumerate(characters):
        dic[i] = c
    

    output = []
    for i,ch in enumerate(char): #iterating over the characters
        img_ = cv2.resize(ch, (28,28), interpolation=cv2.INTER_AREA)
        img = fix_dimension(img_)
        img = img.reshape(1,28,28,3) #preparing image for the model
        y_ = model.predict(img)[0] #predicting the class
        for num in range(len(y_)):
            if y_[num] == 1:
                y_num = num
#         print(img)
#         print(y_)
#         print(dic)
        
        character = dic[y_num] 
#         print(character)
        output.append(character) #storing the result in a list
        
       
        
    plate_number = ''.join(output)
    
   #  plate_number.tostring() 

    return plate_number

# def capture_photo(output_path):
#     camera = cv2.VideoCapture(0)

#     if not camera.isOpened():
#         print("Error: Could not open camera.")
#         return

#     cv2.namedWindow("Camera", cv2.WINDOW_NORMAL)

#     while True:
#         # Capture a frame from the camera
#         ret, frame = camera.read()

#         if not ret:
#             print("Error: Could not capture a photo.")
#             break

#         # Display the live camera feed
#         cv2.imshow("Camera", frame)

#         # Wait for a key press
#         key = cv2.waitKey(1) & 0xFF

#         if key == ord('q') or key == 27:  # 'q' or 'Esc' key to quit
#             break
#         elif key == ord('c'):  # 'c' key to capture the photo
#             cv2.imwrite(output_path, frame)
#             print(f"Photo has been saved as {output_path}.")
#             break

#     # Release the camera and close the window
#     camera.release()
#     cv2.destroyAllWindows()


#######################################################################################


class bleCollector:
   def __init__(self):
      self.mqttClient = mqtt.Client()
      self.mqttClient.on_message = self.on_message
      self.running = True

   def on_message(self, client, userdata, message):
    # Get the license plate number
    #   license_number = '2TH4726'
    ## Example usage:
      img = cv2.imread('captured_photo.png')
      char = segment_characters(img)
      license_number = show_results(char)
      print("Message Recieved: " + json.loads(message.payload.decode())['addr'])
      print("License Plate Number:", license_number)
      update_status(license_number, json.loads(message.payload.decode())['addr'])
      
   
   async def co_run(self, broker_url, broker_port, sub_topic):
      self.mqttClient.connect(broker_url, broker_port)
      self.mqttClient.subscribe(sub_topic)
      while self.running:
         self.mqttClient.loop()
         await asyncio.sleep(0.1)

   def run(self, broker_url, broker_port, sub_topic):
      asyncio.run(self.co_run(broker_url, broker_port, sub_topic))
    #   loop = asyncio.get_event_loop()
    #   loop.run_until_complete(self.co_run(broker_url, broker_port, sub_topic))  

if __name__ == '__main__':
   
   broker_url = "broker.hivemq.com"
#    broker_url = "192.168.1.168"
   broker_port = 1883
   sub_topic = "ict720/suradit/data"
   #sub_topic = "ict720/suradit/data"

#    output_path = "captured_photo.png"
#    capture_photo(output_path)     
#    img = cv2.imread('captured_photo.png')
#    char = segment_characters(img)
   app = bleCollector()
   app.run(broker_url, broker_port, sub_topic)

