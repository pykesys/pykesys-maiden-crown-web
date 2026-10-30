"""
Serializers for users API.
"""
from rest_framework import serializers
from .models import User, UserProfile


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('id', 'email', 'username', 'first_name', 'last_name', 'is_newsletter_subscribed')
        read_only_fields = ('id',)


class UserProfileSerializer(serializers.ModelSerializer):
    user = UserSerializer(read_only=True)

    class Meta:
        model = UserProfile
        fields = '__all__'
        read_only_fields = ('id', 'user', 'created_at', 'updated_at')
