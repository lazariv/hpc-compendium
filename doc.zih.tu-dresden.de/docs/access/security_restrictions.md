# Security Restrictions

As a result of a security incident the German HPC sites in Gauß Alliance have adjusted their
measurements to prevent infection and spreading of malware.

The most important items for ZIH systems are:

* All users (who haven't done so recently) have to
  [change their ZIH password](https://selfservice.zih.tu-dresden.de/l/index.php/pswd/change_zih_password).
    * **Login to ZIH systems is denied with an old password.**
* All old (private and public) keys have been moved away.
* All public ssh keys for ZIH systems have to
    * be re-generated using only the ED25519 algorithm (`ssh-keygen -t ed25519`)
    * **passphrase for the private key must not be empty**
* Ideally, there should be no private key on ZIH system except for local use.
* Keys to other systems must be passphrase-protected!
* **ssh to ZIH systems** is only possible from inside TU Dresden campus
  (`login[1,2].zih.tu-dresden.de` will be blacklisted). Users from outside can use
  [VPN](https://tu-dresden.de/zih/dienste/service-katalog/arbeitsumgebung/zugang_datennetz/vpn).
* **ssh from ZIH system** is only possible inside TU Dresden campus.
  (Direct SSH access to other computing centers was the spreading vector of the recent incident.)

Data transfer is possible via the [export nodes](../data_transfer/export_nodes.md). We are working
on a bandwidth-friendly solution.

We understand that all this will change convenient workflows. If the measurements would render your
work on ZIH systems completely impossible, please [contact the HPC support](../support/support.md).
