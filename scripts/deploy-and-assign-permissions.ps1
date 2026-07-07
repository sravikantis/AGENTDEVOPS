$org = if ($args[0]) { $args[0] } else { 'ravikanti_s@hotmail.com' }
$permset = if ($args[1]) { $args[1] } else { 'Rice_Shopping_User' }

Write-Host "Deploying metadata to $org..."
& "C:\Program Files\sf\bin\sfdx.cmd" force:source:deploy -u $org -p force-app/main/default/permissionsets -w 30

Write-Host "Assigning permission set $permset to $org..."
& "C:\Program Files\sf\bin\sfdx.cmd" force:user:permset:assign -u $org -n $permset
