Add-Type @"
using System;
using System.Runtime.InteropServices;
public class SleepUtil {
  [DllImport("kernel32.dll")] public static extern uint SetThreadExecutionState(uint esFlags);
}
"@
[SleepUtil]::SetThreadExecutionState(0x80000000 -bor 0x00000001) | Out-Null
while ($true) { Start-Sleep -Seconds 30 }
