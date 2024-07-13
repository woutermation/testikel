$projectName = "Test$(Get-Date -Format 'yyyyMMddHHmmss')"
$rootfolder = "$((Get-Location).Path)/$($projectName)"
dotnet new install MudBlazor.Templates
dotnet tool update --global dotnet-ef
winget install Microsoft.DotNet.SDK.8

# Step 2: Create a new solution

mkdir "$($projectName)/.vscode"
mkdir "$($projectName)/src"
mkdir "$($projectName)/tests"
Set-Location $($projectName)
dotnet new sln
dotnet new editorconfig
dotnet new globaljson
dotnet new gitignore

# Step 3: Create a new Web API project

# dotnet new webapi --use-local-db --use-controllers --name "$($projectName).Api" --output "src/$($projectName).Api"
# Set-Location "src/$($projectName).Api"
# dotnet add package Serilog.AspNetCore --version 8.*
# # dotnet add package Microsoft.AspNetCore.Authentication.JwtBearer
# dotnet add package Microsoft.Extensions.DependencyInjection
# Set-Location $rootfolder

# Step 4: Create a new MudBlazor project with authentication

# dotnet new mudblazor --auth Individual --interactivity Server --use-local-db --name "$($projectName).Client" --output "$($projectName).Client"
dotnet new mudblazor --interactivity Server --name "$($projectName).Client" --output "src/$($projectName).Client"

# Create a new class library project for the models / Domain

dotnet new classlib --name "$($projectName).Domain" --output "src/$($projectName).Domain"

# Create a new class library project for data access
dotnet new classlib --name "$($projectName).Infrastructure" --output "src/$($projectName).Infrastructure"
Set-Location "src/$($projectName).Infrastructure"
dotnet add package Microsoft.AspNetCore.Diagnostics.EntityFrameworkCore --version 8.*
dotnet add package Microsoft.AspNetCore.Identity.EntityFrameworkCore --version 8.*
dotnet add package Microsoft.EntityFrameworkCore.Sqlite --version 8.*
dotnet add package Microsoft.EntityFrameworkCore.Tools --version 8.*
Set-Location $rootfolder
# Add the projects to the solution
Get-ChildItem -Path "$($rootfolder)"-Filter "*.csproj" -Recurse | ForEach-Object { dotnet sln add $_.FullName }

# Add the necessary references for the models project

dotnet add "src\$($projectName).Infrastructure\$($projectName).Infrastructure.csproj" reference "src\$($projectName).Domain\$($projectName).Domain.csproj"
# dotnet add "src\$($projectName).Api\$($projectName).Api.csproj" reference "src\$($projectName).Infrastructure\$($projectName).Infrastructure.csproj"
dotnet add "src\$($projectName).Client\$($projectName).Client.csproj" reference "src\$($projectName).Infrastructure\$($projectName).Infrastructure.csproj"

# Build the solution
Get-ChildItem -Path "$($rootfolder)"-Filter "Class1.cs" -Recurse | Remove-Item
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



# Create a shared folder in the root of the solution
# $sharedConfigDir = "SharedConfig"
# if (-not (Test-Path $sharedConfigDir)) {
#   New-Item -ItemType Directory -Path $sharedConfigDir
# }
# Move-Item "$($projectName).Client\appsettings*.json" $sharedConfigDir
# Remove-Item "$($projectName).Api\appsettings.*.json" -Force
# dotnet add "$($sharedConfigDir)\appsettings.json" reference "$($sharedConfigDir)\appsettings.json"

# # Define paths
# $projectPath = "C:\Projects\TestSolution\Test.Api\Test.Api.csproj"
# $sharedConfigPath = "..\SharedConfig\appsettings.json" # Relative path from the project to the shared config

# # Define the XML to add
# $xmlContentToAdd = @"
# <ItemGroup>
#   <Content Include="$sharedConfigPath">
#     <Link>appsettings.json</Link>
#     <CopyToOutputDirectory>PreserveNewest</CopyToOutputDirectory>
#   </Content>
# </ItemGroup>
# "@

# # Load the project file as XML
# [xml]$csproj = Get-Content $projectPath

# # Check if the appsettings.json link already exists to avoid duplicates
# $existingNode = $csproj.Project.ItemGroup.Content | Where-Object { $_.Include -eq $sharedConfigPath }
# if ($existingNode -eq $null) {
#     # Create a new XML element from the string
#     $newNode = $csproj.CreateElement("ItemGroup", $csproj.Project.NamespaceURI)
#     $newNode.InnerXml = $xmlContentToAdd

#     # Append the new node to the project file
#     $csproj.Project.AppendChild($newNode)

#     # Save the modified project file
#     $csproj.Save($projectPath)
#     Write-Host "appsettings.json linked successfully."
# } else {
#     Write-Host "appsettings.json link already exists."
# }