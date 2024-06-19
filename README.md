# testikel  
  
## Step 1: Install the necessary templates

dotnet new --install Microsoft.AspNetCore.Blazor.Templates
dotnet new --install MudBlazor.Templates

## Step 2: Create a new solution

mkdir MyWebApp
cd MyWebApp
dotnet new sln

## Step 3: Create a new Web API project

mkdir MyWebApp.Api
cd MyWebApp.Api
dotnet new webapi --no-https
cd ..

## Step 4: Create a new MudBlazor project with authentication

mkdir MyWebApp.Client
cd MyWebApp.Client
dotnet new mudblazor --auth Individual
cd ..

## Step 5: Add the projects to the solution

dotnet sln add .\MyWebApp.Api\MyWebApp.Api.csproj
dotnet sln add .\MyWebApp.Client\MyWebApp.Client.csproj

## Step 6: Build the solution

dotnet build

dotnet new gitignore
