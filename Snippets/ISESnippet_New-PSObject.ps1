[scriptblock]$code = 
{
$object = New-Object -TypeName PSObject -Property @{
      Name = $Server
      ServerUri = "http://$server/"
      Authorization = $authorization
}
}
 
New-IseSnippet `
    -Text $code.ToString() `
    -CaretOffset $code.ToString().Length `
    -Force `
    -Title ‘NewObject’ `
    -Description ‘Use for creating a new PowerShell Object’