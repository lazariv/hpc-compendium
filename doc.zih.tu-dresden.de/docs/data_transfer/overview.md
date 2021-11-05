# Transfer of Data

## Moving Data to/from ZIH Systems

There are at least three tools for exchanging data between your local workstation and ZIH systems:
`scp`, `rsync`, and `sftp`. Please refer to the offline or online man pages of
[scp](https://www.man7.org/linux/man-pages/man1/scp.1.html),
[rsync](https://man7.org/linux/man-pages/man1/rsync.1.html), and
[sftp](https://man7.org/linux/man-pages/man1/sftp.1.html) for detailed information.

No matter what tool you prefer, it is crucial that the **export nodes** are used as preferred way to
copy data to/from ZIH systems. Please follow the link to the documentation on
[export nodes](export_nodes.md) for further reference and examples.

## Moving Data Inside ZIH Systems: Datamover

The recommended way for data transfer inside ZIH Systems is the **datamover**. It is a special
data transfer machine that provides the best transfer speed. To load, move, copy etc. files from one
filesystem to another filesystem, you have to use commands prefixed with `dt`: `dtcp`, `dtwget`,
`dtmv`, `dtrm`, `dtrsync`, `dttar`, `dtls`. These commands submit a job to the data transfer
machines that execute the selected command.  Please refer to the detailed documentation regarding the
[datamover](datamover.md).
