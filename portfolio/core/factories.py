import factory
from factory.django import DjangoModelFactory
from django.contrib.auth.models import User
from core.models import (
    ColorScheme,
    Block,
    HeaderBlock,
    BlogSectionBlock,
    BlogPost,
    Navigation,
    ProjectsBlock,
    ProjectItem,
    NavigationItem,
    Portfolio
)


class UserFactory(DjangoModelFactory):
    class Meta:
        model = User

    username = factory.Sequence(lambda n: f'user{n}')
    email = factory.LazyAttribute(lambda obj: f'{obj.username}@example.com')


class ColorSchemeFactory(DjangoModelFactory):
    class Meta:
        model = ColorScheme

    name = factory.Faker('word')
    primary_color = '#FFFFFF'
    secondary_color = '#000000'
    background_color = '#F0F0F0'
    accent_color = '#FF5733'
    text_color = '#333333'


class BlockFactory(DjangoModelFactory):
    class Meta:
        model = Block
        abstract = True

    order = factory.Sequence(lambda n: n)
    name = factory.Faker('word')


class HeaderBlockFactory(BlockFactory):
    class Meta:
        model = HeaderBlock

    style = 'minimal'
    image = factory.django.ImageField(color='blue')
    header = factory.Faker('sentence', nb_words=3)
    header_size = 'medium'
    subheading = factory.Faker('sentence', nb_words=5)
    subheading_size = 'medium'
    button_text = factory.Faker('word')
    button_link = factory.Faker('url')


class BlogSectionBlockFactory(BlockFactory):
    class Meta:
        model = BlogSectionBlock

    title = factory.Faker('sentence', nb_words=3)
    description = factory.Faker('paragraph')
    background_style = 'solid'
    blog_style = 'grid'
    blog_page_style = 'modern'


class BlogPostFactory(DjangoModelFactory):
    class Meta:
        model = BlogPost

    blog_section = factory.SubFactory(BlogSectionBlockFactory)
    title = factory.Faker('sentence', nb_words=4)
    subtitle = factory.Faker('sentence', nb_words=6)
    image = factory.django.ImageField(color='green')
    html_file = factory.django.FileField(data=b'Test content')


class NavigationFactory(DjangoModelFactory):
    class Meta:
        model = Navigation

    style = 'top_bar'
    github_link = factory.Faker('url')
    linkedin_link = factory.Faker('url')
    email_link = factory.Faker('email')
    resume_link = factory.Faker('url')
    icon_animation = 'none'


class ProjectsBlockFactory(BlockFactory):
    class Meta:
        model = ProjectsBlock

    title = factory.Faker('sentence', nb_words=3)
    description = factory.Faker('paragraph')
    background_style = 'solid'
    project_style = 'grid'


class ProjectItemFactory(DjangoModelFactory):
    class Meta:
        model = ProjectItem

    projects_block = factory.SubFactory(ProjectsBlockFactory)
    title = factory.Faker('sentence', nb_words=3)
    description = factory.Faker('paragraph')
    image = factory.django.ImageField(color='red')
    link = factory.Faker('url')
    github_link = factory.Faker('url')


class NavigationItemFactory(DjangoModelFactory):
    class Meta:
        model = NavigationItem

    navigation = factory.SubFactory(NavigationFactory)
    text = factory.Faker('word')
    link = factory.Faker('url')


class PortfolioFactory(DjangoModelFactory):
    class Meta:
        model = Portfolio

    owner = factory.SubFactory(UserFactory)
    name = factory.Faker('word')
    color_scheme = factory.SubFactory(ColorSchemeFactory)
    header_block = factory.SubFactory(HeaderBlockFactory)
    navigation = factory.SubFactory(NavigationFactory)
    blog_section_block = factory.SubFactory(BlogSectionBlockFactory)
    projects_block = factory.SubFactory(ProjectsBlockFactory)