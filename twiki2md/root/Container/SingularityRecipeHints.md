# Singularity Recipe Hints

## Index

[GUI (X11) applications](#X11)

------------------------------------------------------------------------

### \<a name="X11">\</a>GUI (X11) applications

Running GUI applications inside a singularity container is possible out
of the box. Check the following definition:

    Bootstrap: docker
    From: centos:7

    %post
    yum install -y xeyes

This image may be run with

    singularity exec xeyes.sif xeyes.

This works because all the magic is done by singularity already like
setting $DISPLAY to the outside display and mounting $HOME so
$HOME/.Xauthority (X11 authentification cookie) is found. When you are
using \`--contain\` or \`--no-home\` you have to set that cookie
yourself or mount/copy it inside the container. Similar for
\`--cleanenv\` you have to set $DISPLAY e.g. via

    export SINGULARITY_DISPLAY=$DISPLAY

When you run a container as root (via \`sudo\`) you may need to allow
root for your local display port: \<verbatim>xhost
+local:root\</verbatim>

#### Hardware acceleration

If you want hardware acceleration you **may** need
[VirtualGL](https://virtualgl.org). An example definition file is as
follows:

    Bootstrap: docker
    From: centos:7

    %post
    yum install -y glx-utils # for glxgears example app

    yum install -y curl
    VIRTUALGL_VERSION=2.6.2 # Replace by required (e.g. latest) version

    curl -sSL https://downloads.sourceforge.net/project/virtualgl/"${VIRTUALGL_VERSION}"/VirtualGL-"${VIRTUALGL_VERSION}".x86_64.rpm -o VirtualGL-"${VIRTUALGL_VERSION}".x86_64.rpm
    yum install -y VirtualGL*.rpm
    /opt/VirtualGL/bin/vglserver_config -config +s +f -t
    rm VirtualGL-*.rpm

    # Install video drivers AFTER VirtualGL to avoid them being overwritten
    yum install -y mesa-dri-drivers # for e.g. intel integrated GPU drivers. Replace by your driver

You can now run the application with vglrun:

    singularity exec vgl.sif vglrun glxgears

**Attention:**Using VirtualGL may not be required at all and could even
decrease the performance. To check install e.g. glxgears as above and
your graphics driver (or use the VirtualGL image from above) and disable
vsync:

    vblank_mode=0 singularity exec vgl.sif glxgears

Compare the FPS output with the glxgears prefixed by vglrun (see above)
to see which produces more FPS (or runs at all).

**NVIDIA GPUs** need the \`--nv\` parameter for the singularity command:
\`singularity exec --nv vgl.sif glxgears\`
