"""
URL patterns for users API.
"""
from django.urls import path
from . import views

app_name = 'users'

urlpatterns = [
    path('profile/', views.UserProfileView.as_view(), name='profile'),
    path('orders/', views.UserOrdersView.as_view(), name='user-orders'),
]
