# Virtual desktops

Use WebVNC or NICE DCV to run GUI applications on HPC resources.

<span class="twiki-macro TABLE" columnwidths="10%,45%,45%"></span>

|                |                                                       |                                                 |
|----------------|-------------------------------------------------------|-------------------------------------------------|
|                | **WebVNC**                                            | **NICE DCV**                                    |
| **use case**   | all GUI applications that do \<u>not need\</u> OpenGL | only GUI applications that \<u>need\</u> OpenGL |
| **partitions** | all\* (except partitions with GPUs (gpu2, hpdlf, ml)  | dcv                                             |

## Launch a virtual desktop

<span class="twiki-macro TABLE" columnwidths="10%,45%,45%"></span> \|
**step 1** \| Navigate to \<a href="<https://taurus.hrsk.tu-dresden.de>"
target="\_blank"><https://taurus.hrsk.tu-dresden.de>\</a>. There is our
[JupyterHub](../software/JupyterHub.md) instance. \|\| \| **step 2** \|
Click on the "advanced" tab and choose a preset: \|\|

|             |                                                                                                                                                                             |                                                             |
|-------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------|
| ^           | **WebVNC**                                                                                                                                                                  | **DCV**                                                     |
| **step 3**  | Optional: Finetune your session with the available SLURM job parameters or assign a certain project or reservation. Then save your settings in a new preset for future use. |                                                             |
| **step 4**  | Click on "Spawn". JupyterHub starts now a SLURM job for you. If everything is ready the JupyterLab interface will appear to you.                                            |                                                             |
| **step 5"** | Click on the **button "WebVNC"** to start a virtual desktop.                                                                                                                | Click on the \*button "NICE DCV"to start a virtual desktop. |
| ^           | The virtual desktop starts in a new tab or window.                                                                                                                          |                                                             |

### Demonstration

\<video controls="" width="320" style="border: 1px solid black">\<source
src="<https://doc.zih.tu-dresden.de/hpc-wiki/pub/Compendium/VirtualDesktops/start-virtual-desktop-dcv.mp4>"
type="video/mp4">\<source
src="<https://doc.zih.tu-dresden.de/hpc-wiki/pub/Compendium/VirtualDesktops/start-virtual-desktop-dcv.webm>"
type="video/webm">\</video>

### Using the quickstart feature

JupyterHub can start a job automatically if the URL contains certain
parameters.

<span class="twiki-macro TABLE" columnwidths="10%,45%,45%"></span>

|                            |                                                                                                                                                                                        |                                                                                                                                                                                                   |
|----------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| examples                   | \<a href="<https://taurus.hrsk.tu-dresden.de/jupyter/hub/spawn#/>\~(partition\~'interactive\~cpuspertask\~'2\~mempercpu\~'2583)" target="\_blank" style="font-size: 1.5em">WebVNC\</a> | \<a href="<https://taurus.hrsk.tu-dresden.de/jupyter/hub/spawn#/>\~(partition\~'dcv\~cpuspertask\~'6\~gres\~'gpu\*3a1\~mempercpu\~'2583)" target="\_blank" style="font-size: 1.5em">NICE DCV\</a> |
| details about the examples | `interactive` partition, 2 CPUs with 2583 MB RAM per core, no GPU                                                                                                                      | `dcv` partition, 6 CPUs with 2583 MB RAM per core, 1 GPU                                                                                                                                          |
| link creator               | Use the spawn form to set your preferred options. The browser URL will be updated with the corresponding parameters.                                                                   |                                                                                                                                                                                                   |

If you close the browser tabs or windows or log out from your local
machine, you are able to open the virtual desktop later again - as long
as the session runs. But please remember that a SLURM job is running in
the background which has a certain timelimit.

## Reconnecting to a session

In order to reconnect to an active instance of WebVNC, simply repeat the
steps required to start a session, beginning - if required - with the
login, then clicking "My server", then by pressing the "+" sign on the
upper left corner. Provided your server is still running and you simply
closed the window or logged out without stopping your server, you will
find your WebVNC desktop the way you left it.

## Terminate a remote session

<span class="twiki-macro TABLE" columnwidths="10%,90%"></span> \| **step
1** \| Close the VNC viewer tab or window. \| \| **step 2** \| Click on
File \> Log Out in the JupyterLab main menu. Now you get redirected to
the JupyterLab control panel. If you don't have your JupyterLab tab or
window anymore, navigate directly to \<a
href="<https://taurus.hrsk.tu-dresden.de/jupyter/hub/home>"
target="\_blank"><https://taurus.hrsk.tu-dresden.de/jupyter/hub/home>\</a>.
\| \| **step 3** \| Click on "Stop My Server". This cancels the SLURM
job and terminates your session. \|

### Demonstration

\<video controls="" width="320" style="border: 1px solid black">\<source
src="<https://doc.zih.tu-dresden.de/hpc-wiki/pub/Compendium/VirtualDesktops/terminate-virtual-desktop-dcv.mp4>"
type="video/mp4">\<source
src="<https://doc.zih.tu-dresden.de/hpc-wiki/pub/Compendium/VirtualDesktops/terminate-virtual-desktop-dcv.webm>"
type="video/webm">\</video>

**Remark:** This does not work if you click on the "Logout"-Btn in your
virtual desktop. Instead this will just close your DCV session or cause
a black screen in your WebVNC window without a possibility to recover a
virtual desktop in the same Jupyter session. The solution for now would
be to terminate the whole jupyter session and start a new one like
mentioned above.
