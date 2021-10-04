# TensorBoard

TensorBoard is a visualization toolkit for TensorFlow and offers a variety of functionalities such
as presentation of loss and accuracy, visualization of the model graph or profiling of the
application.

## Using JupyterHub

The easiest way to use TensorBoard is via [JupyterHub](../access/jupyterhub.md). The default
TensorBoard log directory is set to `/tmp/<username>/tf-logs` on the compute node, where Jupyter
session is running. In order to show your own directory with logs, it can be soft-linked to the
default folder. Open a "New Launcher" menu (`Ctrl+Shift+L`) and select "Terminal" session. It
will start new terminal on the respective compute node. Create a directory `/tmp/$USER/tf-logs`
and link it with your log directory
`ln -s <your-tensorboard-target-directory> <local-tf-logs-directory>`

```Bash
mkdir -p /tmp/$USER/tf-logs
ln -s <your-tensorboard-target-directory> /tmp/$USER/tf-logs
```

Update TensorBoard tab if needed with `F5`.

## Using TensorBoard from Module Environment

On ZIH systems, TensorBoard is also available as an extension of the TensorFlow module. To check
whether a specific TensorFlow module provides TensorBoard, use the following command:

```console hl_lines="9"
marie@compute$ module spider TensorFlow/2.3.1
[...]
        Included extensions
        ===================
        absl-py-0.10.0, astor-0.8.0, astunparse-1.6.3, cachetools-4.1.1, gast-0.3.3,
        google-auth-1.21.3, google-auth-oauthlib-0.4.1, google-pasta-0.2.0,
        grpcio-1.32.0, Keras-Preprocessing-1.1.2, Markdown-3.2.2, oauthlib-3.1.0, opt-
        einsum-3.3.0, pyasn1-modules-0.2.8, requests-oauthlib-1.3.0, rsa-4.6,
        tensorboard-2.3.0, tensorboard-plugin-wit-1.7.0, TensorFlow-2.3.1, tensorflow-
        estimator-2.3.0, termcolor-1.1.0, Werkzeug-1.0.1, wrapt-1.12.1
```

If TensorBoard occurs in the `Included extensions` section of the output, TensorBoard is available.

To use TensorBoard, you have to connect via ssh to the ZIH system as usual, schedule an interactive
job and load a TensorFlow module:

```console
marie@compute$ module load TensorFlow/2.3.1
Module TensorFlow/2.3.1-fosscuda-2019b-Python-3.7.4 and 47 dependencies loaded.
```

Then, create a workspace for the event data, that should be visualized in TensorBoard. If you
already have an event data directory, you can skip that step.

```console
marie@compute$ ws_allocate -F scratch tensorboard_logdata 1
Info: creating workspace.
/scratch/ws/1/marie-tensorboard_logdata
[...]
```

Now, you can run your TensorFlow application. Note that you might have to adapt your code to make it
accessible for TensorBoard. Please find further information on the official [TensorBoard website](https://www.tensorflow.org/tensorboard/get_started)
Then, you can start TensorBoard and pass the directory of the event data:

```console
marie@compute$ tensorboard --logdir /scratch/ws/1/marie-tensorboard_logdata --bind_all
[...]
TensorBoard 2.3.0 at http://taurusi8034.taurus.hrsk.tu-dresden.de:6006/
[...]
```

TensorBoard then returns a server address on Taurus, e.g. `taurusi8034.taurus.hrsk.tu-dresden.de:6006`

For accessing TensorBoard now, you have to set up some port forwarding via ssh to your local
machine:

```console
marie@local$ ssh -N -f -L 6006:taurusi8034.taurus.hrsk.tu-dresden.de:6006 <zih-login>@taurus.hrsk.tu-dresden.de
```

Now, you can see the TensorBoard in your browser at `http://localhost:6006/`.

Note that you can also use TensorBoard in an [sbatch file](../jobs_and_resources/slurm.md).
