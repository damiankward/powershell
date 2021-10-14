<# 
Super important note: this was created for NIGHT SHIFT. Shifts started at 10pm, and finished at 6am. We do a lot of work
with dates and time, and the midnight crossover can make things difficult to follow.

This script is designed to be run at the end of shift.
Todays time shift is dated for the start of the shift - so when the script is run, it is technically dated for 
"yesterday."
#>

# ------------------------------------------------------[Intended functionality]
# email hours to Donald
# copy template for tomorrow
# if Friday (Saturday), create new folder and copy template

#------------------------------------------------------------------[For testing]
# 1) Send email with attachment to self
#   - this will be changed to email Donald
# 2) Create new folder, copy and rename template
#   - make this only happen on Friday (today for testing)
# 3) If not Friday, copy and rename template

#---------------------------------------------------------------[Import Modules]
# Requires non-standard module ImportExcel. Get it with: Install-Module ImportExcel -Scope CurrentUser
Import-Module ImportExcel

#------------------------------------------------------------------------------------------------------------[Variables]
#----------------------------------------------------------------------[General]
#-[Dates]
# Get today's date. This will create tonight's timesheet, and to check what day it is. We need as a datetime and string.
$today                          = Get-Date        
$todayString                    = (Get-Date -Format yyyy-MM-dd).ToString()
# Get Monday's date. This is used for folder creation, and file copying. As datetime and string.
$monday                         = (Get-Date).AddDays((-1 * (Get-Date).DayOfWeek.Value__) + 1).Date
$mondayString                   = $monday.ToString("yyyy-MM-dd")
$nextMondayString               = ($monday.AddDays(7)).ToString("yyyy-MM-dd") 
# Get yesterday's date. Used for email subject, and today's time sheet.
$yesterday                      = (get-date).AddDays(-1).ToString("yyyy-MM-dd")
#-[Paths]
# Get the path of today's time sheet.
$attachment                     = (Resolve-Path ('.\'+ $mondayString + '\' + $yesterday + '.xlsm')).ToString()
$newTimesheet                   = $todayString + '.xlsm'
$template                       = 'dwTemplate.xlsm'
$newTimesheetPath               = ''

#----------------------------------------------------------------[Compose Email]
$toEmail                        = "Donald.Chan@cote.com.au"
$emailSubject                   = "Hours reporting - " + $yesterday
$emailBody                      = @"
    Hi Donald,

    Please find attached todays reporting.

    Regards,
    Damian
"@
#-------------------------------------------------------------------[Send Email]
$Outlook                        = New-Object -ComObject Outlook.Application
$Mail                           = $Outlook.CreateItem(0)
$Mail.To                        = $toEmail 
$Mail.Subject                   = $emailSubject
$Mail.Body                      = $emailBody
$Mail.Attachments.Add($attachment)
$Mail.Send()

#---------------------------------------------------[Create Tomorrows Timesheet]
# if Friday, create folder and copy/rename file
# else, copy file

if ($today.DayOfWeek.value__ -eq 6) { #6 is for Saturday, because Saturday is Friday. Fight me.
    New-Item -Path . -Name $nextMondayString -ItemType Directory
    $newTimesheet               = $nextMondayString + '.xlsm' #Correct timesheet name for *next* week
    Copy-Item .\$template -Destination .\$nextMondayString\$newTimesheet
    $newTimesheetPath           = (Resolve-Path ('.\'+ $nextMondayString + '\' + $newTimesheet)).ToString()
}
else {
    Copy-Item .\$template -Destination .\$mondayString\$newTimesheet
    $newTimesheetPath           = (Resolve-Path ('.\'+ $mondayString + '\' + $newTimesheet)).ToString()
}
#Correct the date field in Sheet1, A1
$excel                          = Open-ExcelPackage -Path $newTimesheetPath
$worksheet                      = $excel.Workbook.Worksheets['Sheet1']
$worksheet.Cells['A1'].Value    = $today
Close-ExcelPackage $excel