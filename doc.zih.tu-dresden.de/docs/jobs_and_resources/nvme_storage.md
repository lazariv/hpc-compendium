# NVMe Storage

90 NVMe storage nodes, each with

-   8x Intel NVMe Datacenter SSD P4610, 3.2 TB
-   3.2 GB/s (8x 3.2 =25.6 GB/s)
-   2 Infiniband EDR links, Mellanox MT27800, ConnectX-5, PCIe x16, 100
    Gbit/s
-   2 sockets Intel Xeon E5-2620 v4 (16 cores, 2.10GHz)
-   64 GB RAM

NVMe cards can saturate the HCAs

![Configuration](misc/nvme.png)
{: align=center}
