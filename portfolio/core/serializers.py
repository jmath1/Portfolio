from rest_framework import serializers
from .models import (
    AboutMeBlock,
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
    image = serializers.ImageField(read_only=True)

    class Meta:
        model = HeaderBlock
        fields = '__all__'

class BlogPostSerializer(serializers.ModelSerializer):
    image = serializers.ImageField(read_only=True)
    html_file = serializers.FileField(read_only=True)

    class Meta:
        model = BlogPost
        fields = '__all__'

class AboutMeSectionBlockSerializer(serializers.ModelSerializer):
    class Meta:
        model = AboutMeBlock
        fields = '__all__'
        
class BlogSectionBlockSerializer(serializers.ModelSerializer):
    blog_posts = BlogPostSerializer(many=True, read_only=True)
    
    class Meta:
        model = BlogSectionBlock
        fields = '__all__'

class ProjectItemSerializer(serializers.ModelSerializer):
    image = serializers.ImageField(read_only=True)

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
    color_scheme = ColorSchemeSerializer()
    header_block = HeaderBlockSerializer()
    navigation = NavigationSerializer()
    blog_section_block = BlogSectionBlockSerializer()
    projects_block = ProjectsBlockSerializer()
    about_me_block = AboutMeSectionBlockSerializer()

    class Meta:
        model = Portfolio
        fields = '__all__'

    def update(self, instance, validated_data):
        if 'color_scheme' in validated_data:
            color_scheme_data = validated_data.pop('color_scheme')
            ColorScheme.objects.filter(id=instance.color_scheme.id).update(**color_scheme_data)
        
        if 'header_block' in validated_data:
            header_block_data = validated_data.pop('header_block')
            HeaderBlock.objects.filter(id=instance.header_block.id).update(**header_block_data)
        
        if 'navigation' in validated_data:
            navigation_data = validated_data.pop('navigation')
            Navigation.objects.filter(id=instance.navigation.id).update(**navigation_data)
        
        if 'blog_section_block' in validated_data:
            blog_section_data = validated_data.pop('blog_section_block')
            BlogSectionBlock.objects.filter(id=instance.blog_section_block.id).update(**blog_section_data)
        
        if 'projects_block' in validated_data:
            projects_block_data = validated_data.pop('projects_block')
            ProjectsBlock.objects.filter(id=instance.projects_block.id).update(**projects_block_data)
        
        return super().update(instance, validated_data)
