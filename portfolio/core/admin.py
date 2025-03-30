from django.contrib import admin, messages
from core.models import (
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

from django.shortcuts import render, redirect
from django.urls import path

from core.serializers import PortfolioSerializer
from core.forms import PortfolioImportForm
import json
from django.utils.html import format_html
from django.urls import reverse
from django.core.serializers.json import DjangoJSONEncoder


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
    change_form_template = "admin/portfolio_change_form.html"
    list_display = ('name', 'owner', 'created_at', 'updated_at', 'edit_json_button')
    list_filter = ('created_at', 'updated_at')
    search_fields = ('name', 'owner__username')

    def edit_json_button(self, obj):
        if not obj.id:
            return ""
        url = reverse('admin:portfolio_edit_json', args=[obj.id])
        return format_html('<a class="button" href="{}">Edit as JSON</a>', url)
    edit_json_button.short_description = "Edit as JSON"

    def get_urls(self):
        urls = super().get_urls()
        custom_urls = [
            path('<int:portfolio_id>/edit-json/', self.admin_site.admin_view(self.edit_json), name='portfolio_edit_json'),
        ]
        return custom_urls + urls

    def edit_json(self, request, portfolio_id):
        portfolio = Portfolio.objects.get(id=portfolio_id)
        if request.method == "POST":
            form = PortfolioImportForm(request.POST)
            if form.is_valid():
                json_data = form.cleaned_data['json_data']
                try:
                    data = json.loads(json_data)
                    serializer = PortfolioSerializer(portfolio, data=data)
                    if serializer.is_valid():
                        portfolio = serializer.save()
                        self.message_user(request, f"Successfully updated portfolio: {portfolio.name}", level=messages.SUCCESS)
                        return redirect("..")
                    else:
                        self.message_user(request, f"Validation errors: {serializer.errors}", level=messages.ERROR)
                except json.JSONDecodeError as e:
                    self.message_user(request, f"Invalid JSON: {e}", level=messages.ERROR)
            else:
                self.message_user(request, "Invalid form submission.", level=messages.ERROR)
        else:
            serializer = PortfolioSerializer(portfolio)
            initial_data = json.dumps(serializer.data, cls=DjangoJSONEncoder, indent=4)
            form = PortfolioImportForm(initial={'json_data': initial_data})

        context = {
            **self.admin_site.each_context(request),
            'form': form,
            'portfolio': portfolio,
        }
        return render(request, "admin/edit_portfolio_json.html", context)
