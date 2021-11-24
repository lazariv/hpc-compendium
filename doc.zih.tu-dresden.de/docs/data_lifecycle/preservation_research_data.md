# Long-term Preservation for Research Data

## Why should research data be preserved?

There are several reasons. On the one hand, research data should be preserved to make the results
reproducible. On the other hand research data could be used a second time for investigating another
question. In the latter case persistent identifiers (like DOI) are needed to make these data
findable and citable. In both cases it is important to add meta-data to the data.

## Which research data should be preserved?

Since large quantities of data are nowadays produced it is not possible to store everything. The
researcher needs to decide which data are worth and important to keep.

In case these data come from simulations, there are two possibilities: 1 Storing the result of the
simulations 1 Storing the software and the input-values

Which of these possibilities is preferable depends on the time the simulations need and on the size
of the result of the calculations. Here one needs to estimate, which possibility is cheaper.

**This is, what DFG says** (translated from
<http://www.dfg.de/download/pdf/foerderung/programme/lis/ua_inf_empfehlungen_200901.pdf>, page 2):

*Primary research data are data, which were created in the course* *of studies of sources,
experiments, measurements or surveys. They are the* *basis of scholarly publications*. *The
definition of primary research data depends on the subject*. *Each community of researchers should
decide by itself, if raw data are* *already primary research data or at which degree of aggregation
data* *should be preserved. Further it should be agreed upon the granularity* *of research data: how
many data yield one set of data, which will be* *given a persistent identifier*.

## Why should I add Meta-Data to my data?

Many researchers think, that adding meta-data is time-consuming and senseless but that isn't true.
On the contrary, adding meta-data is very important, since they should enable other researchers to
know, how and in which circumstances these data are created, in which format they are saved, and
which software in which version is needed to view the data, and so on, so that other researchers can
reproduce these data or use them for new investigations. Last but not least meta-data should enable
you in ten years time to know what your data describe, which you created such a long time ago.

## What are Meta-Data?

Meta-data means data about data. Meta-data are information about the stored file. There can be
administrative meta-data, descriptive meta-data, technical meta-data and so on. Often meta-data are
stored in XML-format but free text is also possible. There are some meta-data standards like
[Dublin Core](http://dublincore.org/) or
[LMER](https://www.dnb.de/DE/Professionell/Standardisierung/Standards/_content/lmer_uof_akk.html)
Below are some examples:

- possible meta-data for a book would be:
    - Title
    - Author
    - Publisher
    - Publication
    - year
    - ISBN
- possible meta-data for an electronically saved image would be:
    - resolution of the image
    - information about the color depth of the picture
    - file format (jpg or tiff or ...)
    - file size how was this image created (digital camera, scanner, ...)
    - description of what the image shows
    - creation date of the picture
    - name of the person who made the picture
- meta-data for the result of a calculation/simulation could be:
    - file format
    - file size
    - input data
    - which software in which version was used to calculate the result/to do the simulation
    - configuration of the software
    - date of the calculation/simulation (start/end or start/duration)
    - computer on which the calculation/simulation was done
    - name of the person who submitted the calculation/simulation
    - description of what was calculated/simulated

## Where can I get more information about management of research data?

Go to [http://www.forschungsdaten.org/en/](http://www.forschungsdaten.org/en/) to find more
information about managing research data.

## I want to store my research data at ZIH. How can I do that?

Long-term preservation of research data is under construction at ZIH and in a testing phase.
Nevertheless you can already use the archiving service. If you would like to become a test
user, please write an E-Mail to [Dr. Klaus Köhler](mailto:klaus.koehler@tu-dresden.de).
