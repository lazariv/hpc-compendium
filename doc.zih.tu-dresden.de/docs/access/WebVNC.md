# WebVNC

We provide a Singularity container with a VNC setup that can be used as an alternative to
X-Forwarding to start graphical applications on the cluster.

It utilizes [noVNC](https://novnc.com) to offer a web-based client that you can use with your
browser, so there's no additional client software necessary.

Also, we have prepared a script that makes launching the VNC server much easier.

## Method with JupyterHub

**Check out the [new documentation about virtual desktops](../software/VirtualDesktops.md).**

The [JupyterHub](../software/JupyterHub.md) service is now able to start a VNC session based on the
Singularity container mentioned here.

Quickstart: 1 Click here to start a session immediately: \<a
href="<https://taurus.hrsk.tu-dresden.de/jupyter/hub/spawn#/>\~(partition\~'interactive\~cpuspertask\~'2\~mempercpu\~'2583\~environment\~'test)"
target="\_blank"><https://taurus.hrsk.tu-dresden.de/jupyter/hub/spawn#/>\~(partition\~'interactive\~cpuspertask\~'2\~mempercpu\~'2583\~environment\~'test)\</a>
1 Wait for the JupyterLab interface to appear. Then click on the + in the upper left corner -> New
launcher -> WebVNC.

Steps to get started manually:

1. Visit <https://taurus.hrsk.tu-dresden.de> to login to JupyterHub.
1. Choose your (SLURM) parameters for the job on Taurus.
1. Select the "test" environment in the "advanced" tab.
1. Click on the "Spawn" button. 1 Wait for the JupyterLab interface to appear. Then
click on the WebVNC button.

## Example usage

### Step 1

Start the `runVNC` script in our prepared container in an interactive batch job (here with 4 cores
and 2.5 GB of memory per core):

```Bash
srun --pty -p interactive --mem-per-cpu=2500 -c 4 -t 8:00:00 singularity exec
/scratch/singularity/xfce.sif runVNC
```

Of course, you can adjust the batch job parameters to your liking. Note that the default timelimit
in partition interactive is only 30 minutes, so you should specify a longer one with `-t`.

The script will automatically generate a self-signed SSL certificate and place it in your home
directory under the name `self.pem`. This path can be overridden via the --cert parameter to
`runVNC`.

On success, it will print you an URL and a one-time password:

```Bash
Note: Certificate file /home/user/self.pem already exists. Skipping generation.  Starting VNC
server...  Server started successfully.  Please browse to: https://172.24.146.46:5901/vnc.html
The one-time password is: 71149997
```

### Setp 1.2

**NEW**: Since the last security issue direct access to the compute nodes is not allowed anymore.
Therefore you have to create a tunnel from your laptop or workstation through the specific compute
node and Port as follows.

```Bash
ssh -NL <local port>:<compute node>:<remote port> <zih login>@tauruslogin.hrsk.tu-dresden.de
e.g. ssh NL 5901:172.24.146.46:5901 rotscher@tauruslogin.hrsk.tu-dresden.de
```

### Step 2:

Open your local web-browser and connect to the following URL.

```Bash
https://localhost:<local port>/vnc.html (e.g. https://localhost:5901/vnc.html)
```

Since you are using a self-signed certificate and the node does not have a public DNS name, your
browser will not be able to verify it and you will have to add an exception (via the "Advanced"
button).

### Step 3:

On the website, click the `Connect` button and enter the one-time password that was previously
displayed in order to authenticate. You will then see an Xfce4 desktop and can start a terminal in
there, where you can use the "ml" or "module" command as usual to load and then run your graphical
applications. Enjoy!
