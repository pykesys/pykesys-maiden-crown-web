"""
Views for users API.
"""
from rest_framework import generics, permissions
from rest_framework.response import Response
from .models import UserProfile
from .serializers import UserProfileSerializer


class UserProfileView(generics.RetrieveUpdateAPIView):
    """
    Get or update the authenticated user's profile.
    """
    serializer_class = UserProfileSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_object(self):
        return self.request.user.profile


class UserOrdersView(generics.ListAPIView):
    """
    List all orders for the authenticated user.
    """
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return self.request.user.orders.all().order_by('-created_at')
