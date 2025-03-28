from django.core.management.base import BaseCommand
from core.models import Portfolio, ColorScheme  # Explicitly import ColorScheme
from core.factories import (
    UserFactory,
    HeaderBlockFactory,
    BlogSectionBlockFactory,
    BlogPostFactory,
    NavigationFactory,
    ProjectsBlockFactory,
    ProjectItemFactory,
    NavigationItemFactory,
    PortfolioFactory
)
from django.contrib.auth import get_user_model

User = get_user_model()


COLOR_SCHEMES = {
    "sunset": {
        "name": "Sunset Glow",
        "primary_color": "#FF5E5B",
        "secondary_color": "#D8D8D8",
        "background_color": "#FCEADE",
        "accent_color": "#FFB400",
        "text_color": "#2E2E2E",
    },
    "forest": {
        "name": "Forest Calm",
        "primary_color": "#2E8B57",
        "secondary_color": "#A9BA9D",
        "background_color": "#E8F0E5",
        "accent_color": "#556B2F",
        "text_color": "#1C1C1C",
    },
    "ocean": {
        "name": "Ocean Breeze",
        "primary_color": "#1CA9C9",
        "secondary_color": "#B0E0E6",
        "background_color": "#F0FFFF",
        "accent_color": "#005577",
        "text_color": "#003344",
    },
    "midnight": {
        "name": "Midnight Pulse",
        "primary_color": "#2C3E50",
        "secondary_color": "#34495E",
        "background_color": "#1A1A1D",
        "accent_color": "#E74C3C",
        "text_color": "#ECF0F1",
    }
}


class Command(BaseCommand):
    help = "Generate a fully populated dummy Portfolio with all related models and a selected color scheme"

    def add_arguments(self, parser):
        parser.add_argument('--color-scheme', choices=COLOR_SCHEMES.keys(), required=True,
                            help=f"Choose one of: {', '.join(COLOR_SCHEMES.keys())}")
        parser.add_argument('--blog-posts', type=int, default=3, help='Number of blog posts')
        parser.add_argument('--project-items', type=int, default=3, help='Number of project items')
        parser.add_argument('--navigation-items', type=int, default=3, help='Number of navigation items')

    def handle(self, *args, **options):
        scheme_key = options['color_scheme']
        scheme_data = COLOR_SCHEMES[scheme_key]

        self.stdout.write(self.style.NOTICE(f"Using color scheme: {scheme_data['name']}"))

        # Create user
        try:
            user = UserFactory()
        except:
            user = User.objects.last()
        self.stdout.write(self.style.SUCCESS(f"Created User: {user.username}"))

        # Create Color Scheme instance
        color_scheme = ColorScheme.objects.create(**scheme_data)
        self.stdout.write(self.style.SUCCESS(f"Created ColorScheme: {color_scheme.name}"))

        # Create Header Block
        header_block = HeaderBlockFactory()
        self.stdout.write(self.style.SUCCESS(f"Created HeaderBlock: {header_block.name}"))

        # Create Blog Section Block
        blog_section_block = BlogSectionBlockFactory()
        self.stdout.write(self.style.SUCCESS(f"Created BlogSectionBlock: {blog_section_block.name}"))

        # Create Projects Block
        projects_block = ProjectsBlockFactory()
        self.stdout.write(self.style.SUCCESS(f"Created ProjectsBlock: {projects_block.name}"))

        # Create Navigation
        navigation = NavigationFactory()
        self.stdout.write(self.style.SUCCESS(f"Created Navigation"))

        # Create Portfolio tying everything together
        portfolio = PortfolioFactory(
            owner=user,
            name=f"{scheme_data['name']} Portfolio",
            color_scheme=color_scheme,
            header_block=header_block,
            navigation=navigation,
            blog_section_block=blog_section_block,
            projects_block=projects_block,
        )
        self.stdout.write(self.style.SUCCESS(f"Created Portfolio: {portfolio.name}"))

        # Create Blog Posts
        for _ in range(options['blog_posts']):
            post = BlogPostFactory(blog_section=blog_section_block)
            self.stdout.write(self.style.SUCCESS(f" - BlogPost: {post.title}"))

        # Create Project Items
        for _ in range(options['project_items']):
            project_item = ProjectItemFactory(projects_block=projects_block)
            self.stdout.write(self.style.SUCCESS(f" - ProjectItem: {project_item.title}"))

        # Create Navigation Items
        for _ in range(options['navigation_items']):
            nav_item = NavigationItemFactory(navigation=navigation)
            self.stdout.write(self.style.SUCCESS(f" - NavigationItem: {nav_item.text}"))

        self.stdout.write(self.style.SUCCESS("✅ Dummy portfolio generation complete with chosen color scheme!"))
