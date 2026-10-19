# Start the recompiled game, wait, and save its main window to a PNG.
#   scripts\grab.ps1 [-Wait 10] [-Out work\grab.png]
param([int]$Wait = 10, [string]$Out = "work\grab.png", [switch]$Keep)
$ErrorActionPreference = "Stop"
Set-Location (Split-Path $PSScriptRoot -Parent)
$env:PATH = "C:\msys64\mingw64\bin;" + $env:PATH
Add-Type -AssemblyName System.Drawing
Add-Type @"
using System; using System.Runtime.InteropServices;
public class G {
  [DllImport("user32.dll")] public static extern bool PrintWindow(IntPtr h, IntPtr dc, uint f);
  [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr h, out RECT r);
  [StructLayout(LayoutKind.Sequential)] public struct RECT { public int L, T, R, B; }
}
"@
Get-Process simant -ErrorAction SilentlyContinue | Stop-Process -Force
$p = Start-Process build\simant.exe -PassThru -RedirectStandardError work\grab.log -RedirectStandardOutput work\grab.out
Start-Sleep -Seconds $Wait
$p.Refresh()
if ($p.HasExited) { "exited early with $($p.ExitCode)"; exit 1 }
$h = $p.MainWindowHandle
$r = New-Object G+RECT; [void][G]::GetWindowRect($h, [ref]$r)
$w = $r.R - $r.L; $ht = $r.B - $r.T
$bmp = New-Object Drawing.Bitmap $w, $ht
$g = [Drawing.Graphics]::FromImage($bmp); $dc = $g.GetHdc()
[void][G]::PrintWindow($h, $dc, 2)   # PW_RENDERFULLCONTENT
$g.ReleaseHdc($dc); $g.Dispose()
$bmp.Save((Join-Path (Get-Location) $Out)); $bmp.Dispose()
"$Out ${w}x${ht}"
if (-not $Keep) { Stop-Process -Id $p.Id -Force }
