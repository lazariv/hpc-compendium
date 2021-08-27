# TensorBoard

TensorBoard is a visualization toolkit for TensorFlow and offers a variety of functionalities such
as presentation of loss and accuracy, visualization of the model graph or profiling of the
application.
On ZIH systems, TensorBoard is only available as an extension of the TensorFlow module. To check
whether a specific TensorFlow module provides TensorBoard, use the following command:

```console
marie@compute$ module spider TensorFlow/2.3.1
```

If TensorBoard occurs in the `Included extensions` section of the output, TensorBoard is available.

## Using TensorBoard

To use TensorBoard, you have to connect via ssh to the ZIH system as usual, schedule an interactive
job and load a TensorFlow module:

```console
marie@login$ srun -p alpha -n 1 -c 1 --pty --mem-per-cpu=8000 bash   #Job submission on alpha node
marie@alpha$ module load TensorFlow/2.3.1
marie@alpha$ tensorboard --logdir /scratch/gpfs/<YourNetID>/myproj/log --bind_all
```

Then create a workspace for the event data, that should be visualized in TensorBoard. If you already
have an event data directory, you can skip that step.

```console
marie@alpha$ ws_allocate -F scratch tensorboard_logdata 1
```

Now you can run your TensorFlow application. Note that you might have to adapt your code to make it
accessible for TensorBoard. Please find further information on the official [TensorBoard website](https://www.tensorflow.org/tensorboard/get_started)
Then you can start TensorBoard and pass the directory of the event data:

```console
marie@alpha$ tensorboard --logdir /scratch/ws/1/marie-tensorboard_logdata --bind_all
```

TensorBoard will then return a server address on Taurus, e.g. `taurusi8034.taurus.hrsk.tu-dresden.de:6006`

For accessing TensorBoard now, you have to set up some port forwarding via ssh to your local
machine:

```console
marie@local$ ssh -N -f -L 6006:taurusi8034.taurus.hrsk.tu-dresden.de:6006 <zih-login>@taurus.hrsk.tu-dresden.de
```

Now you can see the TensorBoard in your browser at `http://localhost:6006/`.

Note that you can also use TensorBoard in an [sbatch file](../jobs_and_resources/batch_systems.md).
