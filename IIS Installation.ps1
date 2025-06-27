<powershell>
  # Install IIS
  Install-WindowsFeature -name Web-Server -IncludeManagementTools

  # Create a basic HTML file
  New-Item -Path C:\inetpub\wwwroot\index.html -ItemType File -Value "<h1>Welcome to my IIS website on EC2!</h1>" -Force

  # Start IIS
  Start-Service W3SVC
</powershell>