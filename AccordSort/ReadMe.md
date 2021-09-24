# Accord files

Short work project where I was given *hundreds* of nested zip files containing a collection of files
we needed for some web-forms.

I was tasked firstly to extract all the archives, and move the files we needed (*Acroform.pdf) into
a new folder.

The second task was to then go through these files and add their form number, form type, and the 2
letter state code for the state the form was used in to a CSV. This presented some interesting 
challanges as not all files were state specific, and some files did not follow the standard naming 
convention.

This was my first time doing anything like this with Powershell, so a lot of the methods used were
new to me. Stand outs included Try/Catch - though I have since found a much more elegant way around
this particular use case with RegEx, and case/switch statements.