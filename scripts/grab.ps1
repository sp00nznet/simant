# Start the recompiled game, optionally click, and save its window to PNGs.
#   scripts\grab.ps1 [-Wait 10] [-Out work\grab.png]
#   scripts\grab.ps1 -Wait 8 -Click "345,237" -After 6     click, then a second shot
# Click points are in the screenshot's own coordinates (the whole window). The
# click is posted to the child window under the point; the real mouse never moves.
param([int]$Wait = 10, [string]$Out = "work\grab.png", [string[]]$Click, [int]$After = 5, [switch]$Keep)
$ErrorActionPreference = "Stop"
Set-Location (Split-Path $PSScriptRoot -Parent)
$env:PATH = "C:\msys64\mingw64\bin;" + $env:PATH
Add-Type -AssemblyName System.Drawing
Add-Type @"
using System; using System.Runtime.InteropServices;
public class G {
  [DllImport("user32.dll")] public static extern bool PrintWindow(IntPtr h, IntPtr dc, uint f);
  [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr h, out RECT r);
  [DllImport("user32.dll")] public static extern bool ScreenToClient(IntPtr h, ref POINT p);
  [DllImport("user32.dll")] public static extern IntPtr ChildWindowFromPointEx(IntPtr h, POINT p, uint f);
  [DllImport("user32.dll")] public static extern IntPtr PostMessageA(IntPtr h, uint m, IntPtr w, IntPtr l);
  [StructLayout(LayoutKind.Sequential)] public struct RECT { public int L, T, R, B; }
  [StructLayout(LayoutKind.Sequential)] public struct POINT { public int X, Y; }
}
"@

function Save-Shot($h, $path) {
    $r = New-Object G+RECT; [void][G]::GetWindowRect($h, [ref]$r)
    $w = $r.R - $r.L; $ht = $r.B - $r.T
    $bmp = New-Object Drawing.Bitmap $w, $ht
    $g = [Drawing.Graphics]::FromImage($bmp); $dc = $g.GetHdc()
    [void][G]::PrintWindow($h, $dc, 2)   # PW_RENDERFULLCONTENT
    $g.ReleaseHdc($dc); $g.Dispose()
    $bmp.Save((Join-Path (Get-Location) $path)); $bmp.Dispose()
    "$path ${w}x${ht}"
}

# The game polls the mouse (GetAsyncKeyState, GetCursorPos) rather than trusting
# button messages, so the runtime's RECOMP_CURSOR file says where the pointer is
# and whether the button is down, in the guest's screen coordinates (the main
# window's client area). The messages are posted too, for what reads them.
$cursorFile = Join-Path (Get-Location) "work\cursor.txt"
Set-Content $cursorFile "-1,-1,0"
$env:RECOMP_CURSOR = "@$cursorFile"

function Post-Click($h, [int]$x, [int]$y) {
    $r = New-Object G+RECT; [void][G]::GetWindowRect($h, [ref]$r)
    $target = $h
    $p = New-Object G+POINT; $p.X = $r.L + $x; $p.Y = $r.T + $y
    $v = $p; [void][G]::ScreenToClient($h, [ref]$v)
    Set-Content $cursorFile "$($v.X),$($v.Y),1"
    while ($true) {                      # descend to the deepest visible child
        $q = $p; [void][G]::ScreenToClient($target, [ref]$q)
        $c = [G]::ChildWindowFromPointEx($target, $q, 1)   # CWP_SKIPINVISIBLE
        if ($c -eq [IntPtr]::Zero -or $c -eq $target) { break }
        $target = $c
    }
    $q = $p; [void][G]::ScreenToClient($target, [ref]$q)
    $lp = [IntPtr](($q.Y -shl 16) -bor ($q.X -band 0xFFFF))
    [void][G]::PostMessageA($target, 0x0201, [IntPtr]1, $lp)   # WM_LBUTTONDOWN
    Start-Sleep -Milliseconds 200
    Set-Content $cursorFile "$($v.X),$($v.Y),0"
    [void][G]::PostMessageA($target, 0x0202, [IntPtr]0, $lp)   # WM_LBUTTONUP
    "clicked ($x,$y) -> window $target at ($($q.X),$($q.Y))"
}

Get-Process simant -ErrorAction SilentlyContinue | Stop-Process -Force
$p = Start-Process build\simant.exe -PassThru -RedirectStandardError work\grab.log -RedirectStandardOutput work\grab.out
Start-Sleep -Seconds $Wait
$p.Refresh()
if ($p.HasExited) { "exited early with $($p.ExitCode)"; exit 1 }
$h = $p.MainWindowHandle
Save-Shot $h $Out
$n = 0
foreach ($c in @($Click)) {
    if (-not $c) { continue }
    $xy = $c -split ','
    Post-Click $h ([int]$xy[0]) ([int]$xy[1])
    Start-Sleep -Seconds $After
    $p.Refresh()
    if ($p.HasExited) { "exited after click with $($p.ExitCode)"; exit 1 }
    $n++
    Save-Shot $h ($Out -replace '\.png$', "-$n.png")
}
if (-not $Keep) { Stop-Process -Id $p.Id -Force }
