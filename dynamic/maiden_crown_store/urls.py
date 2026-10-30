"""
URL configuration for Maiden Crown Store.
"""
from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from drf_spectacular.views import SpectacularAPIView, SpectacularSwaggerView

urlpatterns = [
    # Admin
    path('admin/', admin.site.URLs),

    # API Documentation
    path('api/schema/', SpectacularAPIView.as_view(), name='schema'),
    path('api/docs/', SpectacularSwaggerView.as_view(url_name='schema'), name='swagger-ui'),

    # Authentication
    path('api/auth/', include('rest_framework.urls')),
    path('accounts/', include('allauth.urls')),

    # API v1
    path('api/v1/products/', include('apps.products.urls')),
    path('api/v1/orders/', include('apps.orders.urls')),
    path('api/v1/users/', include('apps.users.urls')),
    path('api/v1/content/', include('apps.content_api.urls')),
    path('api/v1/digital/', include('apps.digital_delivery.urls')),
]

# Serve media files in development
if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)

    # Debug toolbar
    if 'debug_toolbar' in settings.INSTALLED_APPS:
        import debug_toolbar
        urlpatterns = [
            path('__debug__/', include(debug_toolbar.urls)),
        ] + urlpatterns

# Customize admin site
admin.site.site_header = 'Maiden Crown Press Admin'
admin.site.site_title = 'Maiden Crown Press'
admin.site.index_title = 'Store Administration'
