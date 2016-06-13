#
# This script reads the contents of a CSV file defined by the $DataFile varable.
# It will create an Azure account for the email address for the subscription ID.
#
# # NOTE: You must run the follwing cmdlets before executing this script. 
#      Add-AzureAccount 
#           --AND-- 
#      Add-AzureRmAccount (or Login-AzureRmAccount)
#
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
    Select-AzureSubscription -SubscriptionId $Subscription -ErrorAction Inquire
    
    # Set the Subscription context (previously, not necessary)
    Write-Host "   Setting Active Subscription Context: $Subscription"
    Set-AzureRmContext -SubscriptionId $Subscription -ErrorAction Stop

    # Assign the role to the address
    Write-Host "   Setting $SignInName to $Subscription as $Role"
    New-AzureRmRoleAssignment -SignInName $SignInName -RoleDefinitionName $Role -ErrorAction Stop

    # Returns the current Azure role assignments
    Get-AzureRmRoleAssignment -SignInName $SignInName
    }
