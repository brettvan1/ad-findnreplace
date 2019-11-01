#===============================================================================
#
# Program:     ad-swap-DN.ps1
#
# Author:      Brett van Gennip
# Date:        November 1, 2019
#
# Purpose:     Within Active Directory - This script will move a new 
#              computer object to the location of the former object.
#              This facilitates a quick way to swap the old Win7 object with the win10 system
#
#=================================================================================

#Requries -version 5.1

import-module activedirectory

cls

$old=read-host "Enter in the old computer name:  "

$targetcmp=read-host "Enter in new computer name.  This is one you want to replace the old one in AD space:  "

$y=read-host "Do you want to move this $old computer object to this $targetcmp location in AD? Press y to continue:  "

if($y -like "y"){

#This command obtains the Distinguished name within your space within AD but removes the CN (Container Name)
$dn=get-adcomputer $($old) |Select-Object @{Name = "Parent"; Expression ={($_.distinguishedname.split(","))[1 .. $(($_.distinguishedname.split(",") | measure-object).count - 1)] -join ","}}
$dn=$dn.parent

#moves/replaces where the OLD AD computer object used to be
move-adobject $(get-adcomputer $targetcmp).distinguishedname -targetpath $dn -confirm

#This asks if you want to remove the old computer object from AD
remove-adcomputer $old -confirm
}
