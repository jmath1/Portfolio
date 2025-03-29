from django.http import HttpResponse
from rest_framework import generics, permissions
from rest_framework.response import Response
from .models import Portfolio
from .serializers import PortfolioSerializer

def healthcheck(request):
    return HttpResponse("OK")


class PortfolioDetailView(generics.RetrieveAPIView):
    queryset = Portfolio.objects.select_related(
        'color_scheme',
        'header_block',
        'navigation',
        'blog_section_block',
        'projects_block'
    ).prefetch_related(
        'navigation__navigation_items',
        'blog_section_block__blog_posts',
        'projects_block__project_items'
    )
    serializer_class = PortfolioSerializer

    def get(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = self.get_serializer(instance, context={'request': request})
        return Response(serializer.data)