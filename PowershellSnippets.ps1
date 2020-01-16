#Snippets of code from lectures and resources.
#https://sysnetdevops.com/2017/04/24/exploring-the-powershell-alternative-to-netstat/

#Miscelaneous ######################################################################################################
function Miscellaneous(){
    <# $_. is short for $PSItem which is automatic variable for "current object in pipeline" which is proffesional term
       $PSItem ==$_                    $_ was renamed to $PSItem from Powershell2>3
       https://www.interfacett.com/videos/difference-_-psitem-windows-powershell/#>


    #Allows locally stored and written code, and requires remotely acquired code be signed with a certificate from trusted root.
    Set-ExecutionPolicy RemoteSigned

    #Sets an alias for specified command, that overwrites existing one - works as long as session is active.
    Set-Alias -Name ping -value Test-NetConnection   #Bonus: Test-NetConnection is Powershell way of Ping

    #Start-Transcript #Starts logging command outputs to file
    Get-Command               #list all available commands
    Get-Command -Noun service #list all cmdlets containing service
    Get-Command -Verb Start   #list all cmdlets that start somethng
    Get-Help Get-Command <#Or any other command#> [-detailed]
    Update-Help

    nslookup 8.8.8.8 #resolve DNS name of IP address

    #Useful credential object
    $creds = Get-Credential
    $creds.UserName
    $creds.GetNetworkCredential().Password


    <#Szukanie plików, których data ostatniego dostępu i modyfikacji są identyczne#>
    Get-ChildItem | Where-Object {$_.LastAccessTime -eq $_.LastWriteTime} | Select-Object

    <#Cmdlet generujący dane jest zatrzymywany w momencie pobrania 10-go obiektu po wywołaniu #>
    #| select-object limit 10 #Żeby temu zapobiec w select-object ustawiamy flagę -wait. 

    <#Dodanie wartości do klucza rejestru: Odnalezienie klucza | dodanie wartości#>
    #Get-Item -Path HKLM:\Software\MyCompany | New-ItemProperty -Name NoOfEmployees -Value 1234

    #Get-ADuser $env:USERNAME -properties * #get current user Active directory informations
}
#Variables #########################################################################################################
function Variables() {
    #Tick(`) is Escape character, use it to input non pt=rintable characters like `n or `t
    $escapetest='Oops'
    "Evaluating string:     $escapetest, $(2+2)"
    'Non-evaluating string: $escapetest, $(2+2)'

    $variable='This is a string variable'
    $variabletype=$variable.GetType()
    [string]$Variable                      #let's cast it to string anyways
    $variable | Get-Member                 #will work if variable is an object
    $variable | Measure-Object             #<TODO> Check what does it do - measure size of object ? 

    $currentdirectorylisting = Get-ChildItem
    $currentdirectorylisting | Write-Host

    #Removing Variable from Memory 
    Remove-Variable -Name currentdirectorylisting 
    $currentdirectorylisting | Format-List


    <#Arrays in Powershell#>
    1,2,3    #Array with three elements
    ,1       #Array with one element
    @()      #Empty array
    1..5     #Array of consecutive elements in specified range
    @{}      #key-Value pair associating table 


    #List assignment - Note to self: potentially dangerous
    $IWantToSplitThis = "I.want.to.split.this"
    $I, $want, $to, $split,$this = $IWantToSplitThis.split(".")
    <#omitting $this variable split would be a list ($split[0]='split',$split[1]='this')#> 
    write-host $split $this $I $want $to 

    #Defining Scope
    $VariableFoo = "Global Scope"
    function LimittedScope {
        $VariableFoo = "Local Scope"
        Write-Host "`
    Global Foo:`t`t`t`t`t`t  $Global:VariableFoo `
    Local Foo:`t`t`t`t`t`t  $Local:VariableFoo `
    Without scope specifier:`t`t  $VariableFoo"
    }
    LimittedScope
    write-host "`
    (Outside)Local Foo:`t`t`t`t  $Local:VariableFoo `
    (Outside)Without scope specifier: $VariableFoo"
}
#Creating Objects ##################################################################################################
function Objects() {
    #Creatin custom object
    $Type1Object = New-Object -TypeName Type1 -Property @{
        Property1 = "First__Property"
        Property2 = "Second_Property"
        Propertyn = "Nth____Property"
    }
    $Type1Object | Format-List

    #Expanding object
    Get-ChildItem | Select-Object FullName, Name,
        @{Name="DateTime";       Expression={Get-Date}},
        @{Name="CustomProperty"; Expression={"Custom_Property"}} | format-table
}
#Calling .Net library methods ######################################################################################
function .NetMethods(){

#Static methods are invoked by [full_class_name]::method
                               [System.IO.Path]::GetFileName('C:\Windows\explorer.exe')
                               [System.IO.File]::Exists('C:\Windows\explorer.exe')          #checking if file exists

#Dynamic methods require instances of .Net class objects
$NetTimeObject = [System.DateTime]::Now
$NetTimeObjectv2 = $NetTimeObject.AddHours(15)
write-host $NetTimeObject != $NetTimeObjectv2
}


Variables;
Objects;
.NetMethods;