function Convert-RGBToHex {
    #---------------------------------------------------------------[paramaters]
    param (
            [Parameter(
            Position = 0,
            Mandatory = $true
        )]
        [string]
        $RGB
        )
    
    #----------------------------------------------------------------[variables]
    $Red = ""
    $Green = ""
    $Blue = ""
    $HEX = ""

    #-------------------------------------------------------------[calculations]
    $Red, $Green, $Blue = $RGB.split(",")
    $Red = [System.Convert]::ToString($Red,16)
    $Green = [System.Convert]::ToString($Green,16)
    $Blue = [System.Convert]::ToString($Blue,16)
    $HEX =  $Red + $Green + $Blue
    
    return $HEX
}