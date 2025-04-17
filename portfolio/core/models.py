from django.db import models
from colorfield.fields import ColorField
from django.utils.text import slugify

    
class ColorScheme(models.Model):
    name = models.CharField(max_length=255)
    primary_color = ColorField(default='#FFFFFF')
    secondary_color = ColorField(default='#000000')
    background_color = ColorField(default='#F0F0F0')
    accent_color = ColorField(default='#FF5733')
    text_color = ColorField(default='#333333')

    def __str__(self):
        return f"{self.name}"
    
class Block(models.Model):
    order = models.IntegerField()
    name = models.CharField(max_length=255)

    def __str__(self):
        return f"{self.name}"
    class Meta:
        ordering = ['order']
        
    def __str__(self):
        return f"{self.name}"

class HeaderBlock(Block):
    STYLE_CHOICES = [
    ('minimal', 'Minimal'),
    ('modern', 'Modern'),
    ('bold', 'Bold'),
    ('overlay_text', 'Overlay on Image'),
    ('split_layout', 'Split Layout'),
]
    
    style = models.CharField(max_length=255, choices=STYLE_CHOICES, default='minimal')
    background_color_override = ColorField(null=True, blank=True)
    image = models.ImageField(upload_to='header_images/', null=True, blank=True)
    header = models.CharField(max_length=255)
    header_color_override = ColorField(null=True, blank=True)
    header_size = models.CharField(max_length=255, choices=[
        ('small', 'Small'),
        ('medium', 'Medium'),
        ('large', 'Large'),
    ], default='medium')
    subheading = models.CharField(max_length=255)
    subheading_color_override = ColorField(null=True, blank=True)
    subheading_size = models.CharField(max_length=255, choices=[
        ('small', 'Small'),
        ('medium', 'Medium'),
        ('large', 'Large'),
    ], default='medium')
    button_text = models.CharField(max_length=255, null=True, blank=True)
    button_link = models.URLField()
    button_color_override = ColorField(null=True, blank=True)
    
    def __str__(self):
        return self.header

class BlogSectionBlock(Block):
    title = models.CharField(max_length=255)
    description = models.TextField()
    background_color_override = ColorField(null=True, blank=True)
    background_style = models.CharField(max_length=255, choices=[
        ('solid', 'Solid Color'),
        ('gradient', 'Gradient'),
        ('paralax', 'Paralax'),
    ], default='solid')
    blog_style = models.CharField(max_length=255, choices=[
        ('grid', 'Grid'),
        ('rows', 'Rows'),
        ('minimalist', 'Minimalist'),
        ('carousel', 'Carousel'),
    ], default='grid')
    blog_page_style = models.CharField(max_length=255, choices=[
        ('modern', 'Modern'),
        ('classic', 'Classic'),
        ('minimal', 'Minimal'),
    ], default='modern')
    
    def __str_(self):
        return f"BlogSectionBlock {self.id}"

class BlogPost(models.Model):
    blog_section = models.ForeignKey(BlogSectionBlock, on_delete=models.CASCADE, related_name='blog_posts')
    title = models.CharField(max_length=255)
    subtitle = models.CharField(max_length=255, null=True, blank=True)
    date_created = models.DateTimeField(auto_now_add=True)
    image = models.ImageField(upload_to='blog_images/', null=True, blank=True)
    html_file = models.FileField(upload_to='blog_files/')
    slug = models.SlugField(max_length=255, unique=True)
    
    def save(self, *args, **kwargs):
        if not self.slug:
            self.slug = slugify(self.title)
        super().save(*args, **kwargs)
        
    def __str__(self):
        return f"{self.slug}"

class Navigation(models.Model):
    style = models.CharField(max_length=255, choices=[
        ('hamburger', 'Hamburger'),
        ('top_bar', 'Top Bar'),
        ('side_menu', 'Side Menu'),
    ], default='top_bar')
    github_link = models.URLField(null=True, blank=True)
    linkedin_link = models.URLField(null=True, blank=True)
    email_link = models.EmailField(null=True, blank=True)
    resume_link = models.URLField(null=True, blank=True)
    icon_animation = models.CharField(max_length=255, choices=[
        ('none', 'None'),
        ('bounce', 'Bounce'),
        ('spin', 'Spin'),
    ], default='none')
    link_color_override = ColorField(null=True, blank=True)
    link_color_on_hover = ColorField(null=True, blank=True)
    
    def __str__(self):
        return f"Navigation - {self.id}"

class ProjectsBlock(Block):
    title = models.CharField(max_length=255)
    description = models.TextField()
    background_color_override = ColorField(null=True, blank=True)
    background_style = models.CharField(max_length=255, choices=[
        ('solid', 'Solid Color'),
        ('gradient', 'Gradient'),
        ('paralax', 'Paralax'),
    ], default='solid')
    project_style = models.CharField(max_length=255, choices=[
        ('grid', 'Grid'),
        ('list', 'List'),
        ('carousel', 'Carousel'),
    ], default='grid')
    
    def __str__(self):
        return f"{self.title}"

class ProjectItem(models.Model):
    projects_block = models.ForeignKey(ProjectsBlock, on_delete=models.CASCADE, related_name='project_items')
    title = models.CharField(max_length=255)
    blurb = models.TextField(max_length=140, null=True, blank=True)
    description = models.TextField()
    image = models.ImageField(upload_to='project_images/')
    link = models.URLField()
    github_link = models.URLField(null=True, blank=True)
    date_created = models.DateTimeField(auto_now_add=True)
    slug = models.SlugField(max_length=255, default='')
    
    def save(self, *args, **kwargs):
        if not self.slug:
            self.slug = slugify(self.title)
        super().save(*args, **kwargs)
        


    def __str__(self):
        return f"ProjectItem {self.title}"
class NavigationItem(models.Model):
    navigation = models.ForeignKey(Navigation, on_delete=models.CASCADE, related_name='navigation_items')
    text = models.CharField(max_length=255)
    link = models.CharField(max_length=255)
    
    def __str__(self):
        return f"NavigationItem {self.text}"
    

class Portfolio(models.Model):
    owner = models.ForeignKey('auth.User', on_delete=models.CASCADE)
    name = models.CharField(max_length=255)
    color_scheme = models.ForeignKey('ColorScheme', on_delete=models.PROTECT, null=True, blank=True)
    header_block = models.OneToOneField('HeaderBlock', on_delete=models.CASCADE, null=True, blank=True)
    navigation = models.OneToOneField('Navigation', on_delete=models.CASCADE, null=True, blank=True)
    blog_section_block = models.OneToOneField('BlogSectionBlock', on_delete=models.CASCADE, null=True, blank=True)
    projects_block = models.OneToOneField('ProjectsBlock', on_delete=models.CASCADE, null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.name