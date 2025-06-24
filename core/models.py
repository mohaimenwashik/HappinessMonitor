from django.db import models

# Create your models here.

class User(models.Model):
    device_token = models.TextField(unique=True)
    is_subscribed = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = 'users'

    def __str__(self):
        return f"User {self.id}"

class Survey(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='surveys')
    activity = models.TextField()
    happiness = models.IntegerField()
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = 'surveys'

    def __str__(self):
        return f"Survey {self.id} by User {self.user.id}"
