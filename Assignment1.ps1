#Connects to Azure
Connect-AzureAD -TenantId 205bf62b-bfc4-4d64-b460-f0242cdfe2cf

for ($i = 1; $i -le 20; $i++){
    #Create Password Profile Object(password is required to be an object)
    $PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
    $PasswordProfile.Password = "qNP6??9t$i"
    #Formats usernames so that all names have two numbers at the end like Varonis00
    if($i -le 9){
        $DisName = "Varonis0$i"
        $UPName = "Varonis0$i@derekfxugmail.onmicrosoft.com"
        $MailName = "user0$i"
    }else{
        $DisName = "Varonis$i"
        $UPName = "Varonis$i@derekfxugmail.onmicrosoft.com"
        $MailName = "user$i"
    }
    #Create User account
    $params = @{
        AccountEnabled = $true
        PasswordProfile = $PasswordProfile
        DisplayName = $DisName
        UserPrincipalName = $UPName
        MailNickName = $MailName
    }

    New-AzureADUser @params
    }

#Creating Security Group
New-AzureADGroup -DisplayName "Varonis Assignment Group" -MailEnabled $false -SecurityEnabled $true -MailNickName "NotSet"


for ($i = 1; $i -le 20; $i++){
    if($i -le 9){
        $User_Search_String = "Varonis0$i"
    }else{
        $User_Search_String = "Varonis$i"
    }
    #Try-Catch block to output to log and catch errors
    try {
        $state = [PSCustomObject]@{
            Time   = Get-Date -Format 'u'
            UPN    = $User_Search_String
            Result = 'OK'
        }
        $GroupObj = Get-AzureADGroup -SearchString "Varonis Assignment Group"
        $UserObj = Get-AzureADUser -SearchString $User_Search_String
        Add-AzureADGroupMember -ObjectId $GroupObj.ObjectId -RefObjectId $UserObj.ObjectId -ErrorAction Stop | Out-Null
    } catch {
        $state.Result = 'Failed: {0}' -f $_.Exception.Message.Trim()
    } finally {
        $state | Export-Csv C:\Users\Derek\Documents\GitHub\Assignment1_Varonis\Custom_CSV.csv -Append
    }
}
