# Using pkg nvidia-hybrid-graphics

Be sure the correct kernel modules are loaded "i915kms" for intel iGPU and "nvidia-modeset" for nvidia dGPU, also enable the the nvidia_xorg service.

You may need to install the `drm-kmod` package to get your intel gpu driver.

Here's what I'm using in my `/etc/rc.conf`:

```shell
# NVIDIA
nvidia_load="YES"
kld_list="{kld_list} nvidia-modeset"

# NVIDIA xorg in headless mode on display 8
nvidia_xorg_enable="YES"


# Intel
kld_list="{kld_list} i915kms.ko acpi_video"
```

Also make sure to have the correct gpu settings in `/usr/local/etc/X11/`
iGPU in `xorg.conf.d/20-intel.conf`
```shell
#Section "Device"
	#Identifier	"Card0"
	#Driver		"intel"
	#Driver		"modesetting"
	#BusID		"PCI:0:2:0"
#EndSection

Section "OutputClass"
	Identifier "intel"
	MatchDriver "i915"
	Driver "modesetting"
	Option "PrimaryGPU" "yes"
EndSection
```
For the nvidia gpu we only need to run it in headless mode, as the intel gpu will be our default.
Create file `xorg-nvidia-headless.conf.d/xorg-nvidia-headless.conf`
```shell
Section "ServerLayout"
    Identifier     "nvidia"
    Screen      0  "Screen0" 0 0
    InputDevice    "fake" "CorePointer" "CoreKeyboard"
    Option         "AutoAddDevices" "false"
EndSection

Section "Files"
    ModulePath      "/usr/local/lib/xorg/modules-NVIDIA"
    ModulePath      "/usr/local/lib/xorg/modules"
EndSection

Section "Module"
    Load           "dri3"
    Load           "glx"
    Disable        "efifb"
EndSection

Section "InputDevice"
    Identifier     "fake"
    Driver         ""
EndSection

Section "Monitor"
    Identifier     "Monitor0"
EndSection

Section "Device"
    Identifier     "Device0"
    Driver         "nvidia"
    BusID          "PCI:1:0:0"
    Option         "UseDisplayDevice" "None"
EndSection

Section "Screen"
    Identifier     "Screen0"
    Device         "Device0"
    Monitor        "Monitor0"
EndSection
```
Mind you, you may need to change the BusID to match your system, figure out your gpu bus_id:
`pciconf -lv | grep -B3 display`

# VirtualGL / nvrun / optirun
Enables running apps on iGPU and then running graphics intensive apps with:
"optirun" == "nvrun-vgl" which adds some flags to "/usr/local/virtualGL/bin/vglrun"


You can manually do what optirun does by running: '/usr/local/VirtualGL/bin/vglrun -ld "/usr/local/lib/libGL-NVIDIA" -d ":8" glxinfo -B'

Behind the scenes VirtualGL (refered to as vgl) is used.

You can check vgl is actually running by setting VGL_LOGO=1 before running the command: "VGL_LOGO=1 optirun glxgears"

You can check what gpu is being ran with "glxinfo -B"

Can run a whole window manager with "optirun startx" and everything will run with dGPU.

## Problems with spectrwm (adding libswmhack.so to LD_PRELOAD)
If running normally with iGPU (startx), then using optirun has problems:

This is mainly caused by the fact that spectrwm relies on libswmhack to place applications in their correct positions. spectrwm adds libswmhack.so to LD_PRELOAD env which vglrun also needs to use for it's own libraries... the order in which libswmhack and virtualgl libs needs to load is very finnicky and the defaults don't work: 

1. "optirun glxgears" and other programs such as vlc and firefox, will crash/segfault and (coredump).
2. "optirun -nodl" will fix the issue in SOME such cases: "optirun -nodl glxgears".
    HOWEVER another problem is that for programs that DOES launch with -nodl, not all actually manage to use your dGPU and instead still use your iGPU, firefox is one of such cases.
3. FIX: set env var "LD_PRELOAD=" before running command will most likely run the program: "LD_PRELOAD= optirun glxgears"
4. Another fix, overwrite env var and set preloads yourself: "optirun env LD_PRELOAD=libdlfaker.so:libvglfaker.so glxgears"
6. Alternatively unset for terminal session "unset LD_PRELOAD"


MOST LIKELY TO WORK: "LD_PRELOAD= VGL_LOGO=1 optirun +v <program-to-run>"


TIP: You can check env variable with "env"
Run "optirun env" to see which variables gets set by virtualGL

PRO TIP: /usr/local/VirtualGL/bin/vlgrun is just a shell script which populates LD_PRELOAD, we can permanently fix the issue but reordering how the environment variables are appended in there.

I'm currently running a patched verion of vglrun, the original is still in the original folder named _vglrun
