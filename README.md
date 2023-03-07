# Tutorial Cloud & HPC AI4ES

Este repositorio contiene los materiales para el tutorial enfocado en Cloud & HPC realizado dentro del contexto de la [red de excelencia AI4ES](https://www.ai4es.com/).

Concretamente, el tutorial se centra en la ejecución de experimentos en un servicio [Determined AI](https://www.determined.ai/) desplegado sobre un cluster [Kubernetes](https://kubernetes.io/) en Google Kubernetes Engine. El proceso de despliegue y configuración se implementa a través de [Terraform](https://www.terraform.io/) en base a las buenas prácticas de la metodología [Infrastructure as Code (IaC)](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/infrastructure-as-code).

* La carpeta [`classifier`](/classifier) contiene el código Python desarrollado sobre Determined AI para la ejecución de experimentos enfocados en el [entrenamiento y optimización de un clasificador para Fashion MNIST](https://docs.determined.ai/latest/tutorials/tf-mnist-tutorial.html).
* La carpeta [`infra`](/infra) contiene el código de configuración Terraform que describe toda la infraestructura. Por ejemplo, el cluster Kubernetes en GKE, el despliegue de Determined y el bucket de Google Cloud Storage.
