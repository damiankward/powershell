# Enter-Hours.ps1
## Super important note
This was created for *NIGHT SHIFT*.  

Shifts start at 2200, and finish at 0600 the following day. I do a *lot* of work with datetime in the script, and the midnight crossover can make things difficult to follow.

This script is designed to be run at the end of shift, so a lot of references that should be "*tomorrow*" are actually "*today*". Welcome to my life 😜


## Intended functionality
1) Email todays completed timesheet to *MyBoss*.
   - Complete email with subject, body, and today's timesheet attached
2) Create a new timesheet for tomorrow.
    - copy and rename the template, edit the value in A1 for tomorrow's date
    -  if Friday (Saturday), create new folder structure for next week, then copy/rename/edit the template

## Insights
I had originally hoped to sent the email to *MyBoss* using  ```Send-MailMessage``` via Direct Send, as this would avoid using a credential. Unfortunately, I don't seem to have access to *myWorksDomain*.mail.protection.outlook.com:25.

After some investigation, I discovered that I would be able to send from Outlook, using the credential stored in my mail profile. I was *very* surprised at how simple this turned out to be.

I was also surprised at how easy it was to edit the spreadsheet with powershell, even if it requires a non-standard module. I would like to play around with this more, but at the moment I don't really have a use-case for it.

From a code/formatting perspective, I have started tabbing out my variable assignments because it looks *way* cleaner, eg
```powershell
$var1                   = 'value'
$muchLongerNameVar2     = 'some other value'
```
As ever, if you've some how found yourself digging through my scripts and have any tips, let me know!