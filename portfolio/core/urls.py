from django.urls import path
from .views import PortfolioDetailView
from . import views

app_name = "core"

urlpatterns = [
    path("healthcheck/", views.healthcheck, name="healthcheck"),
    path('portfolios/<int:pk>/', PortfolioDetailView.as_view(), name='portfolio-detail'),
]