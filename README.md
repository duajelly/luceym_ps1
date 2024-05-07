
# Блокировка изменений настроек персонализации для системы Windows 10;1

#### Помните, что для выполнения этих действий вам может потребоваться права администратора. Также убедитесь, что вы понимаете последствия ниже описанных действий.

Это руководство для тех, у кого есть необходимость оперативно произвести действия средствами Windows PowerShell, которые блокируют изменение обоев рабочего стола, изменение экрана блокировки, изменение тем, а также запрещают доступ к редактору реестра (regedit) и групповой политике (gpedit)


# Запрет на изменение обоев рабочего стола
#### Скрипт базовый

```powershell
New-Item -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" -Force
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" -Name NoChangingWallPaper -Value 1 -PropertyType DWord -Force
```

| Параметр | Тип     | Описание                |
| :-------- | :------- | :------------------------- |
| `NoChangingWallPaper` | `Boolean` | **Required**. 1 - запрещено изменение, 0 - разрешено изменение|


#### Дополнительнные параметры

Можно строго зафиксировать изображение рабочего стола, сделав запись в редакторе реестра. Вместо `C:\Windows\Web\Screen\img100.jpg` укажите желаемый путь.
О том, где хранятся базовые изображения Windows можно узнать в Интернете. 

```powershell
New-Item -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Force
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name Wallpaper -Value "C:\Windows\Web\Screen\img100.jpg" -PropertyType String -Force
```

| Параметр | Тип     | Описание                |
| :-------- | :------- | :------------------------- |
| `Wallpaper` | `String` | **Required**. Абсолютный путь к изображению|

# Фиксация изображения экрана блокировки

Можно строго зафиксировать изображение экрана блокировки, сделав запись в редакторе реестра. Вместо `C:\Windows\Web\Screen\img100.jpg` укажите желаемый путь.
О том, где хранятся базовые изображения Windows можно узнать в Интернете. 

#### Скрипт базовый

```powershell
New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Personalization" -Name LockScreenImage -Value "C:\Windows\Web\Screen\img100.jpg" -PropertyType String -Force
```

| Параметр | Тип     | Описание                |
| :-------- | :------- | :------------------------- |
| `LockScreenImage` | `String` | **Required**. Абсолютный путь к изображению|




# Запрет на изменение тем системы
#### Скрипт базовый

```powershell
New-Item -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Force
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name NoThemesTab -Value 1 -PropertyType DWord -Force
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name NoDispAppearancePage -Value 1 -PropertyType DWord -Force
```

| Параметр | Тип     | Описание                |
| :-------- | :------- | :------------------------- |
| `NoThemesTab ` | `Boolean` | **Required**. 1 - запрещено изменение, 0 - разрешено изменение|
| `NoDispAppearancePage  ` | `Boolean` | **Required**. 1 - запрещено изменение, 0 - разрешено изменение|




# Запрет доступа к regedit
Подробнее об используемом ниже методе можно узнать [тут](https://sergeyvasin.wordpress.com/2011/11/05/powershell-acls/)

#### Скрипт базовый


```powershell
$Acl = Get-Acl "C:\Windows\System32\GroupPolicy"
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("vsesib", "FullControl", "Deny")
$Acl.SetAccessRule($AccessRule)
Set-Acl "C:\Windows\System32\GroupPolicy" $Acl
```
Немного о параметрах, которые передаются в качестве аргументов для метода `FileSystemAccessRule()`

#### Первым параметром передается имя учетной записи на компьютере, к которой мы будем применять изменения 

| Параметр | Тип     | Описание                |
| :-------- | :------- | :------------------------- |
| Первый параметр | `String` | **Required**. Название учетной записи, к которой хоти применять изменения|

#### Вторым параметром передаются  тип прав доступа к файлу или ресурсу (str). 

| Права доступа | 	Битовая маска     | Название прав при создании объекта                |
| :-------- | :------- | :------------------------- |
|Full Control |	2032127 |	`FullControl` |
|Traverse folder / Execute File	| 32 |	`ExecuteFile`|
|List Folder / Read Data	|1	|`ReadData`|
|Read Attributes|	128|	`ReadAttributes`|
|Read Extended Attributes	|8	|`ReadExtendedAttributes`|
|Create Files / Write Data	|2	|`CreateFiles`|
|Create Folders / Append Data|	4	|`AppendData`|
|Write Attributes	|256|	`WriteAttributes`|
|Write Extended Attributes	|16	|`WriteExtendedAttributes`|
|Delete Subfolders and Files|	64	|`DeleteSubdirectoriesAndFiles`|
|Delete	|65536	|`Delete`|
|Read Permissions	|131072|	`ReadPermissions`|
|Change Permissions|	262144|	`ChangePermissions`|
|Take Ownership	|524288|	`TakeOwnership`|

#### Третьм параметром передаются значения длы параметра доступа, который был выбран выше. 

| Параметр | Тип     | Описание                |
| :-------- | :------- | :------------------------- |
| Третий параметр | `String` | **Required**. разрешаем / не разрешаем доступ|

| Значение параметра | Числовое значение     | 
| :-------- | :------- | 
|Allow|	0|
|Deny|	1|


## После выполнения скрипта и попытек запуска regedit у вас должно появиться следующее

![App Screenshot](https://via.placeholder.com/468x300?text=App+Screenshot+Here)

```powershell
$Acl = Get-Acl "HKLM:\System\CurrentControlSet"
$AccessRule = New-Object System.Security.AccessControl.RegistryAccessRule("vsesib", "FullControl", "Deny")
$Acl.SetAccessRule($AccessRule)
Set-Acl "HKLM:\System\CurrentControlSet" $Acl
```