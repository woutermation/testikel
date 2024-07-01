# testikel  
  
## Step 1: Install the necessary templates
  
```powershell
$projectName = "Test"
dotnet new install MudBlazor.Templates

# Step 2: Create a new solution
  
mkdir "$($projectName)/.vscode"
cd $($projectName)
dotnet new sln
 
# Step 3: Create a new Web API project

dotnet new webapi --use-local-db --use-controllers --name "$($projectName).Api" --output "$($projectName).Api"
cd "$($projectName).Api"
dotnet add package Serilog.AspNetCore --version 8
cd ..
 
# Step 4: Create a new MudBlazor project with authentication

dotnet new mudblazor --auth Individual --interactivity Server --use-local-db --name "$($projectName).Client" --output "$($projectName).Client"

# Create a new class library project for the models

dotnet new classlib --name "$($projectName).Models" --output "$($projectName).Models"

# Add the projects to the solution

dotnet sln add .\$($projectName).Api\$($projectName).Api.csproj
dotnet sln add .\$($projectName).Client\$($projectName).Client.csproj
dotnet sln add .\$($projectName).Models\$($projectName).Models.csproj

# Add the necessary references for the models project

dotnet add $($projectName).Api\$($projectName).Api.csproj reference $($projectName).Models\$($projectName).Models.csproj
dotnet add $($projectName).Client\$($projectName).Client.csproj reference $($projectName).Models\$($projectName).Models.csproj

# Build the solution

dotnet new gitignore
dotnet build

# Step 7: Add the necessary extensions to the .vscode folder
@"
{
  "recommendations": [],
  "unwantedRecommendations": ["ms-dotnettools.csdevkit"]
}
"@ | Out-File -FilePath .vscode\extensions.json -Encoding utf8
@"
{
    "editor.renderWhitespace": "all"
}
"@ | Out-File -FilePath .vscode\settings.json -Encoding utf8

```  
  