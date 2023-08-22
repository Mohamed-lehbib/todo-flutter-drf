from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from . serializers import TodoSerializer
from . models import Todo

# Create your views here.

#this class handle ['GET','POST'] requests
class TodoList(APIView):
    #creating the get request for many todo
    def get(self, request):
        todos = Todo.objects.all()
        serializer = TodoSerializer(todos, many=True)
        return Response(serializer.data)
    #create post method to create a new task
    def post(self,request ):
        serializer = TodoSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
#this class handle the ['GET', 'PUT', 'DELETE'] requests
class TodoDetail(APIView):
    #creating a get_object function 
    def get_object(self, pk):
        try:
            return Todo.objects.get(pk=pk)
        except Todo.DoesNotExist as e :
            return e
    #creating a get function for a single todo
    def get(self, request, pk):
        todo = self.get_object(pk)
        serializer = TodoSerializer(todo)
        return Response(serializer.data)
    #creating a put function to handle the put request
    def put(self, request, pk):
        todo = self.get_object(pk)
        serializer = TodoSerializer(todo, data= request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    #creating a delete function to handle the delete request
    def delete(self, request, pk):
        todo = self.get_object(pk)
        todo.delete()
        return Response(status= status.HTTP_204_NO_CONTENT)