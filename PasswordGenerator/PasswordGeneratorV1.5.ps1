#requires -version 2
<#
.SYNOPSIS
   A PowerShell password generator, to generate short, long, complex, and/or
  memorable passwords.
.DESCRIPTION
  Project to create a password generator that will generate the following:
    - completely random, of given length and character set (letters and/or 
      numbers and/or symbols)
    - word based, given word count, separator, cAsInG min/max word length
    - 'leet' memorable - c0mB1n@t!0n_0f-aBOv3
.PARAMETER <Parameter_Name>
    <Brief description of parameter input required. Repeat this attribute if 
   required>
.INPUTS
  <Inputs if any, otherwise state None>
.OUTPUTS
  System.String
.NOTES
  Version:        0.1
  Author:         DKWard
  Creation Date:  02.09.2021
  Purpose/Change: Initial script development

  Random dictionary? Place random letters in an unordered dictionary?
  Copy to clipboard?
  
.EXAMPLE
  Get-Password

  Returns a newly created password.
#>

#--------------------------------------------------------------------[Variables]
#Set Password Length, between 16 and 32 characters
#$RandomPasswordLength = Get-Random -Minimum 16 -Maximum 32

#Write-Host $PasswordLength

#Define character sets
#$allUpper = (65..90) #All upper-case letters
$allLower = (97..122) #All lower-case letters
$numberRange = (48..57) #0-9
#$symbols = (33..47) + (58..64) + (91..96) + (123..126) #All symbols
$allCharactersAndSymbols = (33..126) #$allUpper + $allLower + $numbers + $symbols #All

#Word list import
$wordList = Get-Content ~\Documents\powershell\LongWords.txt

#$separator = "-"
#Password complexity
#$complexity = $allCharactersAndSymbols #set by user?
#$random3000 = Get-Random -Maximum 2999

#Script Version
#$ScriptVersion = "0.1"

#--------------------------------------------------------------------[Functions]
function Get-NewPassword {    
    param (
        [Parameter(
            Position = 0,
            Mandatory = $false
        )]
        [switch]
        $Simple,        
        
        [Parameter(
            Position = 0,
            Mandatory = $false
        )]
        [switch]
        $Memorable,        
        
        [Parameter(
            Position = 0,
            Mandatory = $false
        )]
        [switch]
        $Complex,

        [Parameter(
            Position = 1,
            Mandatory = $false
        )]
        [int]
        $Length,

        [Parameter(
            Position = 2,
            Mandatory = $false
        )]
        [int]
        $Words,

        [Parameter(
            Position = 3,
            Mandatory = $false
        )]
        [string]
        $Separator,

        [Parameter(
            Position = 4,
            Mandatory = $false
        )]
        [int]
        $Letters,
        
        [Parameter(
            Position = 5,
            Mandatory = $false
        )]
        [int]
        $Numbers 
    )

    $defaultSimpleLetterCount = 5
    $defaultSimpleNumberCount = 3
    $defaultMemorableWords = 3
    $defaultComplexPasswordLength = 16

    function Join-Letters {
        [CmdletBinding()]
        param (
            [Parameter(
            Position = 0,
            Mandatory = $false
        )]
        [int]
        $Letters
        )
    
        #return -join ($allLower | Get-Random -Count $Letters | ForEach-Object {[char]$_})  
        $simpleLetters = ""
        1..$Letters | ForEach { 
            $code = $allLower | Get-Random #-Minimum 97 -Maximum 122
            $simpleLetters = $simpleLetters + [char]$code
        } 
        return $simpleLetters
             
    }

    function Join-Numbers {
        [CmdletBinding()]
        param (
            [Parameter(
            Position = 0,
            Mandatory = $false
        )]
        [int]
        $Numbers
        )
        $simpleNumbers = ""
        1..$Numbers | ForEach { 
            $code = $numberRange | Get-Random #-Minimum 48 -Maximum 57
            $simpleNumbers = $simpleNumbers + [char]$code
        } 
        return $simpleNumbers
    }

    if ($Simple){        
        if ($Letters){
            $simpleLetters = Join-Letters -Letters $Letters
        } else {
            $simpleLetters = Join-Letters -Letters $defaultSimpleLetterCount
        } 
        if ($Numbers){
            $simpleNumbers = Join-Numbers -Numbers $Numbers
        } else {
            $simpleNumbers = Join-Numbers -Numbers $defaultSimpleNumberCount
        }
        return $simpleLetters + $simpleNumbers
        break
    }

    if ($Memorable){
        $memorablePassword = ""
        if (!$Separator){$Separator = "-"}
        if (!$words){$words = $defaultMemorableWords}
        foreach ($word in (1..$words)){
            $memorableWord = $wordList[(Get-Random -Maximum $wordList.Length)]
            $memorablePassword += $memorableWord
            if ($word -lt $words){$memorablePassword += $Separator}
        }
        return $memorablePassword
        break
    }

    if ($Complex){
        $complexPassword = ""
        if (!$Length){ $Length = $defaultComplexPasswordLength }
        1..$Length| ForEach { 
            $code = $allCharactersAndSymbols | Get-Random # -Minimum 33 -Maximum 126
            $complexPassword = $complexPassword + [char]$code
        } 
        return $complexPassword
        break
    }

    $complexityLevel1 = Get-NewPassword -Simple
    $complexityLevel2 = Get-NewPassword -Memorable
    $complexityLevel3 = Get-NewPassword -Complex

    Write-Host "   Simple:" $complexityLevel1
    Write-Host "Memorable:" $complexityLevel2
    Write-Host "  Complex:" $complexityLevel3
    
}  

<#
function Join-Letters {
    [CmdletBinding()]
    param (
        [Parameter(
        Position = 0,
        Mandatory = $false
    )]
    [int]
    $Letters
    )

    #return -join ($allLower | Get-Random -Count $Letters | ForEach-Object {[char]$_})  
    $simpleLetters = ""
    1..$Letters | ForEach { 
        $code = Get-Random -Minimum 97 -Maximum 122
        $simpleLetters = $simpleLetters + [char]$code
    } 
    return $simpleLetters
         
}
#>

<#
function Get-SimplePassword {
    [CmdletBinding()]
    param (
    )
    Write-Verbose -Message "Generating simple password."
    $simpleLetters = -join ($allLower | Get-Random -Count 5 | % {[char]$_})
    $simpleNumbers = -join ($numberRange | Get-Random -Count 3 | % {[char]$_})
    return $simpleLetters + $simpleNumbers
}

function Get-MemorablePassword {
    param (
        #word list?
        #word length?
        #word count?
    )
    
    return ($wordList[(Get-Random -Maximum 2999)] + $separator + $wordList[(Get-Random -Maximum 2999)] + $separator + $wordList[(Get-Random -Maximum 2999)])
}



function Get-ComplexPassword {
    param (
        #OptionalParameters
    )
    if (!$PasswordLength){ 
        $PasswordLength = 1000
        Write-Host "PasswordLength = " $PasswordLength
    }
    return -join ($allCharactersAndSymbols | Get-Random -Count 1000 | % {[char]$_})
}
#>

#--------------------------------------------------------------------[Execution]
#Clear-Host
$complexityLevel1 = Get-NewPassword -Simple
$complexityLevel2 = Get-NewPassword -Memorable
$complexityLevel3 = Get-NewPassword -Complex

Write-Host "   Simple:" $complexityLevel1
Write-Host "Memorable:" $complexityLevel2
Write-Host "  Complex:" $complexityLevel3

<#
$longwords = @()
foreach ($word in $wordList) {
    if ($word.length -gt 4){
        $longwords += $word
    }
}
#>
