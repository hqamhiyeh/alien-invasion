from pygame import mixer

from paths import resource_path

class Audio():
    """A class to manage the audio in the game."""

    def __init__(self):
        self.shooting_sound = mixer.Sound(
            resource_path('sounds/shoot.ogg'))
        self.alien_death_sound = mixer.Sound(
            resource_path('sounds/explosion-1.ogg'))
        self.ship_death_sound = mixer.Sound(
            resource_path('sounds/explosion-2.ogg'))

    def play_shooting_sound(self):
        """Play shooting sound effect."""
        self.shooting_sound.play()

    def play_alien_death_sound(self):
        """Play alien death sound effect."""
        self.alien_death_sound.play()

    def play_ship_death_sound(self):
        """Play ship death sound effect."""
        self.ship_death_sound.play()
