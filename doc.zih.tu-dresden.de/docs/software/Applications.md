# Installed Applications

The following applications are available on the HRSK systems. (General
descriptions are taken from the vendor's web site or from
Wikipedia.org.)

Before running an application you normally have to load a
[module](../software/RuntimeEnvironment.md#modules). Please read the instructions given
while loading the module, they might be more up-to-date than this
manual.

-   **TODO Link** (Complete List of Modules)(SoftwareModulesList)
-   [Using Software Modules](../software/RuntimeEnvironment.md#modules)

<!-- -->

-   [Mathematics](../software/Mathematics.md)
-   [Nanoscale Simulations](../software/NanoscaleSimulations.md)
-   [FEM Software](../software/FEMSoftware.md)
-   [Computational Fluid Dynamics](../software/CFD.md)
-   [Deep Learning](../software/DeepLearning.md)

<!-- -->

-   [Visualization Tools](../software/Visualization.md),
    [Remote Rendering on GPU nodes](../access/DesktopCloudVisualization.md)
-   UNICORE support has been abandoned and so this way of access is no
    longer available.

## Use of external licenses

It is possible (please contact the support team first) for our users to
install their own software and use their own license servers, e.g.
FlexLM. The outbound IP addresses from Taurus are:

-   compute nodes: NAT via 141.76.3.193
-   login nodes: 141.30.73.102-141.30.73.105

The IT department of the external institute has to open the firewall for
license communications (might be multiple ports) from Taurus and enable
handing-out license to these IPs and login.

The user has to configure the software to use the correct license
server. This can typically be done by environment variable or file.

Attention: If you are using software we have installed, but bring your
own license key (e.g. commercial ANSYS), make sure that to substitute
the environment variables we are using as default! (To verify this, run
`printenv|grep licserv` and make sure that you dont' see entries
refering to our ZIH license server.)
