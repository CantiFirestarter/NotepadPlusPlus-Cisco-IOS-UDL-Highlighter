# Notepad++ Cisco IOS UDL Highlighter

<p align="center">
  <img src="assets/cisco-logo.png" alt="Cisco Logo" title="Cisco" width="300" />
</p>

> The original version of this **User Defined Language (UDL)** is made by LuisPisco. His UDL is found [here](https://github.com/notepad-plus-plus/userDefinedLanguages/blob/master/UDLs/Cisco_IOS_byLuisPisco.xml).\
> The **UDL** was further enhanced by Osama Abbas (Tes3awy). His contributions can be found [here](https://github.com/Tes3awy/Cisco-IOS-XE-NotepadPlusPlus-Syntax-Highlight).

After Installing [NotePad++](https://notepad-plus-plus.org/downloads/), place the `Cisco_IOS_Redux.xml` file within the `%AppData%\Notepad++\userDefineLangs` folder, and restart NotePad++.

Files with extensions `.cisco`, `.ios`, `.xe`, `.log`, `.txt`, `.conf`, and `.config` will automagically use this new UDL as their default language when opened with NotePad++. Remove or add any extension when desired.

To change this behavior:

1. Open the `Cisco_IOS_XE_byOsamaAbbas.udl.xml` file.
2. For example, remove `txt` from the `ext` property in `<UserLang>`.

```xml
<UserLang name="Cisco IOS XE" ext="cisco ios xe log conf config" udlVersion="2.0">
```

3. Save the UDL file.
4. Restart NotePad++.

## Preview

![Preview](assets/preview.jpg)
