# Hyperparameter Optimization (OmniOpt)

Classical simulation methods as well as machine learning methods (e.g. neural networks) have
a large number of hyperparameters that significantly determine the accuracy, efficiency, and
transferability of the method. In classical simulations, the hyperparameters are usually
determined by adaptation to measured values. Esp. in neural networks, the hyperparameters
determine the network architecture: number and type of layers, number of neurons, activation
functions, measures against overfitting etc. The most common methods to determine hyperparameters
are intuitive testing, grid search or random search.

The tool OmniOpt performs hyperparameter optimization within a broad range of applications as
classical simulations or machine learning algorithms.
Omniopt is robust and it checks and installs all dependencies automatically and fixes many
problems in the background. While Omniopt optimizes, no further intervention is required.
You can follow the ongoing stdout (standard output) live in the console.
Omniopt’s overhead is minimal and virtually imperceptible.

## Quickstart with OmniOpt

The following instructions demonstrate the basic usage of OmniOpt on the ZIH system, based
on the hyperparameter optimization for a neural network.

The typical OmniOpt workflow comprises at least the following steps:

1. [Prepare application script and software environment](#prepare-application-script-and-software-environment)
1. [Configure and run OmniOpt](#configure-and-run-omniopt)
1. [Check and evaluate OmniOpt results](#check-and-evaluate-omniopt-results)

### Prepare Application Script and Software Environment

The following example application script was created from
[https://pytorch.org/tutorials/beginner/basics/quickstart_tutorial.html](https://pytorch.org/tutorials/beginner/basics/quickstart_tutorial.html){:target="_blank"}
as a starting point.
Therein, a neural network is trained on the MNIST Fashion dataset.

There are three script preparation steps for OmniOpt:

  + Changing hard-coded hyperparameters (chosen here: batch size, epochs, size of layer 1 and 2)
  into command line parameters.
      Esp. for this example, the Python module `argparse` (see the docs at
      [https://docs.python.org/3/library/argparse.html](https://docs.python.org/3/library/argparse.html){:target="_blank"})
      is used.

    ??? note "Parsing arguments in Python"
        There are many ways for parsing arguments into Python scripts.
        The most easiest approach is the sys module (see
        [https://www.geeksforgeeks.org/how-to-use-sys-argv-in-python/](https://www.geeksforgeeks.org/how-to-use-sys-argv-in-python/){:target="_blank"}),
        which would be fully sufficient for usage with OmniOpt.
        Nevertheless, this basic approach has no consistency checks or error handling etc.

  + Mark the output of the optimization target (chosen here: average loss) by prefixing it with
  the RESULT string.
    OmniOpt takes the **last appearing value** prefixed with the RESULT string.
    In the example different epochs are performed and the average from the last epoch is catched
    by OmniOpt. Additionally, the RESULT output has to be a **single line**.
    After all these changes, the final script is as follows (with the lines containing relevant
    changes highlighted).

    ??? example "Final modified Python script: MNIST Fashion "
        ```python linenums="1" hl_lines="18-33 52-53 66-68 72 74 76 85 125-126"
        #!/usr/bin/env python
        # coding: utf-8

        # # Example for using OmniOpt
        # 
        # source code taken from: https://pytorch.org/tutorials/beginner/basics/quickstart_tutorial.html
        # parameters under consideration:# 
        # 1. batch size
        # 2. epochs
        # 3. size output layer 1
        # 4. size output layer 2

        import torch
        from torch import nn
        from torch.utils.data import DataLoader
        from torchvision import datasets
        from torchvision.transforms import ToTensor, Lambda, Compose
        import argparse

        # parsing hpyerparameters as arguments
        parser = argparse.ArgumentParser(description="Demo application for OmniOpt for hyperparameter optimization, example: neural network on MNIST fashion data.")

        parser.add_argument("--out-layer1", type=int, help="the number of outputs of layer 1", default = 512)
        parser.add_argument("--out-layer2", type=int, help="the number of outputs of layer 2", default = 512)
        parser.add_argument("--batchsize", type=int, help="batchsize for training", default = 64)
        parser.add_argument("--epochs", type=int, help="number of epochs", default = 5)

        args = parser.parse_args()

        batch_size = args.batchsize
        epochs = args.epochs
        num_nodes_out1 = args.out_layer1
        num_nodes_out2 = args.out_layer2

        # Download training data from open datasets.
        training_data = datasets.FashionMNIST(
            root="data",
            train=True,
            download=True,
            transform=ToTensor(),
        )

        # Download test data from open datasets.
        test_data = datasets.FashionMNIST(
            root="data",
            train=False,
            download=True,
            transform=ToTensor(),
        )

        # Create data loaders.
        train_dataloader = DataLoader(training_data, batch_size=batch_size)
        test_dataloader = DataLoader(test_data, batch_size=batch_size)

        for X, y in test_dataloader:
            print("Shape of X [N, C, H, W]: ", X.shape)
            print("Shape of y: ", y.shape, y.dtype)
            break

        # Get cpu or gpu device for training.
        device = "cuda" if torch.cuda.is_available() else "cpu"
        print("Using {} device".format(device))

        # Define model
        class NeuralNetwork(nn.Module):
            def __init__(self, out1, out2):
                self.o1 = out1
                self.o2 = out2
                super(NeuralNetwork, self).__init__()
                self.flatten = nn.Flatten()
                self.linear_relu_stack = nn.Sequential(
                    nn.Linear(28*28, out1),
                    nn.ReLU(),
                    nn.Linear(out1, out2),
                    nn.ReLU(),
                    nn.Linear(out2, 10),
                    nn.ReLU()
                )

            def forward(self, x):
                x = self.flatten(x)
                logits = self.linear_relu_stack(x)
                return logits

        model = NeuralNetwork(out1=num_nodes_out1, out2=num_nodes_out2).to(device)
        print(model)

        loss_fn = nn.CrossEntropyLoss()
        optimizer = torch.optim.SGD(model.parameters(), lr=1e-3)

        def train(dataloader, model, loss_fn, optimizer):
            size = len(dataloader.dataset)
            for batch, (X, y) in enumerate(dataloader):
                X, y = X.to(device), y.to(device)

                # Compute prediction error
                pred = model(X)
                loss = loss_fn(pred, y)

                # Backpropagation
                optimizer.zero_grad()
                loss.backward()
                optimizer.step()

                if batch % 200 == 0:
                    loss, current = loss.item(), batch * len(X)
                    print(f"loss: {loss:>7f}  [{current:>5d}/{size:>5d}]")

        def test(dataloader, model, loss_fn):
            size = len(dataloader.dataset)
            num_batches = len(dataloader)
            model.eval()
            test_loss, correct = 0, 0
            with torch.no_grad():
                for X, y in dataloader:
                    X, y = X.to(device), y.to(device)
                    pred = model(X)
                    test_loss += loss_fn(pred, y).item()
                    correct += (pred.argmax(1) == y).type(torch.float).sum().item()
            test_loss /= num_batches
            correct /= size
            print(f"Test Error: \n Accuracy: {(100*correct):>0.1f}%, Avg loss: {test_loss:>8f} \n")

            
            #print statement esp. for OmniOpt (single line!!)
            print(f"RESULT: {test_loss:>8f} \n")

        for t in range(epochs):
            print(f"Epoch {t+1}\n-------------------------------")
            train(train_dataloader, model, loss_fn, optimizer)
            test(test_dataloader, model, loss_fn)
        print("Done!")
        ```

  + Testing script functionality and determine software requirements.

### Configure and Run OmniOpt

As a starting point, configuring OmniOpt is done via a GUI at
[https://imageseg.scads.ai/omnioptgui/](https://imageseg.scads.ai/omnioptgui/).
This GUI guides through the configuration process and as result the config file is created
automatically according to the GUI input. If you are more familiar with using OmniOpt later on,
this config file can be modified directly without using the GUI.

A screenshot of the GUI, including a properly configuration for the MNIST fashion example is shown below.
The GUI, in which the displayed values are already entered, can be reached [here](https://imageseg.scads.ai/omnioptgui/?maxevalserror=5&mem_per_worker=1000&projectname=mnist-fashion-optimization-set-1&partition=alpha&searchtype=tpe.suggest&objective_program=bash%20%2Fscratch%2Fws%2Fpath%2Fto%2Fyou%2Fscript%2Frun-mnist-fashion.sh%20(%24x_0)%20(%24x_1)%20(%24x_2)&param_0_type=hp.randint&param_1_type=hp.randint&number_of_parameters=3){:target="_blank"}.

![GUI for configuring OmniOpt](misc/hyperparameter_optimization-OmniOpt-GUI.png)
{: align="center"}

### Check and Evaluate OmniOpt Results

TODO

## Details on OmniOpt

TODO

### Configuration

TODO

### Monitoring

TODO

### Evaluation of Results

TODO
