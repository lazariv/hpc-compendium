# Security Restrictions on Taurus

As a result of the security incident the German HPC sites in Gau Alliance are now adjusting their
measurements to prevent infection and spreading of the malware.

The most important items for HPC systems at ZIH are:

- All users (who haven't done so recently) have to
  [change their ZIH password](https://selfservice.zih.tu-dresden.de/l/index.php/pswd/change_zih_password).
  **Login to Taurus is denied with an old password.**
- All old (private and public) keys have been moved away.
- All public ssh keys for Taurus have to
  - be re-generated using only the ED25519 algorithm (`ssh-keygen -t ed25519`)
  - **passphrase for the private key must not be empty**
- Ideally, there should be no private key on Taurus except for local use.
- Keys to other systems must be passphrase-protected!
- **ssh to Taurus** is only possible from inside TU Dresden Campus
  (login\[1,2\].zih.tu-dresden.de will be blacklisted). Users from outside can use VPN (see
  [here](https://tu-dresden.de/zih/dienste/service-katalog/arbeitsumgebung/zugang_datennetz/vpn)).
- **ssh from Taurus** is only possible inside TU Dresden Campus.
  (Direct ssh access to other computing centers was the spreading vector of the recent incident.)

Data transfer is possible via the taurusexport nodes. We are working on a bandwidth-friendly
solution.

We understand that all this will change convenient workflows. If the measurements would render your
work on Taurus completely impossible, please contact the HPC support.
