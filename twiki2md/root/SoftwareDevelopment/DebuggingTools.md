Debugging is an essential but also rather time consuming step during
application development. Tools dramatically reduce the amount of time
spent to detect errors. Besides the "classical" serial programming
errors, which may usually be easily detected with a regular debugger,
there exist programming errors that result from the usage of OpenMP,
Pthreads, or MPI. These errors may also be detected with debuggers
(preferably debuggers with support for parallel applications), however,
specialized tools like MPI checking tools (e.g. Marmot) or thread
checking tools (e.g. Intel Thread Checker) can simplify this task. The
following sections provide detailed information about the different
types of debugging tools:

-   [Debuggers](Debuggers) -- debuggers (with and without support for
    parallel applications)
-   [MPI Usage Error Detection](MPI Usage Error Detection) -- tools to
    detect MPI usage errors
-   [Thread Checking](Thread Checking) -- tools to detect OpenMP/Pthread
    usage errors

-- Main.hilbrich - 2009-12-21
