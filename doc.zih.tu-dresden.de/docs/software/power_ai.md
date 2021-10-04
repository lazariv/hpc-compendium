# PowerAI Documentation Links

There are different documentation sources for users to learn more about
the PowerAI Framework for Machine Learning. In the following the links
are valid for PowerAI version 1.5.4.

!!! warning
    The information provided here is available from IBM and can be used on partition ml only!

## General Overview

-   [PowerAI Introduction](https://www.ibm.com/support/knowledgecenter/en/SS5SF7_1.5.3/welcome/welcome.htm)
    (note that you can select different PowerAI versions with the drop down menu
    "Change Product or version")
-   [PowerAI Developer Portal](https://developer.ibm.com/linuxonpower/deep-learning-powerai/)
    (Some Use Cases and examples)
-   [Included Software Packages](https://www.ibm.com/support/knowledgecenter/en/SS5SF7_1.5.4/navigation/pai_software_pkgs.html)
    (note that you can select different PowerAI versions with the drop down menu "Change Product
    or version")

## Specific User Guides

- [Getting Started with PowerAI](https://www.ibm.com/support/knowledgecenter/SS5SF7_1.5.4/navigation/pai_getstarted.htm)
- [Caffe](https://www.ibm.com/support/knowledgecenter/SS5SF7_1.5.4/navigation/pai_getstarted_caffe.html)
- [TensorFlow](https://www.ibm.com/support/knowledgecenter/SS5SF7_1.5.4/navigation/pai_getstarted_tensorflow.html?view=kc)
- [TensorFlow Probability](https://www.ibm.com/support/knowledgecenter/SS5SF7_1.5.4/navigation/pai_getstarted_tensorflow_prob.html?view=kc)
  This release of PowerAI includes TensorFlow Probability. TensorFlow Probability is a library
  for probabilistic reasoning and statistical analysis in TensorFlow.
- [TensorBoard](https://www.ibm.com/support/knowledgecenter/SS5SF7_1.5.4/navigation/pai_getstarted_tensorboard.html?view=kc)
- [Snap ML](https://www.ibm.com/support/knowledgecenter/SS5SF7_1.5.4/navigation/pai_getstarted_snapml.html)
  This release of PowerAI includes Snap Machine Learning (Snap ML). Snap ML is a library for
  training generalized linear models. It is being developed at IBM with the
  vision to remove training time as a bottleneck for machine learning
  applications. Snap ML supports many classical machine learning
  models and scales gracefully to data sets with billions of examples
  or features. It also offers distributed training, GPU acceleration,
  and supports sparse data structures.
- [PyTorch](https://www.ibm.com/support/knowledgecenter/SS5SF7_1.5.4/navigation/pai_getstarted_pytorch.html)
  This release of PowerAI includes
  the community development preview of PyTorch 1.0 (rc1). PowerAI's
  PyTorch includes support for IBM's Distributed Deep Learning (DDL)
  and Large Model Support (LMS).
- [Caffe2 and ONNX](https://www.ibm.com/support/knowledgecenter/SS5SF7_1.5.4/navigation/pai_getstarted_caffe2ONNX.html)
  This release of PowerAI includes a Technology Preview of Caffe2 and ONNX. Caffe2 is a
  companion to PyTorch. PyTorch is great for experimentation and rapid
  development, while Caffe2 is aimed at production environments. ONNX
  (Open Neural Network Exchange) provides support for moving models
  between those frameworks.
- [Distributed Deep Learning](https://www.ibm.com/support/knowledgecenter/SS5SF7_1.5.4/navigation/pai_getstarted_ddl.html?view=kc)
  Distributed Deep Learning (DDL). Works on up to 4 nodes on partition `ml`.

## PowerAI Container

We have converted the official Docker container to Singularity. Here is
a documentation about the Docker base container, including a table with
the individual software versions of the packages installed within the
container: [PowerAI Docker Container](https://hub.docker.com/r/ibmcom/powerai/).
