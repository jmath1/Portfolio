# Project Architecture and Setup Procedure

This repository contains the infrastructure and backend for my portfolio project.

## Setup Procedure

1. **Clone the Repository**:
   ```sh
   git clone https://github.com/jmath1/Portfolio.git
   cd Portfolio
   ```
2. **Buy the domain that you plan to use**
   This requires a domain to be bought via AWS route53

3. **Create Environment Variables**
   copy the .env.template file and fill in the correct values pertaining to your application. If you application is
   jonathanmath.com then it should look like

   ```
   export TF_VAR_domain_name=jonathanmath
   export TF_VAR_tld=com
   ```

   You will also need a github Personal Access Token to add appropriate secrets to your repo for the github workflows

4. **Spin up the services using the task commands in the appropriate order**
   The architecture is divided into several stacks, each responsible for a different aspect of the system. The stacks should be set up in the following order and destroyed in reverse order:

   1. **Domain**: This stack sets up the domain-specific resources and configurations.
   2. **Network**: This stack configures the network settings, including VPCs, subnets, and routing.
   3. **Persistence**: This stack handles the setup of databases and other persistent storage solutions like AWS Secrets.
   4. **Registry**: This stack sets up the ECR repository to hold docker images.
   5. **Service**: This stack deploys the application services and ALB.
   6. **CI**: This stack configures the continuous integration and deployment pipelines, their access, and whatever additional secrets it might need.
