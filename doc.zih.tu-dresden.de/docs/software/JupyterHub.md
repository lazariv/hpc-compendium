# JupyterHub

With our JupyterHub service we offer you now a quick and easy way to
work with jupyter notebooks on Taurus.

Subpages:

-   [JupyterHub for Teaching (git-pull feature, quickstart links, direct
    links to notebook files)](JupyterHubForTeaching.md)

## Disclaimer

This service is provided "as-is", use at your own discretion. Please
understand that JupyterHub is a complex software system of which we are
not the developers and don't have any downstream support contracts for,
so we merely offer an installation of it but cannot give extensive
support in every case.

## Access

<span style="color:red">**NOTE**</span> This service is only available for users with
an active HPC project. See [here](../access.md) how to apply for an HPC
project.

JupyterHub is available here:\
<https://taurus.hrsk.tu-dresden.de/jupyter>

## Start a session

Start a new session by clicking on the **TODO ADD IMAGE** \<img alt="" height="24"
src="%ATTACHURL%/start_my_server.png" /> button.

A form opens up where you can customize your session. Our simple form
offers you the most important settings to start quickly.

**TODO ADD IMAGE** \<a href="%ATTACHURL%/simple_form.png">\<img alt="session form"
src="<https://doc.zih.tu-dresden.de/hpc-wiki/pub/Compendium/JupyterHub/simple_form.png>"
style="border: 1px solid #888;" title="simple form" width="400" />\</a>

For advanced users we have an extended form where you can change many
settings. You can:

-   modify Slurm parameters to your needs ( [more about
    Slurm](../jobs/Slurm.md))
-   assign your session to a project or reservation
-   load modules from the [LMOD module
    system](../data_management/RuntimeEnvironment.md)
-   choose a different standard environment (in preparation for future
    software updates or testing additional features)

**TODO ADD IMAGE** \<a href="%ATTACHURL%/advanced_form_nov2019.png">\<img alt="session
form"
src="<https://doc.zih.tu-dresden.de/hpc-wiki/pub/Compendium/JupyterHub/advanced_form_nov2019.png>"
style="border: 1px solid #888;" title="advanced form" width="400"
/>\</a>

You can save your own configurations as additional presets. Those are
saved in your browser and are lost if you delete your browsing data. Use
the import/export feature (available through the button) to save your
presets in text files.

Note: the [<span style="color:blue">**alpha**</span>]
(https://doc.zih.tu-dresden.de/hpc-wiki/bin/view/Compendium/AlphaCentauri) 
partition is available only in the extended form.

## Applications

You can choose between JupyterLab or the classic notebook app.

### JupyterLab

**TODO ADD IMAGE** \<a href="%ATTACHURL%/jupyterlab_app.png">\<img alt="jupyterlab app"
src="<https://doc.zih.tu-dresden.de/hpc-wiki/pub/Compendium/JupyterHub/jupyterlab_app.png>"
style="border: 1px solid #888;" title="JupyterLab overview" width="400"
/>\</a>

The main workspace is used for multiple notebooks, consoles or
terminals. Those documents are organized with tabs and a very versatile
split screen feature. On the left side of the screen you can open
several views:

-   file manager
-   controller for running kernels and terminals
-   overview of commands and settings
-   details about selected notebook cell
-   list of open tabs

### Classic notebook

**TODO ADD IMAGE** \<a href="%ATTACHURL%/jupyter_notebook_app_filebrowser.png">\<img
alt="filebrowser in jupyter notebook server" width="400"
src="<https://doc.zih.tu-dresden.de/hpc-wiki/pub/Compendium/JupyterHub/jupyter_notebook_app_filebrowser.png>"
style="border: 1px solid #888;" title="Classic notebook (file browser)"
/>\</a>

**TODO ADD IMAGE** \<a href="%ATTACHURL%/jupyter_notebook_example_matplotlib.png">\<img
alt="jupyter_notebook_example_matplotlib" width="400"
src="<https://doc.zih.tu-dresden.de/hpc-wiki/pub/Compendium/JupyterHub/jupyter_notebook_example_matplotlib.png>"
style="border: 1px solid #888;" title="Classic notebook (matplotlib
demo)" />\</a>

Initially you will get a list of your home directory. You can open
existing notebooks or files by clicking on them.

Above the table on the right side is the "New ⏷" button which lets you
create new notebooks, files, directories or terminals.

## The notebook

In JupyterHub you can create scripts in notebooks.  
Notebooks are programs which are split in multiple logical code blocks.
In between those code blocks you can insert text blocks for
documentation and each block can be executed individually. Each notebook
is paired with a kernel which runs the code. We currently offer one for
Python, C++, MATLAB and R.

## Stop a session

It's good practise to stop your session once your work is done. This
releases resources for other users and your quota is less charged. If
you just log out or close the window your server continues running and
will not stop until the Slurm job runtime hits the limit (usually 8
hours).

At first you have to open the JupyterHub control panel.

**JupyterLab**: Open the file menu and then click on Logout. You can
also click on "Hub Control Panel" which opens the control panel in a new
tab instead.

**TODO ADD IMAGE** \<a href="%ATTACHURL%/jupyterlab_logout.png">\<img alt="" height="400"
src="<https://doc.zih.tu-dresden.de/hpc-wiki/pub/Compendium/JupyterHub/jupyterlab_logout.png>"
style="border: 1px solid #888;" title="JupyterLab logout button"/>\</a>

**Classic notebook**: Click on the control panel button on the top right
of your screen.

**TODO ADD IMAGE** \<img alt="" src="%ATTACHURL%/notebook_app_control_panel_btn.png"
style="border: 1px solid #888;" title="Classic notebook (control panel
button)" />

Now you are back on the JupyterHub page and you can stop your server by
clicking on **TODO ADD IMAGE** \<img alt="" height="24"
src="%ATTACHURL%/stop_my_server.png" title="Stop button" />.

## Error handling

We want to explain some errors that you might face sooner or later. If
you need help open a ticket at HPC support.

### Error while starting a session

**TODO ADD IMAGE** \<a href="%ATTACHURL%/error_batch_job_submission_failed.png">\<img
alt="" width="400"
src="<https://doc.zih.tu-dresden.de/hpc-wiki/pub/Compendium/JupyterHub/error_batch_job_submission_failed.png>"
style="border: 1px solid #888;" title="Error message: Batch job
submission failed."/>\</a>

This message often appears instantly if your Slurm parameters are not
valid. Please check those settings against the available hardware.
Useful pages for valid Slurm parameters:

-   [Slurm batch system (Taurus)] **TODO LINK** (../jobs/SystemTaurus#Batch_System)
-   [General information how to use Slurm](../jobs/Slurm.md)

### Error message in JupyterLab

**TODO ADD IMAGE** \<a href="%ATTACHURL%/jupyterlab_error_directory_not_found.png">\<img
alt="" width="400"
src="<https://doc.zih.tu-dresden.de/hpc-wiki/pub/Compendium/JupyterHub/jupyterlab_error_directory_not_found.png>"
style="border: 1px solid #888;" title="Error message: Directory not
found"/>\</a>

If the connection to your notebook server unexpectedly breaks you maybe
will get this error message.  
Sometimes your notebook server might hit a Slurm or hardware limit and
gets killed. Then usually the logfile of the corresponding Slurm job
might contain useful information. These logfiles are located in your
home directory and have the name "jupyter-session-\<jobid>.log".

------------------------------------------------------------------------

## Advanced tips

### Standard environments

The default python kernel uses conda environments based on the [Watson
Machine Learning Community Edition (formerly
PowerAI)](https://developer.ibm.com/linuxonpower/deep-learning-powerai/)
package suite. You can open a list with all included packages of the
exact standard environment through the spawner form:

**TODO ADD IMAGE** \<img alt="environment_package_list.png"
src="%ATTACHURL%/environment_package_list.png" style="border: 1px solid
\#888;" title="JupyterHub environment package list" />

This list shows all packages of the currently selected conda
environment. This depends on your settings for partition (cpu
architecture) and standard environment.

There are three standard environments:

-   production,
-   test,
-   python-env-python3.8.6.

**Python-env-python3.8.6**virtual environment can be used for all x86
partitions(gpu2, alpha, etc). It gives the opportunity to create a user
kernel with the help of a python environment.

Here's a short list of some included software:

|            |           |        |
|------------|-----------|--------|
|            | generic\* | ml     |
| Python     | 3.6.10    | 3.6.10 |
| R\*\*      | 3.6.2     | 3.6.0  |
| WML CE     | 1.7.0     | 1.7.0  |
| PyTorch    | 1.3.1     | 1.3.1  |
| TensorFlow | 2.1.1     | 2.1.1  |
| Keras      | 2.3.1     | 2.3.1  |
| numpy      | 1.17.5    | 1.17.4 |
| matplotlib | 3.3.1     | 3.0.3  |

\* generic = all partitions except ml

\*\* R is loaded from the [module system](../data_management/RuntimeEnvironment.md)

### Creating and using your own environment

Interactive code interpreters which are used by Jupyter Notebooks are
called kernels.  
Creating and using your own kernel has the benefit that you can install
your own preferred python packages and use them in your notebooks.

We currently have two different architectures at Taurus. Build your
kernel environment on the **same architecture** that you want to use
later on with the kernel. In the examples below we use the name
"my-kernel" for our user kernel. We recommend to prefix your kernels
with keywords like "intel", "ibm", "ml", "venv", "conda". This way you
can later recognize easier how you built the kernel and on which
hardware it will work.

**Intel nodes** (e.g. haswell, gpu2):

    srun --pty -n 1 -c 2 --mem-per-cpu 2583 -t 08:00:00 bash -l

If you don't need Sandy Bridge support for your kernel you can create
your kernel on partition 'haswell'.

**Power nodes** (ml partition):

    srun --pty -p ml -n 1 -c 2 --mem-per-cpu 5772 -t 08:00:00 bash -l

Create a virtual environment in your home directory. You can decide
between python virtualenvs or conda environments.

<span class="twiki-macro RED"></span> **Note** <span
class="twiki-macro ENDCOLOR"></span>: Please take in mind that Python
venv is the preferred way to create a Python virtual environment.

#### Python virtualenv

```bash
$ module load Python/3.8.6-GCCcore-10.2.0

$ mkdir user-kernel         #please use Workspaces!

$ cd user-kernel

$ virtualenv --system-site-packages my-kernel
Using base prefix '/sw/installed/Python/3.6.6-fosscuda-2018b'
New python executable in .../user-kernel/my-kernel/bin/python
Installing setuptools, pip, wheel...done.

$ source my-kernel/bin/activate

(my-kernel) $ pip install ipykernel
Collecting ipykernel
...
Successfully installed ... ipykernel-5.1.0 ipython-7.5.0 ...

(my-kernel) $ pip install --upgrade pip

(my-kernel) $ python -m ipykernel install --user --name my-kernel --display-name="my kernel"
Installed kernelspec my-kernel in .../.local/share/jupyter/kernels/my-kernel

[now install additional packages for your notebooks]

(my-kernel) $ deactivate
```

#### Conda environment

Load the needed module for Intel nodes

```
module load Anaconda3
```

... or for IBM nodes (ml partition):

```
module load PythonAnaconda
```

Continue with environment creation, package installation and kernel
registration:

```
$ mkdir user-kernel         #please use Workspaces!

$ conda create --prefix /home/<USER>/user-kernel/my-kernel python=3.6
Collecting package metadata: done
Solving environment: done
[...]

$ conda activate /home/<USER>/user-kernel/my-kernel

$ conda install ipykernel
Collecting package metadata: done
Solving environment: done
[...]

$ python -m ipykernel install --user --name my-kernel --display-name="my kernel"
Installed kernelspec my-kernel in [...]

[now install additional packages for your notebooks]

$ conda deactivate
```

Now you can start a new session and your kernel should be available.

**In JupyterLab**:

Your kernels are listed on the launcher page:

**TODO ADD IMAGE**\<a href="%ATTACHURL%/user-kernel_in_jupyterlab_launcher.png">\<img
alt="jupyterlab_app.png" height="410"
src="<https://doc.zih.tu-dresden.de/hpc-wiki/pub/Compendium/JupyterHub/user-kernel_in_jupyterlab_launcher.png>"
style="border: 1px solid #888;" title="JupyterLab kernel launcher
list"/>\</a>

You can switch kernels of existing notebooks in the menu:

**TODO ADD IMAGE** \<a href="%ATTACHURL%/jupyterlab_change_kernel.png">\<img
alt="jupyterlab_app.png"
src="<https://doc.zih.tu-dresden.de/hpc-wiki/pub/Compendium/JupyterHub/jupyterlab_change_kernel.png>"
style="border: 1px solid #888;" title="JupyterLab kernel switch"/>\</a>

**In classic notebook app**:

Your kernel is listed in the New menu:

**TODO ADD IMAGE** \<a href="%ATTACHURL%/user-kernel_in_jupyter_notebook.png">\<img
alt="jupyterlab_app.png"
src="<https://doc.zih.tu-dresden.de/hpc-wiki/pub/Compendium/JupyterHub/user-kernel_in_jupyter_notebook.png>"
style="border: 1px solid #888;" title="Classic notebook (create notebook
with new kernel)"/>\</a>

You can switch kernels of existing notebooks in the kernel menu:

**TODO ADD IMAGE** \<a href="%ATTACHURL%/switch_kernel_in_jupyter_notebook.png">\<img
alt="jupyterlab_app.png"
src="<https://doc.zih.tu-dresden.de/hpc-wiki/pub/Compendium/JupyterHub/switch_kernel_in_jupyter_notebook.png>"
style="border: 1px solid #888;" title="Classic notebook (kernel
switch)"/>\</a>

**Note**: Both python venv and conda virtual environments will be
mention in the same list.

### Loading modules

You have now the option to preload modules from the LMOD module
system.  
Select multiple modules that will be preloaded before your notebook
server starts. The list of available modules depends on the module
environment you want to start the session in (scs5 or ml). The right
module environment will be chosen by your selected partition.
