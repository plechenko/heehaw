[CmdletBinding()]
param(
  [string]$Url = 'https://example.com',
  [int]$TimeoutSeconds = 30,
  [string]$OutputFile = 'page_content.' + [uri]::EscapeDataString([uri]$Url) + '.html',
  [switch]$Headless
)

if ($PSEdition -eq 'Core') {
  Write-Warning 'HeeHaw is not supported in PowerShell Core. Please run this script in Windows PowerShell.'
  exit 1
}

# Load required assemblies
Add-Type -AssemblyName System.Windows.Forms

# Create a hidden form to host the WebBrowser control
$form = [System.Windows.Forms.Form]::New()
$form.Width = 800
$form.Height = 600
if ($Headless) {
  $form.StartPosition = 'Manual'
  $form.Location = [System.Drawing.Point]::New(-32000, -32000)  # Off-screen
  $form.ShowInTaskbar = $false
  $form.FormBorderStyle = 'None'
  $form.Visible = $false
}
else {
  $form.StartPosition = 'CenterScreen'
  $form.ShowInTaskbar = $true
  $form.FormBorderStyle = 'Sizable'
  $form.Visible = $true
}

# Create WebBrowser control
$browser = [System.Windows.Forms.WebBrowser]::New()
$browser.Width = $form.Width
$browser.Height = $form.Height
$browser.Dock = 'Fill'
$form.Controls.Add($browser)

# Navigate to URL
$browser.Navigate($Url)

$script:documentText = $null
$browser.add_DocumentCompleted({
    $script:documentText = $browser.DocumentText
  })

# Show the form (hidden) to activate the message loop
$form.Show()

if ($Headless) {

  # Wait for document to load (with timeout)
  $timeout = [DateTime]::Now.AddSeconds($TimeoutSeconds)
  while ($Browser.ReadyState -ne [System.Windows.Forms.WebBrowserReadyState]::Complete -and [DateTime]::Now -lt $timeout) {
    [System.Windows.Forms.Application]::DoEvents()
    Start-Sleep -Milliseconds 100
  }
  $form.Close()
  $form.Dispose()
  $browser.Dispose()
}
else {    

  $browser.add_DocumentTitleChanged({
      $form.Text = $browser.DocumentTitle
    })

  [System.Windows.Forms.Application]::EnableVisualStyles()
  [System.Windows.Forms.Application]::Run($form)
}

if ([string]::IsNullOrEmpty($script:documentText)) {
  Write-Warning 'Failed to complete page rendering.'
  exit 1
}
if ([string]::IsNullOrEmpty($OutputFile)) {
  $script:documentText
}
else {
  [System.IO.File]::WriteAllText($OutputFile, $script:documentText)
  Write-Host "Page content saved to $OutputFile"
}