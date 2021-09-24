##from file name, get document number and state, place in CSV

clear
$PDFFiles = @(Get-ChildItem -Path '*.pdf' -Name)#list of all archives to work through
$outarray = @()
$codes = Import-Csv .\inputFile.csv #Our reference/ID file - this file tells us what each form is for

foreach ($fileName in $PDFFiles){
    $splitLine = $fileName.split(' ') #Split the filename into the following values:
        #$splitLine[0] = 'ACORD'
        #$splitLine[1] = Form Number
        #$splitLine[2] = Two letter State Code, eg. 'CA'
        #$splitLine[3] = A year range, eg. '2007-09'
        #$splitLine[4] = 'Acroform.pdf'
    
    <# Some forms do not contain a State Code. Here, we check the length of the
       $splitLine[2] element. If it does not contain only 2 elements, we know 
       it is missing a State Code, so we assign it an empty string as a State 
       Code
    #>
    if ($splitLine[2].Length -ne 2) {
        $splitLine = @($splitLine[0..1]) + @('  ') + @($splitLine[3..4])
    }
    
    <# Sometimes the form number in the file name will include non-digits, eg. 
       "ACORD 0050SET PA 2007-09 Acroform.pdf". Here we will check the file 
       Form Number and clean it up if needed.
    #>
    if ($splitline[1] -match '[\D{3}]'){ #check number formatting, as some enteries have 3 non-digits at the end eg. 0050SET
        $formNumber = $splitLine[1] #assign the Form Number to the variable
        <# For reasons I could not figure out, some forms will incorrectly 
           match the RegEx. To get around this, we can first Try to convert
           the 'number' to an integer, and if that fails we clean it up and 
           try again.
        #>
        try {
            $formNumber = [int]$formNumber
        }
        catch {
            $formNumber = $formNumber.Substring(0, $formNumber.Length-3) #because we know there are never more than 3 non-digits at the end of the Form Numer - we remove them here
            $formNumber = [int]$formNumber #finally, we convert the Form Number to an integer
        }
    }
    else {
        $formNumber = [int]$splitLine[1]
    }
   
    $formState = $splitline[2]
    $formNumberState = [string]$formNumber + ' ' + $formState
    
    <# There are two types of form code:
        - Number, generally a Country Wide form
        - Number + State Code. These are State specific, and take precedence 
          over the generic Country Wide forms
       Here we will check first for State specific forms, then generic Country 
       Wide forms. Descriptions will be set as appropriate.
       If a description is not set then something hasn't worked, and we return
       "Error: " and the $fileName for error checking. 
    #>
    if ($codes | where {$_.form -eq $formNumberState}){
        $Description = $codes | where {$_.form -eq $formNumberState}
        }
    elseif ($codes | where {$_.form -eq $formNumber}) {
        $Description = $codes | where {$_.form -eq $formNumber}
        }
    else { #For error checking, this will let us know if the Description has not been set.
        Write-Host "Error: " $fileName 
        }
    
    $formDescription = $Description.Name -replace '[\W]',' ' -join ',' #Strip all non-word characters, and join any seperate items - with a comma - to facilitate import to CSV
    
    $outarray += New-Object PsObject -property @{ #Add processed data to the output array
        'File Name' = $fileName
        'Description' = $formDescription
        'State' = $formState
        'Form Number' = $formNumber
        }
}

$outarray | Select-Object "Form Number", "State", "Description", "File Name" | Export-Csv output.csv -NoTypeInformation