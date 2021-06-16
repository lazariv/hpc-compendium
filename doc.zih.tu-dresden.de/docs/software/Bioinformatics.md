# Bioinformatics

|                                   |                                           |
|-----------------------------------|-------------------------------------------|
|                                   | **module**                                |
| **[Infernal](#Infernal)**         | infernal                                  |
| **[OpenProspect](#OpenProspect)** | openprospect, openprospect/885-mpi        |
| **[Phylip](#Phylip)**             | phylip                                    |
| **[PhyML](#PhyML)**               | phyml/2.4.4, phyml/2.4.5-mpi, phyml/3.0.0 |

## Infernal

Infernal ("INFERence of RNA ALignment") is for searching DNA sequence
databases for RNA structure and sequence similarities. It is an
implementation of a special case of profile stochastic context-free
grammars called covariance models (CMs). A CM is like a sequence
profile, but it scores a combination of sequence consensus and RNA
secondary structure consensus, so in many cases, it is more capable of
identifying RNA homologs that conserve their secondary structure more
than their primary sequence. Documentations can be found at [Infernal
homepage](http://infernal.janelia.org)

A parallel version is available. It can be used at Deimos like:

    bsub -n 4 -e %J_err.txt -a openmpi mpirun.lsf cmsearch --mpi --fil-no-hmm --fil-no-qdb 12smito.cm NC_003179.fas

## OpenProspect

The idea of threading is to use an existing protein structure to model
the structure of a new amino acid sequence. OpenProspect is an Open
Source Protein structure threading program. You can even generate your
own Protein Templates to thread sequences against. Once a sequence has
been aligned to a library of template, there are tools to analysis the
features of the alignments to help you pick out the best one.

Documentations can be found at [OpenProspect
homepage](http://openprospect.sourceforge.net/index.html).

#Phylip

## Phylip

This is a FREE package of programs for inferring phylogenies and
carrying out certain related tasks. At present it contains 31 programs,
which carry out different algorithms on different kinds of data.
Documentations can be found at [Phylip
homepage](http://cmgm.stanford.edu/phylip).

#PhyML

## PhyML

A simple, fast, and accurate algorithm to estimate large phylogenies by
maximum likelihood.

Documentations can be found at [PhyML
homepage](http://atgc.lirmm.fr/phyml).

-- Main.UlfMarkwardt - 2009-09-24
