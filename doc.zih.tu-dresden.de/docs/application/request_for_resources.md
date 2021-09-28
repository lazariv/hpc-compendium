# Request for Resources

Important note: ZIH systems are based on the Linux system. Thus for the effective work, you should
have to know how to work with Linux based systems and Linux Shell. Beginners can find a lot of
different tutorials on the internet, for example.

## Determine the Required CPU and GPU Hours

ZIH systems are focused on data-intensive computing. The cluster is oriented on the work with the
high parallel code. Please keep it in mind for the transfer sequential code from a local machine.
So far you will have execution time for the sequential program it is reasonable to use
[Amdahl's law][1] to roughly predict execution time in parallel. Think in advance about the
parallelization strategy for your project.

## Available Software

The good practice for the HPC clusters is to use software and packages where parallelization is
possible. The open-source software is more preferable than proprietary. However, the majority of
popular programming languages, scientific applications, software, packages available or could be
installed on the HPC cluster in different ways. First of all, check the [Software module list][2].
There are [two different software environments](../software/modules.md): `scs5` (the regular one)
and `ml` (environment for the Machine Learning partition). Keep in mind that ZIH systems have a
Linux based operating system.

[1]: https://en.wikipedia.org/wiki/Amdahl%27s_law
[2]: https://gauss-allianz.de/de/application?organizations%5B0%5D=1200
