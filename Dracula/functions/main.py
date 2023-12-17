# Welcome to Cloud Functions for Firebase for Python!
# To get started, simply uncomment the below code or create your own.
# Deploy with `firebase deploy`

from firebase_functions import https_fn
from firebase_admin import initialize_app
import cv2
import numpy as np

# initialize_app()
#
#
# @https_fn.on_request()
# def on_request_example(req: https_fn.Request) -> https_fn.Response:
#     return https_fn.Response("Hello world!")



'''
H: 0 a 179; S: 0 a 255; V: 0 a 255

color + brillant: 
H = 179
S = 255

343 
'''


CATEGORIES = ["light", "moderate", "saturated"]

LOWER_HSV1 = (0, 55, 5)
HIGHER_HSV1 = (5, 255, 255)

LOWER_HSV2 = (165, 55, 5)
HIGHER_HSV2 = (179, 255, 255)



def get_category(request_data) -> str:
    '''Given an image of a pad/tampon and its overlay, it returns
    the category of the bleeding'''
    image_path = request_data.get('image_path')
    width_overlay = request_data.get('width')
    height_overlay = request_data.get('height')
    
    image = cv2.imread(image_path)

    #crop image
    ul_corner = (int((image.shape[0] - width_overlay)/2), 
                 int((image.shape[1] - height_overlay)/2)
                )
    br_corner = (image.shape[0] - int((image.shape[0] - width_overlay)/2), 
                 image.shape[1] - int((image.shape[1] - height_overlay)/2)
                 )
    

    image[ul_corner[0]: br_corner[0], ul_corner[1]:br_corner[1]]

    #get bloody pixels
    hsv_img = cv2.cvtColor(image, cv2.COLOR_BGR2HSV)
    mask1 = cv2.inRange(hsv_img, LOWER_HSV1, HIGHER_HSV1)
    mask2 = cv2.inRange(hsv_img, LOWER_HSV2, HIGHER_HSV2)
    mask = mask1 | mask2 
    filtered = cv2.bitwise_and(hsv_img, hsv_img, mask=mask)

    bloody_pixels = np.count_nonzero(filtered)/3
    total_pixels = image.shape[0]*image.shape[1]

    ratio =  bloody_pixels / total_pixels

    if 0 <= ratio <= 0.33:
        return 1
    
    elif 0.33 < ratio <= 0.66:
        return 5
    
    else:
        return 20
    
    