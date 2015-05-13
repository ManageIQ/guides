# Infrastructure Prerequisites and Configuration
## Infrastructure setup:
* Configure iPXE/sources/windows directory to be accessible via SAMBA (Create directories if they don't already exist)
```
      [sources]
      path = /srv/httpboot/ipxe/sources
      guest ok = yes
      writable = yes
      browsable = yes
      printable = no
```
* Configure iPXE/sysprep directory to be accessible via SAMBA (Create directories if they don't already exist)
```
      [sysprep]
      path = /srv/httpboot/ipxe/sysprep
      guest ok = yes
      writable = no
      browsable = no
      printable = no
```
* Configure iPXE menu item and get sources for WinPE
  * Get Memdisk
    * Obtain Syslinux package http://www.kernel.org/pub/linux/utils/boot/syslinux/
    * Extract package
    * get ‘memdisk’ from syslinux-v.vv/memdisk/
  * Prepare iPXE structure TODO
    * Log into PXE server and cd to iPXE directory
    * Copy memdisk file into sources directory
  * Create iPXE menu item for WinPE
    * Menu section:
    ```item winpex64   WindowsPE_amd64```
    * Label:
```
          :winpex64
          initrd http://server/ipxe/sources/windows/winpe_amd64.iso
          kernel http://server/ipxe/sources/memdisk iso raw
          boot
```

## Admin Workstation prep:
1. Get Windows AIK and install on admin workstation http://www.microsoft.com/en-us/download/details.aspx?id=5753
1. Build Windows_PE environment and create ISO
  1. Generate WinPE directory structure
    * Open Start / Windows AIK / Deployment Tools Command Prompt
    ```
    copycmd amd64 c:\winpe_amd64
    ```
  1. Copy additional tools and customize our working directory
    * Always enter WinPE (don't prompt for key press)
    ```
    del c:\winpe_amd64\ISO\boot\bootfix.bin
    ```
  1. Edit the Boot Image
    ```
    # Mount the WIM file
    dism /mount-wim /wimfile:c:\winpe_amd64\winpe.wim /index:1 /mountdir:c:\winpe_amd64\mount

    # Modify startnet.cmd to mount shares and call scripts
    C:\winpe_amd64\mount\Windows\System32>notepad startnet.cmd

    # Add Driver Files
    dism /image:c:\winpe_amd64\mount /add-driver /driver:”path to drivers directory” /recurse /forceunsigned

    # Add VBScripting
    dism /image:c:\winpe_amd64\mount /add-package /packagepath:"C:\Program Files\Windows AIK\Tools\PETools\amd64\WinPE_FPs\winpe-scripting.cab"
    dism /image:c:\winpe_amd64\mount /add-package /packagepath:"C:\Program Files\Windows AIK\Tools\PETools\amd64\WinPE_FPs\en-us\winpe-scripting_en-us.cab"

    # Verify Packages list
    dism /image:c:\winpe_amd64\mount /get-packages

    # Commit changes
    dism /unmount-wim /mountdir:c:\winpe_amd64\mount /commit
    C:\winpe_amd64>copy winpe.wim ISO\sources\boot.wim
    ```
  1. Build the WinPE ISO

     ```
     oscdimg -n -b c:\winpe_amd64\etfsboot.com c:\winpe_amd64\ISO c:\winpe_amd64\winpe_amd64.iso
     ```
1. Build base WIM and capture it (using the WinPE with imagex PXE boot)
  1. Install windows on a VM
  1. Sysprep the install
  1. Boot the VM into windows PE PXE
  1. Capture the image into a wim file
1. Build sample sysprep unattend.xml file



## Some additional reference notes:
Install WAIK on a windows 7 or 2008 R2 Server

* Enter WAIK Command Prompt
On your technician computer: click Start, All Programs, Windows AIK,
right-click Deployment Tools Command Prompt, and Run as administrator

```
# Cope WinPE files - This creates the winPE directory and copies necessary files to it
copype.cmd x86 c:\winpe_amd64

# Copy the out of the box winPE WIM to the ISO folder
copy c:\winpe_amd64\winpe.wim c:\winpe_amd64\ISO\sources\boot.wim

# Mount winpe WIM
dism /mount-wim /wimfile:c:\winpe_amd64\iso\sources\boot.wim /index:1 /mountdir:c:\winpe_amd64\mount

# Inject Drivers into WIM
dism /image:c:\winpe_amd64\mount /add-driver /driver:"c:\drivers" /recurse /forceunsigned

# Add the vb scripting to WinPE
dism /image:c:\winpe_amd64\mount /add-package /packagepath:"C:\Program Files\Windows AIK\Tools\PETools\amd64\WinPE_FPs\winpe-scripting.cab"
dism /image:c:\winpe_amd64\mount /add-package /packagepath:"C:\Program Files\Windows AIK\Tools\PETools\amd64\WinPE_FPs\en-us\winpe-scripting_en-us.cab"

# Verify VB Scripting is installed
dism /image:c:\winpe_amd64\mount /get-packages
```

* notepad C:\winpe_amd64\mount\Windows\System32\startnet.cmd
```
wpeinit
net use s: \\10.10.1.7\ipxe
s:\sources\microsoft\evm.bat
```

* To Commit Changes to the WIM
```
dism /Unmount-Wim /MountDir:C:\winpe_amd64\mount /Commit
```

* To discard change made to the WIM
```
dism /Unmount-Wim /MountDir:C:\winpe_amd64\mount /discard
```

* To Create the ISO image
```
oscdimg -n -bc:\winpe_amd64\etfsboot.com c:\winpe_amd64\ISO c:\winpe_amd64\winpe_amd64.iso
```

* Copy iso image to
```
copy c:\winpe_amd64\winpe_amd64.iso  <PXE Server>/srv/boot/ipxe/sources/microsoft
```

* Refresh PXE Server in EVM

* To rename a WIM files information (Useful if you need to rename the image to match a template name)
```
imagex /info win2k8.wim 1 "win2008r2" "Windows 2008 R2 x64"
```

* To cleanup stale mounts
```
dism /cleanup-wim
```


## Automated Process Overview
1. Create VM based on a blank Windows template
1. Generate config files and drop on share (sysprep/directory-based-on-MAC-address/files)
  1. image.bat (batch file to run the imaging process)
  1. diskpart.txt (partitioning model)
  1. unattend.xml (sysprep unattend file)
1. Boot VM via Network - just like linux install
  1. Client PXE stack automatically chains up to ipxe (no EVM involvement here)
  1. iPXE selects correct image based on mac address (same thing as used
1. WinPE Booted
  1. startnet.cmd (on ISO) calls image.bat (on share) (shown in admin workstation prep above)
    1. disk wiped
    1. partitions created, formatted and mounted
    1. system imaged
    1. unattend file deployed
    1. bootloader installed
    1. Callback to EVM  ##### Still researching
    1. WinPE Shutdown
1. EVM powers on VM normally (not network boot)
1. System runs through sysprep using unattend.xml file and reboots
1. System boots into a working Windows System
1. Done!
