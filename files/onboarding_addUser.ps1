$firstname = 'dummy'
$lastname = 'detail'
$Dbhost = '10.2.0.6'
$Port = '27017'
$Dbname = 'dummmydb'
$workspace = 'C:\agent\_work\4\s'
$username = $firstname +'.'+$lastname
$email_id = $firstname +'.'+$lastname+'@teamnumbertheory.onmicrosoft.com'
$projectName = $firstname +'_'+$lastname +'_Project'

$containerName = $firstname + $lastname+'container'


$targetPath = 'C:\tempMongoJson'
$dbdataPath = 'C:\dbdata\' 

$CustomerConfigURL = $workspace + '\files\master_config.txt'

$StorageAccSceret = "OCS-"+$StorageAccName+"-SAS"
$apiUrlSecret = "OCS-api-url"
#####
$username = "86076dbf-debc-44ba-b4f5-c90686150665" 
$password = "nh08Q~qnTpwwFOkQMp1klMK_dFHUVwVTWmF1pbtS" 

$SecureStringPwd = $password | ConvertTo-SecureString -AsPlainText -Force

$Creds = New-Object System.Management.Automation.PSCredential ($username, $SecureStringPwd)

Connect-Azaccount -ServicePrincipal -Credential $Creds -TenantId "00bb5983-b28f-4542-a099-20eaf8bbb209"


foreach($line in [System.IO.File]::ReadLines($CustomerConfigURL) | Where {$_ -notmatch '^#.*'}) { 
    
    $SourceFilePath = ($workspace+ "\files\master\" + $line)
    Write-Host $SourceFilePath
    
    
    $FileName = $line -replace '.json',''
    $Renamescpath = $SourceFilePath
    $txt_fileName = $FileName +".txt"
    $txt_Renamedespath = $targetPath +"\"+ $txt_fileName


    Write-Host $Renamescpath
    Write-Host $txt_fileName
    Write-Host $txt_Renamedespath
 
    #Rename json file ##
    Copy-Item $Renamescpath -Destination $txt_Renamedespath

    (Get-Content -path $txt_Renamedespath -Raw) -replace 'Project__Name',$projectName | Set-Content -Path $txt_Renamedespath
    (Get-Content -path $txt_Renamedespath -Raw) -replace 'Email__id',$email_id | Set-Content -Path $txt_Renamedespath
    (Get-Content -path $txt_Renamedespath -Raw) -replace 'User__name',$username | Set-Content -Path $txt_Renamedespath
    (Get-Content -path $txt_Renamedespath -Raw) -replace 'Container__name',$containerName | Set-Content -Path $txt_Renamedespath
    #(Get-Content -path $txt_Renamedespath -Raw) -replace 'Container__SAS',$sasRepose | Set-Content -Path $txt_Renamedespath
    #(Get-Content -path $txt_Renamedespath -Raw) -replace 'Storage__SAS',$StorageSAS | Set-Content -Path $txt_Renamedespath
    (Get-Content -path $txt_Renamedespath -Raw) -replace 'Tenant__ID',$TenantId | Set-Content -Path $txt_Renamedespath
    (Get-Content -path $txt_Renamedespath -Raw) -replace 'Storage__Account',$StorageAccName | Set-Content -Path $txt_Renamedespath


    ##change extension of the copied file of master file############
    $JsonFileName = $FileName +".Json"
    $finalpath = $targetPath +"\" + $JsonFileName 

    Copy-Item $txt_Renamedespath -Destination $finalpath

    Remove-Item $txt_Renamedespath

    $collection = $FileName
    $ErrorActionPreference = 'SilentlyContinue'

    if($FileName -ne 'input'){
        mongoimport --host $Dbhost --port $Port --db $Dbname --collection $collection --file $finalpath
    }
    
}

$inputPath = $targetPath +"\input.json"
$DbhostwithPort = $Dbhost+':'+$Port

mongoexport --host $DbhostwithPort -d $Dbname -c app_project  -o C:\dbdata\app_project.json --queryFile $inputPath

$dataFileName = 'app_project.json'
$Onboard_JsonURL = $dbdataPath + $dataFileName
if (Test-Path $Onboard_JsonURL) {
	Write-Host "File Path to Config - $Onboard_JsonURL"
	Write-Host
}
else {
	Write-Error -Message "Config File Not Found" -ErrorAction Stop
}

$JsonContent = (Get-Content $Onboard_JsonURL | Out-String | ConvertFrom-Json)
$Project = $JsonContent.'_id'
$Porject_id = $Project.'$oid'

Write-host Porject id = $Porject_id

$CustomerConfigURL = $workspace + '\files\pipeline.txt'
Write-Host ---------------------------------------------------pipeline--------------------------------------------------------
foreach($line in [System.IO.File]::ReadLines($CustomerConfigURL) | Where {$_ -notmatch '^#.*'}) { 
    
        $SourceFilePath = ($workspace+ "\files\pipeline\" + $line)
        $FileName = $line -replace '.json',''
		$inRenamescpath = $workspace + '\files\pipeline\input_pipeline.json'
		$intxt_Renamedespath = $targetPath + '\input_'+$FileName+".txt"
        $Algo = $FileName
		
		Copy-Item $inRenamescpath -Destination $intxt_Renamedespath

		(Get-Content -path $intxt_Renamedespath -Raw) -replace 'Algo__name',$Algo | Set-Content -Path $intxt_Renamedespath
		(Get-Content -path $intxt_Renamedespath -Raw) -replace 'Project__id',$Porject_id | Set-Content -Path $intxt_Renamedespath
		(Get-Content -path $intxt_Renamedespath -Raw) -replace 'Project__Name',$projectName | Set-Content -Path $intxt_Renamedespath
    
		##change extension of the copied file of pipeline file############
		$inJsonFileName = 'input_'+$FileName+".json"
		$infinalpath = $targetPath +"\" + $inJsonFileName
		Copy-Item $intxt_Renamedespath -Destination $infinalpath
		Remove-Item $intxt_Renamedespath

        Write-Host $SourceFilePath
    
    
        $FileName = $line -replace '.json',''
        $Algo = $FileName
        $Renamescpath = $SourceFilePath
        $txt_fileName = $FileName +".txt"
        $txt_Renamedespath = $targetPath +"\pipeline\"+ $txt_fileName


        Write-Host $Renamescpath
        Write-Host $txt_fileName
        Write-Host $txt_Renamedespath
        Write-Host $Algo
 
        #Rename json file ##
        Copy-Item $Renamescpath -Destination $txt_Renamedespath

        (Get-Content -path $txt_Renamedespath -Raw) -replace 'Algo__name',$Algo | Set-Content -Path $txt_Renamedespath
        (Get-Content -path $txt_Renamedespath -Raw) -replace 'Project__id',$Porject_id | Set-Content -Path $txt_Renamedespath
        (Get-Content -path $txt_Renamedespath -Raw) -replace 'Project__Name',$projectName | Set-Content -Path $txt_Renamedespath
        (Get-Content -path $txt_Renamedespath -Raw) -replace 'Email__id',$email_id | Set-Content -Path $txt_Renamedespath
        (Get-Content -path $txt_Renamedespath -Raw) -replace 'User__name',$username | Set-Content -Path $txt_Renamedespath
        (Get-Content -path $txt_Renamedespath -Raw) -replace 'Container__name',$containerName | Set-Content -Path $txt_Renamedespath
    


        ##change extension of the copied file of pipeline file############
        $JsonFileName = $FileName +".Json"
        $finalpath = $targetPath +"\pipeline\" + $JsonFileName 

        Copy-Item $txt_Renamedespath -Destination $finalpath

        Remove-Item $txt_Renamedespath
		
		$collection = 'naidomain'
        $ErrorActionPreference = 'SilentlyContinue'

        mongoimport --host $Dbhost --port $Port --db $Dbname --collection $collection --file $finalpath

        $inputfilePath = $infinalpath
        $DbhostwithPort = $Dbhost+':'+$Port
        $output = $dbdataPath + $line

        mongoexport --host $DbhostwithPort -d $Dbname -c $collection  -o $output --queryFile $inputfilePath

        $dataFileName = $line
        $Onboard_JsonURL = $output
        if (Test-Path $Onboard_JsonURL) {
	        Write-Host "File Path to Config - $Onboard_JsonURL"
	        Write-Host
        }
        else {
	        Write-Error -Message "Config File Not Found" -ErrorAction Stop
        }

        $JsonContent = (Get-Content $Onboard_JsonURL | Out-String | ConvertFrom-Json)
        $pipeline = $JsonContent.'_id'
        $pipeline_id = $pipeline.'$oid'

        Write-host $FileName pipeline Ref id is $pipeline_id 

        $SourceFilePath = ($workspace+ "\files\pipeline_version\" + $line)
        Write-Host $SourceFilePath
    
    
        $FileName = $line -replace '.json',''
        $Renamescpath = $SourceFilePath
        $txt_fileName = $FileName +".txt"
        $txt_Renamedespath = $targetPath +"\pipeline_version\"+ $txt_fileName


        Write-Host $Renamescpath
        Write-Host $txt_fileName
        Write-Host $txt_Renamedespath
 
        #Rename json file ##
        Copy-Item $Renamescpath -Destination $txt_Renamedespath

        (Get-Content -path $txt_Renamedespath -Raw) -replace 'Project__id',$Porject_id | Set-Content -Path $txt_Renamedespath
        (Get-Content -path $txt_Renamedespath -Raw) -replace 'Project__Name',$projectName | Set-Content -Path $txt_Renamedespath
        (Get-Content -path $txt_Renamedespath -Raw) -replace 'Email__id',$email_id | Set-Content -Path $txt_Renamedespath
        (Get-Content -path $txt_Renamedespath -Raw) -replace 'Ref__id',$pipeline_id | Set-Content -Path $txt_Renamedespath
        (Get-Content -path $txt_Renamedespath -Raw) -replace 'Container__name',$containerName | Set-Content -Path $txt_Renamedespath


        ##change extension of the copied file of pipeline file############
        $JsonFileName = $FileName +".Json"
        $finalpath = $targetPath +"\pipeline_version\" + $JsonFileName 

        Copy-Item $txt_Renamedespath -Destination $finalpath

        Remove-Item $txt_Renamedespath

        $collection = 'naidomain_version'
        $ErrorActionPreference = 'SilentlyContinue'
        mongoimport --host $Dbhost --port $Port --db $Dbname --collection $collection --file $finalpath



    	
    #Remove-Item $finalpath
}


	# Get-Content -Path .\master\app_project.json
        $raw = Get-Content -Path C:\agent\_work\4\s\files\master\app_project.json 
	Write-Host "The vale of app_project.json $raw"
	
	$straw = Get-Content -Path C:\dbdata\app_project.json
	Write-Host "The vale of mongo app_project.json $straw"
	
