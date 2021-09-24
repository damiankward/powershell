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
$allLower = (97..122) #All lower-case letters
$numberRange = (48..57) #0-9
$allCharactersAndSymbols = (33..126) #All letters, numbers and symbols

#Word list import
$wordList = Get-Content ~\Documents\powershell\LongWords.txt

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
    
        $simpleLetters = ""
        1..$Letters | ForEach { 
            $code = $allLower | Get-Random 
            $simpleLetters = $simpleLetters + [char]$code
        } 
        return $simpleLetters
             
    }

    function Join-Numbers { 
        #Because get-random -Minimum 1000 -Maximum 9999 was too hard?
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
            $code = $numberRange | Get-Random 
            $simpleNumbers = $simpleNumbers + [char]$code
        } 
        return $simpleNumbers
    }

    #-------------------------------------------------------------[Calculations]
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
            $code = $allCharactersAndSymbols | Get-Random 
            $complexPassword = $complexPassword + [char]$code
        } 
        return $complexPassword
        break
    }

    # If no parameter given, generate one password of wach variant
    $complexityLevel1 = Get-NewPassword -Simple
    $complexityLevel2 = Get-NewPassword -Memorable
    $complexityLevel3 = Get-NewPassword -Complex

    Write-Host "   Simple:" $complexityLevel1
    Write-Host "Memorable:" $complexityLevel2
    Write-Host "  Complex:" $complexityLevel3
    
}  
