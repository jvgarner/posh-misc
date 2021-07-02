function Get-Weather {
    curl wttr.in/?format="%T+%l+%c+%f+%w+%h+%p+%P"
}

Set-Alias gw Get-Weather 
Export-ModuleMember -Function * -Alias * 