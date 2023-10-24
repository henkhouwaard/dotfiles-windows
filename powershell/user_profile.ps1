# source this file in your profile $PROFILE, 
# for instance: . ~\source\repos\dotfiles-windows\powershell\user_profile.ps1
# Aliases
Set-Alias guidgen uuidgen
Set-Alias paste Get-Clipboard
Set-Alias clip Set-Clipboard
Set-Alias vi nvim
Set-Alias vim nvim
Set-Alias k kubectl

$storageconnectionstring = "DefaultEndpointsProtocol=http;AccountName=devstoreaccount1;AccountKey=Eby8vdM02xNOcqFlqUwJPLlmEtlCDXJ1OUzFT50uSRZ6IFsuFq2UVErCz4I6tq/K1SZFPTOtr/KBHBeksoGMGw==;BlobEndpoint=http://127.0.0.1:10000/devstoreaccount1;QueueEndpoint=http://127.0.0.1:10001/devstoreaccount1;TableEndpoint=http://127.0.0.1:10002/devstoreaccount1;"
$env:azuritecs = $storageconnectionstring
$homeFolder = [environment]::GetFolderPath("UserProfile")
$documentsFolder = [environment]::GetFolderPath("MyDocuments")
$sourceRoot = "$($homeFolder)/source"
$repoRoot = "$($sourceRoot)/repos"
$scriptsRoot = "$($repoRoot)/scripts"
$localScriptsRoot = "$($documentsFolder)/scripts"
$gitBinRoot = "C:\Program Files\Git\usr\bin"
$Env:RepoRoot = $repoRoot

if (Test-Path -Path $gitBinRoot) {
    Write-Host "Add Git bin tools"
    $env:path += ";$gitBinRoot"
}

if (Test-Path -Path "$env:USERPROFILE/.azure-kubelogin") {
    Write-Host "Add kubelogin"
    $env:path += ";$env:USERPROFILE/.azure-kubelogin;"
}

if (Test-Path -Path $localScriptsRoot) {
    #
    # Weird place for temporary/company specific scripts, but most of the time 
    # this folder is sync'ed/backed up in enterprise environments so it does 
    # not (or can't) go into a git repo
    #
    Write-Host "Add local scripts"
    $env:path += ";$($localScriptsRoot);"
}

if (Test-Path -Path $scriptsRoot) {
    Write-Host "Adding scripts"
    $env:path += ";$($scriptsRoot)"
}

if (Test-Path -Path "$($homeFolder)/.nuget/plugins/netcore/CredentialProvider.Microsoft") {
    Write-Host ".NET Credential Provider"
}
else {
    Write-Host "Missing .NET Credential Provider"
    Write-Host "Check https://github.com/Microsoft/artifacts-credprovider"
}

$env:ROBECO_PYTHON_LIB_PATH = "C:\Program Files\Python38\python38.dll"
$env:ROBECO_ALGORITHM_ROOT_PATH = "C:\Users\ROB5347\pyenv"

# Prompt
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/tokyonight_storm.omp.json" | Invoke-Expression
oh-my-posh --init --shell pwsh --config "" | Invoke-Expression

# PSReadline Config
# (Snippets from https://gist.github.com/shanselman/25f5550ad186189e0e68916c6d7f44c3)
if ($host.Name -eq 'ConsoleHost') {
    Import-Module PSReadLine
}

Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineOption -BellStyle None
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows

# Utility Modules
Import-Module -Name DockerCompletion

# Utility functions
function tile() {
    get-process komo* | stop-process
    komorebic start -c $Env:USERPROFILE\komorebi.json --whkd
}
function touch() {
    New-Item -ItemType File -Name $args[0]
}

function which() {
    $command = (Get-Command $args[0] -ErrorAction SilentlyContinue)
    if ($null -eq $command) {
        Write-Host "Could not find $($args[0])"
        return
    }

    $command.Path
}

function printvars() {
    Get-ChildItem env:* | sort-object name
}

function repos() {
    Set-Location $Env:RepoRoot
    Get-ChildItem
}

function editHistory() {
    code (Get-PSReadlineOption).HistorySavePath
}

function uuidgen() {
    param (
        [Parameter()] [int] $count = 1
    )

    for ($i = 0; $i -lt $count; $i++) {
        [guid]::NewGuid().Guid
    }
}

# Fonts
# Caskaydia Cove Nerd Font from https://www.nerdfonts.com/font-downloads
# curl -L -o font.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/CascadiaCode.zip

# Terminal Font & Color
#
# "profiles": 
# {
#     "defaults": 
#     {
#         "background": "#132738",
#         "cursorHeight": 4,
#         "cursorShape": "vintage",
#         "font": 
#         {
#             "face": "CaskaydiaCove NF"
#         }
#     }

# Powershell Modules to install
#
# Install-Module -Name Terminal-Icons -Repository PSGallery
# Install-Module -Name DockerCompletion -Scope CurrentUser
# Install-Module PSReadLine -AllowPrerelease -Force
# Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force
# Install-Module -Name powershell-yaml -Force
# Install-Module -Name MSAL.PS
# Install-Module Pscx -Scope CurrentUser

# NPM stuff
# npm install azure-functions-core-tools -g

# Az extensions/Other commandline stuff
# az aks install-cli
# az extension add --name azure-devops

# Other stuff to install
#
# winget install -e --id=jqlang.jq
# winget install -e --id Git.Git
# winget install -e --id JanDeDobbeleer.OhMyPosh
# winget install -e --id Microsoft.AzureCLI
# winget install -e --id OpenJS.NodeJS.LTS
# winget install -e --id Microsoft.VisualStudioCode
# winget install -e --id Microsoft.VisualStudio.2022.Enterprise
# winget install -e --id Microsoft.VisualStudio.2022.Professional
# winget install -e --id Pulumi.Pulumi
# winget install -e --id Mirantis.Lens
# winget install -e --id Yarn.Yarn
# winget install -e --id Docker.DockerDesktop
# winget install -e --id Microsoft.AzureStorageExplorer
# winget install -e --id Microsoft.SQLServerManagementStudio
# winget install -e --id Insomnia.Insomnia
# winget install -e --id Neovim.Neovim

# VSCode Extensions
# code --install-extension ms-vscode.hexeditor
# code --install-extension esbenp.prettier-vscode
# code --install-extension ms-vscode.powershell
# code --install-extension octref.vetur
# code --install-extension hediet.vscode-drawio
# code --install-extension ms-azuretools.vscode-docker
# code --install-extension ms-azuretools.vscode-bicep
# code --install-extension redhat.vscode-yaml
# code --install-extension sdras.night-owl
# code --install-extension johnsoncodehk.volar
# code --install-extension WallabyJs.quokka-vscode

# Add Az Devops Artifact feed
# - Generate a PAT
# - Run:
#   dotnet nuget update source [SOURCENAME] --source [FEEDURL] --username [EMAIL_USERNAME] --password [PAT]

# Add Az Devops defaults
# az devops configure --defaults "organization=https://dev.azure.com/something" "project=SomeProject"
# az devops login

# Git Config
# - Automatically set the upstream:
#   git config --global push.default current
# - Commit info
#   git config --global user.name "Your Name"
#   git config --global user.email you@example.com
# - Set default branch name
#   git config --global init.defaultBranch main

# Set Azure Subscription
# - az login
# - set-devaccount.ps1 [ACCOUNTNAME] (run without account name to see which ones are available)
