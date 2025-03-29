from django.contrib import admin
from .models import (
    ColorScheme,
    Block,
    HeaderBlock,
    BlogSectionBlock,
    BlogPost,
    Navigation,
    NavigationItem,
    ProjectsBlock,
    ProjectItem,
    Portfolio
)

admin.site.site_header = "Portoflio Creator"
admin.site.site_title = "Portfolio Backend"
admin.site.index_title = "Portfolio Backend" 

class BlogPostInline(admin.TabularInline):
    model = BlogPost
    extra = 1


class ProjectItemInline(admin.TabularInline):
    model = ProjectItem
    extra = 1


class NavigationItemInline(admin.TabularInline):
    model = NavigationItem
    extra = 1


@admin.register(ColorScheme)
class ColorSchemeAdmin(admin.ModelAdmin):
    list_display = ('name',)


@admin.register(Block)
class BlockAdmin(admin.ModelAdmin):
    list_display = ('name', 'order')


@admin.register(HeaderBlock)
class HeaderBlockAdmin(admin.ModelAdmin):
    list_display = ('name', 'style', 'header')


@admin.register(BlogSectionBlock)
class BlogSectionBlockAdmin(admin.ModelAdmin):
    list_display = ('name', 'title', 'background_style', 'blog_style', 'blog_page_style')
    inlines = [BlogPostInline]


@admin.register(Navigation)
class NavigationAdmin(admin.ModelAdmin):
    list_display = ('style', 'github_link', 'linkedin_link')
    inlines = [NavigationItemInline]


@admin.register(ProjectsBlock)
class ProjectsBlockAdmin(admin.ModelAdmin):
    list_display = ('name', 'title', 'background_style', 'project_style')
    inlines = [ProjectItemInline]


@admin.register(Portfolio)
class PortfolioAdmin(admin.ModelAdmin):
    list_display = ('name', 'owner', 'created_at', 'updated_at')
    list_filter = ('created_at', 'updated_at')
    search_fields = ('name', 'owner__username')