# HeeHaw - Internet Explorer Wrapper in pure PowerShell
---

## Usage:

```powershell
.\heehaw.ps1 [[-Url] "https://www.example.com"] [-OutputFile "output.html"] [-TimeoutSeconds 30] [-Headless]
```

## Parameters:
- `-Url`: The URL to navigate to (default: "https://www.example.com").
- `-OutputFile`: Optional file path to save the page content. If not specified, the content will be saved to a default file named "page_content.[html_encoded_Url].html". If the file already exists, it will be overwritten. If you do not want to save the content to a file, you can specify `$null` (e.g., `-OutputFile $null`) - the content will be output to the console.
- `-TimeoutSeconds`: Maximum time to wait for the page to load (default: 30 seconds).
- `-Headless`: If specified, the browser will run in headless mode (hidden). If not specified, the browser window will be shown.

## License

HeeHaw is licensed under MIT License (see [LICENSE](LICENSE) file for details).


