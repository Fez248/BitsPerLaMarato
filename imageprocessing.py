

CATEGORIES = ["light", "moderate", "saturated"]

def count_bloody_pixels(image, overlay) -> int:
    '''Returns the number of bloody pixels inside the overlay'''
    pass


def count_pixels_overlay(overlay) -> int:
    '''Returns the total number of pixels inside the overlay'''
    pass


def get_category(image, overlay) -> str:
    '''Given an image of a pad/tampon and its overlay, it returns
    the category of the bleeding'''

    ratio = count_bloody_pixels(image, overlay) / count_pixels_overlay(overlay)

    if 0 <= ratio <= 0.33:
        return CATEGORIES[0]
    
    elif 0.33 < ratio <= 0.66:
        return CATEGORIES[1]
    
    else:
        return CATEGORIES[2]
    
    