import cv2
import numpy as np

def capture_photo(output_path):
    camera = cv2.VideoCapture(0)

    if not camera.isOpened():
        print("Error: Could not open camera.")
        return

    cv2.namedWindow("Camera", cv2.WINDOW_NORMAL)

    while True:
        # Capture a frame from the camera
        ret, frame = camera.read()

        if not ret:
            print("Error: Could not capture a photo.")
            break

        # Display the live camera feed
        cv2.imshow("Camera", frame)

        # Wait for a key press
        key = cv2.waitKey(1) & 0xFF

        if key == ord('q') or key == 27:  # 'q' or 'Esc' key to quit
            break
        elif key == ord('c'):  # 'c' key to capture the photo
            cv2.imwrite(output_path, frame)
            print(f"Photo has been saved as {output_path}.")
        

    # Release the camera and close the window
    camera.release()
    cv2.destroyAllWindows()

output_path = "captured_photo.png"
capture_photo(output_path)   
