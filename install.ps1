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

# Create a new class library project for data access
dotnet new classlib --name "$($projectName).Data" --output "$($projectName).Data"

# Add the projects to the solution

dotnet sln add .\$($projectName).Api\$($projectName).Api.csproj
dotnet sln add .\$($projectName).Client\$($projectName).Client.csproj
dotnet sln add .\$($projectName).Models\$($projectName).Models.csproj
dotnet sln add .\$($projectName).Data\$($projectName).Data.csproj

# Add the necessary references for the models project

dotnet add "$($projectName).Api\$($projectName).Api.csproj" reference "$($projectName).Models\$($projectName).Models.csproj"
dotnet add "$($projectName).Client\$($projectName).Client.csproj" reference "$($projectName).Models\$($projectName).Models.csproj"

# Create a shared folder in the root of the solution
$sharedConfigDir = "SharedConfig"
if (-not (Test-Path $sharedConfigDir)) {
  New-Item -ItemType Directory -Path $sharedConfigDir
}
Move-Item "$($projectName).Client\appsettings*.json" $sharedConfigDir
Remove-Item "$($projectName).Api\appsettings.*.json" -Force
dotnet add "$($sharedConfigDir)\appsettings.json" reference "$($sharedConfigDir)\appsettings.json"
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