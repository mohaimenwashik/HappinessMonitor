from django.shortcuts import render
from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .models import User, Survey
from .serializers import UserSerializer, SurveySerializer
from django.utils import timezone

@api_view(['POST'])
def register_user(request):
    serializer = UserSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=201)
    return Response(serializer.errors, status=400)

@api_view(['POST'])
def submit_survey(request):
    serializer = SurveySerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=201)
    return Response(serializer.errors, status=400)

@api_view(['GET'])
def latest_surveys(request, device_token):
    try:
        user = User.objects.get(device_token=device_token)
        surveys = Survey.objects.filter(user=user).order_by('-created_at')[:3]
        serializer = SurveySerializer(surveys, many=True)
        return Response(serializer.data)
    except User.DoesNotExist:
        return Response({'error': 'User not found'}, status=404)
    
@api_view(['GET'])
def get_user_by_token(request, token):
    try:
        user = User.objects.get(device_token=token)
        serializer = UserSerializer(user)
        return Response(serializer.data)
    except User.DoesNotExist:
        return Response({'error': 'User not found'}, status=404)

@api_view(['POST'])
def toggle_subscription(request):
    device_token = request.data.get('device_token')
    try:
        user = User.objects.get(device_token=device_token)
        user.is_subscribed = not user.is_subscribed
        user.save()
        return Response({'subscribed': user.is_subscribed})
    except User.DoesNotExist:
        return Response({'error': 'User not found'}, status=404)

