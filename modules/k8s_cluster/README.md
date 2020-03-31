# IBM Cloud Monitoring with Sysdig Teams

Use this template to:
 - provision an IBM Cloud Kubernetes Service cluster in a classic or VPC infrastructure,

## Costs

You must have a Pay-as-You-Go account in IBM Cloud&trade; to follow the steps in this repository to create resources. Since the costs for these resources will vary, use the [Pricing Calculator](https://cloud.ibm.com/estimator/review) to generate a cost estimate based on your projected usage.

Some of the services listed above offer a limited free tier, i.e. IBM Cloud Kubernetes Service in the Classic infrastructure which you can use for testing. Please note the implication of using the free services as some will be deleted automatically after 30 days.

If you deploy paid services, make sure to delete them when they are no longer required in order to not incur charges in your account.

### Prerequisites
Before you start, make sure to have all the items completed below as the template requires them.  

Determine which [region](https://cloud.ibm.com/docs/Monitoring-with-Sysdig?topic=Sysdig-endpoints) you want to use. The value we will need is in the Region column and between the parentheses,i.e jp-tok, us-south, etc...

- This template requires an IBM Cloud API Key that will run with your permissions. Either create a new API key for use by this template or provide an existing one. An API key is a unique code that is passed to an API to identify the application or user that is calling it. To prevent malicious use of an API, you can use API keys to track and control how that API is used. For more information about API keys and how to create them, see [Understanding API keys](https://cloud.ibm.com/docs/iam?topic=iam-manapikey) and [Managing user API keys](https://cloud.ibm.com/docs/iam?topic=iam-userapikey).

- [Setup the Terraform CLI and the latest IBM Cloud Provider plug-in](https://cloud.ibm.com/docs/terraform?topic=terraform-tf-provider#install_cli)


## Getting started

1. Clone this repository to your local computer.
1. From a terminal window change to the `monitoring-sysdig-teams\modules\k8s_cluster` directory.
1. Copy the **config-template** directory to a directory called **config**.

### Create the cluster

1. From a terminal window, change to the `monitoring-sysdig-teams\modules\k8s_cluster` directory.
2. Enable tracing (optional):
    ```sh
    export TF_LOG=TRACE
    ```
3. Save all activities to a log file (optional):
    ```sh
    export TF_LOG_PATH=./config/config.log
    ```
4. Initialize the Terraform providers and modules:
    ```sh
    terraform init
    ```
5. Modify the config/config.tfvars to your own values.
    ```
      ibmcloud_api_key = "<your_ibm_cloud_api_key>"

      resource_group = "default"

      region = "us-south"

      resources_prefix = "<used_to_prefix_resources>"

      generation = 1

      flavor = "c2.2x4"

      cluster_infrastructure = "vpc"

      vpc_id = "<insert_vpc_id>"

      subnets = {
          zone-1   = "<insert_subnet_id_zone_1>"
          zone-2   = "<insert_subnet_id_zone_2>"
          zone-3   = "<insert_subnet_id_zone_3>"
        }
    ```

> Note: By default the template expects the Kubernetes cluster to have been created in a VPC Infrastructure, if you are creating the cluster in the Classic infrastructure set the `cluster_infrastructure` variable to *classic*. 

6. Execute terraform plan by specifying the location of variable files, state and plan file:
    ```sh
    terraform plan -var-file=config/config.tfvars -state=config/config.tfstate -out=config/config.plan
    ```
7. Apply terraform plan by specifying the location of plan file:
    ```sh
    terraform apply -state-out=config/config.tfstate config/config.plan
    ```

  > Note: If you plan on building for multiple environments or regions, you may want to maintain separate state files for each of these environments, you can use a different `config` directory for each environment or region.  Another solution is to use Terraform workspaces which is discussed in our [Plan, create and update deployment environments](https://cloud.ibm.com/docs/tutorials?topic=solution-tutorials-plan-create-update-deployments#plan-create-update-deployments) tutorial.


### Delete all resources
1. Destroy resource when done by specifying the location of variable files, and state file:
    ```sh
    terraform destroy -var-file=config/config.tfvars -state=config/config.tfstate
    ```
  > Note: This is not reversible all resources stored in the Terraform state will be removed.

## License

See [License.txt](License.txt) for license information.