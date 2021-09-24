##get list of zip files
    ##extract first file, navigate to folder
    ##get list of eForm zips
        ##extract first eForm
        ##nav to folder and subfolder
        ##find acroform (*Acroform.pdf), move to c:\temp\Acord\eForms
clear

$PSScriptRoot = Get-Location #set our scripts 'Home' location
New-Item -Path $PSScriptRoot -Name 'Output' -ItemType "directory" #create a folder to put our files in

$StateFormArchives = @(Get-ChildItem -Path '*.zip' -Name)#list of all archives to work through

Foreach ($currentArchive in $StateFormArchives){
    Expand-Archive $currentArchive ## extract the archive
    $separator = '.zip'
    $option = [System.StringSplitOptions]::RemoveEmptyEntries
    $currentArchive = $currentArchive.Split($separator,$option) #this will clean up our variable so we can navigate to the newly created folder
    Set-Location .\$currentArchive #Go into the archive we just extracted
    $eFormArchives = @(Get-ChildItem -Path '*EForms.zip' -Name) #create a list of all the archives we need to iterate over
    
    Foreach ($currentEFormArchive in $eFormArchives){
        Expand-Archive $currentEFormArchive #Extract the current file
        $currentEFormArchive = $currentEFormArchive.Split($separator,$option) #this will clean up our variable so we can navigate to the newly created folder
        Set-Location .\$currentEFormArchive #Go into the archive we just extracted
        $eFormSubDirectory = @(Get-ChildItem -Name) #Sometimes there is a sub directory, this will find it and associate it to a var
        Copy-Item -Path *Acroform.pdf -Destination $PSScriptRoot\Output #copy the form to the \Output folder
        if (Test-Path -path .\$eFormSubDirectory){
            Set-Location .\$eFormSubDirectory
            Copy-Item -Path *Acroform.pdf -Destination $PSScriptRoot\Output #copy the form to the \Output folder
            }
        Set-Location $PSScriptRoot\$currentArchive #return to the CurrentArchive folder to continue with the eForm archives
        }
            
    Set-Location $PSScriptRoot
}