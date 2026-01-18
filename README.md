<h1 align="center">Notepad++ Cisco IOS UDL</h1>

<p align="center">
  <img src="assets/cisco-logo.png" alt="Cisco Logo" title="Cisco" width="300" />
</p>

> The original version of this **User Defined Language (UDL)** is made by LuisPisco. His UDL is found [here](https://github.com/notepad-plus-plus/userDefinedLanguages/blob/master/UDLs/Cisco_IOS_byLuisPisco.xml).\
> The **UDL** was further enhanced by Osama Abbas (Tes3awy). His contributions can be found [here](https://github.com/Tes3awy/Cisco-IOS-XE-NotepadPlusPlus-Syntax-Highlight).

The changes provided with this fork are:
- Distinct Styler colors
- Backround is set to trasparent for all Styler except `Comment style`
- Spacers have there own color in addresses
- Additional Syntax
- Autocomplete grammar (if installed)

## Installation

ULD's doesn't handle spacers very well when it comes to hex. Do to this, the implementation of color coding them in MAC and IPv6 addresses does not work. The use of EnhanceAnyLexer fixes this issue for the most part (there are some edge cases where doesn't work). It is for this reason, the installation of EnhanceAnyLexer is recommended. Instructions on how to do is provided below.

Install EnhanceAnyLexer
-----------------------

If you need to install the EnhanceAnyLexer plugin itself, follow one of these methods:

- Plugins Admin (recommended when available):
  1. Open Notepad++ → `Plugins` → `Plugins Admin...`.
  2. Search for `EnhanceAnyLexer` and check it.
  3. Click `Install` and let Notepad++ restart if prompted.

- Manual install (if Plugins Admin doesn't provide it):
  1. Download the plugin binary (typically a DLL) for your Notepad++ version and architecture.
  2. Copy the plugin DLL into `C:\Program Files\Notepad++\plugins\EnhanceAnyLexer` (create the folder if missing). Administrator privileges are required for this step.
  3. Copy the plugin configuration files/folder (the repository's `EnhanceAnyLexer` folder) to `%AppData%\Notepad++\plugins\config\EnhanceAnyLexer`.
  4. Restart Notepad++.

Notes:
- The installer included in this repository will copy the `EnhanceAnyLexer` configuration to `%AppData%\Notepad++\plugins\config\EnhanceAnyLexer` for you when present.
- If you install the plugin DLL manually to Program Files, ensure the config folder exists under `%AppData%` so the plugin can find its settings.
- After installing, open Notepad++ and check `Plugins` → `EnhanceAnyLexer` to confirm it's available and configure any plugin options as needed.

Manual install
--------------

If you prefer to install files manually without using the installer, follow these steps.

- UDL (User Defined Language):
  1. Create the folder if needed: `%AppData%\Notepad++\userDefineLangs`.
  2. Copy `Cisco_IOS_Redux.xml` into that folder.
  3. Restart Notepad++.

- Auto-completion (per-user or system-wide):
  - Per-user (no admin rights):
    1. Create `%AppData%\Notepad++\autoCompletion` if missing.
    2. Copy `autoCompletion\Cisco IOS Redux.xml` into that folder.
    3. Restart Notepad++ and enable auto-completion under Settings → Preferences → Auto-Completion.
  - System-wide (requires administrator privileges):
    1. Create `C:\Program Files\Notepad++\autoCompletion` if missing (requires elevation).
    2. Copy `autoCompletion\Cisco IOS Redux.xml` into that folder.
    3. Restart Notepad++.

- EnhanceAnyLexer configuration:
  1. Ensure the plugin is installed (Plugins Admin or manual DLL install).
  2. Create `%AppData%\Notepad++\plugins\config\EnhanceAnyLexer` if missing.
  3. Copy the contents of the repository's `EnhanceAnyLexer` folder into that config folder.
  4. Restart Notepad++.

Automated install
-----------------

If you'd prefer an automated installer, a single script is included in the `installers/` folder:

- `install.bat` — Batch installer. Run by double-clicking or from a command prompt:

  ```cmd
  .\installers\install.bat
  ```

The script copies `Cisco_IOS_Redux.xml` into `%AppData%\Notepad++\userDefineLangs` and will also install the auto-completion file `autoCompletion/Cisco IOS Redux.xml` only if administrator privileges are granted. The installer will prompt to run elevated; if elevated it installs the auto-completion file into `C:\Program Files\Notepad++\autoCompletion`. If elevation is declined, auto-completion will be skipped (it will not be installed to `%AppData%`).

- Note: Installing to `C:\Program Files\Notepad++` requires administrator privileges; if you decline elevation, auto-completion will not be installed.

GUI installer
-------------

If you prefer a graphical installer, a simple PowerShell GUI is provided at `installers\installer_gui.ps1`. It allows choosing which components to install and can relaunch itself elevated to install the auto-completion file system-wide.

Run with PowerShell:

```powershell
PowerShell -ExecutionPolicy Bypass -File .\installers\installer_gui.ps1
```

Note: The GUI requires Windows PowerShell with `System.Windows.Forms` available (standard on Windows PowerShell). The GUI will prompt for elevation when you click `Run Elevated`.

If the repository contains the `EnhanceAnyLexer` folder, the installers will copy its contents to `%AppData%\Notepad++\plugins\config\EnhanceAnyLexer` so the plugin can load its configuration. Existing contents are backed up (PowerShell uses timestamped backups; the batch installer moves existing contents to a `_backup_*` folder).

Files with extensions `.cisco`, `.ios`, `.xe`, `.log`, `.txt`, `.conf`, and `.config` will automagically use this new UDL as their default language when opened with NotePad++. Remove or add any extension when desired.

To change this behavior:

1. Open the `Cisco_IOS_Redux.xml` file.
2. For example, remove `txt` from the `ext` property in `<UserLang>`.

```xml
<UserLang name="Cisco IOS XE" ext="cisco ios xe log conf config" udlVersion="2.0">
```

3. Save the UDL file.
4. Restart NotePad++.

## Preview

![Preview](assets/preview.jpg)
