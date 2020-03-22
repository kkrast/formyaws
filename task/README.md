Task description 
1. Create public git repository 
2. Choose a free Cloud Service Provider and register a free account with AWS, Azure, etc. 
3. Automate provision of an Application stack running load balancer, web server and database of your choice, with the tools you like to use - Bash, Puppet, Chef, Ansible, Terraform, etc. Important - each of the services must run separately - on a virtual machine, container or as a service. 
4. Include service monitoring in the automation 
5. Automate service-fail-over, e.g. auto-restart of failing service 
6. Document the steps in git history and commit your Infrastructure-as-a-code in the git repo 
7. Send us link for the repository containing the finished solution
8. Present a working solution, e.g. not a powerpoint presentation, but a working demo

Solution description:
The solution consists of several AWS resources, all of them are created using Terraform IaC tool: 
- Network infrastructure, consisting of a newly created AWS VPC, with Internet Gateway, two public and  two private subnets, as well as Security Groups for Web and DB server instances
- Launch Template "lt-app-inst" for AppServer instances, which has UserData Bash script, installing Apache, PHP, and sample web site files after EC2 instance launch (including index.php and db configuration files).
  The sample application installation is borrowed from official AWS Help site (https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Tutorials.WebServerDB.CreateWebServer.html), and customized with functionality to demonstrate load-balancing, showing the serving IP address on every HTTP request
- Austoscalling group "as-app", which spreads on two AZs of us-east-1 region; uses LT "lt-app-inst", attaching the target group "tg-lp-app"; and has Healthchecks of type "ELB", that allows automatic creation of EC2 instances, replacing unhealthy ALB targets
- Target group "tg-lp-app", associated with the ALB "lb-app-frontend" and as healtcheck is defined path "/index.php"
- Application Load Balancer with HTTP listener (port 80), using as target group tg-lp-app
- AWS RDS MySQL instance, which endpoint URL is assigned automatically to CNAME record db.task.init of a private DNS zone "task.int", and "db.task.int" is configured as endpoint for PHP connection, inside index.php, created by UserData script of the Launch Template lt-app-inst

