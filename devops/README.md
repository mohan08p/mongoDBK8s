# DevOps README file

This is a devops configuration directory where all respective files present.

The `terraform` directory contains a script to spin up a infrastrcture on AWS cloud. VPC, IGW, Router, Public and private availability zones, subnets and control node in the private subnet will get created using the script.

`pre1` shell file go and run on control node to install kubectl, eksctl abd setting and configuring aws-cli respectively.

`pre2` will install K8s cluster name `cluster-1` along with helm installation so that we can automate and easily manage K8s manifest files. It also creates a load balancer of type Ingress which we will use as a proxy to access jenkins with path based routing. Jenkins will be setup using helm and we configure the respective CI/CD plugins for it.

Then `k8s` directory container kubernetes manifest for deploying mongodb cluster onto EKS cluster created. We will use persistent storage as EBS volumes GP2 type for storing the mongodb database. And, replication set-up is configured using a shell script. In future we can use sidecar container to add a new secondary member to mongo replica.

#### Security 
I have follow AWS secuity principles while desigining the system. So, all best practice security policies are enforced in this system. The database not exposed to outside world.

The `Web Application Firewall(WAF)` is configured at the Load balancer so that we can do the rate limiting and aviod the DDoS attack which will flood at the load balancer. Also, we can configure rules to distribute load and apply necessary security measures to to take place.

The mongo database running

For CI/CD process we will leverage Jenkins shared library `https://github.com/mohan08p/jenkins-shared-library` which will created Jenkins pipeline using `Jenkinsfile` to configure the CI job which will create dynamic slave pods on-demand to build a project and created an artifact which we will push to private artifactory like JFrog. Then CI job deploys it to respective environment.
Control Flow
Jenkinsfile --> ci.groovy --> cd.groovy

NOTE: The CI/CD process still needs to be tested.