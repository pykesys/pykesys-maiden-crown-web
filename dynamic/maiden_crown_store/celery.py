"""
Celery configuration for Maiden Crown Store.
Used for async tasks like digital product delivery.
"""
import os
from celery import Celery
from decouple import config

# Set the default Django settings module
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'maiden_crown_store.settings.development')

app = Celery('maiden_crown_store')

# Using a string here means the worker doesn't have to serialize
# the configuration object to child processes.
app.config_from_object('django.conf:settings', namespace='CELERY')

# Load task modules from all registered Django apps.
app.autodiscover_tasks()


@app.task(bind=True)
def debug_task(self):
    print(f'Request: {self.request!r}')
