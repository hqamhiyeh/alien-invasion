import json
from pathlib import Path
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from alien_invasion import AlienInvasion

class GameStats:
    """Track statistics for Alien Invasion."""

    def __init__(self, ai_game: 'AlienInvasion'):
        """Initialize statistics."""
        self.settings = ai_game.settings
        self.reset_stats()

        # High score should never be reset.
        self.high_score = 0
        self.high_score_path = Path('high_score.json')
        self._load_high_score()

    def reset_stats(self):
        """Initialize statistics that can change during the game."""
        self.ships_left = self.settings.ship_limit
        self.level = 1
        self.score = 0
        self.is_new_high_score = False

    def _load_high_score(self):
        """Read high score from save file."""
        if self.high_score_path.exists():
            contents = self.high_score_path.read_text(encoding='utf-8')
            self.high_score = json.loads(contents)

    def save_high_score(self):
        """Write high score to save file."""
        contents = json.dumps(self.high_score)
        self.high_score_path.write_text(contents, encoding='utf-8')
