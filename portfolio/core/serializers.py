from rest_framework import serializers
from .models import (
    ColorScheme,
    Block,
    HeaderBlock,
    BlogSectionBlock,
    BlogPost,
    ProjectsBlock,
    ProjectItem,
    Navigation,
    NavigationItem,
    Portfolio
)

class ColorSchemeSerializer(serializers.ModelSerializer):
    class Meta:
        model = ColorScheme
        fields = '__all__'

class BlockSerializer(serializers.ModelSerializer):
    class Meta:
        model = Block
        fields = '__all__'

class HeaderBlockSerializer(serializers.ModelSerializer):
    class Meta:
        model = HeaderBlock
        fields = '__all__'

class BlogPostSerializer(serializers.ModelSerializer):

    class Meta:
        model = BlogPost
        fields = '__all__'

class BlogSectionBlockSerializer(serializers.ModelSerializer):
    blog_posts = BlogPostSerializer(many=True, read_only=True)
    
    class Meta:
        model = BlogSectionBlock
        fields = '__all__'

class ProjectItemSerializer(serializers.ModelSerializer):

    class Meta:
        model = ProjectItem
        fields = '__all__'

class ProjectsBlockSerializer(serializers.ModelSerializer):
    project_items = ProjectItemSerializer(many=True, read_only=True)
    
    class Meta:
        model = ProjectsBlock
        fields = '__all__'

class NavigationItemSerializer(serializers.ModelSerializer):
    class Meta:
        model = NavigationItem
        fields = '__all__'

class NavigationSerializer(serializers.ModelSerializer):
    navigation_items = NavigationItemSerializer(many=True, read_only=True)
    
    class Meta:
        model = Navigation
        fields = '__all__'

class PortfolioSerializer(serializers.ModelSerializer):
    color_scheme = ColorSchemeSerializer(read_only=True)
    header_block = HeaderBlockSerializer(read_only=True)
    navigation = NavigationSerializer(read_only=True)
    blog_section_block = BlogSectionBlockSerializer(read_only=True)
    projects_block = ProjectsBlockSerializer(read_only=True)
    
    class Meta:
        model = Portfolio
        fields = '__all__'
