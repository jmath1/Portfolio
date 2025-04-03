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
   3. **Registry**: This stack sets up the ECR repository to hold docker images.
   4. **Web**: This stack deploys the application services and ALB. This also handles the setup of databases and other persistent storage solutions like AWS
      Note: If TF_VAR_use_vpc is false then you will need to run the ansible playbook to setup nginx and ssl certs from within the ec2 instance instead of doing it with terraform using acm certs. Use `task apb -- deploy` to achieve this.
   5. **CI**: This stack configures the continuous integration and deployment pipelines, their access, and whatever additional secrets it might need.
   6. **Events** This stack is responsible for starting the EC2 instance and RDS instance at 8:30am and stopping them at 11pm for cost optimization.

5. **Run Ansible Playbook to Deploy the Application**
   Once the infrastructure is provisioned, the only thing left to do is deploy the application via Ansible using `task apb - deploy`. The Ansible inventory file will have already been created by Terraform at this point. This command sets up docker containers and nginx as necessary based on the requested configurations described below.

## Environment Variables for cost optimization

1.  `use_rds` - if this environment variable is set to `"true"`, the Terraform will provision an RDS instance and the Django app will connect to it. If it is `"false"`, a postgres container will be provisioned inside of the same EC2 instance that Django exists in, thus saving costs.
2.  `use_vpc` - this is a misnomer, since EC2 must always use a VPC, but if this is set to `"true"`, the Terraform will provision a specific VPC including public and private subnets for the database and ec2 instance. It will provision an ALB, NAT Gateway, ENI, ACM certs for SSL to the load balancer, and Route53 routes and VPC security groups to connect everything securely. It will also provision an Nginx service inside the EC2 instance that will listen on port 80 (from behind the SSL enabled ALB) and route requests to Django.

However, this was an expensive infrastructure stack for a portfolio website that isn't expecting tons of traffic. When this variable is set to `"false"` the only thing that is provisioned instead of all of the above is an Nginx service running inside of EC2 that will be doing the load balancing from a public facing address. This Nginx service will be listening on port 443, with SSL certs enabled by certbot from the EC2 instance rather than ACM, keeping things simple.
