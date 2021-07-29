# Software Development and Tools

This section provides you with the basic knowledge and tools to get you out of trouble. It will tell
you:

- How to compile your code
- Using mathematical libraries
- Find caveats and hidden errors in application codes
- Handle debuggers
- Follow system calls and interrupts
- Understand the relationship between correct code and performance

Some hints that are helpful:

- Stick to standards wherever possible, e.g. use the **`-std`** flag
  for GNU and Intel C/C++ compilers. Computers are short living
  creatures, migrating between platforms can be painful. In addition,
  running your code on different platforms greatly increases the
  reliably. You will find many bugs on one platform that never will be
  revealed on another.
- Before and during performance tuning: Make sure that your code
  delivers the correct results.

Some questions you should ask yourself:

- Given that a code is parallel, are the results independent from the
  numbers of threads or processes?
- Have you ever run your Fortran code with array bound and subroutine
  argument checking (the **`-check all`** and **`-traceback`** flags
  for the Intel compilers)?
- Have you checked that your code is not causing floating point
  exceptions?
- Does your code work with a different link order of objects?
- Have you made any assumptions regarding storage of data objects in
  memory?

Subsections:

- [Compilers](compilers.md)
- [Debugging Tools](Debugging Tools.md)
  - [Debuggers](debuggers.md) (GDB, Allinea DDT, Totalview)
  - [Tools to detect MPI usage errors](mpi_usage_error_detection.md) (MUST)
- PerformanceTools.md: [Score-P](scorep.md), [Vampir](vampir.md), [Papi Library](papi_library.md)
- [Libraries](libraries.md)

Intel Tools Seminar \[Oct. 2013\]

- [TU-Dresden_Intel_Multithreading_Methodologies.pdf]**todo** %ATTACHURL%/TU-Dresden_Intel_Multithreading_Methodologies.pdf:
  Intel Multithreading Methodologies
- [TU-Dresden_Advisor_XE.pdf] **todo** %ATTACHURL%/TU-Dresden_Advisor_XE.pdf):
  Intel Advisor XE - Threading prototyping tool for software
  architects
- [TU-Dresden_Inspector_XE.pdf] **todo** %ATTACHURL%/TU-Dresden_Inspector_XE.pdf):
  Inspector XE - Memory-, Thread-, Pointer-Checker, Debugger
- [TU-Dresden_Intel_Composer_XE.pdf] **todo** %ATTACHURL%/TU-Dresden_Intel_Composer_XE.pdf):
  Intel Composer - Compilers, Libraries
