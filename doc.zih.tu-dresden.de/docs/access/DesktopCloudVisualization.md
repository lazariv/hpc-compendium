# Desktop Cloud Visualization (DCV)

NICE DCV enables remote accessing OpenGL-3D-applications running on the server (taurus) using the
server's GPUs. If you don't need GL acceleration, you might also want to try our [WebVNC](WebVNC.md)
solution.

Note that with the 2017 version (and later), while there is still a separate client available, it is
not necessary anymore. You can also use your (WebGL-capable) browser to connect to the DCV server. A
standalone-client, which might still be a bit more performant, can be downloaded from
https://www.nice-software.com/download/nice-dcv-2017

## Access with JupyterHub

**todo**
**Check out the [new documentation about virtual desktops](../software/VirtualDesktops.md).**

Click here, to start a session on our JupyterHub:
[https://taurus.hrsk.tu-dresden.de/jupyter/hub/spawn#/\~(partition\~'dcv\~cpuspertask\~'6\~gres\~'gpu\*3a1\~mempercpu\~'2583\~environment\~'production)](https://taurus.hrsk.tu-dresden.de/jupyter/hub/spawn#/~(partition~'dcv~cpuspertask~'6~gres~'gpu*3a1~mempercpu~'2583~environment~'test))\<br
/> This link starts your session on the dcv partition (taurusi210\[7-8\]) with a GPU, 6 CPU cores
and 2583 MB memory per core.  Optionally you can modify many different SLURM parameters. For this
follow the general [JupyterHub](../software/JupyterHub.md) documentation.

Your browser now should load into the JupyterLab application which looks like this:

\<a
href="<https://doc.zih.tu-dresden.de/hpc-wiki/pub/Compendium/DesktopCloudVisualization/jupyterlab-and-dcv.png>">
\<img alt="" src="%ATTACHURL%/jupyterlab-and-dcv.png" style="border: 1px solid #888;" width="400" />
\</a>

Click on the `DCV` button. A new tab with the DCV client will be opened.

### Notes on GPU Support:

- Check GPU support via:

```Bash
glxinfo name of display: :1 display: :1 screen: 0 direct rendering: Yes      # &lt;--- This
line!  ...
```

If direct rendering is not set to yes, please contact <hpcsupport@zih.tu-dresden.de>

- Expand LD_LIBRARY_PATH:

```Bash
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib64/nvidia/
```
