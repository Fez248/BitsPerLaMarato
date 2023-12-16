import cv2
import numpy as np


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

#horitzontal a un X

'''
def converter():
    hsv_web = (360, 100, 7)
    max_web = (360, 100, 100)
    max_cv2 = (179, 255, 255)

    for i in range(3):
        print(hsv_web[i]*max_cv2[i]/max_web[i])
'''


def get_bloody_pixels(image):

    hsv_img = cv2.cvtColor(image, cv2.COLOR_BGR2HSV)
    mask1 = cv2.inRange(hsv_img, LOWER_HSV1, HIGHER_HSV1)
    mask2 = cv2.inRange(hsv_img, LOWER_HSV2, HIGHER_HSV2)
    mask = mask1 | mask2 
    filtered = cv2.bitwise_and(hsv_img, hsv_img, mask=mask)
    bloody = cv2.cvtColor(filtered, cv2.COLOR_HSV2BGR)
    print(bloody.shape)
    show_image(bloody)
    return bloody


def count_bloody_pixels(image, overlay: tuple[float, float]) -> int:
    '''Returns the number of bloody pixels inside the overlay'''    
    return np.count_nonzero(get_bloody_pixels(image))/3


def count_pixels_overlay(overlay) -> int:
    '''Returns the total number of pixels inside the overlay'''

    #miro longitud horitzontal
    #miro longitud vertical
    #miro els pixels 
    pass

def get_overlay():
    '''Returns UR and LW vertices'''
    pass


def cropped_image(image, overlay: tuple[tuple[int, int], tuple[int, int]]):
    return image[overlay[0][0]: overlay[1][0], overlay[0][1]:overlay[1][1]]


def get_category(image_path, overlay) -> str:
    '''Given an image of a pad/tampon and its overlay, it returns
    the category of the bleeding'''

    image = cv2.imread(image_path)
    #image = cropped_image(image, overlay)
    ratio = count_bloody_pixels(image, overlay) / (image.shape[0]*image.shape[1])

    if 0 <= ratio <= 0.33:
        return CATEGORIES[0]
    
    elif 0.33 < ratio <= 0.66:
        return CATEGORIES[1]
    
    else:
        return CATEGORIES[2]
    
    
def show_image(image):
    cv2.imshow("blood", image)
    cv2.waitKey(0)


#agafo color en RGB
#converteixo a BGR


'''def create_image():
    color = (100, 100, 255)
    img = np.full((300, 300, 3), color, np.uint8)
    
    cv2.imshow('Imagen Roja', img)
    cv2.waitKey(0)

    hsv_img = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
    print(hsv_img)
'''



def main():
    #create_image()
    img = cv2.imread("pad.png")
    print(get_category("excessive.png", ((1,2), (4,5))))


if __name__ == "__main__":
    main()