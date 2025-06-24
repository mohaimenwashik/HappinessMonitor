from django.urls import path
from . import views

urlpatterns = [
    path('register/', views.register_user),
    path('user/<str:token>/', views.get_user_by_token),
    path('submit/', views.submit_survey),
    path('latest/<str:device_token>/', views.latest_surveys),
    path('toggle-subscription/', views.toggle_subscription),
]
