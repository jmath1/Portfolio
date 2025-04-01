import random
import colorsys
import webcolors

from django.core.management.base import BaseCommand
from core.models import ColorScheme

# ---------- STYLE DEFINITIONS ----------

STYLE_PROFILES = {
    'pastel': {'s_range': (0.3, 0.6), 'l_range': (0.7, 0.85)},
    'neon': {'s_range': (0.8, 1.0), 'l_range': (0.5, 0.65)},
    'dark': {'s_range': (0.4, 0.7), 'l_range': (0.2, 0.4)},
    'vintage': {'s_range': (0.4, 0.6), 'l_range': (0.5, 0.7)},
    'cool': {'s_range': (0.5, 0.7), 'l_range': (0.5, 0.7)},
    'warm': {'s_range': (0.5, 0.7), 'l_range': (0.5, 0.7)},
    'professional': {'s_range': (0.4, 0.6), 'l_range': (0.4, 0.6)},
    'high_contrast': {'s_range': (0.7, 1.0), 'l_range': (0.3, 0.8)},
    'modern_ui': {'s_range': (0.5, 0.7), 'l_range': (0.6, 0.85)},
    'cyberpunk': {'s_range': (0.8, 1.0), 'l_range': (0.4, 0.6)},
    'earthy': {'s_range': (0.4, 0.6), 'l_range': (0.5, 0.7)},
}

NAMED_COLORS = {
    'red': '#FF0000',
    'green': '#008000',
    'blue': '#0000FF',
    'yellow': '#FFFF00',
    'purple': '#800080',
    'teal': '#008080',
    'orange': '#FFA500',
    'pink': '#FFC0CB',
    'navy': '#000080',
    'black': '#000000',
    'white': '#FFFFFF',
    'gray': '#808080',
}

# ---------- COLOR UTILS ----------

def hex_to_hsl(hex_color):
    r, g, b = webcolors.hex_to_rgb(hex_color)
    r /= 255
    g /= 255
    b /= 255
    h, l, s = colorsys.rgb_to_hls(r, g, b)
    return (h * 360, s, l)

def hsl_to_hex(h, s, l):
    r, g, b = colorsys.hls_to_rgb(h / 360.0, l, s)
    r = max(0, min(255, int(r * 255)))
    g = max(0, min(255, int(g * 255)))
    b = max(0, min(255, int(b * 255)))
    return '#{0:02x}{1:02x}{2:02x}'.format(r, g, b)


# ---------- COLOR SCHEME GENERATOR ----------

def generate_color_scheme(base_hex, style=None):
    if style not in STYLE_PROFILES:
        style = random.choice(list(STYLE_PROFILES.keys()))
    profile = STYLE_PROFILES[style]

    # --- Base Hue from provided hex ---
    base_hue, _, _ = hex_to_hsl(base_hex)

    # --- Harmony ---
    harmony = random.choice(['analogous', 'complementary', 'triadic', 'split_complementary', 'tetradic'])

    # --- Related Hues ---
    if harmony == 'analogous':
        secondary_hue = (base_hue + random.randint(20, 40)) % 360
        accent_hue = (base_hue - random.randint(20, 40)) % 360
    elif harmony == 'complementary':
        secondary_hue = (base_hue + 180) % 360
        accent_hue = (base_hue + random.choice([150, 210])) % 360
    elif harmony == 'triadic':
        secondary_hue = (base_hue + 120) % 360
        accent_hue = (base_hue + 240) % 360
    elif harmony == 'split_complementary':
        secondary_hue = (base_hue + 150) % 360
        accent_hue = (base_hue + 210) % 360
    elif harmony == 'tetradic':
        secondary_hue = (base_hue + 90) % 360
        accent_hue = (base_hue + 180) % 360

    # --- Saturation and Lightness based on Style ---
    s = random.uniform(*profile['s_range'])
    l_primary = random.uniform(*profile['l_range'])
    l_secondary = max(0, min(1, l_primary + random.uniform(-0.1, 0.1)))
    l_accent = max(0, min(1, l_primary + random.uniform(-0.1, 0.1)))
    l_background = 0.95 if style not in ['dark', 'cyberpunk', 'high_contrast'] else 0.1
    l_text = 0.1 if style not in ['dark', 'cyberpunk', 'high_contrast'] else 0.9

    return {
        "name": f"{style.capitalize()} ({harmony}) Scheme",
        "primary_color": hsl_to_hex(base_hue, s, l_primary),
        "secondary_color": hsl_to_hex(secondary_hue, s, l_secondary),
        "accent_color": hsl_to_hex(accent_hue, s, l_accent),
        "background_color": hsl_to_hex(base_hue, s * 0.3, l_background),
        "text_color": hsl_to_hex(base_hue, s * 0.3, l_text),
        "style": style,
        "harmony": harmony,
    }


# ---------- MANAGEMENT COMMAND ----------

class Command(BaseCommand):
    help = "Generate creative color schemes starting from a specified base color"

    def add_arguments(self, parser):
        parser.add_argument('--count', type=int, default=1, help='How many schemes to generate')
        parser.add_argument('--primary', type=str, help='Primary color (hex or named color)', required=True)
        parser.add_argument('--style', type=str, choices=STYLE_PROFILES.keys(), help='Optional style preset')

    def handle(self, *args, **options):
        count = options['count']
        primary_input = options['primary'].lower()
        style = options.get('style')

        # --- Resolve Primary Color ---
        if primary_input in NAMED_COLORS:
            base_hex = NAMED_COLORS[primary_input]
        elif primary_input.startswith('#') and len(primary_input) in [4, 7]:
            base_hex = primary_input
        else:
            self.stdout.write(self.style.ERROR(
                f"Invalid primary color. Use a hex (#rrggbb) or one of: {', '.join(NAMED_COLORS.keys())}"
            ))
            return

        for i in range(count):
            data = generate_color_scheme(base_hex, style)
            data['name'] = f"{data['style'].capitalize()} ({data['harmony']}) {primary_input} Scheme"
            scheme = ColorScheme.objects.create(
                name=data['name'],
                primary_color=data['primary_color'],
                secondary_color=data['secondary_color'],
                accent_color=data['accent_color'],
                background_color=data['background_color'],
                text_color=data['text_color'],
            )
            self.stdout.write(self.style.SUCCESS(
                f"Created [{data['style']}/{data['harmony']}] scheme: {scheme}"
            ))
