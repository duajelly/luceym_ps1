#wallpapwer changes block
New-Item -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Force
New-Item -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" -Force
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name Wallpaper -Value "C:\Windows\Web\Screen\img100.jpg" -PropertyType String -Force
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" -Name NoChangingWallPaper -Value 1 -PropertyType DWord -Force

#lockscreen changes block
New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Personalization" -Name LockScreenImage -Value "C:\Windows\Web\Screen\img100.jpg" -PropertyType String -Force

#themes window disable
New-Item -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Force
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name NoThemesTab -Value 1 -PropertyType DWord -Force
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name NoDispAppearancePage -Value 1 -PropertyType DWord -Force

#regedit access block
$Acl = Get-Acl "HKLM:\System\CurrentControlSet"
$AccessRule = New-Object System.Security.AccessControl.RegistryAccessRule("vsesib", "FullControl", "Deny")
$Acl.SetAccessRule($AccessRule)
Set-Acl "HKLM:\System\CurrentControlSet" $Acl

#gpedit.msc access block
$Acl = Get-Acl "C:\Windows\System32\GroupPolicy"
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("vsesib", "FullControl", "Deny")
$Acl.SetAccessRule($AccessRule)
Set-Acl "C:\Windows\System32\GroupPolicy" $Acl