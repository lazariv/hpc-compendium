# Transfer of Data

## Moving Data to/from ZIH Systems

There are at least three tools to exchange data between your local machine (lm) and ZIH systems:
`scp`, `rsync`, and `sftp`. Please refer to the offline or online man pages of
[scp](https://www.man7.org/linux/man-pages/man1/scp.1.html),
[rsync](https://man7.org/linux/man-pages/man1/rsync.1.html), and
[sftp](https://man7.org/linux/man-pages/man1/sftp.1.html) for detailed information.

!!! hint

    No matter what tool you prefer, it is crucial that the **export nodes** are used prefered way to
    copy data to/from ZIH systems.

!!! example "Example using `scp` to copy a file from your workstation to ZIH systems"

    ```console
    marie@local$ scp <file> <zih-user>@taurusexport.hrsk.tu-dresden.de:<target-location>

    # Add -r to copy whole directory
    marie@local$ scp -r <directory> <zih-user>@taurusexport.hrsk.tu-dresden.de:<target-location>
    ```

!!! example "Example using `scp` to copy a file from ZIH systems to your workstation"

```console
marie@login$ scp <zih-user>@taurusexport.hrsk.tu-dresden.de:<file> <target-location>

# Add -r to copy whole directory
marie@login$ scp -r <zih-user>@taurusexport.hrsk.tu-dresden.de:<directory> <target-location>
```

## Moving Data Inside ZIH Systems: Datamover

The recommended way for data transfer inside ZIH Systems is the **datamover**. It is a special
data transfer machine that provides the best transfer speed. To load, move, copy etc. files from one
filesystem to another filesystem, you have to use commands prefixed with `dt`: `dtcp`, `dtwget`,
`dtmv`, `dtrm`, `dtrsync`, `dttar`, `dtls`. These commands submit a job to the data transfer machines that
execute the selected command.
Plese refer to the detailed documentation regarding the [datamover](datamover.md).
