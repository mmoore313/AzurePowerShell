#
# This script reads the contents of a CSV file defined by the $DataFile varable.
# It removes RBAC roles from the assosciate subscription ID and removes ALL resources
# from the subscription.
#
# NOTE: You must run the follwing cmdlets before executing this script. 
#      Add-AzureAccount 
#           --AND-- 
#      Add-AzureRmAccount (or Login-AzureRmAccount)
#
# WARNING: The removal of the resources is not reversable.  
#          ***** Use with caution! *****
#

# CSV file containing team data
$TeamDataFile = 'C:\tmp\Data.csv'

# Generate lists of Team Members
$MemberList = Import-Csv $TeamDataFile

# Returns a list of email addresses from the CSV file
ForEach ($Member in $MemberList) {
    $SignInName=$Member.Email
    $Subscription=$Member.Subscription
    $IsCaptain=$Member.Captain
    $Role = ''

    if ( $IsCaptain -eq "Yes") {
        $Role = 'Owner'
        }
    else {
        $Role = 'Owner'
        }

    # Select the Subscription ID
    Write-Host "   Setting the Subscription ID to $Subscription"
    Select-AzureSubscription -SubscriptionId $Subscription -ErrorAction Stop
    
    # Remove the role for the address
    Write-Host "   Removing $SignInName as $Role from $Subscription"
    Remove-AzureRmRoleAssignment -RoleDefinitionName $role -SignInName $email -Force -ErrorAction Inquire
    
    # Returns the current Azure role assignments (Should be blank)
    Get-AzureRmRoleAssignment -SignInName $SignInName
    
    }

Write-Host "***** ***** ***** ***** ***** *****"
Write-Host "WARNING: This will remove ALL Resource Groups"
Write-Host "         from ALL Subscriptions in the file:"
Write-Host "         $DataFile"
Write-Host "***** ***** ***** ***** ***** *****"
Pause

ForEach ($Sub in $MemberList) {
    # Set the Subscription context (required for the removal process)
    Write-Host "   Setting Active Subscription Context: $Subscription"
    Set-AzureRmContext -SubscriptionId $Subscription -ErrorAction Stop
    
    # Remove all resources from the active
    Write-Host "   Removing all resource groups for Subscription ID $Subscription"
    Get-AzureRmResourceGroup | Remove-AzureRmResourceGroup -Verbose -Force -ErrorAction Inquire
    
    }
Write-Host "   Done."