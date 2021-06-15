# Installed Applications

The following applications are available on the HRSK systems. (General
descriptions are taken from the vendor's web site or from
Wikipedia.org.)

Before running an application you normally have to load a
[module](RuntimeEnvironment#Modules). Please read the instructions given
while loading the module, they might be more up-to-date than this
manual.

-   [Complete List of Modules](SoftwareModulesList)
-   [Using Software Modules](RuntimeEnvironment#Modules)

<!-- -->

-   [Mathematics](Mathematics)
-   [Nanoscale Simulations](Nanoscale Simulations)
-   [FEM Software](FEMSoftware)
-   [Computational Fluid Dynamics](CFD)
-   [Deep Learning](DeepLearning)

<!-- -->

-   [Visualization Tools](Visualization) , \<a
    href="DesktopCloudVisualization" title="Remote Rendering on GPU
    nodes">Remote Rendering on GPU nodes\</a>
-   \<s>[Graphical access using UNICORE](unicore_access)\</s> The
    UNICORE support has been abandoned and so this way of access is no
    longer available.

## \<a name="ExternalLicense">\</a>Use of external licenses

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
