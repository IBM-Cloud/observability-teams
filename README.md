# IBM Cloud Monitoring, Logging and Activity Tracker with Teams

Use this template to:
 - provision an IBM Cloud Monitoring instance,
 - provision an IBM Cloud Log Analysis instance,
 - deploy the monitoring agent to an existing IBM Cloud Kubernetes cluster,
 - deploy the logging agent to an existing IBM Cloud Kubernetes cluster,
 - deploy two simple applications to the cluster,
 - configure monitoring Teams with IAM integration,
 - configure logging Teams with IAM integration,
 - configure activity tracker Teams with IAM integration,
 - and monitor the deployed environment with secure access and limited visibility to the data that matters to you as the developer.

## What's in this repo

This repo has the following folder structure:

* [modules](/modules): This folder contains stand alone modules that are relevant to the main template.

    * [vpc](/modules/vpc): Create a VPC in IBM Cloud if you do not already have one and intend to deploy in VPC. Create a Kubernetes cluster in IBM Cloud in the VPC.

* [samples](/samples): This repository features two sample applications that generate metrics and limited logs that are pushed to IBM Cloud Monitoring and Log Analysis instances. 
    * The first application is written in [Node.js&reg;](https://nodejs.org/) and deployed to the [IBM Cloud&trade;](https://cloud.ibm.com/) Kubernetes service. 
    * The second application is written in [Go](https://golang.org/) and deployed to the [IBM Cloud&trade;](https://cloud.ibm.com/) Kubernetes service.

  <p align="center">
    <img src="docs/images/Architecture.png">
  </p>

  1. After having created a new Kubernetes cluster, use the provided Terraform template to create:
     - the montoring and log analysis instances, the teams inside of monitoring and log analysis,
     - the [IAM access groups](https://cloud.ibm.com/iam/groups), setup the policies and associate to a specific team,
     - deploy the monitoring and logging agents to the cluster.
  2. A developer deploys their containerized Node.js application to the cluster. Via the IAM access groups and associated monitoring team, she is able to access logs and metrics that are specific to her application. 
  3. A developer deploys their containerized Go application to the cluster. Via the IAM access groups and associated monitoring team, he is able to access logs and metrics that are specific to his application. 

## Costs

You must have a Pay-as-You-Go account in IBM Cloud&trade; to follow the steps in this repository to create resources. Since the costs for these resources will vary, use the [Pricing Calculator](https://cloud.ibm.com/estimator/review) to generate a cost estimate based on your projected usage.

Some of the services listed above offer a limited free tier, i.e. IBM Cloud Monitoring, IBM Cloud Log Analysis, and IBM Cloud Activity Trackler which you can use for testing and will work perfectly for our example application. Please note the implication of using the free services as some will be deleted automatically after 30 days.

If you deploy paid services, make sure to delete them when they are no longer required in order to not incur charges in your account.

### Prerequisites
Before you start, make sure to have all the items completed below as the template requires them.  

Determine which [region](https://cloud.ibm.com/docs/monitoring?topic=monitoring-endpoints) you want to use. The value we will need is in the Region column and between the parentheses,i.e jp-tok, us-south, etc...

- This template requires an IBM Cloud API Key that will run with your permissions. Either create a new API key for use by this template or provide an existing one. An API key is a unique code that is passed to an API to identify the application or user that is calling it. To prevent malicious use of an API, you can use API keys to track and control how that API is used. For more information about API keys and how to create them, see [Understanding API keys](https://cloud.ibm.com/docs/iam?topic=iam-manapikey) and [Managing user API keys](https://cloud.ibm.com/docs/iam?topic=iam-userapikey).

- Activity Tracker is a service that allows only one instance per IBM Cloud region, this template does not create an Activity Tracker instance for you, it requires instead that you provide the name of an existing Activity Tracker instance.  If you don't have one, follow these steps to create one: https://cloud.ibm.com/docs/activity-tracker?topic=activity-tracker-provision

- Follow the steps outlined in the [Kubernetes Service - Creating clusters](https://cloud.ibm.com/docs/containers?topic=containers-clusters) topic to create a Kubernetes cluster. You should create a cluster in a VPC, as this template only supports VPC based clusters. Once the instance is created, **save** the cluster ID for quick reference and proceed to the steps described below. To obtain the cluster ID
    > Note: If you are using an existing cluster in which you have already deployed the monitoring agent, you must [import the configuration of the agent deployment into your Terraform state](#importing-an-existing-monitoring-agent-deployment-into-the-terraform-state), however please note that when you run a Terraform destroy the agent will be removed from the cluster.

    > Note: To obtain the cluster ID either use the CLI: `ibmcloud ks clusters` or the **[Kubernetes console](https://cloud.ibm.com/kubernetes/clusters) > <cluster_name> > Overview** page.

-  If you are running on a Windows operating system [install Git](https://git-scm.com/), this template includes a shell script written in Bash and Git when installed on Windows will also include Git Bash that you can use to run the script.

- [Install IBM Cloud CLI](/docs/cli?topic=cloud-cli-install-ibmcloud-cli) and required plugins:
  - container-registry (0.1.454 or higher)
  - container-service/kubernetes-service (0.4.102 or higher)
  - vpc-infrastructure/infrastructure-service (0.5.11) (optional if you create a cluster inside of a VPC)

- [Install jq](https://stedolan.github.io/jq/).

- [Setup the Terraform CLI and the latest IBM Cloud Provider plug-in](https://cloud.ibm.com/docs/terraform?topic=terraform-tf-provider#install_cli)

- [Install Docker Desktop](https://www.docker.com/products/docker-desktop).

## Invite users to your account

This template will configure monitoring Teams integrated with IAM, as the owner of the instance, you will have full visibility into all of the teams that you create, i.e. you can switch to them and see what other users would see if they were added to those teams.  However, in order to get a more immersive experience, you need to have at minimum two additional users invited to the IBM Cloud account in which you will be creating these resources, follow the steps outlined below to invite users to your account:

1. Go to [Identity & Access > Users](https://cloud.ibm.com/iam/users) in the IBM Cloud console.
2. Click the **Invite Users** button.
3. Enter the e-mail address for two users and click on **Invite**

## Getting started

1. Clone this repository to your local computer.
1. From a terminal window change to the `observability-teams` directory.
1. Copy the **config-template** directory to a directory called **config**.

## Build and push the container image for the applications

Build and push the Docker image to the IBM Cloud container registry.

1. From a terminal window identify your IBM Cloud Container Registry hostname and save it for later use:

    a. Log in to the Container Registry service:
    ```
    ibmcloud cr login
    ```
    b. Obtain the hostname:
    ```
    ibmcloud cr region
    ```
2. Pick one of your existing registry namespaces or create a new one.
    To list existing namespaces, use:
    ```
    ibmcloud cr namespaces
    ```

    To add a new namespace, use:
    ```
    ibmcloud cr namespace-add <your_registry_namespace>
    ```

### Prepare the container image for the Go application

1. From a terminal window, change to the `samples/go-app` directory.
2. Build, tag (-t) to a image:
    ```
    docker build -t <your_region_registry>/<your_registry_namespace>/metrics-go-app .
    ```
3. Push the image to your container registry on IBM Cloud:
    ```
    docker image push <your_region_registry>/<your_registry_namespace>/metrics-go-app
    ```

### Prepare the container image for the Node.js application

1. Open a terminal window and change to the `samples/node-app` directory.
2. Build, tag (-t) to a image:
    ```
    docker build -t <your_region_registry>/<your_registry_namespace>/metrics-node-app .
    ```
3. Push the image to your container registry on IBM Cloud:
    ```
    docker image push <your_region_registry>/<your_registry_namespace>/metrics-node-app
    ```

### Deploy the application

1. From a terminal window, change to the repository root directory.
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

    resource_group = "<your_resource_group>"

    region = "<your_region>"

    resources_prefix = "<used_to_prefix_resources>"

    cluster_id = "<your_kubernetes_cluster_id>"

    go_image_repository = "<location_of_go_app_container_image>"

    node_image_repository = "<location_of_node_app_container_image>"

    team_go_members = ["<email_address_of_an_invited_user_to_your_ibm_cloud_account>"]

    team_node_members = ["<email_address_of_an_invited_user_to_your_ibm_cloud_account>"]

    activity_tracker_instance_name = "<name of existing activity tracker instance>"

    activity_tracker_service_key = "Your service key can be generated or retrieved from the LogDNA web application. Navigate to Settings > Organization > API Keys"

    logging_service_key = ""

    ```

> Note: By default the template expects the Kubernetes cluster to have been created in a VPC Infrastructure.

6. Execute terraform plan by specifying the location of variable files, state and plan file:
    ```sh
    terraform plan -var-file=config/config.tfvars -state=config/config.tfstate -out=config/config.plan
    ```
7. Apply terraform plan by specifying the location of plan file:
    ```sh
    terraform apply -state-out=config/config.tfstate config/config.plan
    ```

  > Note: If you plan on building for multiple environments or regions, you may want to maintain separate state files for each of these environments, you can use a different `config` directory for each environment or region.  Another solution is to use Terraform workspaces which is discussed in our [Plan, create and update deployment environments](https://cloud.ibm.com/docs/tutorials?topic=solution-tutorials-plan-create-update-deployments#plan-create-update-deployments) tutorial.

### Create a service key for the Logging instance

1. Log in to your IBM Cloud account from a browser.
2. Navigate to **Observability** > **Logging** page.
3. Click on the **Open dashboard** for your **<your_resources_prefix>-logging** instance.
4. From the navigation panel, click on **Settings (the gear icon)** and expand **Organization** and click on **API Keys**.
5. Click on **Generate Service Key**. 
6. Copy and paste the value provided for the service key into the `logging_service_key` variable of your `config/config.tfvars` file.

### Create a service key for your existing Activity Tracker instance

1. Log in to your IBM Cloud account from a browser.
2. Navigate to **Observability** > **Activity** page.
3. Click on the **Open dashboard** for the Activity Tracker instance in the region you are using.
4. From the navigation panel, click on **Settings (the gear icon)** and expand **Organization** and click on **API Keys**.
5. Click on **Generate Service Key**. 
6. Copy and paste the value provided for the service key into the `activity_tracker_service_key` variable of your `config/config.tfvars` file.

### Run Terraform Plan and Apply

1. Execute terraform plan by specifying the location of variable files, state and plan file:
    ```sh
    terraform plan -var-file=config/config.tfvars -state=config/config.tfstate -out=config/config.plan
    ```
2. Apply terraform plan by specifying the location of plan file:
    ```sh
    terraform apply -state-out=config/config.tfstate config/config.plan
    ```

### Verify metrics are visible to each designated team

1. Log in to your IBM Cloud account from a browser.
2. Navigate to **Observability** > **Monitoring** page.
3. Click on the **Open dashboard** for your **<your_resources_prefix>-monitoring** instance.
4. From the navigation panel, click on your initials, you should get a popup with a list of teams:
    - Monitor Operations
    - Team Go
    - Team Node
5. Switch to each team and notice the different perspectives as seen by each team:
    - Monitor Operations: You can see metrics from all containers
    - Team Go: You can see metrics only from containers related to the Go application
    - Team Node: You can see metrics only from containers related to the Node.js application.

### Verify metrics are visible to each account you added to a team

1. Log in to your IBM Cloud account from a browser with an account that you added to the Go team.
2. From the top nav bar, select to switch to the account this user was invited to.
3. Navigate to **Observability** > **Monitoring** page.
4. Click on the **Open dashboard** for your **<your_resources_prefix>-monitoring** instance.
5. Notice the user only has access to the data related to the relevant application/containers.
6. Repeat the above steps for the other accounts.

### Verify logs and activities are visible to each account you added to a team

1. Log in to your IBM Cloud account from a browser with an account that you added to the Go team.
2. From the top nav bar, select to switch to the account this user was invited to.
3. Navigate to **Observability** > **Logging** page.
4. Click on the **Open dashboard** for your **<your_resources_prefix>-logging** instance.
5. Content that is visible to you are specific to you only.  
6. Notice the user only has access to the data related to the Go application/containers.
7. Repeat the above steps for your instance of Activity Tracker. 
8. Repeat the above steps for the other accounts.

### Delete all resources
1. Destroy resource when done by specifying the location of variable files, and state file:
    ```sh
    terraform destroy -var-file=config/config.tfvars -state=config/config.tfstate -refresh
    ```
  > Note: This is not reversible all resources stored in the Terraform state will be removed.

2. Terraform will not delete the group that was created in Activity Tracker, you will need to delete this group manualy. Follow the steps outlined in the documentation here: https://cloud.ibm.com/docs/activity-tracker?topic=activity-tracker-group_data_access#groups_data_access_editing

## Tips and Tricks

### Importing an existing monitoring agent deployment into the Terraform State

Importing the namespace in which the monitoring agent was deployed:
  ```
  terraform import -var-file=config/config.tfvars -state-out=config/config.tfstate kubernetes_namespace.ibm_observe ibm-observe
  ```

Importing the service account for the monitoring agent:
  ```
  terraform import -var-file=config/config.tfvars -state-out=config/config.tfstate kubernetes_service_account.sysdig_agent ibm-observe/sysdig-agent
  ```

Importing the cluster role and cluster role binding:
  ```
  terraform import -var-file=config/config.tfvars -state-out=config/config.tfstate kubernetes_cluster_role.sysdig_agent sysdig-agent
  ```

  ```
  terraform import -var-file=config/config.tfvars -state-out=config/config.tfstate kubernetes_cluster_role_binding.sysdig_agent sysdig-agent
  ```

## Related Content

Tutorial: [Analyze logs and monitor application health](https://cloud.ibm.com/docs/tutorials?topic=solution-tutorials-application-log-analysis).

Tutorial: [Plan, create and update deployment environments](https://cloud.ibm.com/docs/tutorials?topic=solution-tutorials-plan-create-update-deployments#plan-create-update-deployments)


## License

See [License.txt](License.txt) for license information.
