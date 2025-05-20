# The 6R's of Cloud Migrations

- Are a set of 6 different strategies of migrating systems into the cloud
- Starting point of a migration is the *discover*, *assess* and *prioritize* all the applications to migrate
- Once we have done this, there are 6 different ways of doing migrations:
    - **Rehosting**: lif and shift
    - **Replatforming**: lift and shift with optimizations
    - **Repurchase**: migrate the application while using something newer, example SaaS
    - **Refactoring / Re-architecting**: take advantage of the feature offered by the cloud
    - **Retire**: dump the applications which are no longer needed
    - **Retain**: do not migrate the application, not worth the time and money or it is too scary to migrate

## Rehosting

- Lift and shift or migrate as is: move the application with the least amount of changes into the cloud
- Generally used with legacy or monolithic applications
- Reasons to do application rehosting:
    - Reduce admin overhead using IaaS
    - Potentially easier to optimize the application when is running in the cloud compared to working with legacy tooling
    - Cost savings, consuming a certain type of instances
- Negatives:
    - We wont be able to take advantage of the full Cloud offerings
    - Potentially "kicking the can down the road" - delaying what we can do today until tomorrow
- For doing rehosting we can use VM Import/Export tools and Server Migration Service

## Replatforming

- Similar to rehosting with the addition of applying certain optimizations to the applications as part of the migration process
- We might decide to use RDS instead of self-managed database instances
- We might use ELBs instead of self managed load balancers
- We might use S3 as a backup or media storage
- Replatforming approach brings no real negatives but also no world-changing benefits
- Potential benefits of migration:
    - Admin overhead reduction
    - Performance benefits
    - More effective backups
    - Improved HA/FT

## Repurchasing

- Unless we have a reason to use self-managed application, we would rather use XaaS (Anything as a Service) products
- Examples of this kind of migrations:
    - MS Exchange => Microsoft 365
    - Self managed CRM => SalesForce
    - Self managed payroll => Xero
- Using a managed service reduces admin overhead, costs and risks. Almost always a preferred option

## Refactoring / Re-architecting

- Requires a full review of the architecture of an application
- The aim is to adopt cloud-native architecture and products
- We might look at adopting service-origin and microservice based architectures
- We might adopt a more API based architecture, event-driven architecture or serverless architecture
- This approach is initially very expensive and time-consuming
- In the long term it does offer the best benefits compared to other types of migrations
- Running a cloud-native application is often cheaper, much more scalable, has better HA/FT, costs are aligned with app usage

## Retire

- Systems are often running for no reasons
- Auditing their usage is often more work than leaving them to run
- A migration is perfect time to re-evaluate the usefulness of an application. If we don't need it, we should switch if off
- Often saves 10% to 20% cost in case of large scale migration

## Retain

- Essentially do nothing
- For some application the usage is uncertain with some complicating factors against being able to retire it or migrate it to the cloud
- In other cases some old applications might have some usage, but it wont worth the effort to move them to the cloud
- Or we might have a complex application - leave it till later
- Super-import application - risky to move
- The best advice is to complete the migration of other applications and swing back to focus on the left-overs

## 6R Migration Plan

![Migration Plan](images/6RsOfMigration.png)



# AWS Certificate Manager - ACM

- HTTPS (SSL/TSL) was designed to address security problems occurred with HTTP
- HTTPS provides data encryption in-transit and certificates to prove the identity
- ACM can function as a public certificate authority or a private certificate authority (CA)
- In case of a private CA applications need to be configured to trust the private CA
- With ACM we can generate or import certificates
- If ACM generates the certificate, it can renew it automatically. If imported, the user is responsible for renewal <span style="color: red;">EXAM</span>
- ACM can only deploy certificates to supported services (services in AWS which are integrated with ACM)
- Not all services all supported. Services which integrate with ACM are the following: load balancers, CloudFront, Cognito, Elastic Beanstalk, App Runner, API Gateway, AWS Nitro Enclaves, OpenSearch, AWS Network Firewall. EC2, for example, is not supported <span style="color: red;">EXAM</span>
- ACM is a regional service
- Certificates cannot leave the region they are generated or imported in, to use a certificate within an ALB in ap-southeast-2, the certificate needs to be in ACM in ap-southeast-2 (ACM is a regional service!!!) <span style="color: red;">EXAM</span>
- For global Services such as CloudFront, certificates should be stored in **us-east-1** !

# AD Connector (Directory Services)

- AD Connector provides a pair of directory endpoints in a VPC
- It injects ENIs into to subnets in a VPC
- Once injected AD connector appears as a native directory to other AWS instances capable of using a directory service
- Redirects requests to an existing on-premise directory server, which means no directory data is stored in AWS
- AD connector allows us to use AWS services which do require an AD directory (such as Workspaces) and use this with an on-premises directory service => we don't need to deploy additional AD directory in AWS
- There are 2 sizes of directory services *small* and *large*, while there are no explicit user limits, the chosen size does impact the amount of compute allocated by AWS for the connector
- We can use multiple connector to distribute the load
- AD directory is placed in 2 subnets in a VPCs in different availability zones => resilient to AZ failure
- The connector should be configured to point to at least one on-premise directory service => we need to provide account information for the connector to be able to authenticate itself
- Requires a working network to on-premise service, otherwise wont work (private network via Direct Connect or VPN)

## AD Connector Architecture

![AD Connector](images/DirectoryServiceADConnector.png)

## Use cases for AD Connector

- Prof of concept projects, we don't want to move our Active Directory to AWS for it
- We have a small infrastructure in AWS and we don't want to move the Active Directory to AWS
- Legal/compliance reasons - we don't want to store user info in AWS
- For larger requirements use AWS Directory Service

# API Gateway

- Is a service which lets us create and manage APIs
- API Gateway acts as endpoint or entry-point applications which want to talk with our services
- Sits between the application and integrations (services)
- API Gateway is HA and scalable
- Handles authorization, throttling, caching, CORS, transformations
- It also supports the OpenAPI spec and direct integration with other AWS services
- API gateway is a public service
- It can provide APIs using REST and WebSocket
- API Gateway overview:
    ![API Gateway Architecture](images/APIGateway.png)

## Authentication

- API Gateway supports a range of authentication types such as Cognito, Lambda based authentication (Custom based authentication - we can assume the client uses a Bearer token) and IAM credentials
- We can allow APIs to be open access without authentication

## Endpoint Types

- **Edge-Optimized**: any incoming request is routed to the nearest CloudFront POP (point of presence)
- **Region**: region endpoint for clients in the same region, it does not utilize the CloudFront endpoint
- **Private**: endpoints only accessible in a VPC via interface endpoints

## Stages

- When we deploy an API configuration, we are doing it into a stage
- Example we can have prod/dev stage with uniq settings and urls
- Deployments can be rolled back on a stage
- On stages we can enable canary deployments. When enabled, the deployment will be made to the canary not the stage itself
- Traffic distribution can be altered between canary and base stage
- Canary stage can be promoted to base

##  Errors

- `4XX` - Client errors: invalid request on the client side
- `5XX` - Server errors: valid request, backend issue
- `400 - Bad Request`: generic client side error
- `403 - Access Denied`: authorizer denies request, request is WAF filtered
- `429` - API Gateway can throttle: this means we have exceeded a specified amount of requests
- `502 - Bad Gateway Exception`: bad output returned by Lambda
- `503 - Service Unavailable`: backing endpoint is offline
- `504` - Integration Failure/Timeout (29s limit)

## Caching

- Caching is configured per stage
- We can define a cache on a stage (500 MB up to 237 GB)
- Cache TTL default value is 300 seconds, configurable between 0 and 3600s. Can be encrypted
- Calls only will reach the backend in case of a cache miss

## Methods and Resources

- API Gateway URL example: `https://1nj7i16t37.execute-api.us-east-1.amazonaws.com/dev/listcats`
- The URL can be represents the following: `[api-gateway-endpoint]/[stage]/[resource]`
- Stages are logical configurations. APIs are deployed into stages. Stages can be used for different application versions or lifecycle points for an API
- API changes only take effect after it is deployed into a stage
- Methods are the desired action to be performed. Methods are HTTP verbs
- Methods are where integrations are configured which provide the functionality of an API. Methods can integrate with Lambda, HTTP and other AWS services

## Integrations

- API Gateway is capable of connecting to Lambda, HTTP Endpoints (running on-premises or on AWS), Step Functions, SNS, DynamoDB
- APIs have 3 phases:
    - Request: authorize, validate and transform the request
    - Integrations
    - Response: transform, prepare and return the response
- The request and response phases are split into 2 parts:
    - Method Request: defines everything about the client request to method (path, headers, parameters)
    - Integration Request: parameters from the method request are transferred to the integrations
    - Integration Response: converts the data from the backend to a form which can be sent back to the client
    - Method Response: how the communication is delivered back to the client
- API methods which are on the client side decide what the client request to method is like. There are integrated to a backend endpoint via integrations
- Integration types:
    - **MOCK**: used for testing, no backed involved. It returns a static response
    - **HTTP**: http custom integration, backend is a HTTP endpoint. We have to configure both integration request and integration response
    - **HTTP Proxy**: subtype of the HTTP integration, but where proxying is utilized. Allows the access HTTP endpoint with a streamline integration. Proxying is where the request is passed to the endpoint as is and sent back to the client as is
    - **AWS**: allows an API to expose AWS services. We have to configure both the integration request and response and setup necessary mappings from the method request to the integration request. Can be used with Lambda functions, but it is relatively complex way of using it with Lambda
    - **AWS_PROXY (LAMBDA)**: integration request/response does not have to be defined, API Gateway passes the request unmodified
- Mapping template: used for non-proxy integrations. Used for:
    - Modify or rename parameters
    - Modify the body or header of the request
    - Filtering - remove anything from the request

## Mapping Templates

- Used for AWS and HTTP (non proxy) integrations
- It is able modify and rename parameters between the integrations
- It can modify the body or the headers of a request
- It can provide filtering by removing anything which is not needed
- Mapping uses VTL (Velocity Template Langue) for editing the request
- Use cases for mapping templates:
    - Integrate a REST API on API Gateway with a SOAP API

## Stages and Deployments

- Editing an API, we are editing settings which are not live (not published)
- The current state of the API needs to be deployed to a stage
- Each stage has its own configuration. Configurations are not immutable, can be modified, overwritten or rolled back
- Stage variables: environment variables for stages

## Swagger and OpenAPI

- OpenAPI (OAS) defines a standard language-agnostic interface to RESTful APIs
- OpenAPI v2 is formerly known as Swagger
- OpenAPI v3 is a more recent version
- OpenAPI defines endpoints, operation (GET, POST, etc.), input and output parameters and authentication methods
- API Gateway is capable of import OpenAPI format and generating it. Useful for backups and migrations

## AWS App Runner

- Fully managed service for deploying a containerized apps and APIs
- It is a PaaS solution with all components managed by AWS - we just bring our code and container image
- Integrates with GitHub and ECR for getting code or already built containers
- Provides the following features:
    - Auto scaling
    - Load balancing
    - Health checks
    - Observability
- App Runner applications can run inside in a VPC

# Application (Layer 7) Firewalls

- Layer 3/4 firewalls:
    - These kind of firewalls see packets, segments, IP addresses and ports
    - The data stream for a request and for the response are seen as separate
- Layer 5 firewalls:
    - Introduces session capability by seeing the request/response streams as a single session
    - With this it reduces admin overhead, with the addition of being able to implement more contextual security
- In both cases they don't understand anything above the layer they operate
- Layer 7 firewalls:
    - They understand various layer 7 protocols, such as HTTP
    - They can identify normal/abnormal elements of layer 7
    - They can protect against various protocol level attacks and weaknesses
    - In case of HTTPS, the encryption is terminated at the firewall in order for the data to be analyzed. A new HTTPS connection is created between the firewall and the server
    - Layer 7 firewalls can inspect, block replace or tag data. They can protect against things such as adult content, spam content, off topic content or malware

## WAF - Web Application Firewall

- It is Layer 7 Firewall (understands HTTP/S)
- Normally firewall operate at Layer 3, 4, 5
- WAF protects against complex Layer 7 attacks/exploits such as SQL Injection, Cross-Site Scripting
- It can filter based on location (Geo Blocks), and provides rate awareness
- Web Access Control List (WEBACL) are used by WAF to protect services and we associate them with ALB, API Gateway, CloudFront or with AppSync
- WEBACL has rules and they are evaluated when traffic arrives
- (WAF) Rules:
    - We have rules within Rule Groups in case fo WEBACL. Examples of AWS managed rule groups are:
        - ALLOW LIST/DENY LIST
        - SQL injection
        - XSS
        - HTTP Flood
        - IP reputation
        - Bots (protection against botnets)
- Web Access Control Lists (WEBACL):
    - They are the main unit of configuration within WAF
    - The starting point of a WEBACL is a Default Action (ALLOW or BLOCK) used for any traffic that is not matched
    - The WEBACL is created for CloudFront or for a regional service (ALB, API GW, AppSync)
    - We need to add Rule Groups/Rules for a WEBACL in order to accomplish any filtering. Rules/rule groups are processed in order
    - WEBACL have a limit of how much compute requirement can the rules use. AWS has a concept named WEBACL Capacity Units for this
    - WEBACL Capacity Units (WCU): indication for the complexity of rules, there is a limit of how many WCU can be on a single ACL. The default maximum is 1500 (can be increased with a support ticket)
    - Associating a WEBACL to a resource can take time (depending on the service), adjusting a WEBACL associated takes less time
    - A AWS resource can have 1 ACL, but 1 WEBACL can be associated with many resources. We can't associate a CloudFront ACL with other region services
    - AWS Outposts do not support WEBACLs
- Rule groups:
    - Groups of rules
    - They don't have default actions, the default action is defined when groups are added to WEBACLs
    - Rule groups can be Managed (AWS or Marketplace), Yours, Service Owned (Shield and Firewall Manager)
    - AWS managed rule groups are mostly available for free for AWS customers (AWS WAF bot control/fraud control have addition fees)
    - Rules groups attained by the marketplace has subscriptions attached
    - When we create a rule group we define upfront the WCU capacity (max 1500)
- Rules:
    - Structure of a rule: Type, Statement, Action
        - Type: determines at a high level how the rule works
        - Statement: one or more things which can match traffic or not
        - Action: what WAF does if traffic is matched
    - The type of a rule can be Regular or Rate-based
        - Regular: designed to match if something occurs
        - Rate-based: designed to match if something occurs after a given rate
    - Statement of a rule: define what the rules checks for
        - For regular rules WHAT does the rule match against
        - For rate-based rules we either apply a rate limit on a number of connection for a source IP address or we apply a rate limit on the nr of connections on an IP address for connection which match certain criteria
    - In terms of criteria we can match against:
        - Origin country
        - IP
        - Label
        - Header
        - Cookies
        - Query parameters
        - URI path
        - Query string body (first 8192 bytes only)
        - HTTP method
    - We can have different types of matches: exact match, starts with, contains, regular expression, etc.
    - We can also have more than one statement with AND, OR, NOT conditions
    - Action: 
        - For regular rules we can have allow, block, count, captcha, custom response/custom header(`x-amzn-waf-`), label
        - For rate based rules allow is not a valid action, we only have block, count and captcha
        - Custom response and custom header can be used with block action. For allow we can use a custom header only
        - Label can be added to traffic. Labels are WAF internal concept. They allow multi-stage flows, where first rule adds a label, the rule after that can run wether the label is present or not
- Pricing:
    - We are charged for every WEBACL per month (currently $5/month). WEBACL can be reused!
    - Rules on WEBACL are charged monthly (currently 1$/month)
    - We will be charged for every rule group or every managed rule group we add to our ACL
    - We will be charged for every request processed per ACL (monthly $0.60/1 million requests)
    - Optional security features can be enabled for additional costs:
        - Intelligent Threat Mitigation
        - Bot Control ($10/month) + ($1/1mil requests)
        - Captcha
        - Fraud Control/Account Takeover
    - Marketplace Rule groups come with extra charge

# AWS AppSync

- AppSync is a managed service which uses *GraphQL*
- It is used for building APIs on AWS which use *GraphQL*
- *GraphQL* makes it easy for applications to get the exact data they need. This includes combining data from multiple resources
- Datasets behind *GraphQL* can include:
    - NoSQL data stores
    - RDS databases
    - HTTP APIs
    - etc.
- AppSync integrates with (resolvers) DynamoDB, Aurora, ElasticSearch, etc.
- Supports customer resources using Lambda
- Provides support for real time data retrieval using WebSocket or MQTT on WebSocket protocols
- Mobile applications: replacement for Cognito Sync
- Requires a GraphQL schema for getting started
- Example for GraphQL schema:

    ```
    type Query {
        human(id: ID!): Human
    }

    type Human {
        name: String
        appearsIn: [Episode]
        starships: [Starship]
    }

    enum Episode {
        NEWHOPE
        EMPIRE
        JEDI
    }

    type Starship {
        name: String
    }
    ```

## Security

- Four ways we can authorize applications to interact with AppSync:
    - API_KEY
    - AWS_IAM
    - OPENID_CONNECT (OpenID Connect provider/ JWT)
    - AMAZON_COGNITO_USER_POOLS
- For custom domain & HTTPS, use CloudFront in front of AppSync

# ASG - Auto Scaling Groups

- Auto Scaling Groups provide auto scaling for EC2
- Provide the ability to implement a self-healing architecture
- ASGs make use of configurations defined in launch templates or launch configurations
- ASGs are using one version of a launch template/configuration
- ASG have 3 important values defined: *Minimum*, *Desired* and *Maximum* size. Desired size has to be more than the minimum size and less than Maximum size.
- ASG provides on foundational job: keeps the size of running instances at the desired size
- Archechturally ASG define where the EC2 instances are launcehd. They are attcahed to VPC and which subnets are configured within the VPC in ACG. 
- **Scaling Policies**: update the desired capacity based on some metric (CPU usage, number of connections, etc.)
    - They are essentially rules defined by us which can adjust the values of an ASG
    - Scaling policies are used with ASG.
    - Scaling types:
        - **Manual Scaling** : Manually adjusts the desired capcacity.
        - **Scheduled Scaling**: Scheduling based on know time window
        - **Dynamic Scaling**
        - **Predictive Scaling**: scale based on historical load to detect patterns in traffic flows
- Dynamic Scaling has 3 subtypes:
    - **Simple Scaling**: Based on Metric. Example "CPU above 50%  +1", "CPU Below 50% -1"
    - **Step Scaling**: scaling based on difference, allowing to react quicker
    - **Target Tracking**: example desired aggregate CPU = 40%. Not all metrics are supported by target tracking scaling
- **Cooldown Period**: a value in seconds, controls how long to wait after a scaling action happened before starting another action
- ASG monitor the health of instances, by default using the EC2 health checks
- ASG can integrate with load balancers: ASG can add/remove instances from a LB target group
- ASG can use the LB health checks in case of EC2 health checks

## Scaling Processes

- `Launch` and `Terminate`: if Launch is suspended, the ASG wont scale out / if Terminate is suspended the ASG wont scale in
- `AddToLoadBalancer`: add instance to LB
- `AlarmNotification`: control is the ASG reacts to CloudWatch alarms
- `AZRebalance`: balances instances evenly across all of AZs
- `HealthCheck`: controls if instance health checks are on/off
- `ReplaceUnhealthy`: controls if instances are replaced in case there are unhealthy
- `ScheduledActions`: controls if scheduled actions are on/off
- `Standby`: suspend any activities of ASG in a specific instance

## ASG Consideration

- ASG are free, we pay only for the instances provisioned
- We should use cool downs to avoid rapid scaling
- We should use smaller instances for granularity
- ASG integrates with ALBs
- ASG defines when and where, LT defines what

## Lifecycle Hooks

- Allow to configure custom actions which can occur during ASG actions
- When an ASG scales out/in instances may pause within the flow to allow execution of lifecycle hooks
- We can specify a timeout (36000s by default) for the lifecycle action, after the pause the system can decide if the ASG process continues or is abandoned
- We can resume the ASG process by calling `CompleteLifecycleAction`
- Lifecycle event hooks can be integrated with EventBridge or SNS notifications
![ASG Lifecycle Hooks](images/ASGArchitecture3.png)

## Scaling Policies

- ASGs don't need scaling policies, they can work just fine with none
- When created without a scaling policy, an ASG has static values for `MinSize`, `MaxSize` and `Desired` capacity
- Manual scaling: we manually adjust the values listed before; useful for testing or urgent situations or when we need to hold capacity at fixed number of instances
- In addition to manual scaling, we had different types of dynamic scaling policies. Each of these adjusts the desired capacity of an ASG based on a certain criteria
- Dynamic scaling policies:
    - **Simple Scaling**:
        - We define action which occur when a alarm goes to ALARM state. For example: add one instance if `CPUUtilization` is above 40%
        - Helps infrastructure scale out/in based on demand
        - This scaling is inflexible, add/remove static number of instances based on the status of an alarm
    - **Step Scaling**:
        - Adjust number of instances based on a number of step adjustments, that wary based on the size of the alarm brige
        - Example:
            - If the CPU usage is between 50-60%, do nothing
            - If the CPU usage is between 60 and 70%, add one instance
            - If the CPU usage is between 70 and 80%, add two instances
            - Finally, add 3 instances if the CPU usage is above 80%
        - Generally is better compared to Simple Scaling, allows us to adjust better to change load patterns
    - **Target Tracking**:
        - Comes with a predefined set of metrics: `CPUUtilization`, `AvgNetworkIn`, `AvgNetworkOut`, `AlbRequestCountPerTarget`
        - We define an ideal value, a target we want to track against for a supported metric
        - The ASG calculates the scaling adjustment based on the metric and the target value
        - The ASG keeps the metric at the target value we specified and adjusts the capacity as required
    - Scaling based on SQS - `ApproximateNumberOfMessagesVisible`:
        - Scaling is done based on the number of messages currently in the SQS queue
    - **Predictive Scaling**:
        - Predictive scaling uses historical data load to detect patterns in traffic flows and scale accordingly
        - Needs at least 24 hours of data to work, if available uses the past 14 days of data to analyze patterns
        - When enabled it will run in `forecast only` mode, in which no autoscaling action will take place. It will generate capacity forecasts which will allow us to evaluate the accuracy and the suitability of the autoscaling
        - After we review it, it will switch to `forecast and scale` mode
        - Maximum capacity limit: maximum number of EC2 instances that can be launched. We can allow the groups maximum capacity to be automatically increased
        - A core assumption of predictive scaling is that the Auto Scaling group is homogenous and all instances are of equal capacity. If this isn’t true, forecasted capacity can be inaccurate
- AWS recommends using Step Scaling instead of Simple Scaling policy

## ASG Health Checks

- ASGs assess the health of instances within their group using health checks
- If an instance fails health checks, it is replaced within the group => automatic healing
- There 3 different types of health checks that can be used by ASGs:
    - EC2 (default)
    - ELB (can be enabled)
    - Custom
- With EC2 health checks any of these statuses are viewed as unhealthy: Stopping, Stopped, Terminated, Shutting Down, Impaired (not 2/2 status checks)
- With ELB health checks in instance to be viewed as healthy it should be running and it should be passing the ELB health checks
- ELB health checks can be more application aware (Layer 7)
- Custom health checks: instances can be marked healthy/unhealthy by an external system
- Health check grace period:
    - It is configurable value, by default is 300s
    - It is a delay before health checks starting to check on a specific instance
    - Allows system launch, bootstrapping and application start

# Amazon Athena

- It is a serverless interactive querying service
- We can take data stored in S3 and perform ad-hoc queries on the data paying only for the data consumed
- Athena uses a process named **Schema-on-read** - table-like translation
- Original data in S3 is never changed, it remains in its original form. It is translated to the predefined schema when it is read for processing
- Supported formats by Athena: XML, JSON, CSV/TSV, AVRO, PARQUET, ORC, Apache, CloudTrail, VPC Flowlogs, etc. Supports standard formats of structured data, semi-structured and unstructured data
- "Tables" are defined in advance in a data catalog and data is projected through when read. It allows SQL-like queries on data without transforming source data
- Athena has no infrastructure. We don't need set up anything in advance
- Athena is ideal for situations where loading/transforming data isn't desired
- It is preferred for querying AWS logs: VPC Flow Logs, CloudTrail, ELB logs, cost reports, etc.
- Can query data form Glue Data Catalog and Web Server Logs
- Athena Federated Query: Athena now supports querying other data sources than S3. Requires a data source connector (AWS Lambda)

# AWS Audit Manager

- AWS Audit Manager helps us continually audit our AWS usage to simplify how we manage risk and compliance with regulations and industry standards
- Audit Manager provides prebuilt frameworks that structure and automate assessments for a given compliance standard or regulation
- We can create an assessment from any framework
- Audit Manager automatically runs resource assessments. These assessments collect data for the AWS accounts that we define as in scope for your audit
- After we complete an audit and we no longer need Audit Manager to collect evidence, we can stop evidence collection

## Amazon Aurora

## Aurora Architecture

- Aurora architecture is very different from RDS
- It uses the base entity of a cluster, which something that other instances of RDS database do not have
- Aurora does not use local storage for the compute instances, instead an Aurora cluster has a shared custom volume
- A cluster is made up from a number of important things:
    - A single primary instance + 0 or more replicas
    - The replicas can be used for read during normal operations
- Aurora uses a *Cluster*:
    - Made up of a single primary instance and 0 or more replicas
    - The replicas can be used for reads (not like the standby replica in RDS)
    - Storage: the cluster uses a shared cluster volume (SSD based by default). Provides faster provisioning, improved availability and better performance. Size can go up to 128 TiB
    - The storage has 6 replicas across AZs. The data is replicated synchronously. Replication happens at the storage level, no extra resources are consumed for replication
    - By default only the primary instance are able to write to the storage, replicas and the primary can perform read operation
    - Self-healing: Aurora can repair its data if a replica or part of the replica if there is a disk failure
    - Aurora uses the cluster to repair the data with no corruption. As a result, Aurora avoids data loss and reduces needs for point-in-time restores or snapshot restores
    - With Aurora can have up to 15 replicas, any of the replicas can be failed over to
    - Billing for Aurora storage:
        - Storage is billed to what we consume up to 128 TiB limit
        - High water mark: we get billed for the most used data at a time, in case of free-up we will be billed for the max usage consumed
        - In case we have to reduce data significantly, we will need to migrate the database to another cluster to avoid paying for the storage
        - Recently Aurora introduced dynamic resizing, where we have to pay for only what we use. It is recommended to upgrade our database to an Aurora version which supports dynamic resizing
    - Aurora clusters use endpoints, providing multiple endpoints:
        - **Cluster endpoint**: always point to the primary instance, can be used for reads and writes
        - **Reader endpoint**: points to the primary instance and also to the read-replicas. Aurora does load balancing we using this endpoint
        - **Custom endpoint**: can be created by us
        - **Instance endpoint**: each instance has its own endpoint

## Aurora Costs

- No free-tier option, Aurora does not support micro instances
- Beyond RDS singleAZ (micro) Aurora offers better value compared to other RDS options
- Compute: hourly charge, per second, 10 minute minimum
- Storage: GB/month consumed, IO cost per request made to the cluster's shared storage
- Backups: 100% DB size in backups are included

## Aurora Restore, Clone and Backtrack

- Backups in Aurora work the same way as other RDS
- Restores create a new cluster
- Backtrack can be enabled per cluster. They allow in-place rewinds to a previous point-in-time
- Fast clone: makes a new database much faster than copying all the data. Aurora references the original storage, only stores any differences between the old data and the new one

## Aurora Serverless

- It provides a version of Aurora without the need to statically provision the database instance
- Removes admin overhead for managing db instances
- Aurora Serverless uses the concept of ACU - Aurora Capacity Units: represent a certain amount of compute and a corresponding amount of memory
- We can set minimum and maximum ACU values per cluster, can go down to 0
- Consumption billing is per-second basis
- Aurora Serverless provides the same resilience as Aurora provisioned (6 copies across AZs)
- Aurora cluster architecture still exists, but in a for of serverless cluster. Instead of using provisioned instances we have capacity units
- Capacity units are allocated from a warm pool of Aurora instances managed by AWS
- ACUs are stateless, shared across multiple AWS customers
- If the load increases beyond the ACU limit and the pool allows it, than more ACU will be allocated to the instance
- In Aurora Serverless we have shared Proxy Fleet for connection management:
    - It is used to distribute connections from us, Aurora users, to Aurora capacity units
    - We never directly connect to Aurora, this makes Aurora scaling seamless
- Aurora use cases:
    - Infrequently used applications
    - New applications where we are unsure about the levels of load that will be places on the application
    - Variable and/or unpredictable workloads
    - Development and test databases: Aurora can be configured to stop itself
    - Multi-tenant applications where the scaling is aligned with infrastructure size and revenue

## Aurora Multi-Master

- Default Aurora mode is single-master: one read/write endpoint and 0 or more read replicas
- In contrast with default mode for Aurora, multi-master offers multiple endpoints which can be used for reads and writes
- There is no cluster endpoint to use, the application is responsible for connection to instances in the cluster
- Benefits:
    - Multiple writer endpoints, if we have an application which can failover between endpoints, the failover time can be significantly reduced
    - Fault tolerance can be implemented at the application level, but the application needs to manually load balance between the instances

# Regional and Global AWS Architecture

- There are 3 main type of architectures:
    - Small scale architectures: one region/one country
    - Small architecture with DR: one region + backup region for disaster recovery
    - Multiple region based systems
- Architectural components at global level:
    - Global Service Location and Discovery
    - Content Delivery (CDN) and optimization
    - Global health checks and Failover
- Regional components:
    - Regional entry point
    - Scaling and resilience
    - Application services and components
![Regional and Global Architecture](images/RegionalandGlobalInfrastructure2.png)


Web Tier : Customer facing layer. There would be regional based services like ALB or API gateway dependig on application architecture. Abstracts customers from underlying architecture.
Compute Tier: The infra to web tier is provided by compute tier using EC2, lambda or containers.
Storage Services: Service like EBS, EFS or S3.
Data Storage: Products like RDS, Aurora, DynamoDB, and RedShift.
Caching: Elastic cache for general caching, DynamoDB acclerator(DAX)
App Services: Kinesis, Step Functions, SQS, SNS



# AWS Batch

- Managed compute service commonly used for large scale data analytics and processing
- It is managed batch processing product
- Batch Processing: jobs that can run without end-user interaction, or can be scheduled to run as resources permit
- AWS Batch lets us worry about defining jobs, it will handle the underlying compute and orchestration
- AWS Batch core components:
    - Job: script, executable, docker container submitted to batch. Jobs are executed using containers in AWS. The job define the work. Jobs can depend on other jobs
    - Job Definition: metadata for a job, including IAM permissions, resource configurations, mount points, etc.
    - Job Queue: jobs are submitted to a queue, where they wait for compute environment capacity. Queues can have a priority
    - Compute Environment: the compute resources which do the actual work. Can be managed by AWS or by ourselves. We can configure the instance type, vCPU amount, spot price, or provide details on a compute environment we manage (ECS)
- Integration with other services:
    ![AWS Batch Integration](images/AWSBatch2.png)

## AWS Batch vs Lambda

- Lambda has a 15 minutes execution limit, for longer workflows we should use Batch
- Lambda has limited disk space in the environment, we can fix this by using EFS, but this would require the function to be run inside of a VPC
- Lambda is fully serverless with limited runtime selection
- Batch is not serverless, it uses Docker with any runtime
- Batch does not have a time limit for execution

# Managed vs Unmanaged AWS Batch

- Managed:
    - AWS Batch manages capacity based on our workload needs
    - We decide the instance type/size and if we want to use on-demand or spot instances
    - We can determine our own max spot price
    - We need to create VPC gateways for access to the resources
    - Using the managed compute environment we allow AWS the manage all the infra on our behalf, we just need to tweak some high level values
- Unmanaged:
    - We manage everything, we create the environment, we direct AWS to use that environment
    - Generally used if we have a full compute environment ready to go
    - Requires specific AMI for the EC2 instances


# BGP - Border Gateway Protocol

- BGP is a routing protocol
- Used to control how data flows from point A to point B
- BGP is made up from a lot of self managing networks know as Autonomous Systems (AS)
- AS could be a large network, collection of routes etc. and is viewed as a black box from BGP perspective
- Each AS is allocated a number by IANA, named ASN
- ASNs are 16 bit in length and range from 0 to 65535, the range from 64512 to 65534 is private
- We can get 32 bit ASN numbers as well (this is out of scope for this exam)
- ASNs are used by the BGP to identify different entities on the network
- BGP is designed to be reliable and distributed, and it operates of TCP/179
- It is not automatic, the communication between to AS should be done manually
- Autonomous Systems do exchange network topology information between them
- BGP is a path-vector protocol: it exchanges the best path to a destination between peers, the path is called **ASPATH** (Autonomous System Path)
- BGP does not take into account link speed or condition, it focuses on path only
- iBGP - internal BGP, routing within an AS
- eBGP - external BGP, routing between AS's
- BGP example:
    ![BGP 101](images/BorderGatewayProtocol101.png)
- BGP always choses the shortest path. There are ways to influence the path by artificially expending the path (prepending itself to the path)

# AWS Billing and Cost Management

## Cost Explorer

- Tracks and analyzes your AWS usage. It is free for all accounts
- Includes a default report that helps visualize the costs and usage associated with our TOP FIVE cost-accruing AWS services, and gives you a detailed breakdown on all services in the table view
- We can view data for up to last 12 months, forecast how much we are likely to spend for the next tree months and get recommendations on what Reserved Instances to purchase
- Cost Explorer must be enabled before it can be used. The owner of the account can enable it

## AWS Cost and Usage Reports

-  AWS Cost and Usage report provides information about our usage of AWS resources and estimated costs for that usage
- The AWS Cost and Usage report is a `.csv` file or a collection of `.csv` files that is stored in an S3 bucket. Anyone who has permissions to access the specified S3 bucket can see the billing report files
- We can use the Cost and Usage report to track your Reserved Instance Utilization, charges, and allocations
- For time granularity, we can choose one of the following:
    - Hourly: if we want our items in the report to be aggregated by the hour
    - Daily: if we want our items in the report to be aggregated by the day
    - Monthly: if we want our items in the report to be aggregated by month
- Report can be automatically uploaded into AWS Redshift and/or AWS QuickSight for analysis

## AWS Budgets

- Allows us to set custom budgets that will alert us when our costs or usage exceed or are forecasted to exceed your budgeted amount
- With Budgets, we can view the following information:
    - How close our plan is to our budgeted amount or to the free tier limits
    - Our usage to date, including how much you have used of your Reserved Instances and purchased Savings Plans
    - Our current estimated charges from AWS and how much your predicted usage will incur in charges by the end of the month
    - How much of our budget has been used
- Budget information is updated up to three times a day
- Types of Budgets:
    - **Cost budgets**: plan how much we want to spend on a service
    - **Usage budgets**: plan how much we want to use one or more services
    - **RI utilization budgets**: define a utilization threshold and receive alerts when your RI usage falls below that threshold
    - **RI coverage budgets**: define a coverage threshold and receive alerts when the number of your instance hours that are covered by RIs fall below that threshold
- Budgets can be tracked at the daily, monthly, quarterly, or yearly level, and we can customize the start and end dates
- Budget alerts can be sent via email and/or Amazon SNS topic
- First two budgets created are free of charge

# CI/CD

- CI/CD architecture:
    ![CI/CD architecture](images/CICD1.png)
- Branching architecture:
    ![Branching architecture](images/CICD2.png)
- Code pipeline:
    ![Code pipeline](images/CICD3.png)
- Each pipeline has stages
- Each pipeline should be linked to a single branch in a repository
    ![Code deployment](images/CICD4.png)
- CodeBuild/CodeDeploy configuration files:
    - `buildspec.yml, appspec.[yml|json]`
    - Reference to these files: [https://docs.aws.amazon.com/codedeploy/latest/userguide/reference-appspec-file.html](https://docs.aws.amazon.com/codedeploy/latest/userguide/reference-appspec-file.html)
    - buildspec is used to influence the way the build process occurs within CodeBuild
    - appspec allows the influence how the deployment process proceeds in CodeDeploy

## AWS CodeCommit

- Managed git service
- Basic entity of CodeCommit is a repository
- Authentication can be configured via IAM console. CodeCommit supports HTTPS, SSH and HTTPS over GRPC
- Triggers and notifications:
    - Notifications rules: can send notifications based on events happening in the repo, example: commits, pull request, status changes, etc. Notifications can be sent to SNS topics or AWS chat bots
    - Triggers: allow the generate event driven processes based on things that happen in the repo. Events can be sent ot SNS or Lambda functions

## AWS CodePipeline

- It is a Continuos Delivery tool
- Controls the flow from source code, through build towards deployment
- Pipelines are built from stages. Stages contain actions which can be sequential or parallel
- Movement between stages can happen automatically or it can require a manual approval
- Actions within stages can consume artifacts or they can generate artifacts
- Artifacts are just files which are generated and/or consumed by actions
- Any changes to the sate of a pipeline, stages or actions generate events which are published to Event Bridge
- CloudTrail can be used to monitor API calls. Console UI can be used to view/interact with the pipeline

## AWS CodeBuild

- CodeBuild is a build as a service product
- It is fully managed, we pay only for the resources consumed during builds
- CodeBuild is an alternative to the solutions provided by third party solutions such as Jenkins
- CodeBuild uses Docker for build environments which can be customized by us
- CodeBuild integrates with other AWS services such as KMS, IAM, VPC, CloudTrails, S3, etc.
- Architecturally CodeBuild gets source material from GitHub, CodeCommit, CodePipeline or even S3
- It builds and tests code. The build can be customized via `buildspec.yml` file which has to be located in the root of the source <span style="color: red;">Remember the spelling of file and location for EXAM</span>
- CodeBuild output logs are published to CloudWatch Logs, metrics are also published to CloudWatch Metrics and events to Event Bridge (or CloudWatch Events)
- CodeBuild supports build environments such as Java, Ruby, Python, Node.JS, PHP, .NET, Go and many more

### `buildspec.yml`

- It is used to customize the build process
- It has to be located in root folder of the repository
- It can contain four main phases:
    - `install`: used to install packages in the build environment
    - `pre_build`: sign-in to things or install code dependencies
    - `build`: commands run during the build process
    - `post_build`: used for packaging artifacts, push docker images, explicit notifications
- It can contain environment variables: shell, variables, parameter-store, secret-manager variables
- `Artifacts` part of the file: specifies what stuff to put where

## AWS CodeDeploy

- Is a code deployment as a service product
- It is an alternative for third-party services such as Jenkins, Ansible, Chef, Puppet or even CloudFormation
- It is used to deploy code, not resources (use CloudFormation for that)
- Uses docker for build environments, it can be customized
- CodeDeploy can deploy code to EC2, on-premises, Lambda and ECS
- Besides code, it can deploy configurations, executables, packages, scripts, media and many more
- CodeDeploy integrates with other AWS services such as KMS, IAM, VPC, CloudTrail, S3
- In order to deploy code on EC2 and on-premises, CodeDeploy requires the presence of an agent

### `appspec.[yaml|json]`

- It controls how deployments occur on the target
- Manages deployments: configurations + lifecycle event hooks
- Configuration section - has 3 important sections:
    - **Files**: applies to EC2/on-premises. Provides information about which files should be installed on the instance
    - **Resources**: applies to ECS/Lambda. For Lambda it contains the name, alias, current version and target version of a Lambda function. For ECS contains things like the task definition and container details (ports, traffic routing)
    - **Permissions**: applies to EC2/on-premises. Details any special permissions and how should be applies to files and folders from the files sections
- Lifecycle event hooks:
    - `ApplicationStop`: happens before the application is downloaded. Used for gracefully stop the application
    - `DownloadBundle`: agent copies the application to a temp location
    - `BeforeInstall`: used for pre-installation tasks
    - `Install`: agent copies the application from the temp folder to the final location
    - `AfterInstall`: perform post-install steps
    - `ApplicationStart`: used to restart/start services which were stopped during the `ApplicationStop` hook
    - `ValidateService`: verify the deployment was completed successfully<span style="color: red;">Remember for EXAM</span>

# CloudFormation

## Physical and Logical Resources

- CloudFormation begins with a template defined in YAML or JSON file
- The template contains logical resources (what we want to create)
- Templates can be used to create CloudFormation Stacks (one ore many stacks)
- The initial job of a stack is to create physical resources based on the logical resources defined in the template
- If a stack's template are changed, physical resources are changed as well
- If a stack is deleted, normally the physical resources are deleted

## Stacks

- A stack is a collection of AWS resources that you can manage as a single unit
- All the resources in a stack are defined by the stack's CloudFormation template
- Stack options:
    - Tags: key/value pairs attached to the stack. Can be used to identify the stack for cost allocation purposes
    - Permissions: IAM service role that can be assumed by CloudFormation
    - Stack failure options:
        - Specifies what to do if something fails while the stack is provisioned
        - Options:
            - Roll back all stack resources
            - Preserve successfully provisioned resources
    - Stack policy: defines the resources that we want to protect from unintentional updates during a stack update
    - Rollback configuration: we can monitor the stack while it is being created/updated and we can roll it back in case a threshold is breached (example if any alarm goes to ALARM state)
    - Notification options: we can specify an SNS topic where notifications should go
    - Stack creation options: following options are included for stack creation, but aren't available as part of stack updates:
        - Timeout: Specifies the amount of time, in minutes, that CloudFormation should allot before timing out stack creation operations

## Template Parameters and Pseudo Parameters

- Template parameters allow input via the console, CLI or API when the stack is created or updated
- Parameters are defined within the resources and they can be referenced from within the logical resources
- Parameters can have default values, allowed values, min/max length, allowed patterns, no echo (useful for passwords, the value is not displayed when typed) and types
- Pseudo Parameters: 
    - AWS makes available parameters which can be referenced by the CF template
    - Example:
        - `AWS::Region`
        - `AWS::StackId`
        - `AWS::StackName`
        - `AWS::AccountId`
    - Pseudo parameters are parameters which can not be populated by us, they are populated by AWS and provided for us to reference them
- Parameters provide portability for the template
- Best practice:
    - Minimize number of parameters and provide defaults where applicable
    - Use pseudo parameters where possible

## Intrinsic Functions

- Intrinsic functions can be used in templates to assign values to properties that are not available until runtime
- Examples of functions:
    - `Ref` and `Fn::GetAtt`: reference a value from one logical resource
    - `Fn::Join` and `Fn::Split`: join/split strings to create new ones
    - `Fn::GetAZs` and `Fn::Select`: get availability zones in a regions and select one
    - Conditions: `Fn::IF`, `And`, `Equals`, `Not`, `Or`
    - `Fn::Base64` and `Fn::Sub`: encode strings to base64, substitute replacement on variables in the text
    - `Fn:Cidr`: build CIDR blocks
- `Fn::GetAZs` - returns the available AZs in region. If the region has a default VPC configured, it return the AZs which are available in the default VPC

## Mappings

- Templates can contain a `Mappings` objects which can contain keys to values objects
- Mappings can have one level or tep and second level keys
- Mappings use another intrinsic function `Fn::FindInMap`
- Mappings are used to improve template portability
- Example:
    ```
    Mappings:
        RegionMap:
            us-east-1:
                HVM64: 'ami-xxx'
                HVMG2: 'ami-yyy'
            us-east-2:
                HVM64: 'ami-zzz'
                HVMG2: 'ami-vvv'
    ```

## Outputs

- The `Outputs` section in a template is optional
- We can declare values in this section which will be visible as output in the CLI/Console
- Output will be accessible from a parent stack when using nesting
- Outputs can be exported allowing cross-stack references
- Example:
    ```
    Outputs:
        WordPressUrl:
            Description: 'description text'
            Value: !Join['', 'https://', !GetAtt Instance.DNSName]
    ```

## Conditions

- Allows stack to react to certain conditions and change infrastructure based on those
- They declared in an optional section named `Conditions`
- We can declare many conditions, each of them being evaluated to `TRUE` or `FALSE`
- Conditions are evaluated before resources are created
- Conditions use other intrinsic functions: `AND`, `EQUALS`, `IF`, `NOT`, `OR`
- Any resource can have associated a condition which will define if the resource will be created or not
- Examples: we can have conditions which evaluate based on the environment (dev, test, prod) in which the template is executed
- Condition example:
    ```
    Conditions:
        IsProd: !Equals
            - !Ref EnvType
            - `prod`
    ```
- Conditions can be nested

## DependsOn

- Allows us to establish dependencies between resources
- CFN tried to be efficient by creating/updating/deleting resources in parallel
- Also, it tries to determine a dependency order (example: VPC => SUBNET => EC2) by using references or functions
- Dependency can be defined using the `DependsOn` property specify the resource on which we depend on
- `DependsOn` can accept a single resource or a list of resources

## Creation Policies, Wait Conditions and cfn-signal

- Creation Policies, Wait Conditions and cfn-signals provide a few ways to notify CFN with details signals on completion or not of creation of resources
- We can configure CFN to wait for a certain number of success signals
- We also configure a timeout within which the signals are received (max 12H)
- The the number of success signals are received within the timeout, CFN stacks moves to `CREATE_COMPLETE`
- `cfn-signal` is an utility running on the EC2 instances sending success/failure signals to CFN
- If the timeout is reached and the number of success signals are not met, the stack will fail creation
- For provisioning EC2 and ASG, we should us a `CreationPolicy`
- For other requirements we might chose to use a `WaitCondition`
- A `WaitCondition` is defined as a logical resource, meaning it can have `DependsOn` property. It can be used as a general progress gait in the template
- A `WaitCondition` relies on a `WaitHandle`, which is another logical resource. Its job is to generate a presigned url which can be used to send signals to `WaitCondition`
- With `WaitHandle` we can pass back data to the template. This data can be retrieved using the `!GetAtt WaitCondition.Data` function

## Nested Stacks

- Most simple projects will generally utilize a CFN stack
- Stacks can have limits:
    - Resource limit: 500 resources per stack
    - We can't easily reuse resources, example reference a VPC
- There are 2 ways to architect multi-stack projects:
    - Nested Stacks
    - Cross-Stack References
- Nested Stacks:
    - Root Stack: the stack which is created first, created manually or using some automation
    - A Parent Stack is the parent of any stack which it immediately creates
    - A root stack can create nested stacks having several parent stacks
    - A root stack can have parameters and outputs (just like a normals stack)
- A stack can have another CFN stack as a resource using `AWS::CloudFormation::Stack` type which needs an url to the template
- We can provide input values to the nested stacks. We need to supply values to any parameters from a nested stack if the parameter does not have a default value defined
- Any outputs of a nested stack are returned to the root stack which can be referenced as `NESTEDStack.Outputs.XXX`
- Benefits of a nested stack is to reuse the same template, not the actual stack created
- We should use nested stacks when we want to link the life cycles of different stacks

## Cross-Stack References

- CFN stacks are designed to be isolated and self-contained
- With nested stacks we can reuse code only, with cross-stack references we can reference resources created by other stacks
- Outputs are normally not visible from other stacks, exception being nested stacks which case the parent stack can reference the nested stack output
- Outputs of a template can be exported making them visible from other stacks
- Exports must have unique names in the region
- To use the exported resources we can use `Fn::ImportValue` intrinsic function
- Cross-region or cross-account is not supported for cross-stack references

## StackSets

- Allows to create/update/delete infrastructure across many regions or many accounts
- StackSets are containers in an admin account (account where the StackSet is applied, it does not have to be any special account)
- StackSets contain stack instances (containers for individual stacks) which reference stacks
- Stack instances and stacks are created in target accounts
- Each stack created by a StackSet is a stack created in one region in one account
- Security: we can use self-managed roles or service-managed roles (everything handled by the product). CFN will assume a role to interact with the target accounts
- Terminology:
    - Concurrent Accounts: a value specifying how in how many accounts can we deploy at the same time
    - Failure Tolerance: amount of individual deployments which can fail before declaring the StackSet itself as failed
    - Retain Stacks: remove stack instances from a StackSet but retain the infrastructure
- StackSet use cases:
    - Crate AWS Config Rules
    - Create IAM Roles for cross-account access

## DeletionPolicy

- If we delete a logical resource from a template, by default the physical resource will be deleted by CFN
- With certain type of resources this can cause data loss
- With deletion policy, we can define on each resource to **Delete** (default), **Retain** or **Snapshot** (if supported)
- Supported resources for snapshot are: EBS volumes, ElastiCache, Neptune, RDS, Redshift
- With snapshot before the physical resource is deleted, a snapshot is taken
- Deletion policies only apply to delete operation, NOT replace operation!

## Stack Roles

- By default CFN uses the permissions of the identity who initiates the stack creation
- CFN stack roles is feature where CFN can assume a role to gain permissions to create resources from a stack without the need for the initiator to have the necessary permissions
- The identity creating the stack does not need resource permissions, only `PassRole`

## `AWS::CloudFormation::Init` and `cfn-init`

- CloudFormationInit is a simple configuration management system
- Configuration directive are stored in the template
- `AWS::CloudFormation::Init` is part of EC2 instance logical resource. With this we can specify configurations which will be applied to the created EC2 instance
- User Data is procedural (HOW should things to be done) / `cfn-init` is a desired state (WHAT we want to occur)
- `cfn-init` can be cross-platform and idempotent
- Accessing the CFN init data is done with the `cfn-init` helper script which should be installed on the instance

## `cfn-hup`

- `cfn-init` is a helper tool running once as part of bootstrapping (user data)
- If the `AWS::CloudFormation::Init` is updated, `cfn-init` is not rerun
- `cfn-hup` is a helper tool which can be installed on EC2 instances
- It will detect changes in the resources metadata
- When change is detected, it can run configurable actions. It might rerun `cfn-init` if necessary

## Change Sets

- Change Sets let us preview the changes that will happen after we update a stack
- We can have multiple change sets and preview each of them
- We can chose which change set we want to apply by executing it

## Custom Resources

- CloudFormation doesn't support everything in AWS
- Custom Resources let CFN integrate with anything it does not yet support or wont support at all
- With Custom Resources we can extend CFN to do things which it does not natively support (example: fet configuration from a third party)
- Architecture of custom resources:
    - CFN sends data to an endpoint defined in the custom resource
    - This endpoint might be a Lambda function or an SNS topic
    - When a custom resources is created/update/deleted, CFN sends events to this endpoint containing the operation and any additional property information
    - The compute (Lambda function) can respond to this custom data, letting it know of the success/failure of its execution

# CloudFront

- It is a content deliver network (CDN)
- Its job is to improve the delivery of content from its original location to the viewers of the content
- It is accomplishing this by caching and by using an efficient global network

## CloudFront Terms and Architecture

- **Origin**: the source location of the content, can be S3 or custom origin (publicly routable IPv4 address)
- **Distribution**: unit of configuration within CloudFront, which gets deployed out to the CloudFront network. Almost everything is configured within the distribution directly or indirectly
- **Edge Location**: pieces of global infrastructure where the content is cached. They are smaller than AWS regions. They are way bigger in number than AWS locations and more widely distributed. Can be used to distribute static data only
- **Regional Edge Cache**: larger version of an edge location, but there are fewer of them. Provides another layer of caching
- CloudFront Architecture:
    ![CloudFront Architecture](images/CloudFrontArchitecture1.png)
- If we are using S3 origins, the region edge location is not used in case there is a cache miss for the edge location. Only custom origin can use the regional edge cache!
- **Origin fetch**: the content is fetched from the origin in case of a cache miss on the edge location
- **Behavior**: it is configuration within a distribution. Origins are directly linked to behaviors, behaviors are linked to distributions
    ![CloudFront Behavior](images/CloudFrontArchitecture2.png)

## CloudFront Behaviors

- Distributions are units of configuration in CF, lots of high level options are configured on the distribution level:
    - Price class
    - Web Application Firewall attachment
    - Alternate domain names
    - Type of SSL certificate
    - SNI configuration
    - Security policy
    - Supported HTTP versions
    - etc.
- A single distribution can have one (default behavior) or multiple behaviors
- Any incoming request is pattern matched against behavior's pattern
- The default behavior has a wildcard (`*`) pattern and it will match anything that was not matched by other more specific behavior
- Once a request is pattern matched against a behavior, it will become subject ot the behavior's configurations which can be the following:
    - Origin or origin group
    - Viewer protocol policy (redirect HTTP to HTTPS)
    - Allowed HTTP methods
    - Field level encryption
    - Cache directives - we can use:
        - Legacy cache settings
        - Cache policy nad origin request policy (recommended by AWS)
    - TTL (min, max, default)
    - Restrict viewer access to a behavior: sets the entire behavior to restricted or private. If we select this , we need to specify the trusted authorization type, which can be:
        - Trusted key groups (recommended by AWS)
        - Trusted signer (legacy)
    - Compress objects automatically
    - Associate Lambda@Edge function

## TTL and Invalidations

![TTL and Invalidations](images/CloudFrontTTL.png)
- And edge location views an object as not expired when it is within its TTL period
- More frequent cache hits = lower origin loads
- Default validity period of an object (TTL) is 24 hours. This is defined in the behavior
- Minimum TTL, maximum TTL: set lower or upper values which an individual object's TTL can have
- Object specific TTL values can be set by the origins using different headers:
    - Cache-Control `max-age` (seconds): TTL value in seconds for an object
    - Cache-Control `s-maxage` (seconds): same as `max-age`
    - Expires (Date and Time): expiration date and time
- For all of these headers if they specify a value outside of minimum, maximum range, the min/max value will be used
- Custom headers for S3 origins can be configured in object's metadata
- Cache invalidations are performed in a distribution and it applies to all edge locations (it takes time)
- Cache invalidation invalidates every object regardless of the TTL value, based on the invalidation pattern
- There is a cost allocated when invalidation is applied. This cost is the same regardless of the number of files we invalidate
- Instead of invalidation we may consider **versioned file names**
- Versioned file names also help to:
    - Avoid using local browser cache in case of a newer file
    - Help improve logging
    - Reduce cost, no need for manual invalidation
- S3 object versioning and versioned file names should not be confused!

## CloudFront and SSL

- Each CF distribution receives a default domain name (CNAME)
- HTTPS can be enabled by default for this address
- CF allows alternate domain names (CNAME)
- Process of adding alternate domain names:
    - If we use HTTPS, we need a certificate applied to the distribution which matches that name
    - Even if we don't want to use HTTPS, we need a way verifying that we own and control the domain. This is accomplished by adding an SSL certificate which matches the the name we are adding to the CF distribution
    - The result is we need to add an SSL certificate wether we are using HTTPS or not
- SSL certificates are imported using ACM (AWS Certificate Manager)
- ACM is a regional service, because of this the certificate for global services (such as CF) needs to be imported in *us-east-1* region
- Option we can set on a CF behavior for handling HTTP and HTTPS:
    - We can allow both HTTP and HTTPS on a distribution
    - We can redirect HTTP to HTTPS
    - We can restrict to only allow HTTPS (any HTTP will fail)
- There are two sets of connections when any individual is using CF:
    - Viewer => CF (viewer protocol)
    - CF => Origin (origin protocol)
- Both connections need valid public certificates as well as any intermediate certificates. Self-signed certificates will not work!
- If our origin is S3, we don't have to worry about this certificate for the origin protocol. S3 handles this natively on it own. We don't/can't apply certificates to S3 buckets

## CloudFront and SNI (Server Name Indication)

- Historically every SSL enabled site needed its own IP
- Encryption for HTTP/HTTPS happens on the TCP connection level
- Host header happens after that at Layer 7. It allows to specify to which application we want to connect in case multiple applications run on the same server
- TLS encryption happens before deciding which application we want to access
- In 2003 an extension was added to TLS: SNI - allowing to specify which domain we want to access. This occurs in the TLS handshake, before HTTP being involved
- This allows one server with a single IP to host many HTTPS websites which need their own certificates
- Older browser do not necessary support SNI. CF needs to allocate dedicated IP addresses for these users, at extra charge
- CF can be used in SNI mode (free) or allocating extra IP addresses ($600 per month per distribution)
- CloudFront SSL/SNI architecture:
    ![SSL/SNI architecture](images/CloudFrontSSLSNI.png)
- For S3 origin, we don't need to apply certificates for the origin protocol. For ALB/EC2/on-prem we can have public certificates which needs to match the DNS name of the origin

## Origin Types and Architecture

- Origins are the locations from where CF goes to get content
- If there is a cache miss in case of a request, than an origin fetch occurs
- Origin groups allow us to add resiliency. We can group origins together an have an origin group used by the behavior
- Categories of origins:
    - Amazon S3 buckets
    - AWS media package channel endpoint
    - AWS media store container endpoint
    - everything else (web-servers) - custom origins
- If S3 is configured to be used as a web-server, CF views it as a custom origin
- S3 origin configuration options:
    - Origin Path: we can use a path from the bucket instead of the top level of the bucket
    - Original access control settings: it is used to restrict access to the bucket only to CloudFront. The legacy version of this was Origin Access Identity
    - Origin Access Identity (legacy): same purpose as the origin access control
    - Add custom headers (optional): we can pass custom headers to the origin S3 bucket
- In case of S3 the viewer protocol is matched with the origin protocol. This means if we use HTTP for the end-users, CF will also use HTTP to access the bucket
- Custom origin configuration options:
    - Origin Path: we can configure to use a sub-path to access the origin
    - Minimum Origin SSL Protocol: minimum TLS protocol version to be used with the origin. Best practice is to select the latest supported by the origin
    - Origin Protocol Policy: HTTP only, HTTPS only or Match Viewer protocol policy
    - HTTP/HTTPS Port: we can use arbitrary port instead of 80 or 443 for being able to connect to the origin
    - Origin Custom Headers: pass custom headers to the origin. Can be used for security to restrict access only from CF

## Caching Performance and Optimization

- Cache Hit: object is available in the cache in the edge location
- Cache Miss: object is not available in the cache, origin fetch is required
- To increase performance we need the maximize the ration between cache hit and cache miss
- We can retrieve objects from CF based on these:
    1. When we require an object from CF, we usually request it using its name
    2. We can use query string parameters as well, example `index.html&lang=en`
    3. Cookies
    4. Request Headers
- When using CF all of this data reaches CloudFront first and than can be forwarded to the origin
- We can configure CF to cache data based on some or all of these request properties
- These choices affect how performant would be the data retrieval from our CF distribution
- Optimization recommendations:
    - When using CF we should forward only the headers needed by the application and cache data based only on what can change the object
    - The more things are involved in caching, the less efficient the process is

## CloudFront Security

### OAI/OAC and Custom Origins

- S3 origins:

    - OAI - Origin Access Identity (legacy): 
        - Is a type of identity, it can be associated with CloudFront distributions
        - Essentially the CloudFront distributions "becomes" the OAI, meaning that this identity can be used in S3 bucket policies
        - Common pattern is to lock the S3 bucket to be only accessible to CloudFront
        - The edge locations gains the attached OAI identity, meaning they will be able to access the bucket
        - Direct access from the end-user to the bucket content can be disabled with a bucket policy
        - OAIs can be created and used one many CF distributions and many buckets at the same time. It is easier to manage one OAI with one CF distribution
    - OAC -  Origin Access Control (recommended):
        - Used for the same purpose as OAI - restrict access to bucket to CF only
        - If enabled CF will sign each request to S3 bucket
        - Once enabled, we will have to adjust the bucket policy to allow request from the CF distribution
- Custom origins:
    - We can not use OAI to control access!
    - We can utilize custom headers, which will be protected by the HTTPS protocol. CloudFront will be configured to send this custom header
    - Other way to handle CloudFront security from custom origins is to determine the IP ranges from which the request is coming from. CloudFront IP ranges are publicly available

### Private Distributions

- CloudFront can run in 2 different modes:
    - Public: can be accessed by any viewer
    - Private: requests to CloudFront needs to be made with a signed url or cookie
- If the CloudFront distribution has only 1 behavior the whole distribution is considered to be either public or private
- In case of multiple behaviors: each behavior can be either public or private
- There are 2 ways two configure private behaviors in CF:
    - The old way: in order to enable private distribution of content, we need to create a **CloudFront Key** by an Account Root User. That account is added as a **Trusted Signer**
    - The new (preferred) way:
        - Create Trusted Key Groups and assign them signers
        - They key groups determine which keys can be used to create signed urls and signed cookies
        - Few reasons we might use this compared to the legacy approach:
            - We don't need the root user from the account to manage CF keys
            - We can manage keys groups with CF API and we can associate a higher number of keys with our distribution/behavior giving us more flexibility
- Signed URLs vs Cookies:
    - Signed URLs provide access to one particular object
    - We should use signed urls if the client does not support cookies
    - Signed cookies can provide access to groups of objects or all files of a particular type
    - With signed cookies we can maintain the application's URL if this is important

### CloudFront Geo Restriction

- Gives a way to restrict content to a particular location
- They are 2 types of restriction:
    - CloudFront Geo Restriction:
        - Whitelist or Blacklist countries
        - **Only works with countries!**
        - Uses a GeoIP database with 99.8% claimed accuracy
        - Applies to the entire distribution
        ![Geo Restriction Architecture](images/CloudFrontGeoRestriction.png)
    - 3rd Party Geolocation:
        - Completely customizable, can be used to filter on lots of other attributes, example: username, user attributes, etc.
        - Requires an application server in front of CloudFront, which controls weather the customer has access to the content or not
        - The application generates a signed url/cookie which is returned to the browser. This can be sent to CloudFront for authorization
        ![3rd Party GeoLocation Architecture](images/CloudFront3rdPartyGeoLocation.png)

### Field-Level Encryption

- We can configure encryption ath the edge location for certain fields from the request using a public key
- Useful for encrypting sensitive data such as passwords, payment information, etc. at the edge locations
- Field-Level encryption happens separately from the HTTPS tunnel
- A private key is needed to decrypt individual fields
- Decryption of the encrypted fields can be done at the origin, if necessary
- Field-Level encryption architecture:
    ![Field-Level encryption architecture](images/FieldLevelEncryption2.png)

## Lambda@Edge

- Lambda@Edge allows us to run lightweight Lambda functions at the edge locations
- These Lambda functions allow us to adjust data between the viewer and the origin
- Lambda functions running at the edge don't have the full Lambda feature set:
    - Currently only NodeJS and Python are supported
    - Functions don't have access to any resources in a VPC, they run in AWS public space
    - Lambda Layers are not supported
- They have different size and duration limits compared to classic Lambda functions:
    - Viewer side: 128 MB limit in size / function timeout is 5 seconds
    - Origin side: function size is the same as classic Lambda / function timeout is 30 seconds
- Lambda@Edge use cases:
    - A/B testing - generally done with Viewer Request function. Lambda function can view the request from the viewer and can modify the response accordingly
    - Migration between S3 origins - generally done with an Origin Request function
    - Different objects based on the type of device - generally done with an Origin Request function
    - Content displayed by country - generally done with an Origin Request function
    - More examples: [https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/lambda-examples.html#lambda-examples-redirecting-examples](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/lambda-examples.html#lambda-examples-redirecting-examples)

# CloudHSM

- Similar to KSM, it creates, manages and secures cryptographic material or keys
- KMS is a shared service. AWS has a certain level of access to the product, they manage the hardware and the software of the system
- KMS uses behind the scene HSM devices
- CloudHSM is true single tenant HSM(Hardware Security Module) hosted by AWS <span style="background-color: Red"><-- REMEMBER THIS FOR EXAM</span>
- AWS provisions the hardware for CloudHSM but they do not have access to it. In case of losing access to a HSM device there is no easy way to re-gain the access to it
- CloudHSM is fully compliant with FIPS 140-2 Level 3 (KMS is L2 compliant overall) <span style="background-color: Red"><-- REMEMBER THIS FOR EXAM</span>
- CloudHSM is accessed with industry standards APIs: PKCS#11, Java Cryptography Extensions (JCE), Microsoft CryptoNG (CNG) libraries. It is not that integrated with other AWS services by design (in comparison, KMS integrates with basically every service) <span style="background-color: Red"><-- REMEMBER THIS FOR EXAM</span>
- KMS can use CloudHSM as a **custom key store**, CloudHSM integration with KMS

## CloudHSM Architecture

- CloudHSM devices are deployed into a VPC managed by AWS, on which we don't have visibility
- They are injected into customer managed VPCs using ENIs (Elastic Network Interfaces)
- For HA we need to deploy multiple HSM devices and configure them as a cluster
- A client needs to be installed on the EC2 instances in order to be able to access HSM modules
- While AWS do provision the HSM devices, we as customers are responsible for the management of the customer keys
- AWS can provide software updates on the HSM devices, but these should not affect the encryption storage part

## CloudHSM Use Cases/Limitations

- There is no native integration with AWS services (except KMS) , this means CloudHSM can not be used for S3 SSE
- CloudHSM can be used for client-side encryption before uploading data to S3
- CloudHSM can be used to offload SSL/TLS processing for web servers. It's economical and efficient to use cloud HSM.
- Oracle Databases from RDS can perform Transparent Data Encryption (TDE) using CloudHSM
- CloudHSM can be used to protect private keys for an Issuing Certificate Authority (CA)

 # CloudTrail

- Is a product which logs API actions which affects AWS accounts (example: stop EC2 instance, delete S3 bucket)
- It logs API calls/activities as a CloudTrail Event, actions taken by user, role or service
- CloudTrail by default logs the last 90 days in Event History. It is enabled by default at no cost
- Trails: used to customize CloudTrail history
- Trails can be of 3 types:
    - **Management Events**: provide information about management operations performed on resources in AWS accounts (control plane operation). Example: create an EC2 instance, terminate an EC2 instance
    - **Data Events**: contain information about resource operations performed on or in a resource, example: objects uploaded to S3, Lambda function being invoked
    - **Insights Events**: CloudTrail Insights analyzes our normal patterns of API call volume and API error rates, also called the *baseline*, and generates Insights events when the call volume or error rates are outside normal patterns
- By default CloudTrail only logs management events
- CloudTrail is a regional service, but when we create a Trail, it can configured to operate in two ways:
    - One region: only will log events from the region in which it is created
    - All regions: collection of trails from all regions
- A one region trail can be configured to log global services events as well
- Most services log events in the region where the event occurred, but a small number of services (IAM, STS, CloudFront) log events globally (us-east-1). For a trail to accept global events, it has to be all region trail (has to be enabled for the trail)
- The default event history is limited to 90 days, with a trail we can be much more flexible
- A trail can store the events in a defined S3 buckets indefinitely, and these logs can be parsed by other tooling (log entries are stored in JSON format)
- CloudTrail can be integrated with CloudWatch Logs, where we can use Metric Filters for example
- Organizational Trail: 
    - A trail created in the management account of an organization storing all events across every account in the organization
    - In case we create a trail from the management account of an organization, we can enable it to bring events from all of the accounts from the organization
- CloudTrail does not offer real time logging!
- CloudTrail pricing:
    - 90 days history enabled by default in every AWS is free
    - One copy of management events is free for every region in an AWS account
    - Other trails created are charged

# CloudWatch

- Provides services to ingest, store and manage metrics
- It is a public service - provides public space endpoints
- Many services have native management plan integration with CloudWatch, for example EC2. Also, EC2 provides external gathered information only, for metrics from inside an EC2 we can use CloudWatch agent
- CloudWatch can be used from on-premises using the agent or the CloudWatch API
- CloudWatch stores data in a persistent way
- Data can be viewed from the console, CLI or API, but also CloudWatch also provides dashboards and anomaly detection
- CloudWatch Alarms: react to metrics, can be used to notify or to perform actions
- Instances in public subnet can connect to cloudwatch using Internet gateway and the instances in the private subnets can connect to the cloudwatch usig Interface Endpoint.

## CloudWatch - Data

- **Namespace**: container for metrics e.g. AWS/EC2 for EC2 NS, AW/Lambda for lambda NS. Its possible to have same mertic name for different service, NS helps to segregate them.
- **Data point**: timestamp, value, unit of measure (optional)
- **Metric**: time ordered set of data point. Example of builtin metrics: `CPUUtilization`, `NetworkIn`, `DiskWriteBytes` for EC2
- Every metric has a `MetricName` and a namespace e.g. CPUUtilization for AWS/EC2
- **Dimension**: name/value pair, example: a dimension is the way for `CPUUtilization` metric to be separated from one instance to another
- Dimensions can be used to aggregate data, example aggregate data for all instances for an ASG
- **Resolution**: standard (60 second granularity) or high (1 second granularity)
- **Metric resolution**: minimum period that we can get one particular data point for
- Data retention:
    - sub 60s granularity is retained for 3 hours
    - High resolution can be measured but they cost more. Resolution determines the minimum period which ca be specified and get a valid value. Standard (60 Sec) .. High (1 Sec)
    - 60s granularity retained for 15 days
    - 5 min retained for 63 days
    - 1 hour retained for 455 days
- As data ages, its aggregated and stored for longer period of time with less resolution
- Statistics: get data over a period and aggregate it in a certain way
- Percentile: relative standing of a value within the dataset

## CloudWatch Alarms

- Alarm: watches a metric over a period of time
- States: `ALARM` or `OK` based on the value of a metric against a threshold over time
- Alarms can be configured with one or more actions, which can initiate actions on our behalf. Actions can be: send notification to an SNS topic, attempt an auto scaling policy modification or use Event Bridge to integrate with other services
- High resolution metrics can have high resolution alarms

## CloudWatch Logs

- CloudWatch Logs provides two type of functionalities: ingestion and subscription
- CloudWatch Logs is a public service designed to store, monitor and provide access logging data
- Can provide logging ingestion for AWS products natively, but also for on-premises, IOT or any application
- CloudWatch Agent: used to provide ingestion for custom applications
- CloudWatch can also ingest log streams from VPC Flow Logs or CloudTrail (account events and AWS API calls)
- CloudWatch Logs is regional service, certain global services send their logs to `us-east-1`
- Log events consist of 2 parts:
    - **Timestamp**
    - **Raw message**
- Log Events can be collected into Log Streams. Log Streams are sequence of log events sharing the same source
- Log Groups: are collection of Log Streams. We can set retention, permissions and encryption on the log groups. By default log groups store data indefinitely
- Metric Filter: can be defined on the log group and will look for pattern in the log events. Essentially creates a metric from the log streams by looking at occurrences of certain patterns defined by us (example: failed SSH logs in events)
- Export logs from CloudWatch:
    - **S3 Export**: we can create an export task (`Create-Export-Task`) which will take up to 12 hours. Its not real time. It is encrypted using SSE-S3.
    - **Subscription**: deliver logs in real time. We should create a subscription filter for the following destination: Kinesis Data Firehose (near real time), OpenSearch (ElasticSearch) using Lambda or custom Lambda, Kinesis Data Streams (any KCL consumer)
- Subscription filters can be used to create a logging aggregation architecture

## CloudWatch Dashboards

- A great way to setup dashboards for quick access to key metrics
- Dashboards are global
- Dashboards can include graphs from different regions
- We can change the time zone and time range of the dashboards
- We can setup automatic refresh (10s, 1m, 2m, 5m, 15m)
- Pricing:
    - 3 dashboards (up to 50 metrics) for free
    - $3/dashboard/month

## CloudWatch Synthetics Canary

- Synthetics Canary are configurable scripts that will monitor APIs and URLs
- These scripts meant to reproduce what a customer would do in order to find issues before the app is deployed to production
- They can be also used to check the availability and latency of our endpoints
- They can store load time data and screenshots of the UI
- They have integration with CloudWatch Alarms
- The scripts can be written in Node.js or Python
- Provides programmatic access to a headless Chrome browser
- They can be run once or on a regular basis
- Canary Blueprints:
    - Heartbeat Monitor: load URL, store screenshot and an HTTP archive file
    - API Canary: test basic read and write functions of a REST API
    - Broken Link Checker: check all links inside a page
    - Visual Monitoring: compare a screenshot taken during a canary run with a baseline screenshot
    - Canary Recorder: used with CloudWatch Synthetics Recorder - used to record actions on a website and automatically generate a test script for that
    - GUI Workflow Builder: verifies that actions can be taken on a webpage (example: test a webpage with a login form)

# Amazon Cognito

- Provides authentication, authorization and user management for mobile/web applications
- Provides 2 main pieces of functionality:
    - **User Pools**: used for sign-in, provides a JSON Web Token (JWT) after authentication
        - **User Pools do not grant access to AWS services!**
        - User Pools provide user directory management and user profiles, sign-up and sing-in with customizable web UI, MFA and other security features
        - They allow social sign-in provided by Google, Apple, Facebook as well as sign in using other identity types such as SAML identity providers
    - **Identity Pools**: the aim of identity pool is to exchange a type of external identity for temporary AWS credentials, which can be used to access AWS resources
        - Unauthenticated Identities: identity pools can provides access to AWS services for guest users (unauthenticated users)
        - Federated Identities: authorize users to temporarily access AWS resources after they authenticated with Google, Facebook, Twitter, SAML 2.0 and event Cognito User Pools

## Cognito concepts

![Cognito Concepts](images/CognitoConcepts.png)



# Amazon Comprehend

- It is a natural language processing (NLP) system available in AWS
- We input a document and Comprehend will develop insights by recognizing the entities, key phrases, language, sentiments and other common elements of the document
- How the system works:
    - Input = Document
    - Output = Entities, phrases, language, PII, sentiments
- Comprehend is ML services and it is based on pre-trained and custom models
- Product is capable of doing real-time analysis for small workloads and asynchronous analysis for large workloads in form of jobs
- The text analysis type can be:
    - Built-in: using AWS built-in models
    - Custom: using custom models from endpoints we have created

# AWS Compute Optimizer

- AWS Compute Optimizer is a service that analyzes our AWS resources' configuration and utilization metrics to provide us with rightsizing recommendations
- Generates optimization recommendations to reduce the cost and improve the performance of your workloads
- Supported resources and requirements:
    - EC2 instances
    - Auto Scaling Groups
    - EBS volumes
    - Lambda functions
    - ECS and ECS Fargate
    - Commercial Software Licenses
    - RDS DB instances and storage
- Compute Optimizer is opt-in
- Analyzing metrics: after opt in, Compute Optimizer begins analyzing the specifications and the utilization metrics of resources from Amazon CloudWatch for the last 14 days
- Enhancing recommendations: we can enhance recommendations by activating recommendation preferences, such as the enhanced infrastructure metrics paid feature

# AWS Config

- AWS Config has 2 main jobs:
    - Primary: record configuration changes over time on AWS resources. Every time a configuration is changed on a resource a configuration item is created which stores the change at that specific point in time
    - Secondary: auditing of changes, compliance with standards
- Config does not prevent changes from happening! It is not a permissions product or a protections product. Even if we define standards for resources, Config can check the compliance against those standards, but it does not prevent us from braking those standards
- Config is a regional service, supports cross-region and cross-account aggregations
- Changes can generate SNS notifications and near-realtime events via EventBridge and Lambda
- Config stores changes historically in a consistent format in an S3 product bucket
- Config recording has to be manually enabled!
- Config Rules:
    - Can be AWS managed ones or user defined using Lambda
    - Resources are evaluated against these rules determining if there are compliant or non-compliant
    - Custom Rules use Lambda, the function does the evaluation and returns the information back to Config
- Config can be integration to EventBridge which can be used to invoke Lambda functions for automatic remediation
- Config can also have integration with SSM to remediate issues
- AWS Config architecture:
    ![AWS Config architecture](images/AWSConfig.png)

## AWS Config Remediations

- Nom-compliant resources can be remediated automatically using System Manager Automation documents
- AWS Config provides a set of managed automation documents with remediation actions. We can create custom remediation documents

## Conformance Packs

- A conformance pack is a collection of AWS Config rules and remediation actions that can be deployed as a single entity in an account/region or across an AWS Organization
- Conformance packs are created by authoring a YAML template that contains a list AWS Config rules and remediation actions

# AWS Control Tower

- Control Tower's job is to allow quick and easy setup of a multi-account environment
- Control Tower orchestrates other AWS services to provide this functionality
- It is using Organizations, IAM Identity Center, CloudFormation, AWS Config and more
- It is essentially an evolution of AWS Organizations adding more features, intelligence and automation

## Control Tower Features

- **Landing Zones**: it is the multi-account environment
    - Provides via other AWS services:
        - SSO/ID Federation
        - Centralized logging and auditing
- **Guard Rails**: used to detect/mandate rules and standards across all accounts
- **Account Factory**: automates and standardizes new account creation
- **Dashboard**: single page oversight of the entire environment
- When Control Tower is set up, it creates to OUs:
    - Foundational OU (security)
    - Custom OU (sandbox)
- Inside the Foundational OU Control Tower creates two accounts:
    - Audit Account: for users who needs access to audit information provided by Control Tower
    - Log Archive Account: for users who need access to all log information to all enrolled accounts within the Landing Zones
- Within the Custom OU Account Factory will provision AWS accounts in an automated way
- For these new accounts we have bases templates for configurations:
    - Account Baseline template
    - Network Baseline template (cookie cutter)
- Control Tower utilizes CloudFormation under the hood to implement all of these automation
- It also uses both AWS Config and SCPs to implement account Guard Rails

## Landing Zones

- It is a feature designed that anyone should be able to implement a *well architected* multi-account environment
- Home Region: the region where we initially deploy the product
- A Landing Zone creates the Security and Sandbox OUs, we can create other OUs and accounts as well
- Landing Zones utilizes the IAM Identity Center for multiple-accounts and ID Federation
- A Landing Zone provides monitoring and notifications via CloudWatch and SNS
- We can allow end-users to provision new accounts from a Landing Zone using Service Catalog

## Guardrails

- They are rules for multi-account governance
- There are 3 different types of rules:
    - Mandatory
    - Strongly Recommended
    - Elective
- Guardrails function in two different ways:
    - Preventive: stop us from doing things
        - They are implement using SCPs
        - They are enforced or not enabled
        - Example: allow or deny regions; disallow bucket policy changes in the Org
    - Detective: compliance check
        - Uses AWS Config Rules to detect compliance violations
        - These types of Guardrails are either *clear*, *in violation* or *not enabled*
        - Example: check if CloudTrail is enabled; check if EC2 instances have public IPv4 attached

## Account Factory

- Allows automated account provisioning
- This can be done by either cloud administrators or end users (with appropriate permissions)
- Guardrails are automatically applied to the provisioned accounts
- Account admin can be given to a named user who provisions the account or to another user
- Accounts can be configured with standard account and network configurations
- Can be fully integrated with a businessess SDLC

# Cost Allocation Tags

- Are tags that we can enable to provide additional information for any billing report in AWS
- Cost Allocation Tags needs to enabled individually per account or per organization from the management account
- There 2 different form of Cost Allocation Tags:
    - AWS generated - example: `aws:createdBy` or `aws:cloudformation:stack-name`. These are added automatically by AWS if cost allocation tags are enabled
    - User defined tags: `user:something`
- Both type of tags will be visible in AWS cost reports and can be used as a filter
- Cost Allocation Tags appear only int he Billing Console
- After enabling Cost Allocation Tags, it can take up to 24 hours to be visible and active
- Cost Allocation Tags are not added retroactively

# AWS DataSync

- It is a data transfer service which allows data to be transferred into or out of AWS
- Can be used for workflows such as migrations, data processing transfers, archival, cost effective storage, DR/BC
- Each agent can handle 10 Gbps transfer speed, each job can handle 15 million files
- It also handles the transfer of metadata (permissions, timestamps)
- It provides built in data validation

## Key Features

- Scalable: 10 Gbps per agent (~100 TB of data per day)
- Bandwidth Limiters: used to avoid link saturation
- Incremental and scheduled transfer options
- Compressions and encryption
- Automatic recovery from transit errors
- Service integration: S3, EFS, FSx, service-to-service transfer
- Pay as you use service: per GB of data transferred
- The DataSync agent runs on a virtualization platform such as VMWare

## DataSync Components

- Task: a job within DataSync, defines what is being synced, how quickly, from where and to where
- Agent: software used to read or write to on-premises data stores using NFS or SMB
- Location: every task has two locations from and to, examples: Network File System (NFS), Server Message Block (SMB), Amazon EFS, Amazon FSx and Amazon S3

# Amazon Detective

- GuarDuty, Macie and Security Hub are used to identify potential security issues or findings
- Sometimes security findings require deeper analysis to isolate the root cause and take actions
- Amazon Detective analyzes, investigates and quickly identifies the root cause of security issues or suspicious activities using ML and graphs
- Automatically collects nad processes events from VPC Flow Logs, CloudTrail trails and GuarDuty  to create an unified view
- Produces visualization with details and context to get to the root cause of the issue

# AWS Device Farm

- Device Farm is service which provides managed Web and Mobile application testing
- We can test an application on a fleet of real browser and devices
- Device Farm provides access to real devices: phones, tablets, different languages, sizes and operating systems
- We can use build in or supported automated testing frameworks from which we can receive reports detailing testing output
- It also supports remote connection to devices for issue reproduction and testing
- We can define tests using testing tools such as Explorer (Android), Fuzz (Android, iOS), Web app Tests, Appium, Calabash
- We can configure which devices we want to use for testing (huge selection is available). We can configure device state, additional apps, radio states, locations, etc.

# DX - Direct Connect

- It is a physical entry point into the AWS network
- It is a physical fibre connection through which we can access AWS services without sending traffic through the public internet
- The connection is between the business premises => DX Location => AWS Region
- When we order a DX connection, what we order is actually a Port Allocation at a DX Location
- The port has 2 costs:
    - Hourly cost based on the DX location and speed of the port
    - Outbound data transfer, inbound data transfer is free of charge
- In order to get a Direct Connect we have to create a connection (logical entity) inside an AWS account. This connection will have an unique ID
- Provisioning time: weeks/months of extra time
- DX provides low and consistent latency + high speeds (1/10/100 Gbps)
- In the DX location we will have to install a cross-connect (physical cable) in order to connect our own network to the AWS network
![DX architecture](images/DirectConnectArchitecture1.png)

## DX Physical Connection Architecture

- A Direct Connect is a physical port allocated at a DX Location
- This physical port provides 1, 10 or 100 Gbps speed
- DX can be ordered directly from AWS or through partners (wider range of speeds, with less options)
- The port requires single-mod fibre, NO copper cable connection supported
- Depending on the speed we order we will interface with DX using the following standards:
    - **1000BASE-LX** (1310 nm) Transreceiver for 1 Gbps
    - **10GBASE-LR** (1310 nm) Transreceiver for 10 Gbps
    - **100GBASE-LR4** - 100 Gbps
- Auto-Negotiation should be disabled for the connection
- We configure the port speed, full-duplex should be manually set on the network connection
- The router in the DX location should support Border Gateway Protocol (BGP) and BGP MD5 Authentication
- Optional configurations:
    - MACsec
    - Bidirectional Forwarding Detection (BFD)

## Direct Connect - MACsec

- It is a security feature that improves/partially improves a long-standing problem with DX: lack of builtin encryption
- It is a standard which allows frames on the network to be encrypted. Frames are the unit of data which occur at the layer 2 of the OSI model
- MACsec provides a hop by hop encryption architecture => 2 devices need to be next to each other at layer 2 to order MACsec (layer 2 adjacency)
- MACsec features:
    - Confidentiality: strong encryption at layer 2 by encryption the frame's EtherType and payload
    - Data integrity: adds additional fields to ensure that data cannot be modified in transit without both parties being able to detect the modification
    - Data origin authenticity: both parties can see that frames were been sent by other trusted peer
    - Replay protection
- MACsec does not replaces IPSEC over DX, it is not end-2-end!
- It is designed to allow transfer for super high speeds for terabit networks
- MACsec key components:
    - **Secure Channel** (unidirectional): each MACsec participant creates a MACsec channel that is used to send traffic
    - **Secure Channels** are assigned an identifier (SCI): uniquely identifies a secure channel
    - **Secure Associations**: communication that occurs on each secure channel, takes place as a series of transient sessions, multiple secure associations will take place on each secure channel over the lifetime of the connection. Each secure channel generally has 1 secure association at a time (exception when the associations are being replaced)
    - **MACsec encapsulation**: 16 bytes MACsec tag & 16 bytes of Integrity Check Value (ICV). MACSec modifies Ethernet frames by inserting these tags
    - **MACSec Key Agreement** protocol: manages discovery, authentication and key generation
    - **Cipher Suite**: controls how the data is encrypted: algorithm, packets per key, key rotation
- MACsec can be defined either ona DX connection on a Link Aggregation Group (LAG)
- Configuring MACsec: we associate a CAK/CKN pair with the connection on both the AWS DX router(s) and customer side's router
- It is possible to extend MACsec from the DX location ot the customer side
- This requires a dedicated physical extension of the cross connect to the business premises; this type of extension requires Layer 2 Adjacency

## DX Connection Process

- A DX connection begins in a DX Location, which contains AWS equipment and also customer/provider equipment
- AWS does not own this facility (neither does the provider) - it is a data center owned by a third party
- A large data center is collection of cages, these cages are areas that specific customers rent
- Only the staff at the data center can connect stuff together, only they have access to the space in-between the cages to connect different cages together
- Connecting these cages can be done only by staff members only when they have authorization from all parties
- The authorization is called **Letter of Authorization Customer Facility Access (LOA-CFA)**
- It is form that gives the access from one customer to get the data center staff to connect to the equipment of another customer
- DX connection process:
![DX Connection Process](images/DXConnectionProcess.png)

## DX Virtual Interfaces BGP Sessions + VLAN

- DX Connections are a layer 1 connections (physical cables) running layer 2 protocols (Data Link)
- We need a way to connect to multiple types of layer 3 (IP) networks (VPCs and public zones) over a single DX connection => this is where Virtual Interfaces (VIFs) come in handy
- VIFs allows us to run multiple layer 3 networks over a layer 2 direct connect
- A VIF is simply a BGP Peering Session => something which exchanges prefixes which allow traffic to be router to one point to the other
- All of this is isolated within a VLAN
- A VLAN isolates different layer 3 networks using VLAN tagging
- BGP exchanges prefixes, which means each end knows which networks are at each side; BPG MD5 authentication means that only authenticated data will accepted by either type
- 3 types of VIFs can be run over DX:
    - Private VIF: used to connect ot AWS private networks, so VPCs
    - Public VIF: used to connect to Public Zone Service
    - Transit VIF: allow integration between DX and Transit Gateways
![DX VIFs - BGP Session + VLAN](images/DXBGPSessonVLAN.png)
- A single dedicated DX can have in total 50 public/private VIFs, as well as 1 Transit VF
- Hosted VIFs: we can share VIFs with other AWS accounts. Can be connected to a virtual private gateway in a VPC of the other account

## Private VIFs

- They are used to access the resources inside 1 AWS VPC using private IP addresses
- Resources can be accessed with their private IP using private VIFs, public IPs and Elastic IPs wont work
- Private VIFs are associated with a Virtual Private Gateway (VGW) which can be associated to 1 VPC. This has to be in the same region where the DX location connection terminates
- 1 Private VIF = 1 VGW = 1 VPC (there are ways around this using Transit VIFs)
- There is no encryption on private VIFs, DX is not adding encryption and neither is the private VIFs (there are ways around this, example using HTTPS)
- With private VIFs we can use normal or Jumbo Frames (MTU of 1500 or 9001)
- Using VGW, route propagation is enabled by default
- Creating private VIFs:
    - Pick the connection the VIF will run over
    - Chose VGW (default) or Direct Connect Gateway
    - Chose who owns the interface (this account or another account)
    - Choose a VLAN id - 802.1Q which needs to match the customer config
    - We need to enter the BGP ASN of on-premises (public or private). If private use 64512 to 65535
    - We can choose IPs or auto generate them
    - AWS will advertise the VPC CIDR range and the BGP Peer IPs (`/30`)
    - We can advertise default or specific corporate prefixes (**max 100** - this is HARD limit, the interface will go into an idle state)
- Private VIFs architecture:
    ![Private VIFs Architecture](images/DXPrivateVIFS.png)
 - Key learning objectives:
    - Private VIFs are used to access private AWS services
    - Private VIF => 1 VGW => 1 VPC
    - VPC needs to be in the same region as the DX location
    - VGW has an AWS assigned
    - Over the private VIF runs the BGP with IPv4 or IPv6 (separate BPG peering connections)
    - We configure our own AS on the VIF, which can be private ASN or public ASN

## Public VIFs

- Are used to access AWS public zone services: both public services and services which have a public Elastic IP
- They offer no direct access to private VPC services
- We can access all public zone regions with one public VIF across AWS global network
- AWS advertises all AWS public IP ranges to us, all traffic to AWS services will go over the AWS global network
- We can advertise any public IPs we own over BGP, in case we don't have public IPs, we can work with AWS support to allocate some to us
- Public VIFs support bi-directional BGP communities
- Advertised prefixes are not transitive, our prefixes don't leave AWS
- Create a public VIF:
    - We pick the connection the VIF will run over
    - We chose the interface owner (this account or another)
    - Chose VLAN - 802.1Q, which needs to match the customer configuration
    - Chose the customer side BGP ASN (ideally this is public ANS for full functionality offered by public VIFs)
    - Configure MD5 authentication and select optional peering IP addresses
    - We have to select which prefixes we want to advertise
- Public VIFs architecture:
![Public VIFs Architecture](images/DXPublicVIFS.png)

## Direct Connect Public VIF + VPN

- Using a VPN gives us an encrypted and authenticated tunnel
- Architecturally, having a VPN over DX uses a Public VIF + VGW/TGW public endpoints
- With a VPN we connect to public IPs which belong to a VGW or TGW
- A VPN is transit agnostic: we can connect using a VPN to VGW or a TGW over the internet or over DX
- A VPN is end-to-end encryption between a Customer Gateway (CGW) and TGW/VGW, while MACsec is single hop based
- VPNs have wide vendor support
- VPNs have more cryptographic overhead compared to MACsec
- A VPN can be provided immediately, can be used while DX is provisioned and/or as a DX backup
![VPN over DX](images/DXPublicVIFVPN.png)

## Direct Connect Gateways

- Direct Connect is a regional service
- Once a DX connection is up, we can use public VIFs to access all AWS Public Services in all AWS regions
- Private VIFs can only access VPCs in the same AWS regions via VGWs
- Direct Connect Gateway is a global network device: it is accessible in all regions
- We integrate with it on the on-premises side by creating a private VIF and associate this with a DX Gateway instead of the Virtual Private Gateway (VGW). This integrates the on-premises router with the DX Gateway
- On the AWS side we create VGW associations in any VPC in any AWS regions
- DX gateways allow to route through them to the on-premises environments and vice-versa. They don't allow VPCs connected to the gateway to communicate with each other
- We can have 10 VGW attachments per DX Gateway
- 1 DX connection can have up to 50 private VIFs, each of which support 1 DX gateway and 1 DX gateway supports 10 VGW association => we can connect up to 500 VPCs
- DX gateway don't have a cost, we have cost for data transit only
![DX Gateway Architecture](images/DirectConnectGateway3.png)
- Cross-account DX Gateways: multiple account can create association proposal for a DX gateway

## Transit VIFs and TGW

- A DX Gateway does not route between the associated VPCs to that gateway, it only routes from on-premises to AWS side or vice-versa
- Transit Gateways are regional, it is possible to peer TGWs allowing connections between regions
- Transit Gateways are hub-and-spoke architecture, anything associated with a TGW is able to communicate with anything other associated to that TGW
- This architecture also works within peered TGWs
- DX-TGW Architecture:
   ![DX-TGW Architecture](images/DXGateway4.png)
- A DX supports up to 50 public and private VIFs and only 1 Transit VIF
- We can connect up to 3 Transit Gateways to a Direct Connect Gateway
- An individual DX gateway can be used with VPCs and private VIFs or with Transit Gateways and transit VIFs, **NOT BOTH** at the same time!
- Consideration:
    - DX gateway does not route between its attachments, this is why the peering connection between TGWs is required
    - Each TGW can be attached up to 20 DX gateways
    - Each TGW supports up 5000 attachments, up to 50 peering attachments
- DX Gateway routing problems:
    - DX gateway only allows communications from a private VIF to any associated virtual private gateways
    - With a transit gateway we can solve this, if we connect the DX gateway to a transit gateway (works only in one region)

## Direct Connect Resilience and HA

- To improve resilience:
    - Order 2 DX ports instead of one => 2 cross connects, 2 customer DX routes connecting to 2 on-premises routes
    - Connect to 2 DX locations, have to customer routers and 2 on-premises routers in different buildings (geographically separated)
- Not resilient DX architecture:
![DX resilience NONE](images/DirectConnectResilience1.png)
- Resilient DX architecture:
![DX resilience OK](images/DirectConnectResilience2.png)
- Improved resilient DX architecture:
![DX resilience BETTER](images/DirectConnectResilience3.png)
- Extreme resilient DX architecture:
![DX resilience GREAT](images/DirectConnectResilience4.png)

## Direct Connect Link Aggregation Groups (LAG)

- LAG: allows to take multiple physical connections and configure them to act as one
- From speed perspective a LAG can have:
    - 2 ports, each 100 Gbps
    - 4 ports, the speed of each being less than 100 Gbps
- We can create a LAG with the maximum speed of 200 Gbps
- LAG do provide resilience, although AWS does not market them as such. They do not provide any resilience regarding hardware failure or the failure of entire location
- LAGs use an Active/Active architecture, maximum 4 connection can be part of the LAG
- All connections must have the same speed and terminate at the same DX location
- A LAG has an attribute called `minimumLinks`: the LAG is active as long as the number of working connections is greater or equal to this value
![DX LAG](images/DirectConnectLAG.png)

# DMS - Database Migration Service

- Database migrations are complex actions to perform
- DMS it is a managed database migration service
- It starts with using a replication instance running on EC2
- This instance runs one or more replication task
- For these tasks we have to specify the source and destination endpoints at source and target databases. **One endpoint must be on AWS!** We can't use the product between on-premises migrations
- Source databases supported are: MySQL, Aurora, Microsoft SQL, MariaDB, MongoDB, PostgreSQL, Oracle, Azure SQL, etc.
- DMS uses jobs to handle migrations. Jobs can be one of 3 types:
    - Full load migrations: used to migrate existing data, simply migrates the data from source to target. Great if we can afford an outage for the source DB
    - Full load + CDC (Change data capture): migrates the existing data and replicates any ongoing changes
    - CDC only: designed to replicate only data changes. In some situations might be more efficient to use other tools for full migration and use CDC only for ongoing changes afterwards
- DMS does not support any form of schema conversions, for this we should use Schema Conversion Tool (SCT) provided by AWS

## SCT - Schema Conversion Tool

- SCT is a standalone app used for converting one database engine to another including conversion of schema from a DB to S3
- SCT is not used when migrating between DBs of the same type
- SCT works with OLTP DBS (MySQL, Oracle, Aurora, etc.) and OLAP databases (Teradata, Oracle, Vertica, Greenplum, etc.)
- Example when SCT should be used: on-premises MSSQL -> RDS MySQL (the engine changes from MSSQL to MySQL) or from Oracle -> Aurora

## DMS and Snowball

- Larger migrations might imply moving databases with sizes of multi-TB
- Moving data over networks takes time and consumes capacity
- DMS is able to utilize Snowball products to migrate databases
- Migration steps:
    1. Use SCT to extract data locally and move the data to a Snowball
    2. Ship the device back to AWS. They will load the data into an S3 bucket
    3. DMS migrates from S3 into a target source
    4. Change Data Capture (CDC) can capture changes and via S3 intermediary they are also written to the target database

# DR/BC Architecture

- Effective DR/BC costs money all of the time
- We need some type of extra resources which will increase costs
- Executing disaster recover/business continuity process takes time. How long it takes depends on the type of DR/BC in usage
- DR/BC is trade-off between the time and costs

## Types of Disaster Recovery

- **Backup and Restore**:
    - Data is constantly backup up at the primary site
    - The only costs are backup media and management, no ongoing space infrastructure costs
    - Has little or no upfront costs, but implies a significant time for recovery
    - Expected recovery time is counted in hours
- **Pilot Light**:
    - Primary site is running at full
    - Pilot Light implies running a secondary environment only having the absolute minimum services running
    - In the event of a disaster the shutdown services can be spined up, no costs are expected to be inquired if there is no need for DR
    - Expected recovery time is a few 10s of minutes
- **Warm Standby**:
    - Primary site is running at full, everything is replicated on the backup site at a smaller scale
    - Ready to be increased in size when failover is required
    - It is faster than pilot light approach and cheaper than active/active approach
    - Expected recovery time is a few minutes
- **Active/Active (Multi-site):**
    - Primary site is entirely replicated on a secondary site
    - Data is constantly replicated from the primary site to the backup
    - Costs are generally 200%
    - There is no concept of recovery time
    - Additional benefits:
        - Load balancing across environments
        - Improved HA and performance
- Summary:
    - Backups: cheap and slow
    - Pilot Light: fairly cheap but faster
    - Warm Standby: costly, but quick to recover
    - Active/Active: expensive, 0 recovery time

## DR Architecture - Storage

- Instance Store volumes:
    - Most high risk form of storage available
    - If the host fails, the instance store volumes will also fail
    - Should be viewed as temporary and unreliable storage
- EBS:
    - Volumes are created an run in a single AZ (failure of AZ means failure of EBS volumes)
    - Snapshots of EBS are stored in S3, will increase reliability
- S3: 
    - Data is replicated across multiple AZs
    - One-Zone: not regionally resilient
- EFS:
    - EFS file systems are replicated across multiple AZs
    - They are by default regionally resilient - failure of a region means failure of EFS volumes
- DR Architecture - Storage:
    ![DR Architecture - Storage](images/DRArchitectureStorage.png)

## DR Architecture - Compute

- EC2:
    - If the host fails, EC2 instances fails as well
    - An EC2 instance by itself is not resilient in any way
    - If the failure is limited to one host, the instance can move to another host in the AZ. The EBS volume can be presented to the new instance
    - Auto Scaling Group: can be placed in multiple AZs, if the instance fails in one AZ, the ASG's role is to recreate them in another
- ECS:
    - Can run it 2 modes: EC2 and Fargate
    - EC2 mode: DR architecture is similar as above
    - Fargate mode: containers are running on a cluster host managed by AWS being injected in VPCs
    - Fargate can provide automatic HA by running things in different AZs
- Lambda:
    - By default runs in public mode
    - In VPC mode (private) Lambdas are injected in VPCs. If an AZ fails, Lambda can be automatically injected in another subnet in a different AZ
    - It will take the failure if a region in order for Lambda to be impacted
- DR Architecture - Compute:
    ![DR Architecture - Compute](images/DRArchitectureCompute.png)

## DR Architecture - Databases

- Running databases on EC2 should be done in certain cases only!
- DynamoDB:
    - Data is replicated between multiple nodes in different AZs
    - Failure can occur only if the entire region fails
- RDS:
    - Requires creation of a subnet group which specifies which subnet can be used in a VPC for a DB
    - Normal RDS (not Aurora) involves a single instance or primary and standby instance running in different AZs
    - Data is stored in local storage for each instance, data is replicated asynchronously to the standby
    - If the primary instance fails, automatic fallback is done to the standby
    - In case of Aurora, we can have one or more replicas in each AZs
    - Aurora uses a cluster storage architecture, storage is shared between running DB instances
    - Aurora can resist failures up to the entire region failure (not using Aurora Global)
- Global Databases:
    - DynamoDB Global Table: multi master replication between regional replicas.
    - Aurora Global Databases: read-write cluster in one region, secondary read cluster in other regions. Replication happens at the storage layer, no additional load placed on the DB
    - Cross Region Read Replicas for RDS: asynchronous replication but not done on the storage layer
- DR Architecture - Databases:
    ![DR Architecture - Databases](images/DRArchitectureDatabases.png)

## DR Architecture - Networking

- Networking at local level:
    - VPC are regionally resilient
    - Certain gateway objects like VPC Router and IGW are also regionally resilient
    - Subnets are tied to AZ they are located in, if the AZ fails, the subnet fails as well
    - LB: regional services, nodes are deployed into each AZ we select
    - By using a LB we can route traffic to AZs which are healthy
- Interface endpoint:
    - Are tied to an AZ
    - Multiple interface endpoints can be deployed into different AZs
- DR Architecture - Networking:
    ![DR Architecture - Networking](images/DRArchitectureNetworking.png)
- Global Networking:
    - Route53 can route globally to different regions (failover routing)

# AWS Elastic Disaster Recovery (DRS)

- Minimizes downtime and data loss with fast, reliable recovery of on-premises and cloud-based applications using affordable storage, minimal compute, and point-in-time recovery
- We can increase IT resilience when you use AWS Elastic Disaster Recovery to replicate on-premises or cloud-based applications running on supported operating systems
- We set up a DRS agent on our source servers to initiate secure data replication
- Our data is then replicated in a staging area subnet in our AWS account
- The staging area is designed to reduce costs by using affordable storage and minimal compute
- AWS Elastic Disaster Recovery automatically converts our servers to boot and run natively on AWS when we launch instances for drills or recovery
- If we need to recover applications, you can launch recovery instances on AWS within minutes

# DynamoDB

- NoSQL, wide column, DB-as-service product
- DynamoDB can handle key/value data or document data
- It requires no self-managed servers of infrastructure to be managed
- Supports a range of scaling options:
    - Manual/automatic provisioned performance IN/OUT
    - On-Demand mode
- DynamoDB is highly resilient across AZs and optionally globally
- DynamoDB is really fast, provides single-digit millisecond data retrieval
- Provides automatic backups, point-in-time recovery and encryption at rest
- Supports event-driven integration, provides actions when data is modified inside a table

## DynamoDB Tables

- A table in DynamoDB is a grouping of items with the same primary key
- Primary key can be a simple primary key (Partition Key - PK) or composite primary key (Partition Key + Sort Key - SK)
- In a table there are no limits to the number of items
- In case of composite keys, the combination of PK and SK should be unique
- Items can have, besides primary key, other data named attributes
- Every item can be different as long as it has the same primary key
- An item can be at max 400 KB
- DynamoDB can be configured with provisioned and on-demand capacity (capacity = speed)
- For on-demand capacity, we have to set:
    - Wite-Capacity Units (WCU): 1 WCU = 1KB per second
    - Read-Capacity Units (RCU): 1 RCU = 4KB per second

## DynamoDB Backups

- On-demand backups:
    - Full copy of the table is retained until the backup is removed
    - On-demand backups can be used restore data and config to same region or cross-region
    - If we restore a backup we can retain or remove indexes
    - Similarly, we can adjust encryption settings
- Point-in-time Recovery:
    - Not enabled by default, has to be enabled
    - It is a continuous record of changes
    - Allows replay to any point in the window (35 days recovery window)
    - From this 35 day window we can restore to another table with a 1 second granularity

## DynamoDB Considerations

- It is a NoSQL database, it is NOT relational, not suited for relational data
- It is a Key/Value database
- Access to DynamoDB tables is via console, CLI, or API (SDK)
- True SQL query language is not supported, DynamoDB offers support for PartiQL (SQL like language)
- Billing: based on RCU/WCU, storage and additional features enabled. Reserved allocation can be purchased for longer commitments

## DynamoDB Operation, Consistency and Performance

- We can chose between to different capacity mode at table creation: on-demand and provisioned
- We may be able to switch between this capacity mode afterwards
- On-demand capacity mode: 
    - Designed for unknown, unpredictable load
    - Requires low administration
    - We don't have to explicitly set capacity settings, all handled by DynamoDB
    - We pay a price per million R or W unit
- Provisioned capacity mode:
    - We set the RCU/WCU per table
- Every operation consumes at least 1RCU/WCU
- 1 RCU is `1 * 4KB` read operation per second for strongly consistent reads, `2 * 4KB` read operations per second for eventual consistent reads
- 1 WCU is `1 * 1KB` write operation per second
- Every table has a RCU and WCU bust pool (300 seconds)
- DynamoDB operations:
    - **Query**:
        - When a query is performed we need to provide a partition key. Optionally we can provide a sort key or a range
        - Query item can return 0 or more items, but we have to specify the partition key every time
        - We can specify specific attribute we would want to be returned, we will be charged for querying the whole item anyway
    - **Scan**:
        - Least efficient operation, but the most flexible
        - Scan moves through a table consuming the capacity of every item
        - Any attribute can be used and any filters can be applied, but scan will consume the capacity for every item scanned through

## DynamoDB Consistency Model

- DynamoDB can operate using two different consistency modes:
    - Eventually consistent
    - Strongly (immediately) consistent
- DynamoDB replicates data cross AZs using storage nodes. Storage nodes have a leader node, which is elected from the existing nodes
- DynamoDB has a fleet of entities which redirect connections to the appropriate storage nodes. Writes are always directed to leader node
- The leader nodes replicates data to other nodes, typically finishing within a few milliseconds
- There are 2 types of reads possible in DynamoDB:
    - Eventually consistent reads:
        - It might happen that we attempt to read data which is outdated (stale) / not present at all
        - We can read double the amount of data with the same number of RCUs
    - Strongly consistent reads:
        - These read operations always use the leader node
        - Not every application can tolerate eventual consistent reads
        - Strongly consistent reads cost two times more than eventual consistent ones

## WCU/RCU Calculation

- Example: we need to store 10 items per second, 2.5K average size per item
    - WCU required: 
        ```
        ROUND UP(ITEM SIZE / 1 KB) => 3
        MULT by average (30) => WCU required = 30
        ```
- Example: we need to retrieve 10 items per second, 2.5K average size per item
    - RCU required:
        ```
        ROUND UP (ITEM SIZE / 4 KB) => 1
        MULT by average read ops per second (10) => Strongly consistent reads = 10, Eventually consistent reads => 5
        ```

## DynamoDB Indexes

- Are way to improve efficiency of data retrieval from DynamoDB
- Indexes are alternative views on table data, allowing the query operation to work in ways that it couldn't otherwise
- Local Secondary Indexes allow to create a view using different sort key, Global Secondary Indexes allow to create create different partition and sort key

### Local Secondary Indexes (LSI)

- **Must be created with the base table!**
- We can have at max 5 LSIs per base table
- LSIs allow an alternative sort key, but with the same partition key
- They share the same RCU and WCU with the main table
- Attributes which can be projected into LSIs: `ALL`, `KEYS_ONLY`, `INCLUDE` (we can specifically pick which attribute to be included)
- Local Secondary Indexes are sparse: only items which have a value in the index alternative sort key are added to the index

### Global Secondary Indexes (GSI)

- They can be created at any time
- It is a default limit of 20 GSIs per base table
- We cane define different partition and sort keys
- GSIs have their own RCU and WCU allocations in case we are using provisioned capacity
- Attributes which can be projected into an index: `ALL`, `KEYS_ONLY`, `INCLUDE`
- GSIs are also sparse, only items which have values in the new PK and optional SK are added to the index
- GSIs are always eventually consistent, the data is replicated from the main table

### LSI and GSI Considerations

- We have to be careful with the projections, more capacity is consumed if we project unnecessary attributes
- If we don't project a specific attribute and require that when querying the index, it will fetch the data from the main table, the query becoming inefficient
- AWS recommends using GSIs as default, LSI only when strong consistency is required

## DynamoDB Streams and Triggers

- A DynamoDB stream is a time ordered list of item changes in a DynamoDB table
- A DynamoDB stream is a 24H rolling window of these changes. Behind the scenes uses Kinesis Streams
- Streams has to be enabled per table basis
- Streams record inserts, updates and deletes
- We can create different view types influencing what is in the stream
- Available view types:
    - `KEYS_ONLY`: the stream will only record the partition key and available sort keys for items which did change
    - `NEW_IMAGE`: stores the entire item with the new state after the change
    - `OLD_IMAGE`: stores the entire state of the item before the change
    - `NEW_AND_OLD_IMAGE`: stores the before/after states of the items in case of a change
- In some cases the new/old states recorded can be empty, example in case of a deletion the new state of an item is blank
- Streams are the foundation for database triggers
- An item change inside a table generate an event, which contains the data which changed
- An action is taken using that data in case of event
- We can use streams and Lambda in case of changes and events
- Streams and triggers are useful for data aggregation, messaging, notifications, etc.

## DynamoDB Accelerator (DAX)

- It is an in-memory cache directly integrated with DynamoDB
- DAX operates within a VPC, designed to be deployed in multiple AZs in a VPC
- DAX is a cluster service, nodes are placed in different AZs. There a primary nodes from which data is replicated into replica nodes
- DAX maintains 2 different caches:
    - Items cache: holds results of (`Batch`)`GetItem` calls
    - Query cache: holds the collection of items based on query/scan parameters
- DAX is accessed via an endpoint. This endpoint load balances across nodes
- Nodes are HA, if primary node fails another node is elected
- DAX can scale UP or scale OUT
- When writing data to DynamoDB, DAX uses write-through caching, the data is written at the same time to the cache as it is written to the DB
- DAX is deployed in a VCP! Any application which wants to use DAX has to be in a VPC as well
- Cache hits are returned in microseconds, cache misses in milliseconds
- DAX is not suitable for applications requiring strongly consistent reads

## DynamoDB Global Tables

- Global tables provide multi-master cross-region replication
- To implement global tables we have to create tables in multiple regions and add them to the same global table (becoming replicate tables)
- DynamoDB utilizes **last writer wins** in conflict resolution
- We can read and write to any region, updates are replicated generally sub-second
- Strongly consistent reads are only supported in the same region as writes
- Global tables provide global HA and global DR/BC

## DynamoDB TTL

- TTL = Time-to-Live
- In order to use TTL we have to enable it on a table and select a specific attribute for the TTL
- The attribute should contain a number representing an epoch (number of seconds)
- A per-partition process periodically runs for checking the current time to the value in the TTL attribute
- Items where the TTL attribute is older than the current time are set to expired
- Another per-partition background process scans for expired items and removes them from tables and indexes, adding a delete event to the streams is enabled
- These processes run on the background without affecting the performance of the table and without any additional charge
- We can configure a dedicated stream linked to the TTL processes, having 24h rolling window for any deletions caused by the TTL processes. Useful if we want to have any housekeeping where we track the TTL events that occur on tables (for example we can implement an un-delete process)

# Elastic Beanstalk - EB

- It is a platform as a service (PaaS) product in AWS, meaning the vendors handles all the infrastructure, we provide the code only
- EB is a developer focused product, providing managed application environments
- At a high level, developers provide code and EB handles infrastructure
- EB is fully customizable - uses AWS products under the covers provisioned with CloudFormation
- Using EB requires application support, there are things to do as a developer. This does not come for free, and it not something a non-technical end-user could do

## Platforms

- EB is capable of accepting code in many languages known as platforms
- EB has support for built-in languages, Docker and custom platforms
- Built-in supported languages: Go, Java SE, Java Tomcat, .NET Core (Linux) and .NET (Windows), Node.JS, PHP, Python, Ruby
- Docker options: single container docker and multi container docker (ECS)
- Pre-configured Docker: way to provide runtimes which are not yet natively supported, example Java with Glassfish
- We can create our own custom platform using packer which can be used with Beanstalk

## EB Terminology

- **Elastic Beanstalk Application**: is a collection of things relating to an application - a container/folder
- **Application Version**: specific labeled version of deployable code for an application. The source bundle is stored in S3
- **Environments**: are containers of infrastructure and configuration for a specific version
- Each environment is either a **web server tier** or a **worker tier**. The web server tier is designed to communicate with the end-users. The worker tier is designed to process work from the web tiers. Web server tier and worker tier communicate using SQS queues
- Each environment is running a specific version at any given time
- Each environment has its own CNAME, a CNAME SWAP can be done to exchange to environment DNS

## Deployment Policies

- **All at once**: 
    - Deploy to all instances at once
    - It is quick and simple, but it will cause a brief outage
    - Recommended for testing and development environments
- **Rolling**:
    - Application code is deployed in rolling batches
    - It is safer, since the deployment will continue only if the previous batch is healthy
    - The application will encounter loss in capacity based on size of batch you selected.
    - We need to select the batch size based on decision how many instances you can tolerate out of service at any one time. 
- **Rolling with additional batch**:
    - Same as rolling deployment, with the addition of having a new batch in order to maintain capacity during the deployment process
    - Recommended for production environment with real load
    - This deployment takes longer time but is asfer and good for prod because we don't drop any capacity.
- **Immutable**:
    - New temporary ASG is created with the newer version of the application
    - Once the validation is complete, the older stack is removed
    - It is easier to roll back as if anything goes wrong the original instances are available in their original state.
    - It has the highest cost as it uses the double of instances.
- **Traffic Splitting**:
    - Fresh instances are created in a similar way as in case of immutable deployment
    - Traffic will be split between the older and the newer version
    - Allows to perform A/B testing on the application
    - It does not have capacity drops, but it will come with an additional cost
- **Blue/Green**:
    - Not automatically supported by EB
    - Requires manual CNAME swap between 2 environments
    - Provides full control in terms of when we would want to switch to the new environment

## EB and RDS

- In order to access an RDS instance from EB we can create an RDS instance within an EB environment
- If we do this, the RDS is linked to the environment
- If we delete the environment, the database will also be deleted
- If we link a database to an environment, we get access to the following environment properties:
    - `RDS_HOSTNAME`
    - `RDS_PORT`
    - `RDS_DB_NAME`
    - `RDS_USERNAME`
    - `RDS_PASSWORD`
- Other alternative is to create the RDS instance outside of the EB
- The environment properties above are not automatically provided in this case, we can create them manually
- With this method the RDS lifecycle is not tied to the EB environment
- Decoupling an existing RDS from an EB environment:
    1. Create a Snapshot
    2. Enable Delete Protection
    3. Create a new EB environment with the same app version
    4. Ensure new environment can connect to the DB
    5. Swap environment (CNAME or DNS)
    6. Terminate the old environment - this will try to terminate the RDS instance
    7. Locate the `DELETE_FAILED` stack in CloudFormation console, manually delete the stack and pick to retain stuck resources

## Customizing via `.ebextensions`

- We can include directive to customize EB environments using `.ebextensions` folder
- Anything added in this folder as YAML or JSON and it ends in `.config` is regarded to be an EB extension configuration file. These configurations files are CloudFormation definitions, and they are used to influence the EB environment itself to change its configuration or provision new resources
- EB will use CFN to create additional resources within the environment specified in the `.config` files
- These files can have the following sections:
    - `option_settings`: allows us to set options of resources (example: use NLB instead of ALB for the EB environment)
    - `Resources`: allows us to create new resources using CFN (example: configure OpenSearch cluster for our environment)
    - Additional sections: packages, sources, files, users, groups, commands, container_commands and services

## EB with HTTPS

- To use HTTPS with EB we need to apply an SSL certificate to the load balancer
- We can do this using the EB console or we can use the `.ebextensions/securelistener-[alb|nlb].config` feature
- We can configure the security group as well to allow SSL connections

## Environment Cloning

- Cloning allows to create new EB environment by cloning existing environments
- By cloning an environment we don't have to manually configure options, environment variables, resources and other settings
- A clone does copy any RDS instance defined, but the data is not copied by default
- EB cloning does not include any un-managed changes to resources from the environment. Changes to AWS resources we make using tools other than the EB console/CLI/API are considered un-managed changes
- To clone an environment from the eb command line we can use `eb clone <ENV>` command

## EB and Docker

### Single Container Mode

- We can only run one container in one Docker host
- This mode uses EC2 with Docker, not ECS
- In order to use this mode we have to provide a few configurations:
    - `Dockerfile`: used to create a new container image from this file
    - `Dockerrun.aws.json` (version 1): to use an existing docker image. We can configure ports, volumes and other Docker attributes
    - `Docker-compose.yml`: if we want to use Docker compose

### Multi-Container Mode

- Elastic Beanstalk uses ECS to create a cluster
- ECS uses EC2 instances provisioned in the cluster and an ELB for HA
- EB takes care of ECS tasks, cluster creation, task definition and task execution
- We need to provide an `Dockerrun.aws.json` (~~version 2~~ version 3) file in the application source bundle (root level)
- Any images need to be stored in a container registry such as ECR

# EBS and Instance Store

## EBS Volume Types

- **General Purpose SSD (GP2/GP3)**:
    - GP2 is the default storage type for EC2, GP3 is the newer version
    - A GP2 volume can be as small as 1GB or as large as 16TB
    - IO Credit:
        - An IO is one input/output operations, one 16 KB chunk of data
        - 1 IOPS is 1 IO in 1 second
        - 1 IO credit = 1 IOPS
    - If we have no credits for the volume, we can not perform any IO
    - The IO bucket has 5.4 million of credits, it refills based at rate based on the baseline performance of the storage
    - The baseline performance for GP2 is based on the volume size, we get 3 IO credits per second, per GB of volume size. Also, it fills with a min of 100 IO credit per second regardless of the volume size
    - By default GP2 can burst up to 3000 IOPS
    - If we consume more credits than the bucket is refilling, than we are depleting the bucket
    - We have to ensure the buckets are replenishing and not depleting down to 0, otherwise the storage will be unusable
    - Volume larger than 1TB will exceed the burst rate of 3000 IOPS, they will always achieve the baseline performance as standard, they wont use the credit system
    - Max IO 16000 IO credits per second, any volume larger than 5.33 TB will achieve this maximum rate constantly
    - GP2 can be used for boot volumes
    - GP3 is similar to GP2, but it removes the credit system for a simpler way of working:
        - Every GP3 volume starts at a standard 3000 IOPS and 125 MiB/s regardless of volume size
    - Base price for GP3 is 20% cheaper than GP2
    - For more performance we can pay extra cost for up to 16000 IOPS or 1000 MiB/s throughput
- **Provisioned IOPS SSD (IO1/2)**:
    - There are 3 types of provisioned IOPS storage options: IO1 and its successor IO2 and IO2 BlockExpress (currently in preview)
    - For this storage category the IOPS value can be configured independently of the storage size
    - Provisioned IOPS storages are recommended for usage where consistent low latency and high throughput is required
    - Max IOPS per volume is 64_000 IOPS per volume and 1000 MB/s throughput, while with BlockExpress we can achieve 256_000 IOPS per volume and 4000 MB/s throughput
    - Volume size ranges from 4 GB up to 16 TB for IO2/IO3 and up to 64 TB for BlockExpress
    - We can allocate IOPS performance values independently of the size of the volume, there is a maximum IOPS value per size:
        - IO1 50 IOPS / GB MAX
        - IO2 500 IOPS / GB MAX
        - BlockExpress 1000 IOPS / GB MAX
    - Per instance performance: maximum performance between EBS service and EC2. Usually this implies more than one volume in order to be saturated. Max values:
        - IO1 260_000 IOPS and 7500 MB/s (4 volumes to saturate)
        - IO2 160_000 IOPS and 4750 MB/s (less than IO1)
        - BlockExpress 260_000 IOPS and 7500 MB/s
    - Use cases: smaller volumes and super high performance
- HDD based volume types:
    - There are 2 types of HDD based storages: ST1 Throughput Optimized, SC1 Cold HDD
    - **ST1**:
        - Cheaper than SSD based volumes, ideal for larger volumes of data
        - Recommended for sequential data, applications when throughput is more important than IOPS
        - Volume size can be between 125 GB and 16 TB
        - Offers maximum 500 IOPS, data IO is measured in blocks of 1 MB => max throughput of 500 MB/s
        - Works similar as GP2 with a credit system
        - Offer a base performance of 40 MB/s per TB of volume size with bursting to 250 MB/s per TB
        - Designed for frequently accessed sequential data at lower cost
    - **SC1**:
        - SC1 is cheaper than ST1, has significant trade-offs
        - Geared towards maximum economy when we want to share a lot of data without caring about performance
        - Offers a maximum of 250 IOPS, 250 MB/S throughput
        - Offer a base performance of 12 MB/s per TB of volume size with bursting to 80 MB/s per TB
        - Volume size can be between 125 GB and 16 TB
        - It is the lower cost EBS storage available

## Instance Store Volumes

- Provides block storage devices, raw volumes which can be mounted to a system
- They are similar to EBS, but they are local drives instead of being presented over the network
- These volumes are physically connected to the EC2 host, instances on the host can access these volumes
- Provides the highest storage performance in AWS
- Instance stores are included in the price of EC2 instances with which they come with
- **Instance stores have to be attached at launch time, they can not be added afterwards!**
- If an EC2 instance moves between hosts the instance store volume loses all its data
- Instances can move between hosts for many reasons: instance are stopped and restarted, maintenance reasons, hardware failure, etc.
- **Instance store volumes are ephemeral volumes!**
- One of the primary benefit of instance stores is performance, ex: D3 instance provides 4.6 GB/s throughput, I3 volumes provide 16 GB/s of sequential throughput with NVMe SSD
- Instance store considerations:
    - Instance store volumes are local to EC2 hosts
    - Instance store can be added only at launch
    - Data is lost on an instance stores in case the instance is moved, resized or there is a hardware failure
    - Instance stores provide high performance
    - For instance store volumes we pay for it with the EC2 instance
    - Instance store volumes are temporary!

## Choosing between Instance Store and EBS

- Fer persistence storage we should default to EBS
- For resilience storage we should avoid instance store an default to EBS
- If the storage should be isolated from EC2 instance lifecycle we should use EBS
- Resilience with in-built replication - we can use both, it depends on the situation
- For high performance needs -  we can also use both, it depends on the situation
- Fos super high performance we should use instance store
- If cost is a primary concern we can use instance store if it comes with the EC2 instance
- Cost consideration: cheaper volumes: ST1 or SC1
- Throughput or streaming: ST1
- Boot volumes: HDD based volumes are not supported (no ST1 or SC1)
- GP2/3 - max performance up to 16000 IOPS
- IO1/2 - up to 64000 IOPS (BlockExpress: 256000)
- RAID0 + EBS: up to 260000 IOPS (maximum possible IOPS per EC2 instance)
- For more than 260000 IOPS - use instance store

# EC2

## EC2 Purchase Options (Launch Types)

- **On-Demand (default)**:
    - Average of anything, no specific cons or pros
    - On-demand instances are isolated but multiple customer instances run on a shared hardware
    - Multiple instance types (different sizes) can run on the same EC2 hosts, consuming a different allocation of resources
    - Billing: per-second billing while an instance is running, if a system is shut down, we don't get billed for that
    - Associated resources such as storage consume capacity, we will be billed regardless the instance is running or it is stopped
    - We should always start the evaluation process using on-demand
    - With on-demand there are no interruptions. We start an instance and it should run as long as we don't decide to shut it down
    - In case of resource shortage the reserved instances receive highest priority, consider them instead of on-demand in case of business critical systems
    - On-demand offers predictable pricing without any discount options
    - If you are unsure of duration or type of workload, On-demand should be considered.
- **Spot instances**:
    - Cheapest way to get EC2 compute capacity
    - Spot pricing is selling EC2 capacity at lower price in order make use of spare EC2 capacity on the host machines
    - If the spot price goes above selected maximum price, our instances are terminated
    - We should never use the spot instances for workloads which can't tolerate interruptions
    - Anything which can tolerate interruptions and can be re-triggered is good for spot
- **Standard Reserved Instances**:
    - On-demand is generally used for unknown or short term usage, reserved is for long term consistent usage of EC2
    - Reservations:
        - They are commitments that we will use a instance/set of instances for a longer amount of time
        - The effect of a reservation is to reduce the per second cost or remove it entirely
        - Reservation needs to be planned in advance
        - We pay for unused reservations
        - Reservations can be bought for a specific type of instances. They can be region and AZ locked
        - Az locked instances reserve EC2 capacity
        - If an instance is reserved for a region,it doesn't reserve capacity but it can benefit any instances launched in any AZ in that region.
        - Reservations can have a partial effects in a sense the we can get discounts for larger instances compared to which the reservation was purchased
        - We can commit to reservations of 1 year of 3 years
        - Payment structures:
            - No upfront: we pay per second a lower amount of fee compared to on-demand. We pay even if the instance is not used
            - All upfront: the whole cost of the 1 or 3 years. No second per fee payment will be required. Offer the greatest discount
            - Partial upfront: we pay a reduced fee upfront for smaller per second usage
    - Reserved instances are good for components which have known usage, require consistent access for compute for a long term basis
- **Scheduled Reserved Instances**:
    - Great for long term requirements which does not run constantly, ex. batch processing running 5 hours/day
    - For scheduled reserved instances we specify a time window. The capacity can be used only during the time window
    - Limitations: 
        - Does not support all kind of instance types
        - Minimum purchase per year is 1200 hours, minimum commitment is 1 year
- **Dedicated Hosts**:
    - They are EC2 hosts allocated to a customer entirely
    - They are hosts designed for specific instances, ex. A, C, R, etc.
    - Hosts come with all of the resources we expected from a physical machine: number of cores and CPUs, memory, local storage and connectivity
    - We pay for the host, we don't pay anymore for instance usage per second in case we launch instances on the host
    - We have a capacity for a dedicated hosts, we can launch different sizes of instances based on the available capacity
    - Reasons for dedicated hosts: we want to use software which is licensed for number of cores or number of sockets
    - Host affinity: feature of dedicated hosts. Links instances to hosts, if we stop and start the instance, it will remain on the same host
    - Only our instances will run on a dedicated hosts
    - Capacity management:
        - We have to manage our capacity in terms of under utilization of the host
        - We have a limited capacity in terms of how many EC2 instances we can launch
- **Dedicated Instances**:
    - Our instances run on an EC2 host with other instances of ours. The host is not shared with other AWS customers, no other customers will use the same hardware
    - We don't pay for the host, nor do we share the host
    - There are some extra fees for this kind of purchase option:
        - One-of hourly fee for any regions in which we are using dedicated instances
        - There is a fee for the dedicated instances themselves
    - Dedicated instances are common in industries where we cannot share hardware
    - No extra capacity management required from us

## Capacity Reservations

- AWS prioritizes any scheduled commitment for delivering EC2 capacity
- After scheduled instances on-demand is prioritized
- The leftover capacity can be used for spot instances
- Capacity reservation is different compared to reserved instances
- Regional reservation 
    - Provides a billing discount for valid instances launched in any AZ in that region
    - While this is flexible, region reservation don't reserve capacity within az AZ - risky if the capacity is limited during a major fault
- Zonal reservation: 
    - Same billing discount as for region reservation, but the reservation applies only to specific AZs
- Regional/zonal reservation commitment is 1 or 3 years
- On-Demand capacity reservation: can be booked to ensure we always have access to capacity in an AZ when we need it but at full on-demand price. No term limits, but we pay regardless if we consume the reservation or not
- Capacity reservations do not provide any billing benefit, we just reserve the capacity for EC compute

## EC2 Savings Plan

- A hourly commitment for 1 or 3 years term
- Saving Plan can be 2 different types:
    - General compute dollar amounts: we can save up to 66% version on-demand
    - EC2 Saving Plan: up to 72% saving for EC2
    - SageMaker savings plan: reduces costs up to 64% for SageMaker usage. Applies to Sagemaker ML instances (ml.t3, ml.m5, ml.m5d)
- General compute savings plan currently apply to EC2, Fargate and Lambda
- Resource usage consumes savings plan commitment at the reduced saving plans rate, beyond commitment on-demand billing is used

## EC2 Networking

- Instances are created with a primary ENI, this can not be removed or detached from the instance
- Secondary ENIs can be added to an instance which can be in different subnets (NOT AZs!)
- Secondary ENIs can be detached and attached to other instances
- Security Groups are associated with an ENI, not an EC2 instances
- Every instances is allocated a primary private IPv4 address from the subnet range. This IP address remains the within the lifetime of EC2 instance
- The primary IP address is exposed to the OS
- ENIs can also have one or more secondary IP addresses depending on the instance type
- Public IP address is allocated to the instance if we launch it in a subnet where this is enabled or we explicitly enable a primary address to the instance. These public IP addresses are dynamic and they can change if the EC2 instance is moving to another EC2 host
- Public IPs are not visible to the OS
- In order to get static public IP addresses, we can associate an Elastic IP to the instance
- We can allocate one public IP per private IP
- We get charged if the Elastic IPs are not associated to instances
- ENIs can have 1 or more IPv6 addresses, 1 MAC address and 1 or more Security Groups
- IPv6 addressing if enabled, all the IPv6 addresses are publicly routable
- IPv6 addresses are always visible to the OS
- Source/destination checks: each ENI has a flag which can be disabled
- By default source/destination check is enabled, if disabled the ENI can process traffic which was not created by the EC2 instances or traffic for which the EC2 instance is not the destination

## Bootstrapping and AMI Baking

- Bootstrapping:
    - Is a way of building EC2 instances in a flexible way. Isn't fast, but super flexible.
    - Flexible, automated building of EC2 instances
    - We provision EC2 instances and add a script to the user data
    - CloudInit runs the script on the instance when the instance is launched
    - This process can longer time, although it is very flexible
    - When finished, ec2 instance is ready to use.
- AMI Baking:
    - We front-load the time and effort required to configure an instance
    - Our aim is to get the instance ready or almost ready at this point of the process. We can use bootstrapping to install the software and make the instance ready.
    - We launch an EC2 instance and perform the necessary tasks from which we can create an AMI
    - We can use the AMI to deploy many instances quickly.
    - The tradeoff is, it harder to change the AMI.
    - AMI baking and bootstrappig are not mutually exclusive.
    - <span style="color: orange;">If there are any exam question related to time taken to launch the EC2 instance, think of AMI baking.</span>

## EC2 Placement Groups

- Allow us to influence EC2 instance placements, insuring that instances are closed together or not
- There are 3 types of placements groups in AWS:
    - **Cluster**: any instances in a single placement groups are physically close
    - **Spread**: instances are all using different underlying hardware
    - **Partition**: groups of EC2 instances which are spread apart on different host hardware

### Cluster Placement Groups

- Used for highest possible performance
- Best practice is to launch all of the instances at the same time which will be part of the placement group. This ensures that AWS allocates capacity in the same location
- Cluster placement groups are located in the same AZ, when the first instance is launched, the AZ is locked
- Ideally the instances in a cluster placement group are located on the same rack, often on the same EC2 host
- All instances have fast direct bandwidth between each other (they can achieve single stream transfer rate of 10Gbps vs 5Gbps which is achievable normally)
- They offer the lowest latency possible and max PPS(packets per second) possible in AWS
- To achieve these levels of performance we need to use instances with high performant networking: instances with more bandwidth and with Enhanced Networking
- Cluster placement groups should be used for highest performance. They offer no HA and very little resilience
- Considerations for cluster placement groups: <span style="color: #ff5733;">Important for EXAM!!!</span>
    - We can not span over AZs, the AZ is locked when the first instance is launching
    - We can span over VPC peers, but this will impact performance negatively
    - Cluster placement groups are not supported for every instance type
    - *Recommended*: use the same type of instances and launch them at the same time
    - Cluster placement groups offer 10 Gbps for single stream performance
    - Use cases: High performace, fast speeds, low latency

### Spread Placement Groups

- They offer the maximum possible availability and resiliency
- They can span multiple AZs
- Instances in the same spread placement group are located on different racks, having isolated networking and power supplies
- There is a limit for 7 instances per AZ in case of spread placement groups. This is because each instance is a completely separate instance rack 
- Considerations: <span style="color: #ff5733;">Important for EXAM!!!</span>
    - Spread placement provides infrastructure isolation
    - Hard limit: 7 instances per AZ
    - We can not use dedicated instances or hosts
    - Use cases: Small number of critical instances that need to be kept seperated from each other. May be mirrors of file server, or may be different domain controllers within an organization.

### Partition Placement Groups

- Similar to spread placement groups
- They are designed for situations when we need more than 7 instances per AZ but we still need separation
- Can be created across multiple AZs in a region
- At creation we specify the number of partition per AZ (max 7 per AZ)
- Each partition has its own rack with isolated power and networking
- We can launch as many instances as we need in a partition group. We can select the partition by hand or we can let EC2 decide on a partition for a new instance
- Use cases for partition groups: HDFS, HBase, Cassandra, topology aware applications<span style="color: #ff5733;">Important for EXAM!!!</span>
- Instances can be placed in a specific partition or we can let AWS to decide
- Offer visibility in partitions and you can see which instance is in which partition.

## EC2 Spot Instances

- Can get a discount of up to 90% compared to On Demand instances
- We can define a max spot price and get he instance of our price is bigger than the current price
- If the current spot price goes beyond our max price, we can choose to stop or terminate the instance within 2 minutes grace period
- If we don't want our spot instance to be reclaimed by AWS, we can use a **Spot Block**
    - We can block a spot instance during a specified time frame (1 to 6 hours) without interruptions
    - In rare situations the instance may be reclaimed
- Use cases for spot instances: batch jobs or workloads that are resilient to failure
- We can launch spot instances with a spot request. A spot request contains the following information:
    - Maximum price
    - Desired number of instances
    - Launch specification
    - Request type: on-time, persistent
    - Valid from, valid until
- Request types:
    - One time request: as soon as the request is fulfilled, the request will go away
    - Persistent request: the number of instances is attempted to be kept even if some instances are reclaimed, meaning that the request will not go away as soon as it is completed first time
- Canceling a spot instances: in order ot cancel a spot instance, it has to be in an **open**, **active** or **disabled** state
- Spot instance states:
    ![Spot instance states](images/spot_request_states.png)
- Cancelling a spot request, it will not terminate the instances themselves. In order to terminate instances, first we have to terminate the spot request, if there is one active

## Spot Fleets

- Spot Fleet - set of spot instances + (optional) on-demand instances
- The spot fleet will try to meet the target capacity with price constraints
- A launch pool can have the following can have different instance types, OS, AZ
- We can have multiple launch pools, so the fleet can choose the best
- Spot fleet will stop launching instances the target capacity is reached
- Strategies to allocate spot instances:
    - **lowestPrice**: the spot fleet will launch instances from the pool with the lowest price
    - **diversified**: distribute instances across all pools
    - **capacityOptimized**: launch instances based on the optimal capacity for the number of instances
- Spot fleets allow us to automatically request spot instances with the lowest price

# ECS - Elastic Container Service

- It is a service that accepts containers and orchestrates where and how to run those containers
- It is a managed container based compute service
- It runs on two modes: EC2 and Fargate
- Cluster: is the place where container run based on how we want them to run
- Containers are located in container registries (ECR, DockerHub)
- ECS uses **container definitions** to locate images in the container registries, which port should the image use, etc. providing information about the container we want to run
- **Task definition**: represents a self-contained application, can have one or many containers defined in it. A task in ECS defines the application as a whole
- Task definitions store the resources to be used (CPU, memory), networking configuration, compatibility (EC2 mode or Fargate) and also they store the task role (IAM role)
- **Task role** is IAM role that the task can assume. It gives permission to ECS containers to access AWS services
- **Task Execution Role**: to set up the container itself and maintain that, some tasks are performed. Container Agent performs those tasks for the container. So, the role required & assumed by Container Agent to set up the container is Task Execution Role
- A task does not scale by its own and it is not HA
- **ECS service**: it is configured by a **service definition**. In a service we define how we want a task to scale, how many copies we like to run
- ECS services define scalability and HA for tasks

## ECS Cluster Modes

- Cluster mode define how much of the admin overhead is required for running containers in ECS (what parts do we manage and what parts does AWS manage)
- Cluster modes are:
    - EC2 Mode
    - Fargate Mode

### EC2 Mode

- Uses EC2 instances which are running inside of a VPC
- Since we are inside of a VPC, we can benefit from using multiple AZs
- When we create the cluster, we specify the initial size of containers
- Horizontal scaling for EC2 instances and for ECS tasks is controlled by ASGs
- With EC2 cluster mode we are paying for EC2 instances independently of what containers and how many of containers are running on them

### Fargate Mode

- We don't have to manage EC2 instances for use as container host
- With Fargate there are no servers to manage
- AWS maintains a shared Fargate infrastructure platform offered to all users
- We gain access to resources from a shared pool, we don't have visibility for other customers
- A Fargate deployment still uses a cluster with a VPC which operates in AZs
- ECS tasks are injected into the VPC with an ENI, they are running on the Fargate shared platform
- With Fargate mode we only pay for the containers we using based on the resources they consume

## EC2 vs ECS (EC2) vs Fargate

- If we are already using containers, we should use ECS
- Containers make sense if we want to isolate applications
- We generally pick EC2 mode if we have a large workload and the business is price conscious
- Historically EC2 mode was giving the most value for the price if we were using saving plans. Nowadays we can have savings plan for Fargate and Lambda, so we should default to Fargate instead of EC2 mode
- If we are overhead conscious, we should use Fargate
- For small/burst workloads we should use Fargate as well. Same is recommended for batch/periodic workloads

# EFS - Elastic File System

- It is a network based file system which can be mounted on Linux based instance
- Can be mounted to multiple instances at once
- EFS it is an implementation of the NFSv4 file system format
- EFS file systems can be mounted in a folder in Linux based operating systems
- EFS storage exists separately from the lifecycle of an EC2 instance
- It can be shared between many EC2 instances
- It is a private service, it can be mounted via mount targets inside a VPC. By default an EFS it is isolated to the VPC in which was provisioned
- EFS can be accessed outside of the VPC over hybrid networking: VPN or DX. EFS is a great tool for storage handling across multiple units of compute
- EFS is accessible for Lambda functions. Lambda has to be configured to use VPC networking in order to use EFS
- Mount targets: provide IP addresses in the range of the VPC. For HA we should provision mount targets in every availability zones present in a VPC
- EFS offers 2 performance modes:
    - General Purpose: ideal for latency sensitive use cases (it is the default)
    - Max I/O: can be used to scale to higher levels of aggregate throughput. Has higher latencies
- EFS offers 2 different throughput modes:
    - Bursting (default): works similar to EBS GP2 storage
    - Provisioned: we can specify throughput requirements independent of the size
- EFS offers 3 storage classes:
    - Standard: for data that is accessed and modified frequently
    - Infrequent Access (IA): cost-optimized storage class for data that is less frequently accessed (few times a quarter)
    - Archive: for data that is accessed a few times a year
- We can automatically move data between these 2 classes using lifecycle policies

# EKS - Elastic Kubernetes Service

## Kubernetes 101

- It is an open source container orchestration system
- We used to automate the deployment, scaling and management of containerized applications
- It is a cloud-agnostic product, can be used on-premises as well
- Cluster Structure:
    - A Kubernetes cluster is a HA cluster of compute resources organized to work as one unit
    - Cluster starts with the Cluster Control Plane: manages the cluster, scheduling, applications, scaling and deploying
    - Compute in Kubernetes is provided via Cluster Nodes: VM or physical servers which function as a worker in the cluster. These run the containerized applications
    - Software that will run on each node:
        - On each of the nodes runs a container runtime: `containerd` or other software used to handle container operations
        - `kubelet`: the agent which interacts with the control plane is. This uses the Kubernetes API to communicate with the control plane
- Cluster details:
    - Pods: 
        - The smallest units of computing in Kubernetes
        - Pods can have multiple containers and provide shared storage and networking for them
        - It is common to have one container per pod, although we can have multiple container in a pod
        - Pods are not permanent: they can be deleted when finished with a job, evicted because of lack of resources or when a node fails
    - Control plane runs the following software:
        - `kube-apiserver`: 
            - The front-end for the Kubernetes control 
            - It is what nodes and other cluster elements interact with
            - Can be horizontally scaled for HA and performance
        - `etcd`:
            - HA key/value store
            - Backing store for the cluster
        - `kube-scheduler`:
            - Identifies any pods within a cluster that does not have a node assigned
            - Assigned pods based on resources, deadlines, affinity, data locality and any other constraints
        - `cloud-controller-manager`:
            - Optional component
            - Provides cloud-specific control logic
            - It allows us to link Kubernetes with cloud providers APIs such as AWS
        - `kube-controller-manager`:
            - It is a collection of processes:
                - Node Controller: monitoring and responding to node outages
                - Job Controller: one-of tasks (jobs)
                - Endpoint Controller: populates endpoints 
                - Service Account and Token Controllers: accounts/API tokens
    - kube-proxy:
        - Every node runs it
        - It is a networking proxy
        - It coordinates networking with the control plane
        - It helps implement "services" and configures rules allowing communications with pods from inside or outside of the cluster
- Ingress: exposes a way into a service from outside to the cluster
- Ingress Controller: a piece of software with arranges the underlying hardware to allow ingres (example: AWS LB Controller which use ALB/NLB)
- Persistent Storage (PV): they are volumes whose lifecycle lives beyond any one single pod that is using it. "Normal" long running storage

## Elastic Kubernetes Service 101

- It is an AWS managed implementation of Kubernetes as a service
- EKS can be run in different ways:
    - On AWS itself as a product
    - On Outposts: racks and servers operating in on-premises locations, but controlled and managed by AWS
    - EKS Anywhere: EKS clusters running on on-premises or anywhere else
    - EKS Distro: EKS product as open-source
- The EKS control plane is managed by AWS and scales based on load. It runs across multiple AZs
- Integrates with other AWS services such as ECR, ELB, IAM, VPC
- EKS Cluster = EKS Control Plane and EKS Notes
- etcd is also managed by AWS and distributed across multiple AZs
- Nodes can be the following types:
    - Self managed: EC2 instances managed by us
    - Managed node groups: still EC2 instances, but EKS manages the provisioning and lifecycle managing
    - Fargate: nodes are managed by EKS, we don't have to worry about scaling and optimizing clusters (similar to ECS Fargate)
- Choosing between node types depends on for what we want to use the cluster. If we want Windows nodes, GPU, Inferentia, Bottlerocket, Outposts, Local zones, etc. we need to check which types of nodes support the feature we require
- Persistent storage on EKS: it can use EBS, EFS, FSx for Lustre, FSx for NetApp ONTAP as storage providers

# ElastiCache

- It is an in-memory database for application which need high-end performance
- It is orders of magnitude faster than a classic DB, but is not persistence
- ElastiCache provides 2 different engines: Managed Redis and MemcacheD as a service
- ElastiCache can be used for read heavy workloads with low latency requirements
- Can be used for reduction of database workloads, by this reducing cost accumulated by heavy database usage
- Can be used to store session date, making stateful applications stateless
- Using ElastiCache requires application code changes!

## Redis vs MemcacheD

- Both offer sub-millisecond access to data
- MemcacheD supports simple data structures (string), while Redis can support more advanced type of data: lists, sets, sorted sets, hashes, bit arrays, etc.
- Redis supports replication of data across multiple AZs, MemcacheD supports multiple nodes with manual sharding, but it does not supports "true" replication across AZs for scalability reasons
- Redis supports backups and restores, MemcacheD does not support persistance
- MemcacheD is multi-threaded by design, can take better advantage of multithreaded CPUs, can offer better performance
- Redis supports transactions (multiple operations at once)
- Both of these engines can support a ranges of instance types

# ELB - Elastic Load Balancer

## ELB Architecture

- It is the job of the load balancer to accept connection from customers and distribute those connections to any registered backend compute
- ELBs support many different type of compute services
- LB architecture:
![LB Architecture](images/ELBArchitecture1.png)
- Initial configurations for ELB:
    - IPv4 or double stacking (IPv4 + IPv6)
    - We have to pick the AZ which the LB will use, specifically we are picking one subnet in 2 or more AZs
    - When we pick a subnet, AWS places one or more load balancer nodes in that subnet
    - When an LB is created, it has a DNS A record. This A record points to all the nodes provisioned for the LB => all the incoming connections are distributed equally
    - The nodes are HA: if the node fails, a different one is created. If the load is to high, multiple nodes are created
    - We have to decide on creation if the LB is internal or internet facing. The internet facing the nodes will have public IP addresses otherwise private IP address is assigned. EC2 innstances need not have public IP address for internet facing LB. <span style="color: #ff5733;"><!Important for EXAM></span>
- Load Balancers are configured with listeners which accept traffic on a port and protocol and communicate with the targets
- An internat facing load balancer can connect to both public and private instances
- Minimum subnet size for a LB to function is /28 - 8 or more fee addresses per subnet (AWS suggests a minimum of /27)
- Internal LB are same as internet LB but they have private IP address assiged to the nodes. Internal LB are used to connect to private nodes and help in internal scaling,

## Cross-Zone Load Balancing

- An LB by default has at least one node per AZ that is configured for
- Initially each LB node could distribute connections to instances in the same AZ
- Cross-Zone Load Balancing: allows any LB node to distribute connections equally across all registered instances in all AZs.
- This help with the uneven distribution of load and could be helpful in <span style="color: #ff5733;">EXAM</span>
![CROSS-ZONE LB Architecture](images/ELBArchitecture2.png)

## User Session State

- Session state: 
    - A piece of server side information specific to one single user of one application
    - It does persist while the user interacts with the application
    - Examples of session state: shopping cart, workflow position, login state
- The date representing a sessions state is either stored internally or externally (stateless applications)
- Externally hosted session:
    - Session data is hosted outside of the back-end instances => application becomes stateless
    - Offers the possibility to do load balancing for the back-end instances, the session wont get lost in case the LB redirects the user to a different instance

## ELB Evolution

- Currently there are 3 different types of LB in AWS
- Load balancers are split between v1 and v2 (preferred)
- LB product started with Classic Load Balancers (v1)
- CLBs can load balance HTTP/HTTPS and lower level protocols as well, although they can not understand the http protocol, they can't make decision based on HTTP protocols features
- CLBs can have only 1 SSL certificate per load balancer
- They can not be considered entirely being a layer 7 product
- We should default to using v2 load balancer for newer deployments
- Version 2 (v2) load balancers:
    - Application Load Balancer (ALB - v2 LB) are layer 7 devices, they support HTTP(S) and WebSocket protocols
    - Network Load Balancers (NLB) are also v2 load balancers supporting lower level protocols such as TCP, TLS and UDP. 
      These could be used for applications like Email servers, Games or applications which does't use HTTP/s protocols.
- In general v2 load balancers are faster and they support target groups and rules, this allow to use single LB for multiple things.

## Application and Network Load Balancers

- Consolidation of load balancers:
    - Classic load balancers do not scale, they do not support multiple SSL certificates (no SNI support) => for every application a new load balancer is required
    - V2 load balancers support rules and target groups
    - V2 load balancers can have host based rules using SNI
- **Application Load Balancer (ALB)**:
    - ALB is a true layer 7 load balancer, configured to listen either HTTP or HTTPS protocols
    - ALB can not understand any other layer 7 protocols (such as SMTP, SSH, etc.)
    - ALB requires HTTP and HTTPS listeners
    - It can understand layer 7 content, such as cookies, custom headers, user location, app behavior, etc.
    - Any incoming connection (HTTP, HTTPS) is always terminated on the ALB - no unbroken SSL
    - All ALBs using HTTPS must have SSL certificates installed
    - ALBs are slower than NLBs because they require more levels of networking stack to process. Any <span style="color: #ff5733;">EXAM</span> question which talks about performance, NLB should be considered instead of ALB.
    - ALB offer health checks evaluation at application layer
    - Application Load Balancer Rules:
        - Rules direct connection which arrive at a listener
        - Rules are processed in a priority order, default rule being a catch all
        - Rule conditions: host-header, http-header, http-request-method, path-pattern, query-string and source-ip
        - Rule actions: forward, redirect, fixed-response, authenticate-oidc and authenticate-cognito
    - The connection from the LB and the instance is a separate connection
    - If you need to forward connections without terminating on the LB, then you need to consider NLB. (<span style="color: #ff5733;">EXAM</span>)
- **Network Load Balancer (NLB)**:
    - NLBs are layer 4 load balancers, meaning they support TPC, TLS, UDP, TCP_UDP connections
    - They have no understanding of HTTP or HTTPS => no concept of network stickiness
    - They are really fast, can handle millions of request per second having 25% latency of ALBs because they don't have to deal with any  of the heavy computational upper layers.
    - Recommended for SMTP, SSH, game servers, financial apps (not HTTP(S)) <-- <span style="color: #ff5733;">EXAM</span>
    - Health checks can only check ICMP or TCP handshake
    - They can be allocated with static IP addresses which is udeful for whitelisting which is beneficial for corporate client.
    - They can forward TCP straight through the instances => unbroken encryption <-- <span style="color: #ff5733;">EXAM</span>
    - NLBs can be used for PrivateLink <-- <span style="color: #ff5733;">EXAM</span>

- **Scenarios for NLB**:
    - Unbroken encryption
    - Static IP for whitelisting
    - Fast performance
    - Protocols other tha HTTP or HTTPS
    - Privatelink

## Session Stickiness

- Stickiness: allows us to control which backend instance to be used for a given connection
- With no stickiness connections are distributed across all backend services
- Enabling stickiness:
    - CLB: we can enable it per LB
    - ALB: we can enable it per target group
- When stickiness is enabled, the LB generates a cookie: `AWSALB` for ALB / `AWSELB` for CLB which is delivered to the end-user
- This cookie has a duration defined between 1 sec and 7 days
- When the user accesses the LB, it provides the cookie to the LB
- The LB than can decide to route the connection to the same backend instance every time while the cookie is not expired
- Change of the backed instance if the cookie is present:
    - If the instance to which the cookie maps to fails, then a new instance will be selected
    - If the cookie expires => the cookie will be removed, new cookie is created while a new instance is chosen
- Session stickiness problems: load can become unbalanced
- Enable session stickiness if an application does't use external sessions

## Connection Draining and Deregistration Delay

- Connection draining a setting which controls what happens when instances are unhealthy or deregistered
- Default behavior: LB closes all connections and the instance receives no new connections
- Connections draining allows in-flight requests to complete for a certain amount of time, while no new connections are sent to the instance
- Connection draining is supported on Classic Load Balancers only! It is defined on the load balancer itself
- Connection draining is a timeout between 1 and 3600 seconds (default 300)
- If the instance become unhealthy because if a failed health check, connection draining settings do not apply to it
- If an instance is taken out of service manually or by an ASG, it is listed "InService: Instance deregistration currently in progress". If we use an ASG, it will wait for all connections to complete before terminating or for the timeout value
- Deregistration delay is essentially the same feature as connection draining, but it is supported by ALB, NLB and GWLBs
- It is defined on target groups, not on the LB
- It works by stopping sending connections to deregistering targets. Existing connections can continue until thy complete naturally or the deregistration delay is reached
- Deregistration delay is enabled by default on all the new LBs, default value for it is 300 seconds (configurable between 0-3600 seconds)

## `X-Forwarded-For` and PROXY protocol

- In case a client connects to a backend without any load balancing in the front of the backend, the IP address of the client is visible and can be recorded
- With load balancers this can be more complicated, this is where `X-Forwarded-For` header and the PROXY protocol become handy
- `X-Forwarded-For` is a HTTP header, it only works with HTTP/HTTPS. This is a layer 7 header.
- This header is added/appended by proxies/load balancers. It can have multiple values in case the request is passing multiple proxies/load balancers. E.g X-Forwarded-For: 1.3.3.7(ClientIP), proxy1, proxy2..
- The backend server needs to be aware of this header and needs to support it
- Supported on CLB and ALB, NLB does not supports it because they don't support the layer 7 of the OSI stack.
- PROXY protocol works at Layer 4, it is an additional layer 4 (tcp) header => works with a wide range or protocols (including HTTP/HTTPS)
- There are 2 versions of PROXY protocol:
    - v1: human readable, works with CLB
    - v2: binary encoded, works with NLB
- v2 can support an unbroken HTTPS connection (tcp listener). Use case for this: end to end encryption
- When using PROXY protocol, we can add a HTTP header, the request is not decrypted

# EMR - Elastic Map Reduce

## MapReduce 101

- Is a framework designed to allow processing huge amount of data in a parallel, distributed way
- Data Analysis Architecture: huge scale, parallel processing
- MapReduce has two main phases: map and reduce
- It also has to optional phases: combine and partition
- At high level the process of map reduce is the following:
    - Data is separated into splits
    - Each split can be assigned to a mapper
    - The mapper perform the operation at scale
    - The data is recombined after the operation is completed
- HDFS (Hadoop File System):
    - Traditionally stored across multiple data nodes
    - Highly fault-tolerant - data is replicated between nodes
    - Named Nodes: provide the namespace for the file system and controls access to HDFS
    - Block: a segment of data in HDFS, generally 64 MB

## Amazon EMR Architecture

- Is a managed implementation of Apache Hadoop, which is a framework for handling big data workloads
- EMR includes other elements such as Spark, HBase, Presto, Flink, Hive, Pig
- EMR can be operated long term, or we can provision ad-hoc (transient) clusters for short term workloads
- EMR runs in one AZ only within a VPC using EC2 for compute
- It can use spot instances, instance fleets, reserved and on-demand instances as well
- EMR is used for big data processing, manipulation, analytics, indexing, transformation, etc.
- EMR architecture:
    ![EMR architecture](images/EMRArchitecture.png)
    - Each cluster requires at least one **master node**. This manages the cluster and distributes workloads and acts as the NAME node within MapReduce (we SSH into this if necessary)
    - Historically we could have only one master node, nowadays we can have 3 master nodes
    - **Core nodes**: cluster can have many core nodes. They are used for tracking task, we don't want to destroy these nodes
    - Core nodes also managed to HDFS storage for the cluster. The lifetime of HDFS is linked to the lifetime of the core nodes/cluster
    - **Task nodes**: used to only run tasks. If they are terminated, the HDFS storage is not affected. Ideally we use spot instances for task nodes
    - EMRFS: file system backed by S3, can persist beyond the lifetime of the cluster. Offers lower performance than HDFS, which is based on local volumes

## Amazon EMR Serverless

- It is a deployment option for Amazon EMR that provides a serverless runtime environment
- With EMR Serverless we don't have to configure, optimize, secure or operate clusters to run applications with frameworks such as Spark and Hive
- Job run:
    - Is a request submitted to an EMR Serverless application that the application asynchronously executes and tracks it until completion
    - When a job is submitted we must specify an IAM role that will provide required access for the job to other services such as S3
    - We can submit different jobs at the same time with different runtime roles
- Workers:
    - EMR Serverless internally uses workers to execute our workloads
    - The default size of this workloads depends on the application type and EMR version
    - When we submit a job, EMR Serverless computes the resources that the application needs for the job and schedules workers
    - EMR Serverless automatically scales workers up or down based on the workload and parallelism required at every stage of the job
- Pre-initialized capacity:
    - Used to keep workers initialized and ready to respond in seconds
    - Effectively creates a warm pool of workers for an application
- EMR Studio:
    - It is the user console where we manage our EMR Serverless applications

# CloudWatch Events and EventBridge

- Deliver a near real-time stream of system events
- These events describe changes in AWS services, example: EC2 instance is started
- EventBridge is a newer system replacing CloudWatch Events. It can perform the same functionality, in addition it can handle events from third-parties and custom applications
- Both of the services operate using an event bus. Both have a default event bus
- In CloudWatch Events there is only the default event bus, which is explicit and it is not exposed to the UI
- In EventBridge we can have additional event buses
- In both systems we create rules matching incoming events, or we have scheduled based rules
- Events themselves are JSON objects, including for example which EC2 instance changed state, in what state changed into as well as other things such as date and time

# Amazon Forecast

- Provides forecasting for time series data. For example can be used for predicting retail demand, supply chain, staffing levels, energy requirements, server capacity and web traffic
- For any type of time-series data where we have a large amount of historical data, Forecast can be used to provide the ability to forecast future trends and events
- In order to accomplish this forecasting we have to import historical data and other related data. Related data includes extra contextual information (example promotions running when an item was sold)
- The output of Forecast will be a forecast and forecast explainability. The explainability allows to understand the reasons behind the forecasted data

# Amazon Fraud Detector

- Is a fully managed fraud detection service
- Allows us to look at various historical trends and other related data and identify any potential fraud as it related to certain only activities such as new account creation, payments or guest checkouts
- We upload some historical data and we have to chose a model type:
    - Online Fraud: needs little historical data
    - Transaction Fraud: idean when we have a transactional history for a customer, identifies suspect payments
    - Account Takeover: used to identify phishing or another social based attack
- Events are scored, based on which we can create rules/decisions to react to events according to our business activity

# FSx

## FSx For Windows File Servers

- FSx for Windows are fully managed native Windows file servers/file shares
- Designed for integration with Windows environments
- Integrates with AWS managed Directory Service or Self-Managed AD
- Resilient and highly available service. Can be deployed in single or multi-AZ within a VPC. Even in a single-AZ deployment the backend of the service uses replications to ensure that is resilient to hardware failure
- It can perform a full range of different kind of backups, including client-side and AWS-side features. On the AWS-side, it can perform automatic and on-demand backups
- FSx can be accessed over VPC peering, VPN and DX
- FSx supports de-duplication, scaling through Distributed File System (DFS), KMS at rest encryption and enforced encryption in transit
- Allows for volumes shadow copies, we can initiate previous versions for a file
- It is highly performant: 8 MB/s up to 2 GB/s throughput, 100k's IOPS, <1ms latency
- Features:
    - VSS - user-driven restores (view previous versions)
    - Native file system accessible over SMB
    - Uses Windows permission model
    - Supports DFS - scale-out file share structure, group file shares together in one enterprise-wise structure
    - Managed - no file server admin
    - Integrates with Amazon managed DS or our own directory

## FSx for Lustre

- File system designed for high performance workloads
- Is a managed implementation of the Lustre file system, designed for HPC - Linux clients (POSIX file system)
- Lustre is designed for machine learning, big data, financial modelling
- Can scale to 100's GB/s throughput and offers sub millisecond latency
- Can be provisioned using 2 different deployment types:
    - Persistent: provides HA in one AZ only, provides self-healing, recommended for long term data storage
    - Scratch: highly optimized for short term solutions, no replication is provided
- FSx is available over VPN or DX for on-premises
- S3 repository: files are stored in S3 and they are lazily loaded into FSx for Lustre file system at first usage
- Sync changes between the file system and S3: `hsm_archive` command. The file system and the S3 bucket are not automatically in sync
- Lustre file system:
    - MST - Metadata stored on Metadata Targets
    - OST - Objects are stored on object storage targets, each can be up to 1.17 TiB
- Baseline performance of the file system is based on the size:
    - Size: min 1.2 TiB  and then we can use increments of 2.4 TiB
    - Scratch: base 200 MB/s per TiB of storage
    - Performance offers: 50 MB/s, 100 MB/s and 200 MB/s per TiB storage
    - For both types we can burst up to 1300 MB/s per TiB using credits
- FSx for Luster deployment types:
    - Scratch:
        - Is designed for pure performance, for short term and temporary workloads
        - Does not provide any type of HA or replication, in case of a HW failure all the data stored on that hardware is lost
        - Larger file systems mean more servers, more disks => more chance of failure
    - Persistent:
        - Has replication within one AZ only
        - Auto-heals when hardware failure occurs
    - Both of these options provide backups to S3 (manual or automatic with a retention of 0-35 days)

## FSx for NetApp ONTAP

- Fully managed storage built on NetAPP ONTAP
- Provides reach set of features available with NetApp's data management software:
    - Storage efficiencies: compression, deduplication, compaction, thin provisioning
    - Low-cost, fully elastic capacity pool tiering
    - Data protection: snapshots, SnapVault and native Amazon FSx backups
    - Disaster recovery using SnapMirror and Amazon FSx Backups
    - Caching: FlexCache, Global File Cache
    - Multiprotocol access from Linux, Windows
    - Other features: antivirus scanning
- Intelligent policy-based data movement between tier:
    - Amazon FSx for NetApp ONTAP file system has two storage tiers: primary storage and capacity pool storage
        - Primary storage is provisioned, scalable, high-performance SSD storage (up to 192 TB) that’s purpose-built for the active portion of our data set
        - Capacity pool storage is a fully elastic storage tier that can scale to petabytes in size and is cost-optimized for infrequently accessed data
    - Enabling tiering allows intelligent data movement between tiers based on the access
- Use case for NetApp ONTAP:
    - Backup and archive using SnapVaults
    - Cross region DR copy of FSx file data using SnapMirror
    - FlexCache for caching data and bringing data closer between regions and on-prem access
    - Can be used with Amazon WorkSpaces to provide shared network-attached storage (NAS) or to store roaming profiles for Amazon WorkSpaces accounts

## FSx for OpenZFS

- Fully managed file storage service built on the open-source OpenZFS file system
- Can be accessed over the industry-standard Network File System (NFS) protocol
- Powered by AWS Graviton processors, along with the latest AWS disk and networking technologies
- Use cases:
    - Migration of on-premises data stored in ZFS or other Linux-based file servers to AWS
    - Wide range of Linux, Windows, and macOS workloads, including big data and analytics, code and artifact repositories, DevOps solutions, web content management, front-end electronic design automation (EDA), genomics research, and media processing
- Data security:
    - Encryption of data at rest is automatically enabled when we create an Amazon FSx for OpenZFS file system through the AWS
    - Amazon FSx for OpenZFS uses industry-standard AES-256 encryption algorithm to encrypt file system data at rest
    - Amazon FSx for OpenZFS file systems automatically encrypt data in transit when they are accessed from Amazon EC2 instances that support encryption in transit

# AWS Global Accelerator

- Designed to optimize the flow of data from user to AWS
- Similar to CloudFront, both improve performance when communicating with services hosted in AWS
- Global Accelerator provides 2 **anycast** IP addresses. Anycast IP addresses are special type of IP addresses
- Normal IP addresses are called **unicast** IP addresses, these refer to one device in the network
- In contrast anycast IP addresses can be used by multiple devices at the same time, the traffic will be routed to the device closest to the source
- Global Accelerator uses the AWS Edge Locations. Since multiple locations advertise the given anycast IP addresses, the traffic will be routed to the Edge Location closer to the user
- AWS has its own dedicated network consisting in fiber links. Edge Locations relay traffic to this network improving performance

## CloudFront vs Global Accelerator

- CloudFront moves the content closer to the customer by caching it on the Edge Location. Global Accelerator moves the customer closer to the service pe providing access to the AWS global network
- Global Accelerator is a network product: works on any TCP/UDP applications including web apps (HTTP/HTTPS). CloudFront only caches HTTP/HTTPS content
- Global Accelerator does not cache anything. It does not understand the HTTP/HTTPS protocol

# AWS Glue

- Is a serverless ETL (Extract, Transform, Load) product
- Similar to AWS Datapipeline (which can do ETL) but it uses servers (EMR clusters)
- Glue is used to move data and transform data between source and destination
- Glue also crawls data sources and generates the AWS Glue Data catalog
- Supports a range of data collection as data sources: S3, RDS, JDBC compatible data sources and DynamoDB
- Supports data streams as data sources such as Kinesis Data Streams and Apache Kafka
- Data targets supported: S3, RDS, JDBC data sources

## Data Catalog

- Collection of persistent metadata about data sources in a region
- Provides one uniq data catalog in every region per account
- It helps avoid data silos: makes data not visible in an organization be visible a able to be browsed
- Data Catalog can be used by Amazon Athena, Redshift Spectrum, EMR and AWS Lake Formation
- Data is discovered by configuring crawlers and givin it credentials to access data sources

## Glue Job

- Extract, Transform an Load jobs
- Jobs can do transformation by using scripts created by us
- Jobs are serverless, AWS maintains a pool of resources
- We are only billed by resources we consume

# AWS GuardDuty

- It is a security service used for continuous monitoring of an account
- It can be integrated with supported data sources, constantly monitoring them
- It uses AI/ML and thread intelligent feeds for monitoring for suspicious activities
- Identifies any unexpected and unauthorized activity and it tries to spot odd activities
- If it finds something, it can be configured to notify us or to do event-driven protection/remediation
- Supports multiple accounts (Master and Member accounts)
- GuardDuty architecture:
    ![GuardDuty architecture](images/AmazonGuardDuty.png)

# Gateway Load Balancers (GWLB)

- It is a product to help us run and scale third party security appliances
- This appliances can be firewalls, intrusion detection and prevention systems or even data analysis tools
- We can use these to perform inbound and outbound transparent traffic inspection and protection
- At high level a GWLB has to major components:
    - GWLB endpoints: run from a VPC where traffic enters/leaves via these endpoints. This are similar to interface endpoints with some key improvements
    - GWLB itself: there are normal EC2 instances running security software
- The GWLB needs to forward traffic without any alteration, the security appliance needs to review packets as they are sent/received
- GWLB use a protocol named GENEVE, this is a traffic and metadata tunneling protocol
- GWLBs are layer 3/4 devices, similar to NLB, but they integrate with GWLB endpoints and they encapsulate all traffic between them and the target using the GENEVE protocol. When the scanning is finished, the traffic is returned on the same tunnel to the GWLB from where, using the GWLB endpoint, it is returned to the intended destination
- GWLB will load balance between security appliances, so we can horizontally scale
- GWLB manage flow stickiness, one flow of data will always use the same appliance
- Ingress route tables:
    - They are placed on the internet gateway
    - They influence what happens with the traffic arriving to the VPC
    - They can redirect traffic to GWLB endpoints
- GWLB architecture:

    Below is an architecture where EC2 instances are running in a pair of private subnets followed by ALB which is runig in pair of public subnets. On thie right side we have a VPC running a set of security applicances inside ASG which ca grow or sink based on the load. 

    1. The traffic hits the IG which is configure with route table which determines what happens if the traffic arrives at VPC.
    2. Traffic is routed to GWLB endpoint. 
    3. Traffic is forwarded to GWLB itself whichis running in security VPC. At this point the packets still have original IP address.
    4. Packets are encapsulated using GENEVE protocol and forwarded to security appliances.
    5. Once the packets are aalyzed, they are returned to the GWLB.
    6. The packets are stripped and returned back to GWLB endpoint via the internet.
    7. Since the original IP are maintained, the traffic is routed to ALB using local route table.
    8. The traffic is forwarded to the choosen application instance.
    9. The traffic is returned back from instance to the GWLB in steps from 9 to 14, following the same flow as it came to the instance.
    15. The data is sent back to the original client using the IG. 


    ![GWLB Architecture](images/GWLB3.png)

# IAM: Identity and Access Management

- When accessing AWS, the root account should **never** be used. Users must be created with the proper permissions. IAM is central to AWS
- **Users**: A physical person
- **Groups**: Functions (admin, devops) Teams (engineering, design) which contain a group of users
- **Roles**: Internal usage within AWS resources
    - **Cross Account Roles**: roles used to assumed by another AWS account in order to have access to some resources in our account
- **Policies (JSON documents)**: Defines what each of the above can and cannot do. **Note**: IAM has predefined managed policies
    - There are 3 types of policies:
        - AWS Managed
        - Customer Managed
        - Inline Policies
- **Resource Based Policies**: policies attached to AWS services such as S3, SQS

## IAM Roles vs Resource Based Policies

- When we assume a role (user, application or service), we give up our original permission and take the permission assigned to the role
- When using a resource based policy, principal does not have to give up any permissions
- Example: user in account A needs to scan a DynamoDB table in account A and dump it in an S3 bucket in account B. In this case if we assume a role in account B, we wont be able to scan the table in account A
  
## Best practices

- One IAM User per person **ONLY**
- One IAM Role per Application
- IAM credentials should **NEVER** be shared
- Never write IAM credentials in your code. **EVER**
- Never use the ROOT account except for initial setup
- It's best to give users the minimal amount of permissions to perform their job

# IAM Identity Center (Successor to AWS Single Sing-On - SSO)

- A way to use existing enterprise identity store with AWS
- Allows to centrally manage SSO access to multiple AWS accounts and external business applications as well
- Replaces the historical uses cases provided by SAML 2.0
- Flexible Identity store: where identities are stored. Allows for external identities to be swapped with AWS credentials
- IAM Identity Center supports the following type of identity stores:
    - Built-in identity store
    - AWS Managed Microsoft AD
    - On-premise Microsoft AD (Two way trust or AD Connector)
    - External Identity Provider - SAML 2.0
- IAM Identity Center is preferred by AWS for any "workforce" (enterprise) identity federation over the traditional SAML 2.0 based identity federation

## IAM Identity Center Architecture

![IAM Identity Center](images/AWSSSO.png)

- A requirement of IAM Identity Center is that we should have a valid AWS Organization created

# AWS Inspector

- Is a product designed to check EC2 instances and the operating systems running on those instances, as well as container workflows, for any vulnerabilities or deviations against best practice
- Inspector can be run for a certain period of time (15 min, 1 hour, 1 day, etc.) to identify any unusual traffic and configurations which can put instances to risk
- At the end of this process, Inspector provides a report of findings ordered by severity
- Inspector can work with 2 main type of assessments:
    - Network Assessment: can be conducted agentless, but adding an agent can provide a more richer assessment
    - Network and Host Assessment: requires an agent to be installed. The host assessment looks for OS level vulnerabilities, so it requires the presence of an agent
- Rules packages: determine what is checked on an instance
- Examples of rule packages:
    - **Network Reachability**: 
        - Can be done with no agent or with an agent providing OS visibility
        - Checks reachability end to end
        - Returns the following findings:
            - `RecognizedPortWithListener`
            - `RecognizedPortNoListener`
            - `RecognizedPortNoAgent`
            - `UnrecognizedPortWithListener`
    - **Host Assessment**:
        - Agent is required
        - Checks for Common vulnerabilities and exposures (CVE)
        - Center for Internet Security (CIS) Benchmarks
        - Security best practices for Amazon Inspector

# AWS IoT

- IoT - Internet of Things

## AWS IoT Core

- AWS IoT Core is a product set in AWS, used for managing millions of IoT devices
- IoT devices can be temp, wind, water sensors, light sensors, valve control sensors, etc.
- All of these need to be registered into a system to allow secure communication for managing them: provisioning, updates and control
- Communication to or from devices is likely to be unreliable, so AWS provides *device shadows*: virtual representations of actual devices, having the same configuration registered for the actual device. We can read from them the last communicated data, essentially the device communicates with the shadow, the last registered data can be retrieved anytime afterwards
- Device messages are sent JSON format, using MQTT protocols
- AWS IoT provides rules: event-driven integration with other AWS Services
- AWS IoT architecture:
    [AWS IoT architecture](images/ElasticTranscoder&AWSIoT.png)

## AWS IoT Device Management

- Helps us to register, organize, monitor and remotely manage IoT devices at scale

## AWS IoT Device Defender

- Used to audit configurations, authenticate devices, detect anomalies and receive alerts to help us secure our IoT device fleet

## AWS IoT 1-Click

- Used to launch AWS Lambda functions from IoT devices
- We can also create actions in the cloud or on-premises

## AWS Greengrass

- AWS Greengrass is an extension of the services provided by AWS IoT, moving those services closer to the edge
- Greengrass allow some services like compute, messages, data management, sync and ML capabilities to run from edge devices
- Devices with Greengrass Core software can locally run Lambda functions or containers => compute can run locally without leaving the local network
- Greengrass provides local device shadows which are synced back to AWS
- Allows messaging using MQTT
- Allows local hardware access for Lambda functions

## AWS IoT Analytics

- Used to run analytics on IoT data and get insights to make better and more accurate decisions
- Supports up to petabyte of data from millions of devices

## AWS IoT Events

- Used to detect and respond to events from IoT sensors and applications
- We can ingest data from multiple sources to detect the state of our processes or devices and proactively manage maintenance schedules

## AWS IoT SiteWise

- Simplifies collecting, organizing and analyzing industrial equipment data
- We can organize sensor data streams from multiple production lines and facilities to drive efficiencies across locations

## AWS IoT TwinMaker (formerly AWS IoT Things Graph)

- Used to create digital twins of real-world systems such as buildings, factories, industrial equipment and production lines
- We used this to quickly pinpoint and address equipment and process anomalies from the plant floor to improve worker productivity and efficiency

# Amazon Kendra

- Is an intelligent search service
- It's primary aim is to be designed to mimic interacting with a human expert
- Supports wide range if question types such as:
    - Factoid: Who, What, Where
    - Descriptive: How do I get my cat to spot being a jek?
    - Keyword: What time is the keynote address (address can have multiple meaning) - Kendra helps determine intent

## Key Concepts

- **Index**: searchable data organized in an efficient way
- **Data Source**: where the data lives, Kendra connects and indexes from this location. Example of locations are: S3, Confluence, Google Workspaces, RDS, OneDrive, Salesforce, Kendra Web Crawler, Workdocs, FSX, etc.
- We configure Kendra to synchronize a data source with an index based on a **schedule**. This should keep the index current
- **Documents**: can be structured (FAQs) and unstructured (HTML, PDF, etc.)

## Others

- Kendra integrates with other AWS services: IAM, Identity Center (SSO) and others

# Kinesis Video Streams

- Allows us to ingest live video data from producers
- Producers can be security cameras, smartphones, cars, drones, time-serialised audio, thermal, depth and RADAR data
- Consumers can access the data frame-by-frame or as needed
- Kinesis can persist and encrypt data in-transit and at rest
- We can not access data directly via storage, only via APIs!
- Data is not stored in its original format. Data is indexed and stored in a structured way
- Kinesis Video Streams integrates with other AWS services such as Rekognition and Connect

# Kinesis

- Is a scalable streaming service, designed to ingest lots of data
- Producers send data into a Kinesis stream, the stream being the basic entity of Kinesis
- Streams can scale from low to near infinite data rates
- It is a public service and it is highly available in a region by design
- Persistence: streams store by default a 24H moving window of data
- Kinesis include storage to be able to ingest and retain it for 24H by default (can be increased to 365 days at additional cost)
- Multiple consumers can access the data from that moving window

## Kinesis Data Streams

- Kineses Data Streams are using shards architecture for scaling, initially there is one shard, additional shards can be added over time to increase performance
- Each shard provides its own capacity, each shard has 1MB/s ingestion capacity, 2MB/s consumption capacity
- Shards directly affect the price of the Kinesis stream, we have to pay for each shard
- Pricing is also affected by the length of the storage window. By default is 24H, it can be increased to 365 days
- Data is stored in Kinesis Data Records (1MB), these records are distributed across shards

## SQS vs Kinesis Data Streams

- Is it about ingestion (Kinesis) of data or about decoupling, worker pools (SQS)
- SQS usually has 1 production group, 1 consumption group
- SQS is designed for decoupling and asynchronous communication
- SQS does not have the concept of persistence, no window for persistence
- Kinesis is designed for huge scale ingestion, having multiple consumers with different rate of consumption
- Kinesis is recommended for ingestion, analytics, monitoring, click streams

## Kinesis Data Firehose

- Used to provide data ingestion for other AWS services such as S3
- Fully managed service used to load data for data lakes, data stores and analytics services
- Data Firehose scales automatically, it is serverless and resilient
- It is not a real time product, it is a Near Real Time product with a deliver product of ~60 seconds
- Supports transformation of data on the fly using Lambda. This transformation can add latency
- Firehose is a pay as you go service, we pay per volume of data
- Firehose supported destinations:
    - HTTP endpoints (third party providers)
    - Splunk (has direct support for it)
    - RedShift
    - OpenSearch (ElasticSearch)
    - S3
- Firehose can accept data directly from producers or from Kinesis Data Streams
- Firehose receives the data in real-time, but the ingestion is buffered
- Firehose buffer by default waits for 1MB of data in 60 seconds before delivering to consumer. For higher load, it will deliver every time there is an 1MB chunk of data
- Data is sent directly form Firehose to destination, exception being Redshift, where data is stored in an intermediary S3 bucket
- Firehose use cases:
    - Persistence for data coming into Kinesis Data Streams
    - Storing data in a different format (ETL)

## Kinesis Data Analytics

- It is a real-time data processing product using SQL
- The product ingests data from Kinesis Data Streams or Firehose
- After the data is processed, it can be sent directly to destinations such as:
    - Firehose (data becoming near-real time)
    - Kinesis Data Streams
    - AWS Lambda
- Kinesis Data Analytics architecture:
    ![Kinesis Data Analytics architecture](images/KinesisDataAnalytics.png)
- Kinesis Data Analytics use cases:
    - Anything using stream data which needs real-time SQL processing
    - Time-series analytics: election data, e-sports
    - Real-time dashboards: leader boards for games
    - Real-time metrics

# Encryption and KMS

## Encryption Approaches

- **Encryption At Rest**: designed to protect against physical threat or tempering
    - Data is stored in shared hardware in an encrypted form, even if somebody has access to hardware it can not access the data in a readable format
    - General used when one party is involved
- **Encryption In Transit**: aimed to protect data when transferred between 2 places
    - Generally used when multiple individual/systems are involved

## Encryption Concepts

- Plaintext: un-encrypted data, can be text, image, other application, etc.
- Algorithm: peace of code which takes plaintext and a key and generates encrypted data. Examples of algorithms: Blowfish, AES, RC4, DES, RC5 and RC6
- Key: is a password
- Ciphertext: when an algorithm takes the plaintext and the key, the output generated is cyphertext (encrypted data)

## Symmetric Encryption

- Symmetric Keys: the same key can be used for encryption and for decryption as well
- Symmetric encryption algorithms: AES-256
- Great for encryption at rest, not recommended for encryption in-transit

## Asymmetric Encryption

- Makes it much easier to exchange keys
- Asymmetric algorithms: RSA, ElGamal
- Asymmetric Keys: are formed of 2 parts: public key and private key
- A public key can be used to generate cyphertext which can only be encrypted by the private key
- Asymmetric encryption is used by PGP, SSL, SSH, etc.

## Signing

- Process used to prove identity of a message
- A message can be signed with a private key and verified using the public key

## Steganography

- A process to hide encrypted data in plaintext data

## KMS - Key Management Service

- It is a regional and a public service
- Let's us create, store and manage cryptographic keys
- Can handle symmetric and asymmetric keys
- Can perform cryptographic operations such as encryption and decryption
- **Keys never leave KMS!** Keys can be created, imported but they are locked inside KMS
- KMS also provides a FIPS 140-2 (L2) compliance <span style="background-color: Red"><-- REMEMBER THIS</span>

### KMS Keys (Formerly known mainly as CMK - Customer Master Keys)

- Main things managed by KMS are KMS keys
- They are used by KMS in cryptographic operations
- They are logical containing the following things: ID, date, policy, description and state
- Every KMS key is backed by physical key material. The physical key material can be generated by KMS or imported by KMS
- KMS keys can be used to directly encrypt or decrypt data for up to 4KB of data

### DEK - Data Encryption Keys

- Data Encryption Keys are generated from KMS keys using `GenerateDataKey` API
- These keys can be used to locally encrypt/decrypt data with size larger than 4KB
- DEK generated is linked to a specific KMS keys
- KMS does not store the DEK in any way, it is generated and provided to the user and it is discarded afterwards
- KMS provides 2 version of the key a plaintext and a ciphertext encrypted with the CMK
- It is expected from us to discard the plaintext key as soon as we encrypted the data
- The encrypted data and the encrypted data encryption key should be stored side by side
- For decryption of the data we pass back to KMS the encrypted DEK to be decrypted and with the decrypted key we decrypt the data itself

### Key Concepts

- KMS keys are isolated to a region and never leave KMS (by default)
- KMS also supports multi-region keys, where keys are replicated to other regions
- There are 2 types of keys: AWS owned and customer owned. In case of customer owned keys, we can have AWS managed (created automatically) or customer managed keys (created explicitly by the customer)
- Customer managed keys are more configurable. For example, we can edit the key policy to allow cross account access to the key
- KMS keys support rotation. Rotation is optional for customer managed keys
- A KMS key contains the backing key, the physical key material and all previous backing keys caused by rotation => data encrypted with previous keys can still be decrypted
- We can create aliases for KMS keys. Aliases are per region
- Key policies and security:
    - Key Policies (Resource): they are different compared to policies other AWS services have in the way that each KMS keys policy has to explicitly allow access from the owner AWS account
    - Every KMS keys has a key policy
    - KMS keys are very granular

# AWS Lambda

- Lambda is a Function-as-a-Service (FaaS) product. We provide specialized short running focused code for Lambda and it will take care running it and billing us for only what we consume
- Every Lambda function uses a supported runtime, example: Python 3.8, Java 8, NodeJS
- Every Lambda function is loaded into an executed in a runtime environment
- When we create a function we define the resources the function will use. We define the memory directly and CPU usage allocation indirectly (based on the amount of memory)
- We are only billed for the duration the function is running based on the number of invocations and the resources specified
- Lambda is a key part of serverless architectures in AWS
- Lambda has support for the following runtimes:
    - Python
    - Ruby
    - Go
    - Java
    - C#
    - Custom using Lambda layers (such as Rust)
- Lambda deployment package size:
    - 50 MB zipped
    - 250 MB unzipped
    - Up to 10 GB as a Docker image
- Lambda functions are stateless, meaning there is no data left over after an invocation
- When creating a Lambda function we define the memory. The memory can be between 128 MB and 10240 MB in 1 MB steps
- We do not directly define the vCPU allocated to each function, it will automatically scale with the memory: 1769 MB of memory gives 1 vCPU
- The runtime env. has a 512 MB (by default) storage available as `/tmp`. We can scale this storage up to 10240 MB. We can use this storage for whatever we need as long as we assume that it is blank at each execution of the function
- Lambda function can run up to 15 minutes, after this a timeout will occur
- The security for a Lambda function is controlled by the execution role. This is an IAM role attached to the function. This can have permissions for integration with other AWS services

## Lambda Networking

- Lambda functions can have 2 types of networking modes:
    - Public (default):
        - Lambda can access public AWS services such as SQS, DynamoDB, etc. and also internet based services
        - Lambda has network connectivity to public services running on the internet
        - Offers the best performance for Lambda, no customer specific networking is required
        - With public networking mode Lambda function wont be able to access resources in a VPC unless the resources do have public IPs and security controls allow external access
    - VPC Networking:
        - Lambda functions will run inside a VPC, so they will access everything in a VPC, assuming NACLs and SGs allow access
        - They wont be able to access services outside of the VPC, unless networking configuration exists in the VPC to allow external access
        - The Lambda needs `EC2Networking` permissions in order ot be able to create ENIs in the VPC
        - VPC based Lambda functions do not directly in the VPC, they will use a shared ENI to access resources in the VPC as long as all the functions have the same Security Group. In case new Security Groups are attached to a certain Lambda, new ENIs are placed inside the VPC
        - At the creation of the function, a certain ENI might be created for accessing the VPC. The initial setup would take up to 90 seconds. This setup will take place only once, not at every invocation

## Lambda Security

- There are 2 key parts of the security model
    - Lambda Functions will assume an execution role in order to access other AWS resources
    - Resource policies: similar to resource policies for S3. Allows external accounts to invoke a Lambda functions, or certain services to use Lambda functions. Resources polices can be modified using the CLI/API (currently cannot be changed with the console)

## Lambda Logging

- Lambda uses CloudWatch Logs and X-Ray
- Logs from Lambda executions are stored in CloudWatch Logs
- Details about Lambda metrics are stored in CloudWatch Metrics
- Lambda can be integrated with X-Ray for distributed tracing
- For Lambda to be able to log we need to give permissions via the execution role

## Lambda Invocations

- There are 3 ways Lambda functions can be invoked:
    - **Synchronous invocation**:
        - Command line or API directly invoking the function
        - The CLI or API will wait until the function returns
        - API Gateway will also invoke Lambdas synchronously, use case for many serverless applications
        - Any errors or retries have to be handled on the client side
    - **Asynchronous invocation**:
        - Used typically when AWS services invoke the function (example: S3 events)
        - The service will not wait for the response (fire and forget)
        - Lambda is responsible for any failure. Reprocessing will happen between 0 and 2 times
        - The function should be idempotent in order to be rerun
        - Lambda can be configured to send events to a DLQ in case of the processing did not succeed after the number of retries
        - Destination: events processed by Lambdas can be delivered to destinations like SQS, SNS, other Lambda, EventBride. Success and failure events can be sent to different destinations
    - **Event Source mapping**:
        - Typically used on streams or queues which don't generate events (Kinesis, DynamoDB streams, SQS)
        - Event Source mappers polls these streams and retrieves batches. These batches can be broken in pieces and sent to multiple Lambda invocations for processing
        - We can not have a partially successful batch, either everything works or nothing works
- In case of event processing in async invocation, in order to process the event we don't explicitly need rights to read from the sender
- In case of event source mapping the event source mapper is reading from the source. The event source mapping uses permissions from the Lambda execution role to access the source service
- Even if the function does not read data directly from the stream, the execution role needs read rights in order to handle the event batch
- Any batch that consistently fails to be processed, it can be sent to an SQS queue or SNS topic for further processing

## Lambda Versions

- We can define different versions for given functions
- A version of a function is the code + configuration of the function
- When we publish a version, it becomes immutable, it no longer can be changed. It event gets its own ARN (Amazon Resource Name)
- `$Latest` points to the latest version of Lambda version (it is not immutable)
- We can also define aliases (DEV, STAGE, PROD) which point to a version of the function. Aliases can be changed to point to other versions

## Lambda Start-up Times

- Lambda code runs inside of a runtime environment (execution context)
- At first invocation this execution context needs to be created and this will take time
- This process is known as cold start and it can take 100ms or more
- If the function is invoked again without too much of a gap, it might use the same execution context. This is called warm start
- One function invocation runs in an execution environment at a time. If multiple parallel instances are needed, the contexts will require cold starts
- **Provisioned concurrency**: we can provision one or more execution contexts in advance for Lambda invocations
- The improve performance we can use the `/tmp` folder to pre-download data to it. If another invocations uses the same execution context, it will be able to access the previously downloaded data
- We can create database connections outside of the Lambda handler. These will also be available for other invocations afterwards

## Lambda Function Handler

- Lambda function executions have life cycles
- The function code runs inside an execution environment
- Lifecycle phases:
    - `INIT`: creates or unfreezes the execution environment
        - It has the following sub-components:
            - `EXTENSION INIT`
            - `RUNTIME INIT`
            - `FUNCTION INIT`
        - Init phase runs only at cold-starts
    - `INVOKE`: runs the function handler (cold start)
    - `NEXT INVOKE`(s): warm start using the same environment
    - `SHUTDOWN`: execution environment is terminated after a period of inactivity
        - It has the following sub-components:
            - `RUNTIME SHUTDOWN`
            - `EXTENSION SHUTDOWN`
        - We can use Provisioned Concurrency to avoid having a cold-start in case the Lambda should be terminated

## Lambda Versions and Aliases

- Unpublished functions can be changed and deployed
- `$LATEST` version of the Lambda code can be edited and deployed
- We can take the current state of the function and publish it which will create an immutable version
- If the function is published, the code, dependencies, runtime settings and env. variables in the version created can not be edited
- Each version gets an uniq ARN (Qualified ARN)
- Unqualified ARN points at the function without a specific version (`$LATEST`)
- An alias is a pointer to a function version
- Example: PROD => function:1, BETA => function:2
- Each alias has an unique ARN
- Aliases can be updated, changing which version they reference
- Useful for PROD/DEV, BLUE/GREEN deployments, A/B testing
- We can also use alias routing: sending a certain percentage of request to v1 and other percentage to v2. Both versions need the same role, same DLQ (or no DLQ) will be used and both versions need to be published

## Lambda Environment Variables

- Key and value pairs for associated with Lambda functions
- By default they are associated with `$LATEST` - can be edited
- If they are publishes, they can not be edited
- They can be accessed within the execution environment
- The environment variables can be encrypted with KMS
- They allow code execution to be adjusted based on variables

## Lambda Layers

- Used to split off libraries and dependencies from Lambda functions
- Reduces the size of the deployment package
- Layers can be reused by multiple Lambda functions
- Libraries in layers are extracted in the `/opt` folder
- Layers allow new runtimes which are not explicitly supported by AWS

## Lambda Container Images

- Until recently Lambda was considered to be a Function as a Service (FaaS) product, which means creation of a function, uploading code and executing it
- Many organizations use containers and CI/CD processes built for containers
- Lambda is now capable to use containers images
- It is an alternative way of packaging the function code and using it with the Lambda product
- Lambda Runtime API - has to be included with the container images, it is a package which allows interaction between a container and the Lambda
- AWS Lambda Runtime Interface Emulator (RIE): used for local Lambda testing

## Lambda and ALB

- Lambda functions can be registered to ALB target groups
- Communication between the user and the ALB is via HTTP/HTTPS, there is no difference than connecting to a classic server (EC2) from the user's perspective
- When the ALB receives a request from the client it synchronously invokes the Lambda function
- The LB passes in a JSON structure to the Lambda function, inside the `Event` structure. This has to be interpreted by the Lambda. What actually happens is that the LB translates the HTTP(S) request to a Lambda compatible event, to which the Lambda answers with a JSON object that gets translated back to HTTP/HTTPS response
- Multi-Value headers:
    - For an example lets us this URL for the Lambda: http://catagram.io?&search=roffle&search=winkie
    - Without multi-value headers the Lambda receives the following:
        ```
        "queryStringParameters": {
            "search": "winkie"
        }
        ```
    - If the multi-value headers are enabled, we get this delivered to Lambda:
        ```
        "multiValueQueryStringParameters": {
            "search": ["roffle", "winkie"]
        }
        ```

# Amazon Lex and Amazon Connect

## Amazon Lex

- Provides text or voice conversational interfaces (Lex for voice, Lex for Alexa)
- Powers the Alexa service
- Lex provides 2 main bits of functionality:
    - Automatic speech recognition (ASR) - speech to text
    - Natural Language Understanding (NLU) - intent
- Lex allows us to build voice and text understanding into our applications
- It scales well, integrates with other AWS services, it is quick to deploy and it has a pay as you go pricing model
- Use cases:
    - Chatbots
    - Voice Assistants
    - Q&A Bots
    - Info/Enterprise Bots

## Amazon Connect

- It is a contact center as a service
- Requires no infrastructure in on-premises
- It is omnichannel: voice and chat, incoming and outgoing
- Integrates with PSTN networks for traditional voice, allowing us to accept incoming calls and make outgoing calls using the traditional cellular phone networks
- Agents can connect using the internet from anywhere
- AWS Connect can integrate with other services such as Lambda/Lex for additional intelligence and features
- It is quick to provision, provides a pay as you go pricing. It is scalable

# Amazon Macie

- It is a data security and data privacy service
- Macie is a service to discover, monitor and protect data stored in S3 buckets
- Once enabled and pointed to buckets, Macie will automatically discover data and categorize it as PII, PHI, Finance etc.
- Macie is using data identifier. There are 2 types of data identifier:
    - Managed Data Identifier: built-in, can use machine learning, pattern matching to analyze and discover data. It is designed to detect sensitive data from many countries
    - Custom Data Identifier: created by clients, they are proprietary to accounts and they are regex based
- Discovery Jobs: these jobs will use data identifiers to manage and search for sensitive content. They will generate findings which can be used for integration with other AWS services (ex: Security Hub from where findings can be passed to Event Bridge) in order to do automatic remediation
- Macie uses multi account architecture: one account is the administrator account which can used to manage Macie within the member accounts to discover sensitive data
- This multi-account structure can be done with AWS Organizations or by explicitly inviting accounts in Macie

## Macie Identifiers

- Data Discovery Jobs: analyzes data in order to determine wether the objects contain sensitive data. This is done using data identifiers
- **Managed Data Identifiers**:
    - Created and managed by AWS
    - Can be used to detect a growing list of common sensitive data types: credentials, financial data, health data, personal identifiers (addresses, passports, etc.)
- **Custom Data Identifiers**:
    - Can be created by us, AWS account users/owners
    - They are using regex patterns to match data
    - We can add optional keywords: optional sequences that need to be in the proximity to regex match
    - Maximum Match Distance: how close keywords are to regex pattern
    - We can also include ignore words

## Macie Findings

- Macie will produce 2 types of findings:
    - **Policy Findings**: are generated when the policies or settings are changed in a way that reduces the security of the bucket after Macie is enabled
    - **Sensitive Data Findings**: generated when sensitive data is identified based on identifiers
- Types if policy findings:
    - `Policy:IAMUser/S3BlockPublicAccessDisabled`: all bucket-level block public access settings were disabled for the bucket
    - `Policy:IAMUser/S3BucketEncryptionDisabled`: default encryption settings for the bucket were reset to default Amazon S3 encryption behavior, which is to encrypt new objects automatically with an Amazon S3 managed key
    - `Policy:IAMUser/S3BucketPublic`: an ACL or bucket policy for the bucket was changed to allow access by anonymous users or all authenticated AWS Identity and Access Management (IAM) identities
    - `Policy:IAMUser/S3BucketSharedExternally`: an ACL or bucket policy for the bucket was changed to allow the bucket to be shared with an AWS account that's external to (not part of) your organization
- Types of sensitive data findings:
    - `SensitiveData:S3Object/Credentials`: object contains sensitive credentials data, such as AWS secret access keys or private keys
    - `SensitiveData:S3Object/CustomIdentifier`: object contains text that matches the detection criteria of one or more custom data identifiers
    - `SensitiveData:S3Object/Financial`: object contains sensitive financial information, such as bank account numbers or credit card numbers
    - `SensitiveData:S3Object/Multiple`: object contains more than one category of sensitive data
    - `SensitiveData:S3Object/Personal`: object contains sensitive personal information—personally identifiable information (PII) such as passport numbers or driver's license identification numbers, personal health information (PHI) such as health insurance or medical identification numbers, or a combination of PII and PHI

# Amazon Mechanical Turk

- Provides a managed human task outsourcing system
- Provides a set of APIs and a marketplace to outsource jobs to human beings
- Allows requesters to post Human Intelligence Tasks (HITs) to a marketplace
- Tasks are completed by workers, who earn money for it
- Pay per task, perfect for tasks suited to humans rather than ML
- Qualification: worker attribute, we can require a test. A qualification can be a requirement to complete HITs
- Great for data collection, manual processing, image classification

# Elastic Transcoder and AWS Elemental MediaConvert

- MediaConvert a fairly new AWS product replacing Elastic Transcoder
- MediaConvert is a superset of features provided by Transcoder
- Both of the systems are file based video transcoding systems
- They are serverless transcoding services for which we pay per use
- For both we add jobs to pipelines (ET) or queues (MC)
- Files are loaded from S3, processed and stored back to S3
- MC supports EventBridge for job signalling
- ET/MC architecture example:
    [ET/MC architecture](images/ElasticTranscoder&MediaConvert.png)
- We use these products when we need to the media convert in a serverless, event-driven media processing pipeline

## Choosing between ET and MC

- ET is legacy, by default we should chose MC
- MC supports more codecs, design for larger volume and parallel processing
- MC supports reserved pricing
- ~~ET required for WebM(VP8/VP9), animated GIF, MP3, Vorbis and WAV.~~ All of these codecs are supported for MC. For everything else we should use MediaConvert

# Multi-Factor Authentication (MFA)

- **Factor**: different piece of evidence which proves the identity
- Factors:
    - **Knowledge**: something we as users know: username, password
    - **Possession**: something we as users have: bank card, MFA device/app
    - **Inherent**: something we are, example: fingerprint, face, voice, iris
    - **Location**: a location (physical) or which network we are connected to (corporate wifi)
- More factors means more security, harder to bypass by an intruder


# Amazon MQ

- SNS and SQS are AWS services using AWS APIs
- SNS provides topics which are one to many communication channels, SQS provides queues which are one to one communication channels
- Both SNS and SQS are public services, HA and AWS integrated
- Larger organization might already use on-premise messaging systems, which are not entirely compatible with SNS and SQS
- Amazon MQ is an open-source message broker, is a managed implementation of Apache ActiveMQ
- It supports the JMS API and protocols such as AMQP, MQTT, OpenWire and STOMP
- It provides both queues and topics
- It uses message broker services which can be single instance (test, dev) and HA pair (Active/StandBy for production)
- Unlike SQS and SNS, Amazon MQ is not a public service, it runs in a VPC
- It does not have native integration with other AWS services in the same way as SNS/SQS
- Amazon MQ considerations:
    - By default we should chose SNS/SQS for newer implementation
    - We should use Amazon MQ if we migrate from an existing system with little to no application change
    - We should use Amazon MQ if we need APIs such as JMS or protocols such as AMQP, MQTT, OpenWire, STOMP
    - Amazon MQ requires the appropriate private networking

# Amazon Neptune

- Neptune is a managed graph database in AWS
- A graph database is a database type where the relationships between the data is as important as the data itself
- Neptune runs in a VPC, private by default
- It is resilient, it can be deployed in multiple AZs and scales via read replicas
- It does continuous backups and allows point-in-time recovery
- Common use cases for graph based data models:
    - Social media used databases - anything involving fluid relationships
    - Fraud prevention
    - Recommendation engines
    - Network and IT Operations
    - Biology and other life sciences

# AWS Network and DNS Firewalls

## AWS Network Firewall

- AWS Network Firewall is a stateful, managed, network firewall and intrusion detection and prevention service for your virtual private cloud
- It is a managed network appliance used to filter incoming/outgoing traffic
- In a VPC it is deployed in a separate subnet with a Firewall Endpoint
- Has a flexible rules engine which gives a fine-grained control over network traffic
- Resources send traffic to the firewall subnet, the firewall will redirect traffic to the gateway (internet gateway, transit gateway, DX connection, IPSEC VPN)
- The firewall endpoint uses gateway load balancer
- Route table configuration is needed for the protected subnet to be able to send outgoing traffic to the gateway load balancer
- Network Firewall deployment can be managed with AWS Organizations and AWS Firewall Manager
- Network Firewall features:
    - Stateful and stateless firewall
    - Intrusion Prevention System (IPS)
    - Web filtering
- In the firewall subnet we should not deploy any resources
- For HA we should allocate a subnet per AZ

## Route 53 Resolver DNS Firewall

- Allows us to filter and regulate outbound DNS traffic for VPCs
- Requests route through Route 53 Resolver for DNS queries, the DNS Firewall will help prevent DNS exfiltration of data
- We can monitor and control the domains application can query
- We can use AWS Firewall Manager to centrally configure and manage DNS Firewall

# AWS OpenSearch (Formerly known as ElasticSearch)

- Is a managed implementation of ElasticSearch, an open source search solution. It is part of the ELK stack (ElasticSearch, Logstash, Kibana)
- OpenSearch is not serverless, it runs in a VPC using compute
- OpenSearch is usually an alternative to other AWS services
- Can be used for log analytics, monitoring, security analytics, full text search and indexing, click stream analytics

## ELK Stack

- ElasticSearch (or OpenSearch on AWS): provides search and indexing services
- Kibana: visualization and dashboard tool
- Logstash: similar to CloudWatch Logs, needs a Logstash agent installed on anything to ingest data



# AWS OpsWorks

- OpsWorks is configuration managed service which provides AWS managed implementation of Chef a Puppet
- OpsWorks functions in one of 3 modes:
    - Puppet Enterprise: we can create an AWS Managed Puppet Master Server (desired state architecture)
    - Chef Automate: we can create AWS Managed Chef Servers (similar as IaC, set of steps using Ruby)
    - OpsWorks: AWS implementation of Chef, no servers. Chef at a basic level, little admin overhead
- Generally we should only chose to use them if we are required to use Chef or Puppet, for example in case of a migration
- Other use case would be a requirement to automate
- If you see any mention of Recipes, Cookbook or Manifests than you know that it would be any of the three options mentioned above.

## Opsworks Mode

- **Stacks**: core components of OpsWorks, container of resource similar to CFN stacks
- **Layers**: represent a specific function in a stack, example layer of load balancers, layer of database, layer of EC2 instances running a web application
- **Recipes** and **Cookbooks**: they are applied to layers. We can use them to install packages, deploy applications, run scripts, perform reconfigurations. Cookbooks are collections of recipes which can be stored on GitHub
- **Lifecycle Events**: special events which run on a layer, examples:
    - Setup
    - Configure: generally executed when instances are removed or added to the stack. It will run on all instances, including already existing ones
    - Deploy
    - Undeploy
    - Shutdown
- **Instances**: compute instances (EC2 instances or on-premise servers). They can be:
    - **24/7** instances: started manually
    - **Time-Based** instances: configured to start and stop on a schedule
    - **Load-Based** instances: turn on or off based on system metrics (similar to ASG)
- Instance **auto-healing**: Opsworks automatically restarts instances in they fail for some reason
- **Apps**: they can be stored in repositories such as S3. Each app is represented by an OpsWorks App which specifies the application type and containing any information needed to deploy the app from repositories to instances.
- OpsWorks architecture:
    ![OpsWorks architecture](images/AWSOpsWorks.png)

# AWS Organizations

- Standard AWS account: it is an account which is not in an AWS Organization
- We create an AWS Organization from a standard AWS account
- The organization is not created in this account, we just use the account to create the organization. The standard account then becomes the **Management Account** (used to be called *Master Account*)
- Using the Management Account we can invite other accounts into the organization
- When a standard account joins an organization, it will change to **Member Account** of that organization
- Organizations have 1 Management Account and 0 or more Member Accounts
- We can create a structure of AWS accounts in an organization. We can group accounts by things such as business units, function or development stage, etc.
- This structure is hierarchical, it is an inverted tree
- At the top of this tree is the root container of the organization (just a container within the organization, NOT to be confused with the root user)
- This root container can contain other containers, this containers are known as **Organizational Units (OU)**
- OUs can contains accounts (Management/Member accounts) or other OUs

## Consolidated Billing

- It is an important feature of AWS Organizations
- The individual billing method of each account from the organization is removed, the member accounts pass their billing through the Management Account (**Payer Account**)
- Using consolidated billing we get a single monthly bill. This covers the Management Account and all the Member Accounts of the Organization
- When using organization reservation benefits and discounts are pooled, meaning the organization can benefit as a whole for the spending of each AWS account within the org

## Best Practices

- Have a single account into which users can log into and assume IAM roles in order to access other accounts from the org
- The account with all the identities may be the Management Account or it can be another Member Account (*Login Account*)

## `OrganizationAccountAccessRole`

- This is an IAM role used to access the newly added/created account in an organization
- This role will be created automatically if we create the account from an existing organization
- This role has to be created manually in the member account if the account was invited into the organization

# Service Control Policies (SCP)

- They are a feature of AWS Organizations used to restrict AWS accounts
- They are JSON documents
- They can be attached to the root of the organization, to one or more OUs or to individual AWS accounts
- SCPs inherit down through the organization tree
- The Management Account is special: even if it has SCPs attached (directly or through an OU) it wont be affected by the SCP
- SCPs are account permission boundaries:
    - They limit what the account (including the root user of the account) can do
    - We can never restrict a root user from an account, but we can restrict the account itself, hence these restrictions will apply to the root user as well
- **SCPs don't grant any permissions!** This are just a boundary to limit what is and is not allowed in an account
- SCPs can be used in two ways:
    - Deny list (default): allow by default and block access to certain services
        - `FullAWSAccess`: policy applied by default to the org an all OUs when we enable SCPs. This policy means tha by default nothing is restricted
        - SCPs don't grant permissions, but when they are enabled, there is a default deny for everything. This is why the `FullAWSAccess` policy is needed
        - SCP priority rules:
            1. Explicit Deny
            2. Allow
            3. Default (implicit) deny
        - Benefits of deny lists is that as AWS is extends the list of service offerings, new services will be available for accounts (low admin overhead)
    - Allow list: block by default and allow certain services
        - To implement allow lists:
            1. Remove the `FullAWSAccess` policy
            2. Add any services which should be allowed in a new policy
        - Allow lists are more secure, but they require more admin overhead

# Other Data Analytics Related Products

## AWS Data Exchange

- AWS Data Exchange is a service that helps AWS easily share and manage data entitlements from other organizations at scale
- As a data receiver, we can track and manage all of our data grants and AWS Marketplace data subscriptions in one place
- For data senders, AWS Data Exchange eliminates the need to build and maintain any data delivery and entitlement infrastructure

## AWS Data Pipeline

- AWS Data Pipeline is a web service that we can use to automate the movement and transformation of data
- We you can define data-driven workflows, so that tasks can be dependent on the successful completion of previous tasks
- Components of a data pipeline:
    - Pipeline definition:  specifies the business logic of our data management
    - Pipeline: schedules and runs tasks by creating Amazon EC2 instances to perform the defined work activities
    - Task Runners: polls for tasks and then performs those tasks. For example, Task Runner could copy log files to Amazon S3 and launch Amazon EMR clusters. Task Runner is installed and runs automatically on resources created by your pipeline definitions
- Use case examples:
    - We can use AWS Data Pipeline to archive your web server's logs to Amazon Simple Storage Service (Amazon S3) each day and then run a weekly Amazon EMR (Amazon EMR) cluster over those logs to generate traffic reports

## AWS Lake Formation

- AWS Lake Formation is a service that makes it easy to set up a secure data lake in days
- Creating a data lake with Lake Formation is as simple as defining data sources and what data access and security policies we want to apply
- Helps us collect and catalog data from databases and object storage, move the data into new Amazon S3 data lake, clean and classify data using machine learning algorithms, and secure access to sensitive data

# AWS Systems Manager Parameter Store

- Used to store system configurations (documents, configurations, secrets, strings) in a resilient, secure and scalable way
- Stores data in a key-value format
- Many AWS services have native integration with Parameter Store
- Parameter store offers the availability to store 3 different type of values: Strings, StringLists and SecureStrings
- We can store license codes, database strings, full configs and passwords in Parameter Store
- Values can be stored in a hierarchical way. Different versions of the values are also stored
- Parameter Store can store plaintext and ciphertext which can be decrypted using the KMS integration
- Public Parameters: parameters maintained and provided by AWS, example: latest AMIs per region
- Parameter Store is public service
- Parameter Store is tightly integrated with IAM

# Policies

- IAM policies define permissions for an action regardless of the method that you use to perform the operation

## Policy types

- **Identity-based policies**: attach managed and inline policies to IAM identities (users, groups to which users belong, or roles). Identity-based policies grant permissions to an identity
- **Resource-based policies**: attach inline policies to resources. The most common examples of resource-based policies are Amazon S3 bucket policies and IAM role trust policies. Resource-based policies grant permissions to a principal entity that is specified in the policy. Principals can be in the same account as the resource or in other accounts
- **Permissions boundaries**: use a managed policy as the permissions boundary for an IAM entity (user or role). That policy defines the maximum permissions that the identity-based policies can grant to an entity, but does not grant permissions. Permissions boundaries do not define the maximum permissions that a resource-based policy can grant to an entity
- **Organizations SCPs**: use an AWS Organizations service control policy (SCP) to define the maximum permissions for account members of an organization or organizational unit (OU). SCPs limit permissions that identity-based policies or resource-based policies grant to entities (users or roles) within the account, but do not grant permissions
- **Access control lists (ACLs)**: use ACLs to control which principals in other accounts can access the resource to which the ACL is attached. ACLs are similar to resource-based policies, although they are the only policy type that does not use the JSON policy document structure. ACLs are cross-account permissions policies that grant permissions to the specified principal entity. ACLs cannot grant permissions to entities within the same account
- **Session policies**: pass advanced session policies when you use the AWS CLI or AWS API to assume a role or a federated user. Session policies limit the permissions that the role or user's identity-based policies grant to the session. Session policies limit permissions for a created session, but do not grant permissions. For more information, see Session Policies

## Policies Deep Dive

- Anatomy of a policy: JSON document with `Effect`, `Action`, `NotAction` (inverse condition of `Action`), `Resource`, `Conditions` and `Policy Variables`
- Priority order of permissions in AWS is: deny (explicit) > allow > deny (implicit). A policy always assumes a default (implicit) deny => if we do not allow explicitly to do something, we wont be able to do it
- An explicit `DENY` has always precedence over `ALLOW`
- Best practice: use least privilege for maximum security
    - Access Advisor: a tool for seeing permissions granted and when last accessed
    - Access Analyzer: used of analyze resources shared with external entities
- Common Managed Policies:
    - `AdministratorAccess`
    - `PowerUserAccess`: does not allow anything regarding to IAM, organizations and account (with some exceptions), otherwise similar to admin access
- IAM policy condition:

    ```
    "Condition": {
        "{condition-operator}": {
            "{condition-key}": "{condition-value}"
        }
    }
    ```

- Operators:
    - String: `StringEquals`, `StringNotEquals`, `StringLike`, etc.
    - Numeric: `NumericEquals`, `NumericNotEquals`, `NumericLessThan`, etc.
    - Date: `DateEquals`, `DateNotEquals`, `DateLessThan`, etc.
    - Boolean
    - IpAddress/NotIpAddress:
        - `"Condition": {"IpAddress": {"aws:SourceIp": "192.168.0.1/16"}}`
    - ArnEquals/ArnLike
    - Null
        - `"Condition": {"Null": {"aws:TokenIssueTime": "192.168.0.1/16"}}`
- Policy Variables and Tags:
    - `${aws:username}`: example `"Resource:["arn:aws:s3:::mybucket/${aws:username}/*"]`
    - AWS Specific:
        - `aws:CurrentTime`
        - `aws:TokenIssueTime`
        - `aws:PrincipalType`: indicates if the principal is an account, user, federated or assumed role
        - `aws:SecureTransport`
        - `aws:SourceIp`
        - `aws:UserId`
    - Service Specific:
        - `ec2:SourceInstanceARN`
        - `s3:prefix`
        - `s3:max-keys`
        - `sns:EndPoint`
        - `sns:Protocol`
    - Tag Based:
        - `iam:ResourceTag/key-name`
        - `iam:PrincipalTag/key-name`

## Permission Boundaries

- Only IDENTITY permissions are impacted by boundaries - any resource policies are applied full
- Permission boundaries can be applied to IAM Users and IAM Roles
- Permission boundaries don't grant access to any action. They define maximum permissions an identity can receive
- Use cases for permission boundaries:
    - Delegation problem: if we give elevated permissions to an user, he/she could promote itself to have administrator permissions or could create another user with administrator permissions
    - Solution is to have a boundary which forbids changing its onw user's permissions and forbid creating other users/roles with elevated permissions

## Policy Evaluation Logic

- Components involved in a policy evaluations:
    - Organization SCPs
    - Resource Policies
    - IAM Identity Boundaries
    - Session Policies
    - Identity Policies
- Policy evaluation logic - same account:
    ![policy evaluation logic - same account](images/PolicyEvaluation1.png)
- Policy evaluation logic - different account:
    ![policy evaluation logic - different account](images/PolicyEvaluation2.png)

## AWS Policy Simulator

- When creating new custom policies you can test it here:
  - https://policysim.aws.amazon.com/home/index.jsp
  - This policy tool can you save you time in case your custom policy statement's permission is denied
- Alternatively, you can use the CLI:
    - Some AWS CLI commands (not all) contain `--dry-run` option to simulate API calls. This can be used to test permissions.
    - If the command is successful, you'll get the message: `Request would have succeeded, but DryRun flag is set`
    - Otherwise, you'll be getting the message: `An error occurred (UnauthorizedOperation) when calling the {policy_name} operation`

# Amazon Polly

- Converts text in "life-like" speech
- The products takes text in specific languages and outputs speech in that specific language. Polly does not do translation!
- There 2 modes that Polly operates in:
    - Standard TTS:
        - Uses a concatenative architecture
        - Takes phonemes (smallest units of sound) to build patterns of speech
    - Neural TTS:
        - Takes phonemes, generate spectograms, it puts those spectograms through a vocoder form which gets the output audio
        - Much advanced way of generating human-like speech
- Output formats: MP3, Ogg Vorbis, PCM
- Polly is capable of using the Speech Synthesis Markup Language (SSML). This is a way we can provide additional control over how Polly generates speech. We can get Polly to emphasis certain part of the text or do certain pronunciation (whispering, Newscaster speaking style)

# AWS PrivateLink

- Allows us to connect to services hosted by other AWS accounts 
- We can connect to them directly or we can utilize AWS Marketplace partner services
- In both cases these services are presented in our VPC as private IP address ans ENIs
- AWS PrivateLink is the technical basis for Interface Endpoints
- For HA we should make sure we deploy multiple endpoint. Recommended one per AZ in each subnet we need to consume the service
- PrivateLink supports IPv4 and TCP only (~~IPv6 is not supported!~~, see: https://aws.amazon.com/about-aws/whats-new/2022/05/aws-privatelink-ipv6/)
- Private DNS is supported for overriding public DNS names (if there is a public DNS provided by the service we consume)
- PrivateLink endpoints can be accessed through Direct Connect, S2S VPN and VPC Peering

## VPC Endpoints 

### Gateway Endpoints

- Gateway endpoints provide private access to supported services: **S3** and **DynamoDB**
- They allow any resource in a private only VPC to access S3/DynamoDB
- We crate a gateway endpoint per service per region and associate it to one or more subnets in a VPC
- We allocate a gateway endpoint to a subnet, a *Prefix List* is added to the route table for the subnet. This prefix lists targets the gateway endpoint
- Any traffic targeted to S3/DynamoDB will go through the gateway endpoint and not through the internet gateway
- Gateway endpoints are highly available across all AZs in a region, they are not directly inside a VPC/subnet
- **Endpoint policy**: allows what things can be connected to the by the endpoint (example: a particular subset of S3 buckets)
- Gateway endpoints can be used to access services in the same region only
- Gateway endpoints allow private only S3 buckets: S3 buckets can be set to private allowing only access from the gateway endpoint. This will help prevent *Leaky Buckets*
- Gateway endpoints are logical gateway objects, they can be only accessed from inside the assigned VPC

### Interface Endpoints

- Interface endpoints provide private access to AWS public services similar to Gateway Endpoints
- Historically they have been used to provide access to services other than S3 and DynamoDB, recently AWS allowed interface endpoints to provide access to S3 as well
- Difference between gateway endpoints and interface endpoints is that interface endpoints are not HA by default. Interface endpoints are added to subnets as an ENI
- In order to have HA, we have to add an interface endpoint to every subnet per AZ inside of a VPC
- Interface endpoints are able to have security groups assigned to them (gateway endpoints do not allow SGs)
- We can also use endpoints policies, similar to gateway endpoints
- Interface endpoints support TCP only over IPv4
- Interface endpoints use PrivateLink behind the scene
- Gateway endpoints use prefix lists, interface endpoints use DNS. Interface endpoints provide a new DNS name for every service they are meant communicate with
- Interface endpoints are given a number of DNS names:
    - Endpoint Region DNS
    - Endpoint Zonal DNS
    - PrivateDNS: overrides the default service DNS with a new version pointing to interface endpoint

## VPC Endpoints Policies

- Endpoints policies don't grant access to any AWS services in isolation
- Identities accessing resources still need they permissions to access resources
- An endpoint policy only limits access if the service is accessed to the specific endpoint
- The endpoint policy contains a policy and conditions (who has access to what)
- Policies are commonly used to limit what private VPCs can access

# AWS Proton

- It is:
    - Automated infrastructure as code provisioning and deployment of serverless and container-based applications:
        - AWS Proton service is a two-pronged automation framework
        - We create versioned **service templates** that define standardized infrastructure and deployment tooling for serverless and container-based applications
        - AWS Proton identifies all existing service instances that are using an outdated template version for us
        - We can request AWS Proton to upgrade them with one click
    - Standardized infrastructure:
        - Platform teams can use AWS Proton and versioned infrastructure as code templates
    - Deployments integrated with CI/CD:
        - AWS Proton automatically provisions the resources, configures the CI/CD pipeline, and deploys the code into the defined infrastructure

# Amazon Quantum Ledger Database - QLDB

- Part of AWS Blockchain part of products
- It as an immutable append-only ledger-only database
- It provides a cryptographically verifiable transaction log
- It is transparent: full history is always accessible
- It is a serverless product, it provides Ledgers and Tables. We have no servers to manage
- It is resilient through 3 AZs, replicates data within each of those AZs
- It can stream data to Amazon Kinesis, it can stream any changes to data into Kinesis in real-time
- It is a document database model, storing JSON documents (key-value pairs with a nested structure)
- Provides ACID transactions
- Use cases for QLDB:
    - Anything related to finance: account balances and transactions
    - Medical application: full history of data changes matters
    - Logistics: track movement of objects
    - Legal: track the usage and change of data (custody)

# AWS Quicksight

- It a business analytics and intelligence (BA/BI) service
- It is used for visualization and ad-hoc analysis
- Cost-effective, on-demand service
- It is able to discover and integrate with AWS data sources and supports a wide range of external data sources
- Supported data sources:
    - Athena, Aurora, Redshift, Redshift Spectrum
    - S3, AWS Iot
    - Jira, GitHub, Twitter, SalesForce
    - Microsoft SQL Server, MySQL, PostgreSQL
    - Apache Spark, Snowflake, Presto, Teradata

# AWS Resource Access Manager - RAM

- Allows sharing resources between AWS accounts
- Some services may allow sharing between any AWS accounts, some allow sharing only between accounts from the same organization
- Services needs to support RAM in order to be shared (not everything can be shared)
- Services can be shared with principals: accounts, OU's and ORG
- Shared resources can be accessed natively
- There is no cost by using RAM, only the service cost may apply
- AWS RAM for sharing resources in an organization can be enabled with `enable-sharing-with-aws-organizations` CLI command. This operation creates a service-linked role called `AWSServiceRoleForResourceAccessManager` that has the IAM managed policy named `AWSResourceAccessManagerServiceRolePolicy` attached. This role permits RAM to retrieve information about the organization and its structure. This lets us share resources with all of the accounts

## Availability Zone IDs

- A region in AWS has multiple availability zones, example: `us-east-1a`, `us-east-1b`, etc.
- AWS rotates the name of the AZs depending on the AWS account, meaning that `us-east-1a` may not be the same AZ if we compare 2 accounts
- If a failure happens on the hardware level, two accounts may see the issue being in different AZ, this may introduce a challenge in troubleshooting
- AWS provides AZ IDs to overcome this challenge. Example of IDs: `use1-az1`, `use1-az2`
- AZ IDs are consistent across multiple accounts

## RAM Concepts

- **Owner account**: 
    - Owns the resource, creates a share, provides the name
    - Retains full permission over the resource shared
    - Defines the principal (AWS account, OU, entire AWS organization) with whom the share a specific resource
- **Principle**:
    - It can be an AWS account, OU, entire AWS organization
    - Resources are shared with a principle
- If the participant is inside an ORG with the sharing enabled, sharing is accepted automatically
- For non ORG accounts, or sharing with AWS Organizations is not enabled, we have to accept an invite

## Shared Services VPC

- It is a VPC which provides infrastructure which can be used by other services
- In AWS this has been traditionally architected using separate networks connected using VPC peering or Transit Gateways. With AWS RAM and AWS Organizations we can create something which is more effective:
    ![Shared Services VPC](images/RAM.png)
- VPC owner can create and manage the VPC and subnets which shared with participants
- Participants can provision services into the shared subnets, can read an reference network objects but can not modify or delete the subnets
- Resources created by a participant account will not be visible for other participants or by the VPC owner account
- Resources created by a participant account can be accessed from other resources created by other participant accounts because they are on the same network

# RDS - Relational Database Service

- RDS is often described as a Database-as-a-service (DBaaS) but this is not accurate. It should be named Database Server as a Service (DBSaaS) product
- RDS provides managed database instances, which can themselves hold one or more databases
- Benefits of RDS are the we don't need to manage the physical hardware, the server operating system or the database system itself
- RDS supports MySQL, MariaDB, PostgreSQL, Oracle, Microsoft SQL Server
- Amazon Aurora: it is a db engine created by AWS and we can select it as well for usage
- RDS Subnet Group: list of subnets which an RDS database can use. Generally it is best practice to have on Subnet Group per database deployment

## RDS Database Instance

- Runs one of the few types of db engine mentioned above
- Can contain multiple user created databases
- A database instance after creation can be accessed using its hostname (CNAME)
- RDS instances come in various types, share many of features of EC2. Example of instances: db.m5, db.r5, db.t3
- RDS instances can be single AZ or multi AZ (active-passive failover)
- When an instance is provisioned, it will have a dedicated storage allocated as well (usually EBS)
- Storage allocated can be based on SSD storage (IO1, GP2) or magnetic (mainly for compatibility)
- Billing for RDS:
    - We are billed based on instance size on a hourly rate
    - We are billed for additional instances used for Multi AZ deployments
    - We are also billed per storage (GB/month) + extra per iops in case of provisioned iops (IO1)
    - Data transfer is also billed if data is coming from/goes to the internet/other regions
    - Backups and snapshots are also billed (per GB per month)
    - Licensing is applicable is also billed

## RDS Multi AZ

- They are 2 types of Multi AZ deployments:
    - Multi AZ Instance (historically called Multi AZ)
    - Multi AZ Cluster
- Multi AZ Instance:
    - Used to add resilience to an RDS instance
    - Replication happens at the storage level
    - Enables synchronous replication between primary and standby instances
    - Multi AZ is an option which can be enabled on an RDS instance, when enabled secondary hardware is allocated in another AZ (standby replica)
    - RDS is accessed via provided endpoint address (CNAME)
    - With a single instance the endpoint address points the instance itself, with multi AZ, by default the endpoint points to the primary instance
    - We can not directly access the standby instance
    - If an error occurs with the primary instance, RDS automatically changes the endpoint to point to the standby replica. This failover occurs in around 60-120 seconds
    - Multi AZ is not available in the Free-tier (generally costs double as it would the single AZ)
    - Backups are taken from the standby instance (removes performance impact)
    - In case of a failover the DNS name will be updated to point to the standby replica instance. Since this is a DNS change, for the update it generally takes between 60-120 seconds to occur. This can be lessened by removing DNS caching in the application
    - With Multi AZ instance we have ONE standby replica. This replica cannot be used for read and writes. It waits for a failover to happen and then it can be used
    - Backups can be taken from the standby instance to improve performance
    - Failovers can happen if:
        - AZ outage
        - Primary instance failure
        - Manual failover
        - Instance type change
        - Software patching
- Multi AZ Cluster:
    - RDS is capable of having one writer replicate to two reader instances. We can have 2 readers only!
    - These readers are in different AZs compared to the writer
    - Compared two Aurora cluster mode, Multi AZ cluster can have 2 readers only, while Aurora Cluster can have more
    - In case of Multi AZ cluster the instances to which data is replicated are usable, compared to Multi AZ instance mode when they are not
    - In terms of replication the data is viewed as committed when one of the readers confirms that it was written
    - Other comparisons two Aurora Cluster:
        - In RDS multi AZ cluster each instance has its own storage, in case of Aurora this is not the case
        - Like Aurora, the cluster can be accessed with multiple endpoints:
            - Cluster endpoint: database CNAME, points to the writer, can be used for reads/writes and administration
            - Reader endpoint: points to any available endpoint for reads (it can point to the writer instance in certain cases). Generally it points to the dedicated reader instances
            - Instance endpoints: each instance gets one endpoint, generally not recommended to be used
    - Generally Multi AZ Cluster runs on faster hardware: Graviton + local NVME SSD storage. Any writes are written to local super fast storage, after that they are flushed to the EBS
    - Replications are done via transaction logs => much more efficient then Multi AZ instance. This also allows faster failover: ~35 seconds + any time required to apply the transaction logs

## RDS Backups and Restores

- RPO (Recovery Point Objective): time between the last working backup and the failure. Lower the RPO value, usually the more expensive the solution
- RTO (Recovery Time Objective): time between the failure and system being fully recovered. Can be reduced with spare hardware, predefined processes, etc. Lower the RTO value, the system is usually more expensive
- RDS backup types:
    - Manual snapshots:
        - Have to be run manually, or via a script
        - First snapshot is full content of the DB, incremental onward
        - When any snapshot occurs, there is brief interruption in the flowing of data between the compute resource and the storage (no noticeable effect in case of Multi AZ, since the backup is taken from the standby instance)
        - Manual snapshots do not expire
        - When we delete an RDS instance, AWS offers to make one final snapshot
    - Automatic backups:
        - They occur once per day (backup window is defined on the instance)
        - Snapshots which occur automatically, first being full snapshot, incremental afterwards
        - In addition to the automated snapshots, every 5 minute transaction logs are written to S3
        - Automatic backups are not retained, we can set the retention period between 0 and 35 days
        - Automatic backups can be retained after a DB is deleted, but they still expire after the retention period
        - We can replicate backups to another region: both snapshots and transaction logs can be replicated. Charges apply to cross-region data copy and any storage used in the destination region
        - Cross-region replication has to be explicitly configured within automated backups
- Backups are stored in AWS manages S3 buckets (backups are not visible to us directly in S3) => any data in S3 is regionally resilient
- RDS backups are taken from the standby instance in case Multi AZ is enabled
- RDS Restores:
    - RDS creates a new RDS instance when we restore an automated backup or a manual snapshot => new address will be created for the DB
    - When we restore a snapshot, we restore our DB to a single point in time, when the creation time of the snapshots happened
    - With automated backups we can chose a point-in-time to where we want to restore (any 5 minute point-in-time)
    - Restoring snapshots is not a fast procedure (important for RTO)

## RDS Read-Replicas

- Provide 2 main benefits: performance and availability
- Read replicas are read-only replicas of an RDS instance
- Read replicas can be used for reading only data
- Multi AZ Cluster mode is a similar to how read replicas work, but for read replicas we have to think of read replicas as separate things: 
    - They are not part of the main database instance
    - They have their own endpoint address
    - Require application support
    - There is no automatic failover to a read replica
- The primary instance and read replica is kept sync using asynchronous replication
- There can be a small amount of lag in case of replication
- Read replicas can be created in a different AZ or different region (CRR - Cross-Region Replication)
- We can 5 direct read-replicas per DB instance
- Each read-replica provides an additional instance of read performance
- Read-replicas can also have read-replicas, but lag starts to be a problem in this case
- Read-replicas can provide global performance improvements
- Snapshots and backups improve RPO but not RTO. Read-replicas offer near 0 RPO
- Read-replicas can be promoted to primary in case of a failure. This offers low RTO as well (lags of minutes)
- Read-replicas can replicate data corruption

## Data Security

- With all the RDS engines we can use encryption in transit (SSL/TLS). This can be set to be mandatory on a per user bases
- For encryption at rest RDS supports EBS volume encryption using KMS which is handled by the host EBS and it is invisible for the database engine
- We can use customer managed or AWS generated CMK data keys for encryption at rest
- Storage, logs and snapshots will be encrypted with the same customer master key
- Encryption can not be removed after it is activated
- In addition to encryption at rest MSSQL and Oracle support TDE (Transparent Data Encryption) - encryption at the database engine level
- Oracle supports TDE with CloudHSM, offering much stronger encryption
- IAM authentication with RDS:
    - Normally login is controlled with local database users (username/password)
    - We can configure RDS to allow IAM authentication (only authentication, not authorization, authorization is handled internally!):
    ![ASG Lifecycle Hooks](images/RDSIAMAuthentication.png)

## RDS Proxy

- Opening and closing connections consumes resources and takes time => in case we only want to read/write a tiny amount of data the overhead of establishing a connection creates a significant latency
- Handling failure of databases instances is hard, this adds significant overhead and risks to our application
- DB proxies can help, but managing them is not always trivial (scaling, resilience)
- In case of an RDS proxy our application connects to the proxy, which handles connection polling and connectivity to the database
- RDS proxies provide multiplexing: a smaller number of connections can be used to connect to the database while having a larger number of applications using the database through the proxy. This helps to reduce the load on the database
- RDS Proxy can help with database failover events abstracting this from the applications. The proxy can wait until a healthy database instance is in place and can automatically connect to it
- When to use RDS proxy?
    - In case we have errors such as `Too many connections`. An RDS proxy can reduce the number of connections to the dabase while being able to handle many more connections from the applications to itself
    - Useful when using AWS Lambda, we won't need to invoke a new connection after each invocation of our function. Saves time by connection reuse and IAM auth
    - Useful for long running applications (SAAS apps) by reducing latency
- RDS Proxy key facts:
    - Fully managed by RDS/Aurora
    - By default provides auto scaling, HA
    - Provides connections pooling, which reduces DB load
    - Only accessible from a VPC, not accessible from the public internet
    - Accessed via Proxy Endpoint
    - Can enforce SSL/TLS connection
    - Can reduce failover time by over 60% in case of Aurora
    - Abstracts the failure of a database away for our application

## RDS Custom

- Fills the gap between the main RDS product and EC2 running a DB engine
- The main RDS is fully managed database service => OS/Engine access is limited
- In contrast databases running on EC2 are self managed, this can have significant management overhead
- RDS custom bridges this gap, we can utilize RDS but still get access to customization we would have when running a DB instance on EC2
- Currently RDS custom works from MSSQL or Oracle
- We can connect to the underlying OS using SSH, RDP or Session Manager
- RDS custom will run withing our AWS account. Classic RDS will run in an AWS managed environment
- If we need to perform RDS customization for RDS Custom, we need to look inside the Database Automation settings to make sure we wont have any disruption caused by the Database Automation. We need to pause Database Automation for this period

# Amazon Redshift

- It is petabyte scale data warehouse
- It is designed for reporting and analytics
- It is an OLAP (column based) database, not OLTP (row/transaction)
    - OLTP (Online Transaction Processing): capture, stores, processes data from transactions in real-time
    - OLAP (Online Analytical Processing): designed for complex queries to analyze aggregated historical data from other OALP systems
- Advanced features of Redshift:
    - RedShift Spectrum: allows querying data from S3 without loading it into Redshift platform
    - Federated Query: directly query data stored in remote data sources
- Redshift integrates with Quicksight for visualization
- It provides a SQL-like interface with JDBC/ODBC connections
- By Redshift is a provisioned product, it is not serverless (AWS offers Redshift Serverless option as well). It does come with provisioning time
- It uses a cluster architecture. A cluster is a private network, and it can not be accessed directly
- Redshift runs in one AZ, not HA by design
- All clusters have a leader node with which we can interact in order to do querying, planning and aggregation
- Compute nodes: perform queries on data. A compute node is partition into slices. Each slice is allocation a portion of memory and disk space, where it processes a portion of workload. Slices work in parallel, a node can have 2, 4, 16 or 32 slices, depending the resource capacity
- Redshift if s VPC service, it uses VPC security: IAM permissions, KMS encryption at rest, CloudWatch monitoring
- Redshift Enhance VPC Routing:
    - By default Redshift uses public routes for traffic when communicating with external services or any public AWS service (such as S3)
    - When enabled, traffic is routed based on the VPC networking configurations (SG, ACLs, etc.)
    - Traffic is routed based on the VPC networking configuration
    - Traffic can be controlled by security groups, it can use network DNS, it can use VPC gateways
- Redshift architecture:
    ![Redshift architecture](images/RedshiftArchitecture.png)

## Redshift Components
-  **Cluster**: a set of nodes, which consists of a leader node and one or more compute nodes
    - Redshift creates one database when we provision a cluster. This is the database we use to load data and run queries on your data
    - We can scale the cluster in or out by adding or removing nodes. Additionally, we can scale the cluster up or down by specifying a different node type
    - Redshift assigns a 30-minute maintenance window at random from an 8-hour block of time per region, occurring on a random day of the week. During these maintenance windows, the cluster is not available for normal operations
    - Redshift supports both the EC2-VPC and EC2-Classic platforms to launch a cluster. We create a cluster subnet group if you are provisioning our cluster in our VPC, which allows us to specify a set of subnets in our VPC
- **Redshift Nodes**:
    - The leader node receives queries from client applications, parses the queries, and develops query execution plans. It then coordinates the parallel execution of these plans with the compute nodes and aggregates the intermediate results from these nodes. Finally, it returns the results back to the client applications
    - Compute nodes execute the query execution plans and transmit data among themselves to serve these queries. The intermediate results are sent to the leader node for aggregation before being sent back to the client applications
    - Node Type:
        - Dense storage (DS) node type – for large data workloads and use hard disk drive (HDD) storage
        - Dense compute (DC) node types – optimized for performance-intensive workloads. Uses SSD storage
- **Parameter Groups**: a group of parameters that apply to all of the databases that we create in the cluster. The default parameter group has preset values for each of its parameters, and it cannot be modified

## Redshift Resilience and Recovery

- Redshift can use S3 for backups in the form a snapshots
- There are 2 types of backups:
    - Automated backups: occur every 8 hours or after every 5 GB of data, by default having 1 day retention (max 35). Snapshots are incremental
    - Manual snapshots: performed after manual triggering, no retention period
- Restoring from snapshots creates a brand new cluster, we can chose a working AZ to be provisioned into
- We can copy snapshots to another region where a new cluster can be provisioned
- Copied snapshots also can have retention periods
![Redshift Resilience and Recovery](images/RedshiftDR.png)

## Amazon Redshift Workload Management (WLM) 

- Enables users to flexibly manage priorities within workloads so that short, fast-running queries won’t get stuck in queues behind long-running queries
- Amazon Redshift WLM creates query queues at runtime according to service classes, which define the configuration parameters for various types of queues, including internal system queues and user-accessible queues
- From a user perspective, a user-accessible service class and a queue are functionally equivalent


# AWS Rekognition

- Rekognition is a deep learning based image and video analysis product
- It can identify objects, people, text, activities, content moderation, face detection, face analysis, face comparison, pathing and much more
- The product is per as you use per image or per minute in case of video
- Integrates with application and can be invoked event-driven
- Can analyse live video streams integrating with Kinesis Video Streams

# Route53

## DNS Fundamentals

- DNS is a discovery service, translate information which machines need into information that humans need and vice-versa
- Example: www.amazon.com => 104.98.34.131
- DNS database is a huge distributed database
- DNS allows a DNS resolver server to find a Zone File ona Name Sever (NS) and query the it, retrieving the necessary IP address for a DNS name

## DNS Terminology

- **DNS Client**: refers to a customer PC, laptop, tablet, etc.
- **DNS Resolver**: software running on a device or a server which queries DNS on our behalf
- **DNS Zone**: a part of the DNS database (example: amazon.com)
- **Zone file**: it is a physical database for a zone, contains all the DNS information for a particular domain
- **DNS Name server**: a server which hosts the zone files

## DNS Root

- DNS is structures like a tree, DNS root is at the top of the tree
- DNS root is hosted in 13 special nameservers, known as DNS Root Servers
- Root hints file: an OS file containing the address of all root servers
- Authority: when something is trusted in DNS, example root hints file
- Delegation: trusted authorities can delegate a part of themselves to other entities, those entities becoming authoritative for the part delegated

## Route53 Introduction

- It is a managed DNS product
- Provides 2 main services:
    - Register domains
    - Can host zone files on managed nameservers
- It is a global service, its database is distributed globally and resilient

## Hosted Zones

- DNS as a service
- Let's us create and manage zone files
- Zone files are hosted on 4 AWS managed nameservers
- A hosted zone can be public, accessible for the public internet, part of the public DNS system, or it can be private, linked to one or more VPC(s)
- A hosted zone stores DNS records (recordsets)

## DNS Record Types

- Name server (NS): allow delegation to occur in DNS
- A and AAAA records: map host names to IP addresses. A records maps a host name to IPv4, AAAA maps the host to IPv6 addresses
- CNAME (canonical name): maps host to host records, example ftp, mail, www can reference different servers. CNAME can not point directly to IP addresses, they can point to other names only
- MX records: used for sending emails. Can have 2 parts: priority and value. If we include a dot (.) in the end of the domain to which the record points, that will co considered as a FQDN (Fully Qualified Domain Name)
- TXT (text) records: arbitrary text to domain. Commonly used to prove domain ownership

## DNS TTL - Time To Live

- Indicates how long records can be cached for
- Resolver server will store the records for the amount of time specified by the TTL in seconds
- TTL is a balance: low values means less queries to the server, high values mean less flexibility when the records are changed

## Public Hosted Zones

- A hosted zone is DNS database for a given section of the global DNS database
- Hosted zones are created automatically when a domain is registered in R53, they can be created separately as well (we will have to update the name severs values after that)
- There is a monthly fee for each running hosted zone
- A hosted zone hosts DNS records, example A, AAAA, MX, NS, TXT etc.
- Hosted zones are authoritative for a domain
- When a public hosted zone is created, R53 allocates 4 public name servers for it, on these name servers the zone file is hosted
- We use NS records to point at these name servers to be able to connect to the global DNS
- Externally registered domains can point to R53 public zone

## Private Hosted Zones

- Similar to a public hosted zone except it can not be accessed from the public internet
- They are associated with VPCs from AWS and it only can be shared with VPCs from the account. Cross account access is possible
- Split-view (Split Horizon) DNS: it is possible to create split-view (split-horizon) DNS for public and internal use with the same zone name. Useful for accessing systems from the private network without accessing the public internet

## CNAME vs Alias Records

- The problem with CNAME:
    - An A record maps a NAME to an IP Address
    - A CNAME records maps a NAME to another NAME
    - We can not have a CNAME record for an APEX/naked domain name
    - Many AWS services use DNS Name (example: ELBs)
- For the APEX domain to point to another domain, we can use ALIAS records
- An alias record maps a NAME to an AWS resource
- Can be used for both apex and normal records
- There is no additional charge for alias requests pointing at AWS resources
- An alias is a subtype, we can have an A record alias and a CNAME record alias

## Simple Routing

- With simple routing with can create one record per name
- Each record can have multiple values
- In case of a request, all the values for the record are returned to the client
- The client choses one of the values an connects to the server
- Limitations: does not support health checks!

## Health Checks

- Health checks are separate from, but used by records in Route53
- They are created separately and they can be used by records in Route53
- Health checks are performed by a fleet of health checkers distributed globally
- Health checks are not just limited to AWS targets, can be any service with an IP address
- Health checkers check every 30s (or 10s at extra cost)
- Health checks can be TCP, HTTP, HTTPS, HTTP(S) with String Matching. A TCP connections should be completed in 4s and endpoint should respond with a 2xx or 3xx status code within 2s after connections. After the status code is received, the response body should also be received within 2 seconds
- In case of string matching the text should be present entirely in the first 5120 characters of the request body or the endpoint fails the health check
- Based on the health checks the service can be categorized as `Healthy` or `Unhealthy`
- Health checks can be of 3 types:
    - Endpoint: assess the health of an endpoint we specify
    - CloudWatch Alarm Checks: they react to CloudWatch alarms
    - Calculated Checks: checks of other checks
- If 18%+ of the health checkers report the target as healthy, the target is considered healthy

## Failover Routing

- We can add 2 records of the same name (a primary and a secondary)
- Health checks happen on the primary record
- If the primary record fails the health checks, the address of the secondary record is returned
- Failover routing should be used when we configure active-passive failover

## Multi Value Routing

- Multi Value Routing is mixture to simple and failover routing
- With multi value routing we can create many records with the same name
- Each record can have an associated health check
- When queried, 8 records are returned to the client. If more than 8 records are present, 8 records will be randomly selected and returned
- The client picks one a of the values and connects to the service
- Any records which fails the health checks won't be returned when queried
- Multi value routing is not a substitute for an actual load balancer

## Weighted Routing

- Weighted Routing can be used when looking for a simple form of load balancing or when we want to test new versions of an API
- With weighted routing we can specify a weight for each record
- For a given name the total of weight is calculated. Each record is returned depending on the percentage of the record compared to the total weight
- Setting a weight to 0, the record will not be returned. If every record is set to 0, all of them will be returned
- Weighted routing can be combined with health checks. Health checks don't remove records from the calculation of the total weight. If a record is selected, but it is unhealthy, another selection will be made until a healthy record is selected

## Latency-Based Routing

- Should be used when we trying to optimize for performance and better user experience
- For each record we can specify an region
- AWS maintains a list of latencies for each region from the world (source - destination latency)
- When a request comes in, it will be directed to the lowest latency destination based on the location from where the request is coming from
- Latency-based routing can be combined with health checks. If the lowest latency record fails, the second lowest latency record will be returned to the client
- The latency database maintained by AWS is not updated in real time

## Geolocation Routing

- Geolocation routing is similar to latency-based routing, only instead of latency the location of customer and resources is used to determine the resolution decisions
- When we create records, we tag the records with a location
- This location is generally a country (ISO2 code), continent or default. There can be also a subdivision, in USA we can tag records with a state
- When the user does a query, an IP checks verifies the location is the user
- Geolocation does not return the closest record, it returns relevant records: when the resolution happens, the location of the user is cross-checked with the location specified for the records and the matching on is returned
- Order of the cross-checks is the following:
    1. R53 checks the state (US only)
    2. R53 checks the country
    3. R53 checks the continent
    4. Returns default if not previous match
- If no match is detected, the a `NO ANSWER` is returned
- Geolocation is ideal for restricting content based on the location of the user
- It can be used for load-balancing based on user location as well

## Geoproximity Routing

- Geoproximity aims to provide records as close to the customer as possible, aims to calculated the distance between to resource and customer and return the record with the lower one
- When using geoproximity, we define rules:
    - Region the resource is created in, if it is an AWS resource
    - Lat/lon coordinate for external resources
    - Bias: adjust how R53 calculates the distance between the user and the resource
- Geoproximiy allows defining a bias: it can be a `+` or `-` bias, increasing or decreasing the region size. We can influence the routing distance based on this bias

## Route53 Interoperability

- Route53 acts as a domain registrar and as a domain hosting
- We can also register domains using other external services
- Steps happening when we register a domain using R53:
    - R53 accepts the registration fee
    - Allocates 4 Name Servers
    - Creates a zone file (domain hosting) on the NS
    - R53 communicates with the registry of the top level domain and adds the address of the 4 NS for the given domain
- Route53 acting as a registrar only:
    - We pay for the domain for Route53 but the name servers are allocated by other entity
    - We have to allocate the name servers to Route53 which will communicate with the top level domain registry
- Using Route53 for hosting only:
    - Generally used for existing domains. The domain is registered at third party
    - We create a hosted zone inside R53 and provide the address of the name servers to the third party

## Implementing DNSSEC with Route53

- DNSSEC can be enabled form the console and from the CLI
- Once initiated, the process starts with KMS, an asymmetric key pair is required/created within KMS
- The key-signing keys (KSK) is created from this KMS key, both the public and private ones which will be used by R53
- These keys need to be in us-east-1
- Next, R53 creates the zone-signing keys (ZSK) internally
- Next, R53 adds the KSK and zone-signing key public parts into a DNS key record within the hosted zone, this tells every DNSSEC resolver which public keys to use to verify signatures on any other records
- The private key signing key used to sign those DNS key records and create the RRSIG and DNSKEY records
- At this point signing is configured (step 1)
- Next, R53 has to establish the chain of trust with the parent zone
- The parent zone needs ot add a DS record, which is hash of the public part of the KSK
- If the domain was registered with R53, the AWS console or the CLI can be used to make this change. R53 will liaise with the appropriate top-level domain and add the delegated sign record
- If the domain was created externally, we will have to add this record manually
- Once done, the top level domain will trust this domain with the delegated sign record (DS)
- The domain zone will sign each record either with the KSK or with the ZSK
- When enabling DNSSEC we should make sure we configure CloudWatch Alarms, specifically create alarms for `DNSSECInternalFailure` and `DNSSECKeySigningKeyNeedingAction`, both of these need urgent intervention

## Advanced VPC DNS and DNS Endpoints

- In every VPC the VPC.2 IP address is reserved for the DNS
- In every subnet the .2 is reserved for Route53 resolver
- Via this address VPC resources can access R53 Public and associated private hosted zones
- Route53 resolver is only accessible from the VPC, hybrid network integration is problematic both inbound and outbound
![Isolated DNS Environments](images/Route53Endpoints1.png)
- Solution to the problem before Route53 endpoints were introduced:
![Before Route53 Endpoints](images/Route53Endpoints2.png)
- Route53 endpoints:
    - Are deliver as VPC interfaces (ENIs) which can be accessed over VPN or DX
    - 2 different type of endpoints:
        - Inbound: on-premises can forward request to the R53 resolver
        - Outbound: interfaces in multiple subnets used to contact on-premises DNS
        - Rules control what requests are forwarded
        - Outbound endpoints have IP addresses assigned which can be whitelisted on-prem
- Route53 endpoint architecture:
![Route53 Endpoints Architecture](images/Route53Endpoints3.png)
- Route53 endpoints are delivered as a service
- They are HA and they scale automatically based on load
- They can handle around 10k queries per second per endpoint


# S3

## Storage Classes

- **S3 Standards (default)**:
    - The objects are stored in at least 3 AZs
    - Provides eleven nines of availability
    - The replication is using MD5 file checks together with CRCs to detect object issues
    - When objects are stored in S3 using the API, a HTTP 200 OK response is provided
    - Billing: 
        - GB/month of data stored in S3
        - A dollar for GB charge transfer out (in is free)
        - Price per 1000 requests
        - No specific retrieval fee, no minimum duration, no minimum size
    - S3 standard makes data accessible immediately, can be used for static website hosting
    - Should be used for data frequently accessed
- **S3 Standard-IA**:
    - Shares most of the characteristics of S3 standard: objects are replicated in 3 AZs, durability is the same, availability is the same, first byte latency is the same, objects can be made publicly available
    - Billing:
        - It is more cost effective for storing data
        - Data transfer fee is the same as S3 standard
        - Retrieval fee: for every GB of data there is a retrieval fee, overall cost may increase with frequent data access
        - Minimum duration charge: we will be billed for a minimum of 30 days, minimum capacity of the objects being 128KB (smaller objects will be billed as being 128 KB)
        - Should be used for long lived data where data access is infrequent
- **S3 One Zone-IA**:
    - Similar to S3 standard, but cheaper. Also cheaper than S3 standard IA
    - Data stored using this class is only stored in one region
    - Billing:
        - Similar to S3 standard IA: similar minimum duration fee of 30 days, similar billing for smaller objects and also similar retrieval fee per GB
        - Same level of durability (if the AZ does not fail)
        - Data is replicated inside one AZ
    - Since data is not replicated between AZs, this storage class is not HA. It should be used for non-critical data or for data that can be reproduced easily
- **S3 Glacier Instant Retrieval**:
    - It like S3 Standard-IA, but with cheaper storage, more expensive retrieval, longer minimums
    - Recommended for data that is infrequently accessed (once per quarter), but it still needs to be retrieved instantly
    - Minimum storage duration charge is 90 days
- **S3 Glacier Flexible Retrieval (formerly knowns as S3 Glacier)**:
    - Same data replication as S3 standard and S3 standard IA
    - Same durability characteristics
    - Storage cost is about 1/6 of S3 standard
    - S3 objects stored in Glacier should be considered cold objects (should not be accessed frequently)
    - Objects in Glacier class are just pointers to real objects and they can not be made public
    - In order to retrieve them, we have to perform a retrieval process:
        - A job that needs to be done to get access to objects
        - Retrievals processes are billed
        - When objects are retrieved for Glacier, they are temporarily stored in standard IA and they are removed after a while. We can retrieve them permanently as well
    - Retrieval job types:
        - **Expedited**: objects are retrieved in 1-5 minutes, retrieval process being the most expensive
        - **Standard**: data is accessible at 3-5 hours
        - **Bulk**: data is accessible at 5-12 hours at lower cost
    - Glacier has a 40KB minimum billable size and a 90 days minimum duration for storage
    - Glacier should be used for data archival (yearly access), where data can be retrieved in minutes to hours
- **S3 Glacier Deep Archive**:
    - Deep Archive represents data in a frozen state
    - Has a 40KB minimum billable data size and a 180 days minimum duration for data storage
    - Objects can not be made publicly available, data access is similar to standard Glacier class
    - Restore jobs are longer:
        - **Standard**: up to 12 hours
        - **Bulk**: up to 48 hours
    - Should be used for archival which is very rarely accessed
- **S3 Intelligent-Tiering**:
    - It is a storage class containing 5 different tiering a storage
    - Objects that are access frequently are stored in the Frequent Access tier, less frequently accessed objects are stored in the Infrequent Access tier. Objects accessed very infrequently will be stored in either Archive or Deep Archive tier
    - We don't have to worry for moving objects over tier, this is done by the storage class automatically
    - Intelligent tier can be configured, archiving data is optional and can be enabled/disabled
    - There is no retrieval cost for moving data between frequent and infrequent tiers, we will be billed based on the automation cost per 1000 objects
    - S3 Intelligent-Tiering is recommended for unknown or uncertain data access usage
- Storage classes comparison:

|                                    | S3 Standard            |  S3 Intelligent-Tiering | S3 Standard-IA         | S3 One Zone-IA          | S3 Glacier Instant       | S3 Glacier Flexible     | S3 Glacier Deep Archive |
|------------------------------------|------------------------|-------------------------|------------------------|-------------------------|--------------------------|-------------------------|-------------------------|
| Designed for durability            | 99.999999999% (11 9's) | 99.999999999% (11 9's)  | 99.999999999% (11 9's) | 99.999999999% (11 9's)  | 99.999999999% (11 9's)   | 99.999999999% (11 9's)  | 99.999999999% (11 9's)  |
| Designed for availability          | 99.99%                 | 99.9%                   | 99.9%                  | 99.5%                   | 99.9%                    | 99.99%                  | 99.99%                  |
| Availability SLA                   | 99.9%                  | 99%                     | 99%                    | 99%	                   | 99%                      | 99.9%                   | 99.9%                   |
| Availability Zones                 | ≥3                     | ≥3                      | ≥3                     | 1                       | ≥3                       | ≥3                      | ≥3                      |
| Minimum capacity charge per object | N/A                    | N/A                     | 128KB                  | 128KB                   | 128KB                    | 40KB                    | 40KB                    |
| Minimum storage duration charge    | N/A                    | 30 days                 | 30 days                | 30 days                 | 90 days                  | 90 days                 | 180 days                |
| Retrieval fee                      | N/A                    | N/A                     | per GB retrieved       | per GB retrieved        | per GB retrieved         | per GB retrieved        | per GB retrieved        |
| First byte latency                 | milliseconds           | milliseconds            | milliseconds           | milliseconds            | milliseconds             | select minutes or hours | select hours            |
| Storage type                       | Object                 | Object                  | Object                 | Object                  | Object                   | Object                  | Object                  |
| Lifecycle transitions              | Yes                    | Yes                     | Yes                    | Yes                     | Yes                      | Yes                     | Yes                     |

## S3 Lifecycle Configuration

- We can create lifecycle rules on S3 buckets which can move objects between tiers or expire objects automatically
- A lifecycle configuration is a set of rules applied to a bucket or a group of objects in a bucket
- Rules consist of actions:
    - Transition actions: move objects from one tier to another after a certain time
    - Expiration actions: delete objects or versions of objects
- Objects can not be moved based on how much they are accessed, this can be done by the intelligent tiering. We can move objects based on time passed
- By moving objects from one tier to another we can save costs, expiring objects also will help saving costs
- Transitions between tiers:
    ![Transition between tiers](images/S3StorageClassesLifecycleConfiguration.png)
- Considerations:
    - Files from One Zone-IA can transition to Glacier Flexible, or Deep Archive, NOT into Glacier Instant retrieval
    - Smaller objects cost more in Standard-IA, One Zone-IA, etc.
    - An object needs to remain for at least 30 days in standard tier before being able to be moved to infrequent tiers (objects can be uploaded manually in infrequent tiers)
    - A single rule can not move objects instantly from standard IA to infrequent tiers and then to Glacier tiers. Objects have to stay for at least 30 days in infrequent tiers before being able to be moved by one rule only. In order ot overcome this, we can define 2 different rules

## S3 Replication

- 2 types of replication are supported by S3:
    - Cross-Region Replication (CRR)
    - Same-Region Replication (SRR)
- Both types of replication support same account replication and cross-account replication
- If we configure cross-account replication, we have to define a policy on the destination account to allow replication from the source account
- We can create replicate all objects from a bucket or we can create rules for a subset of objects. We can filter objects to replicate based on prefix or tags or both
- We can specify which storage class to use for an object in the destination bucket (default: use the same class)
- We can also define the ownership of the objects in the destination bucket. By default it will be the same as the owner in the source bucket
- Replication Time Control (RTC): if enabled ensures a 15 minutes replication of objects
- Replication consideration:
    - By default replication is not retroactive: only newer objects are replicated after the replication is enabled
    - Versioning needs to be enabled for both source and destination buckets
    - Batch replication can be used to replicate existing objects. It needs to be specifically configured. If it is not, replication wont be retroactive
    - Replication by default one-way only, source => destination. There is an option to use bi-directional replication, but this has to be configured
    - Replication is capable of handling objects encrypted with SSE-S3 and SSE-KMS (with extra configuration). SSE-C (customer managed keys) is also supported, historically it was incompatible
    - Replication requires for the owner of source bucket needs permissions on the objects which will be replicated
    - System events will not be replicated, only user events
    - Any objects in the Glacier and Glacier Deep Archive will not be replicated
    - By default, deletion are not replicated. We can enable replication for deletion events
- Replication use cases:
    - SRR:
        - Log aggregation
        - PROD and Test sync
        - Resilience with strict sovereignty
    - CRR
        - Global resilience improvements
        - Latency reduction

## S3 Encryption

- Buckets aren't encrypted, objects inside buckets are encrypted
- Encryption at rest types:
    - Client-Side encryption: data is encrypted before it leaves the client
    - Server-Side encryption: data is encrypted at the server side, it is sent on plain-text format from the client
- Both encryption types use encryption in-transit for communication
- Server-side encryption is mandatory, we cannot store data in S3 without being encrypted
- There are 3 types of server-side encryption supported:
    - **SSE-C**: server-side encryption with customer-provided keys
        - Customer is responsible for managing the keys, S3 managed encryption/decryption
        - When an object is put into S3, we need to provide the key utilized
        - The object will be encrypted by the key, a hash is generated and stored for the key
        - The key will be discarded after the encryption is done
        - In case of object retrieval, we need to provide the key again
    - **SSE-S3** (default): server-side encryption with Amazon S3-managed keys
        - AWS handles both the encryption/decryption and the key management
        - When using this method, S3 creates a master key for the encryption process (handled entirely by S3)
        - When an object is uploaded an unique key is used for encryption. After the encryption, this unique key is encrypted as well with the master key and the unencrypted key is discarded. Both the key and the object are stored together
        - For most situations, this is the default type of encryption. It uses AES-256 algorithm, they key management is entirely handled bt S3
    - **SSE-KMS**: Server-side encryption with customer-managed keys stored in AWS Key Management Service (KMS)
        - Similar to SSE-S3, but for this method the KMS handles stored keys
        - When an object is uploaded for the first time, S3 will communicate with KMS and creates a customer master key (CMK). This is default master key used in the future
        - When new objects are uploaded AWS uses the CMK to generate individual keys for encryption (data encryption keys). The data encryption key will be stored along with the object in encrypted format
        - We don't have to use the default CMK provided by AWS, we can use our own CMK. We can control the permission on it and how it is regulated
        - SSE-KMS provides role separation:
            - We can specify who can access the CMK from KMS
            - Administrators can administers buckets but they may not have access to KMS keys
- Default Bucket Encryption:
    - When an object is uploaded, we can specify which server-side encryption to be used by adding a header to the request: `x-amz-server-side-encryption`
    - Values for the header:
        - To use SSE-S3: `AES256`
        - To use SSE-KMS: `aws:kms`
    - All Amazon S3 buckets have encryption configured by default, and all new objects that are uploaded to an S3 bucket are automatically encrypted at rest
    - Server-side encryption with Amazon S3 managed keys (SSE-S3) is the default encryption configuration for every bucket in Amazon S3, this can be overridden in a PUT request with `x-amz-server-side-encryption` header

## S3 Bucket Keys

- Each object in a bucket is using a uniq data-encryption key (DEK)
- AWS uses the bucket's KMS key to generate this data-encryption key
- Calls to KMS have a cost and levels where throttling occurs: 5500/10_000/50_000 PUT/sec depending on region
- Bucket keys:
    - A time limited bucket key is used to generate DEKs within S3
    - KMS generates a bucket key and gives it to S3 to use to generate DEKs for each upload, offloading the load from KMS to S3
    - Reduces the number of KMS API calls => reduces the costs/increases scalability
- Using bucket keys is not retroactive, it will only affect objects after bucket keys are enabled
- Thing to keep in mind after enabling bucket keys:
    - CloudTrail KMS event logs will show the bucket ARN instead of the object ARN
    - Fewer CloudTrail events of KMS will be in the logs (since work is offloaded to S3)
    - Bucket keys work with SRR and CRR; the object encryption settings are maintained
    - If we replicate plaintext to a bucket using bucket keys, the object is encrypted at the destination side; this can result in ETAG changes on the object

## S3 Presigned URLs

- Is a way to give other people access to our buckets using our credentials
- An IAM admin can generate a presigned URL for a specific object using his credentials. This URL will have an expiry date
- The presigned URL can be given to unauthenticated uses in order to access the object
- The user will interact with S3 using the presigned URL as if it was the person who generated the presigned URL
- Presigned URLs can be used for downloads and for uploads
- Presigned URLs can be used for giving direct access private files to an application user offloading load from the application. This approach will require a service account for the application which will generate the presigned URLs
- Presigned URL considerations:
    - We can create a presigned ULR for objects we don't have access to
    - When using the URL, the permissions match the identity which generated it. The permissions are evaluated at the moment of accessing the object (it might happen the the identity had its permissions revoked, meaning we wont have access to the object either)
    - We should not generate presigned URLs generated on temporary credentials (assuming an IAM role). When the temporary credentials are expired, the presigned URL will stop working as well. Recommended to use long-term identities such as an IAM user

## S3 Select and Glacier Select

- Are ways to retrieve parts of objects instead of entire objects
- S3 can store huge objects (up to 5 TB)
- Retrieving a huge objects will take time and consume transfer capacity
- S3/Glacier provides services to access partial objects using SQL-like statements to select parts of objects
- Both S3 Select and Glacier selects supports the following formats: CSV, JSON, Parquet, BZIP2 compression for CSV and JSON

## S3 Access Points

- Improves the manageability of objects when buckets are used for many different teams or they contain objects for a large amount of functions
- Access Points simplify the process of managing access to S3 buckets/objects
- Rather than 1 bucket (1 bucket policy) access we can create many access points with different policies
- Each access point can be limited from where it can be accessed, and each can have different network access controls
- Each access point has its own endpoint address
- We can create access point using the console or the CLI using `aws s3control create-access-point --name < name > --account-id < account-id > --bucket < bucket-name >`
- Any permission defined on the access point needs to be defined on the bucket policy as well. We can do delegation, by defining wide access permissions in the bucket policy and granular permissions on the access point policy

## S3 Block Public Access

- The Amazon S3 Block Public Access feature provides settings for access points, buckets, and accounts to help manage public access to Amazon S3 resources
- The settings we can configure with the Block Public Access Feature are:
    - **IgnorePublicAcls**: this prevents any new ACLs to be created or existing ACLs being modified which enable public access to the object. With this alone existing ACLs will not be affected
    - **BlockPublicAcls**: Any ACLs actions that exist with public access will be ignored, this does not prevent them being created but prevents their effects
    - **BlockPublicPolicy**: This prevents a bucket policy containing public actions from being created or modified on an S3 bucket, the bucket itself will still allow the existing policy
    - **RestrictPublicBuckets**: this will prevent non AWS services or authorized users (such as an IAM user or role) from being able to publicly access objects in the bucket

## S3 Cost Saving Options

- S3 Select and Glacier Select: save in network a CPU cost by retrieving ony the necessary data
- S3 Lifecycle Rules: transition objects between tiers
- Compress objects to save space
- S3 Requester Pays:
    - In general, bucket owners pay for all Amazon S3 storage and data transfer costs associated with their bucket
    - With Requester Pays buckets, the requester instead of the bucket owner pays the cost of the request and the data download from the bucket
    - The bucket owner always pays the cost of storing data
    - Helpful when we want to share large datasets with other accounts
    - Requires a bucket policy
    - If an IAM role is assumed, the owner account of that role pays for the request!

## S3 Object Lock

- Object Lock can be enabled on newly created S3 buckets. For existing ones in order to enable Object Lock we have to contact AWS support
- Versioning will be also enabled when Object Lock is enabled
- Object Lock can not be disabled, versioning can not be suspended when Object Lock is active on the bucket
- Object Lock is a Write-Once-Read-Many (WORM) architecture: when an object is written, can not be modified. Individual versions of objects are locked
- There are 2 ways S3 managed object retention:
    - Retention Period
    - Legal Hold
- Object versions can have both retention period and legal hold enabled; can have only one of those enabled or none of them
- Object Lock retentions can be individually defined on object versions, a bucket can have default Object Lock settings

### Retention Period

- When a retention period is enabled on an object, we specify the days and years for the period
- The retention period will end after the period
- There are 2 types of retention period modes:
    - **Compliance mode**: 
        - Object can not be adjusted, deleted or overwritten. The retention period can not be reduced, the retention mode can not be adjusted even by the account root user
        - Should be used for compliance reasons
    - **Governance mode**:
        - Objects can not be adjusted, deleted or overwritten, but special permissions can be added to some identities to allow for the lock setting to be adjusted
        - This identities should have the `s3:BypassGovernanceRetention` permission
        - The governance mode can be overwritten when passing `x-amz-bypass-governance-retention:true` header (header is default for console ui)

### Legal Hold

- We don't set a retention period for this type of retention, Legal Hold can be on or off for specific versions of an object
- We can't delete or overwrite an object with Legal Hold
- An extra permission is required when we want to add or remove the Legal Hold on an object: `s3:PutObjectLegalHold`
- Legal Hold can be used for preventing accidental removals

## S3 Transfer Accelerate

- Used to transfer files into S3. Enables fast, easy, and secure transfers of files over long distances between our client and an S3 bucket
- Takes advantage of the globally distributed edge locations in Amazon CloudFront
- We might want to use Transfer Acceleration on a bucket for various reasons:
    - We upload to a centralized bucket from all over the world
    - We transfer gigabytes to terabytes of data on a regular basis across continents
    - We can't use all of our available bandwidth over the internet when uploading to Amazon S3
- To use Transfer Accelerate, it must be enabled on the bucket. After we enable Transfer Acceleration on a bucket, it might take up to 20 minutes before the data transfer speed to the bucket increases

## S3 Object Lambda

- With Amazon S3 Object Lambda, we can add our own code to Amazon S3 `GET`, `LIST`, and `HEAD` requests to modify and process data as it is returned to an application
- S3 Object Lambda uses AWS Lambda functions to automatically process the output of standard S3 `GET`, `LIST`, or `HEAD` requests
- After we configure a Lambda function, we attach it to an S3 Object Lambda service endpoint, known as an *Object Lambda Access Point*
- The Object Lambda Access Point uses a standard S3 access point
- When we send a request to your Object Lambda Access Point, Amazon S3 automatically calls your Lambda function

## Hosting Static Site on S3

- We can host a static site on S3
- To host a static site in a bucket we must enable static website hosting, configure an index document, and set permissions
- We should also make a bucket content public:
    - We should turn of Block Public Access settings
    - We should attach a bucket policy which allows public read on the objects
- Amazon S3 website endpoints do not support HTTPS! If we want to use HTTPS, we can use Amazon CloudFront to serve a static website hosted on Amazon S3

# AWS SAM - Serverless Application Model

- A serverless application is not just a Lambda function, it can include many more services such as:
    - Front end code and assets hosted by S3 and CloudFront
    - API endpoint - API Gateway
    - Compute - Lambda
    - Database - DynamoDB
    - Event sources, permissions and more...
- The SAM group of products and features within AWS has 2 main parts:
    - AWS SAM template specification, which is an extension of CloudFormation. Adds components to CloudFormation templates designed specifically for serverless applications: Transforms, Globals & Resources (can include normal CFN resources as well as SAM specific ones)
    - AWS SAM CLI allows local testing, local invocation and deployments into AWS

# SAML 2.0 Identity Federation

- Federation lets user outside of AWS to assume a temporary role for access AWS resources
- These users assume identity provider access role
- SAML 2.0 - Security Assertion Markup Language
- SAML 2.0 allows to **indirectly** use on-premise identities with AWS (console and CLI)
- SAML 2.0 based identity federation is used when we have and enterprise based identity provider which is SAML 2.0 compatible
- SAML 2.0 based federation is ideal when we have an existing identity management team managing access to other services including AWS
- If we are looking to maintain a single source of truth and/or we have more than 5000 users, SAML 2.0 based federation is recommended to be used
- Federation is using IAM Roles and AWS Temporary Credentials (12 hours validity)

## SAML 2.0 Identity Federation Authentication Process - API Access

![SAML 2.0 Federation API](images/SAML2.0FederationAPI.png)

## SAML 2.0 Identity Federation Authentication Process - AWS Console Access

![SAML 2.0 Federation Console](images/SAML2.0FederationConsole.png)

## SAML 2.0 Federation

- We need to setup trust between AWS IAM and SAML (both ways)
- SAML 2.0 enabled web based, cross domain SSO
- Uses the STS API: `AssumeRoleWithSAML`
- It is the old way of doing federation, recommended way by AWS is to use **Amazon Single Sign On (SSO)**

# AWS Secrets Manager

- It does share functionality with SSM Parameter Store
- Secrets Manager is designed specifically for secrets, example passwords, API Keys
- It is usable via Console, CLI, API or SDK's
- It supports the automatic rotation of secrets using a Lambda functions
- For certain AWS services, Secrets Manager offers direct integration, such as RDS (automatic synchronization when the secrets are rotated)
- Secrets are encrypted using KMS

# AWS Security Hub

- Provides a comprehensive view of our security state in AWS
- Helps us assess our AWS environment against security industry standards and best practices
- Security Hub collects security data across AWS accounts, AWS services, and supported third-party products and helps us analyze our security trends and identify the highest priority security issues
- Security Hub needs to be enabled to be used. There are two ways to enable AWS Security Hub, by integrating with AWS Organizations or manually
- Organization can have a delegated administrator for the Security Hub

## Central Configuration

- It is a feature that helps us set up and manage Security Hub across multiple AWS accounts and regions
- We must integrate Security Hub and Organizations to use central configuration. Also, we must designate a home Region to use central configuration. The home Region is the Region from which the delegated administrator configures the organization
- The delegated administrator account can create AWS Security Hub configuration policies to configure Security Hub, security standards, and security controls in your organization
- Policy configurations:
    - Configuration policies must be associated to take effect
    - An account or OU can be associated with only one configuration policy
    - Configuration policies are complete: Configuration policies provide a complete specification of settings
    - Configuration policies can't be reverted: There's no option to revert a configuration policy after you associate it with accounts or OUs
    - Configuration policies take effect in your home Region and all linked Regions
    - Configuration policies are resources: they have an ARN
- Types of configuration polices:
    - Recommended configuration policy - provided by AWS
    - Custom configuration policy

# Service Catalog

- A service catalog is a document or database crate by the IT team containing an organized collection of products
- Used when different teams in the business use a service-charge module
- Key product information: Product Owner, Cost, Requirements, Support Information, Dependencies
- Defines approval of provisioning from IT and customer side
- Designed for managing cost and scale service delivery

## AWS Service Catalog

- Portal for end users who can launch predefined products by admins
- End user permissions can be controlled
- Admins can those products using CloudFormation and the permissions required to launch them
- Admins build products into portfolios which are made visible to the end users
- Service Catalog architecture:
    ![Service Catalog architecture](images/AWSServiceCatalog.png)

# AWS Service Quotas

- Defines how much of a "thing" we can use inside of an AWS account
- Example:
    - Number of EC2 instances at a certain times per region
    - Number of IAM users per AWS accounts
- Services usually have a default per region quota
- Global services may have a per account quota instead per region
- Most services quotas can be increased as needed
- Some service quotes can not be changed, example: number of IAM users per account (5000)
- Service endpoint and quotas: [https://docs.aws.amazon.com/general/latest/gr/aws-service-information.html](https://docs.aws.amazon.com/general/latest/gr/aws-service-information.html)
- **Service Quotas**: 
    - From the console we can go to *Service Quotas* page, where we can create dashboards for quotas we want to monitor
    - We can request quota changes from this service for certain services
    - *Quote request template*: we can predefine quota value request for new accounts in an AWS organization
    - We can create a CloudWatch Alarm based on a particular service quota
- Legacy method to increase quotas: create a support ticket selecting service quota increase
- We can request service quota increase from the CLI as well. Reference API: [https://awscli.amazonaws.com/v2/documentation/api/latest/reference/service-quotas/request-service-quota-increase.html](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/service-quotas/request-service-quota-increase.html)

# AWS Shield

- Provides protection against DDoS attacks
- Provides a custom designed set of protection against DDoS attacks
- Offers protection against all known infrastructure Layer 3 and Layer 4 DDoS attacks: Network Volumetric attacks (L3), Network Protocol Attacks (L4) for example TCP SYN Floods
- Comes in 2 forms:
    - **Shield Standard**:
        - It is free of charge for all AWS customers
        - Protection is at the perimeter of the network (this can be either at the region/VPC or AWS edge in case of CloudFront usage)
        - Protects against common Network (L3) and Transport (L4) layer attacks
        - We get the best protection if we use Route 53, CloudFront or Global Accelerator
        - It does not provide anything against proactive capability of any form of explicit configurable configuration
    - **Shield Advanced**:
        - Costs $3000 per month per organization, 1 year lock-in + charge for data (OUT) / month. Cost is not per account, if we want protection for multiple accounts, we have to make sure they are in the same organization
        - Expands the range of products which can be protected: CloudFront, Global Accelerator, Route53, anything associated with am EIP (example EC2 instances), load balancers (ALB, CLB, NLB)
        - Protection offered by Shield Advanced is not automatic. We need to enable it in Shield Advanced or as part as AWS Firewall Manager Shield Advanced policy
        - Shield Advanced provides access to 24/7 advanced response team named AWS Shield Response Team (SRT)
        - Provides financial insurance for any increase of payments in case of DDoS attacks
        - Additional Shield Advanced features
            - Integration with WAF:
                - Shield Advanced integrates with WAF to protect against Application Layer (L7) attacks
                - Includes basic AWS WAF fees for web ACLs, rules and web requests
            - Real time visibility of DDOS events and attacks
            - Health-based detection: application specific health checks used by proactive engagement team to provide faster detection and mitigation of any issues
            - Protection groups:
                - We can create grouping of resources that Shield Advanced protects
                - We can define the criteria of membership for groups, any new resource will automatically be added

# Snow Family

- Snowball series are designed to move large amount of data in or out of AWS
- The products in Snow series are physical storage units: suitcases and trucks
- We can order them empty, load them up and return them or vice-versa

## Snowcone

- It is portable, rugged and secure device for edge computing and data transfer
- Snowcone is available in two flavors:
    - Snowcone: has two vCPUs, 4 GB of memory and 8 TB of HDD based drive
    - Snowcone SSD: has two vCPUs, 4 GB of memory and 14 TB of SSD based storage
- Use cases for Snowcone:
    - Edge computing applications, to collect data, process the data to gain immediate insight, and then transfer the data online to AWS
    - Transfer data that is continuously generated by sensors or machines online to AWS in a factory or at other edge locations
    - Distribute media, scientific, or other content from AWS storage services to your partners and customers
    - Aggregate content by transferring media, scientific, or other content from your edge locations to AWS

## Snowball

- It is a device which is ordered from AWS, log a job and device will be delivered to us
- Any data stored in Snowball is encrypted using KMS
- There are 2 types of devices with 50 TB and 80T B capacity
- In terms of network connectivity we can have 1 Gbps (RJ45 1GBase-TX) or 10 Gbps (LR/SR) networking
- Economical range for a Snowball is 10 TB to 10 PB range of data (multiple devices can be used)
- Multiple devices can be ordered and be sent to multiple business premises
- Snowball only includes storage capability

## Snowball Edge

- Includes both storage capability and compute capability
- It has a larger capacity compared to classic Snowball and has faster networking connection
- There are 3 different type of Snowball Edge:
    - Storage optimized (with EC2 capability): 80 TB, 24 vCPU, 32 Gib RAM, 1 TB of local SSD for EC2 usage
    - Compute optimized: 100 TB + 7.68 NVME, 52 vCPU, 208 Gib RAM
    - Compute optimized with GPU: 100 TB + 7.68 NVME, 52 vCPU, 208 Gib RAM, GPU
- Ideal for remote sites or where data processing on ingestion is needed

## Snowmobile (Discontinued)

- Portable data center within a shipping container on a truck
- Needs to be specially ordered from AWS
- Ideal for single location when 10 PB+ is required
- Can store up to 100PB of data per Snowmobile
- Not economical for multi-site or sub 10PB

# SNS - Simple Notification Service

- It is a highly available, durable, secure, pub-sub messaging service
- It is a public AWS service: requires network connectivity with a public endpoint
- It coordinates the sending and delivery of messages
- Messages are <= 256 KB payloads
- SNS Topics are the base entity of SNS. On this topics are permissions controlled and configurations defined
- A publisher sends messages to a topic
- Topics can have subscribers which will receive messages from a topic
- Supported subscribers are:
    - HTTP(s)
    - Email (JSON)
    - SQS queues
    - Mobile Push Notifications
    - SMS messages
    - Lambda Functions
- SNS is used across AWS for notifications, example CloudWatch uses it extensively
- It is possible to apply filters to a subscriber
- Fan-out architecture: single topic with multiple SQS queue subscribers
- SNS offers delivery status for supported subscribers which are HTTP, Lambda and SQS
- SNS supports delivery retries
- SNS it is a HA and scalable service within a region
- SNS supports Server Side Encryption (SSE)
- We can use cross-account access to a topic via topic policies

# SQS - Simple Queue Service

- SQS provides managed message queues
- It is a public AWS service
- It is fully managed with highly available and highly performant queues by design
- Queues come in two types: Standard (ordering is best effort) and FIFO (guarantee an order)
- Messages added to the queue are up to 256 KB in size
- `VisibilityTimeout`: when a client receives a message, the message is hidden for a period of time. The `VisibilityTimeout` is the period which is given to the client in order to process the message
- If the client processes the message, it has to delete the message from the queue. If the message is not deleted, after the `VisibilityTimeout` the message will be available for other clients
- **Dead-Letter queues**: all unprocessed messages can be sent here after a given number of retries. Allows different types of processing on the messages
- Queues can be used for scaling by ASGs, Lambdas can be invoked based on messages in the queue

## SQS Standard vs FIFO Queues

- Standard: 
    - Messages are delivered at least once
    - The order of the delivery is not guaranteed (best-effort ordering)
    - They don't have performance limitations
- FIFO: 
    - Messages are delivered exactly once
    - The order of the delivery is guaranteed to be the same as the messages were sent
    - Performance is limited: 3000 messages per second with batching or up to 300 messages per second without batching
    - There is also available a high throughput mode for FIFO queues
    - FIFO queues have to have `.fifo` suffix in order to be valid FIFO queues

## SQS Billing

- With SQS we are billed per request
- With a 1 request we can receive between 1 and 10 messages up to 64 KB total
- SQS is less cost effective if we poll more frequently

## SQS Polling

- Polling SQS queues:
    - **Short polling** (immediate): can return 0 or more messages. It will return immediately if there are no messages on the queue
    - **Long polling**: we can specify `waitTimeSecond` value which can be up to 20 seconds to wait form messages when polling. It uses fewer requests than short polling

## SQS Encryption and Security

- SQS supports encryption at rest (KMS) and encryption in transit
- Access to a queue is based on identity policies and queue policies
- Queue policies can allow cross-account access

## SQS Extended Client Library

- SQS has a message size limit of 256 KB
- Extended Client Library can be used when we want to send messages larger than this size
- It can process large payloads and have the bulk of the payloads stored in S3
- When we send a message using `SendMessage` API, the library uploads the content to S3 and stores a link to this content in the message
- When receiving a message, the library loads the payload from S3 and replaces the link with the payload in the message
- When deleting a message from a queue, the large S3 payload will also be deleted
- The Extended Client Library can handle messages up to 2 GB
- It has an implementation in Java. Equivalent libraries are available for other languages

## SQS Delay Queues

- Delay queues allow us to postpone the delivery of messages in SQS queues
- For a delay queue we configure a `DelaySeconds` value. Messages added to the queue will be invisible for the amount of `DelaySeconds`
- The default value of `DelaySeconds` is 0, the max value is 15 minutes. In order for a queue to be delay queue, the value should be set to be greater than 0
- Message times allows a per-message basis invisibility to be set, overriding the queue setting. Min/max values are the same. Per message setting is not supported for FIFO queues

## SQS Dead Letter Queues (DLQ)

- Dead Letter Queues are designed to help handle reoccurring failures while processing messages from a queue
- Every time a message is received, the `ReceiveCount` is incremented. In order to not process the same message over and over again, we define a `maxReceiveCount` and a DLQ for a queue. After the number of retries is greater than the `maxReceiveCount`, the message is pushed into the DLQ
- Having a DLQ, we can define alarms to get notified in case of a failure
- Messages in DLQ can be further analyzed
- Every queue (including DLQ) have a retention period for messages. Every message has an `mq-timestamp` which represents when was the message was added to the queue. In case a message is moved into a DLQ, this timestamp is not altered
- Generally the retention period for a DLQ should be longer compared to normal queues
- A single DLQ can be used for multiple sources

# AWS Systems Manager (SSM)

- Is a product which lets us manage and control AWS and on-premise infrastructure
- SSM is agent based, which means an agent needs to be installed on Windows and Linux based AMIs
- SSM manages inventory (what application are installed, files, network config, hw details, services, etc.) and can patch assets
- It can also run commands and manage desired state of instances (example: block certain ports)
- It provides a parameters store for configurations and secrets
- Finally it provides session manager used to securely connect to EC2 instances even in private VPCs

## Agent Architecture

- An instances needs the SSM agent to be installed in order to be able to be managed by the service
- It also needs an EC2 instance role attached to it which allows communication with the service
- Instances require connectivity to the SSM service. This can be done via IGW or VPCE
- On the on-premises side we need to create managed instance activations
- For each activation we will receive an activation code and an activation ID

## SSM Run Command

- It allows us to run commands on managed instances
- It takes a Command Document and executes it using the agent installed on the instance
- It does this without using SSH/RDP protocol
- Command documents can be executed on individual instances, multiple instances based on tags or resource groups
- Command documents can be reused and they can have input parameters
- Rate Control: if we are running commands on lot of instances, we can control it by using rate control. It can be based on:
    - **Concurrency**: on how many instances must run the command at a time
    - **Error Threshold**: defines how many individual commands can fail
- Output of commands can be sent to S3 or we can send SNS notifications
- Commands can be integrated with EventBridge

## SSM Patch Manager

- Allows to patch Linux and Windows instances running in EC2 or on-premises
- Concepts:
    - **Patch Baseline**: we can have many of these defined. Defines what should be installed (what patches, what hot-fixes)
    - **Patch Groups**: what resources we want to patch
    - **Maintenance Windows**: time slots when patches can take place
    - **Run Command**: base level functionality to perform the patching process. The command used for patching is `AWS-RunPatchbaseline`
    - **Concurrency** and **Error Threshold**: (see above)
    - **Compliance**: after patches are applied, system manager can check success of compliance compared to what is expected
- Patch Baselines:
    - For Linux: `AWS-[OS]DefaultPatchBaseline` - explicitly defines patches, example: `AWS-AmazonLinux2DefaultPatchBaseline`, `AWS-UbuntuDefaultPatchBaseline` - contain security updates and any critical update
    - For Windows: `AWS-DefaultPatchBaseline`, `AWS-WindowsPredefinedPatchBaseline-OS`, `AWS-WindowsPredefinedPatchBaseline-OS-Application` - Contains patches for MS applications as well.



# AWS Step Functions

- Step Functions address limitations of Lambda product
- A Lambda function has an execution time of maximum 15 minutes
- Lambda functions can be chained together, but it is considered to be an anti-patterns and it can get messy. Lambda runtime environments are stateless
- Step Functions is service which lets us create state machines
- States can do things, can decide things, can take in data, modify data and output data
- Maximum duration for state machine execution is 1 year
- Step Functions can represent 2 different type of workflow:
    - Standard workflow: is the default and it has 1 year execution limit
    - Express workflow: designed for high volume event processing (IoT, streaming data processing and transformations), which can run up to 5 minutes
- Step Functions can be initiated with API Gateway, IoT Rules, EventBridge, Lambda or even manually
- State machines for Step Functions can be created with Amazon State Language (ASL) JSON templates

## States

- Type of states available:
    - `SUCCEED` and `FAIL`
    - `WAIT`: will wait for a certain period or time or until a date
    - `CHOICE`: allows a state machine to take a different path depending on an input
    - `PARALLEL`: allows to create parallel branches in a state machine
    - `MAP`: expects a list of things, for each it will perform a certain set of things
    - `TASK`: represents a single unit of work performed by a state machine. It can be integrated with: Lambda, Batch, DynamoDB, ECS, SNS, SQS, Glue, SageMaker, EMR, other Step Functions, etc.




# Storage Gateway

- Normally runs as a VM on-premises (or hardware appliance)
- Acts as bridge between storage that exists on-premises and AWS
- Presents storage using iSCSI, NFS or SMB
- On AWS integrates with EBS, S3 and Glacier
- Storage gateways is used for migrations, extensions, storage tiering, DR and replacement of backup systems

## Volume Gateway

- Offers 2 different types of operation:
    - Volume Stored Mode:
        - The virtual appliance presents volumes over iSCSI to servers running on-premises (similar to what NAS/SAN hardware would)
        - Servers can create files systems on top of these volumes and use it in a normal way
        - These volumes consume capacity on-premises
        - Storage gateway has local storage, used as primary storage, everything is stored locally
        - Upload buffer: any data written to the local storage is also copied in the upload buffer and it will be uploaded to the cloud asynchronously via the storage gateway endpoint
        - The upload data is copied into S3 as EBS snapshots which can be converted into EBS volumes
        - It is great to do full disk backups, offering excellent RTO and RPO values
        - Volume Stored Mode does not allow extending the data center capacity! The full copy of the data is stored locally
        ![Volume Stored Mode architecture](images/StorageGatewayVolumeStored.png)
    - Volume Cached Mode:
        - Volume Cached Mode shares the same basic architecture with Stored Mode
        - The main location of data is no longer on-premises, it is on AWS S3
        - It has a local cache for the data only storing the frequently accessed data, the primary data will be in S3
        - The data will be stored in AWS managed area of S3, meaning it wont be visible using the AWS console. It can be viewed from the storage gateway console
        - The data is stored in raw block state
        - We can create EBS volumes out of the data
        - Volume Cached Mode allows for an architecture know as data center extension
        ![Volume Cached Mode architecture](images/StorageGatewayVolumeCached.png)

## Tape - VTL Mode

- VTL - Virtual Tape Library
- Examples of tape backups: LTO-9 (Linear Tape Open) Media which can hold 24TB raw data per tape
- Tape Loader (Robot): robot arm can insert/remove/swap tapes
- A Library is 1 ore more drives, 1 or more loaders and slots
- Traditional tape backup architecture:
    ![Traditional tape backup architecture](images/TraditionalTapeBackup.png)
- Storage Gateway Tape (VTL) Mode architecture:
    ![Storage Gateway Tape (VTL) Mode architecture](images/StorageGatewayVTL.png)
- A Virtual tape can be from 100 GiB to 5 TiB
- A Storage Gateway can handle at max 1PB ot data across 1500 virtual tapes
- When virtual tapes are not used, they can be exported in the backup software marking them not being in the library (equivalent of ejecting them and moving them to the offsite storage)
- When exported, the virtual tape is archived in the Virtual Shelf which is backed by Glacier
- Storage Gateway in VTL Mode pretends to be a iSCSI tape library, tape change and iSCSI drive (physical tape backup system)
- Use cases: 
    - On-premises data storage extension into AWS
    - Migration of historical sets a tape backups

## File Mode

- Storage Gateway manages files in File Mode
- File Gateway bridges on-premises file storage and S3
- With File Gateway we create one or more mount points (shares) available via NFS or SMB
- File Gateways maps directly onto on S3 bucket above which we have visibility from the AWS console
- File Mode uses Read an Write Caching ensuring LAN-like performance
- File Gateway architecture:
    ![File Gateway architecture](images/StorageGatewayFile.png)
- For Windows environments we can use AD authentication to access the File Gateway
- File Mode can be used for multiple contributors (multiple shares on-premises)
- File paths in a File Gateway map directly to S3 object names
- `NotifyWhenUploaded`: API to notify other gateways when objects are changed
- File Gateway does not support any kind of object locking => one gateway can override files from another gateway. We should use a read only mode on other shares or tightly control file access
- The bucket backing the File Gateway can be used with cross-region replication (CRR)
- The lifecycle policies can also be used for files to be moved automatically between classes

# STS

- Allows to assume roles across different accounts or same accounts
- Generates temporary credentials (`sts:AssumeRole*`)
- Temporary credentials are similar to access key. They expire and they don't directly belong to the identity which assumes the role
- Temporary credentials usually provide limited access
- Temporary credentials are requested by another identity (AWS or external - identity federation)
- Temporary credentials include the following:
    - `AccessKeyId`: unique ID of the credentials
    - `Expiration`: date and time of credential expiration
    - `SecretAccessKey`: used to sign the requests to AWS
    - `SessionToken`: unique token which must be passed with all the requests to AWS
- STS allows us to enable identity federation

## Assume a Role with STS

1. Define an IAM role within an account or cross-account
2. Define which principals can access the IAM role
3. Use the AWS STS (Secure Token Service) to retrieve the IAM role we have access to (`AssumeRole` API)
4. Temporary credentials can be valid between 15 minutes to 1 hour

## Revoke IAM Role Temporary Credentials

- **Trust policy**: specifies who can assume a role
- Roles can be assumed by many identities
- Everybody who assumes a role, gets the same set of permissions
- Temporary credentials can not be cancelled, they are valid until they expire
- Temporary credentials can last for longer time
- In case of a credential leak if we change the permissions for the policy, we will affect all legitimate users - not a good idea for revoking access
- Solution: 
    - Revoke all existing sessions, by applying an `AWSRevokeOlderSessions` inline policy to the role. This will apply to all existing sessions, sessions created afterwards will not be affected
    - We can not manually revoke credentials!



# SWF - Simple Workflow Service

- Allows us to build workflows used to coordinate activities over distributed components (example: order flow)
- Allows to build complex, automated and human involved workflows
- It is the predecessor of Step Functions, it uses instances/servers
- It allows the usage of the same patterns/anti patterns like long running workflows
- AWS recommends defaulting to Step Functions instead of SWF, use SWF only if there is very specific workflow that requires it
- Workflow: set of activities that carry out some objective together with the logic that coordinates the activities
- Within workflows we have activity task and activity workers
- A worker is program that we create to perform tasks
- Workflows have deciders, applications that run on an unit of compute of AWS
- Deciders schedule activity tasks, provides input data to activity workers, processes events and ends the workflow when the object is completed
- SWF workflows can run for max 1 year

## SWF vs Step Functions

- Default: Step Functions - they are serverless, they require lower admin overhead
- AWS FLow Framework - way of defining workflows supported by SWF
- External Signals to intervene in process, we need SWF
- Launch child flows and have the processing return to parent, we need ot use SWF
- Bespoke/complex decision logic: use SWF (custom decider application can be coded by us, we can implement whatever logic we want)
- Mechanical Turk integration: use SWF (suggested AWS architecture)

# Amazon Textract

- Is a ML product used to detect and analyse text contained in input documents such as JPEG, PNG, PDF or TIFF
- The output is extracted text, structure of that text and any analysis that can be performed on that text
- For most documents the Textract is capable to operate in a synchronous way (real time)
- For large documents it will operate in asynchronous way
- It is pay per usage, custom pricing being available for large volume of documents
- Use cases of Textract:
    - Detection of text and the relationship between the text, example receipt - dates, items, prices. It also offers metadata about the text: where the ext occurs
    - Document analysis:
        - For generic documents might detect names, addresses, birth date, etc.
        - For receipts: prices, vendors, line items, dates, etc.
        - Identity documents: abstraction of certain fields to being able to store them in a table of a database
- It can be integrated with other AWS services

# Amazon Transcribe

- Is an Automatic Speech Recognition (ASR) service
- Input: audio; output: text
- Offers various features that improve this feature:
    - Language customizations
    - Filters for privacy
    - Audience-appropriate language
    - Speaker identification
- In addition we can configure custom vocabularies and configure language models according to our use-case
- The product is pay as we use per second of transcribed audio
- Products comes in different flavors such as Transcribe, Transcribe Medical and Transcribe Call Analytics
- Amazon Transcribe use cases:
    - Full text indexing of audio to allow searching
    - Create meeting notes
    - Generate subtitles/captions and transcripts
    - With Call Analytics we can ingest phone calls to do analytics such as characteristics, summarization, categories and sentiment analysis
- Can be integrated with our applications with APIs as well it integrates with other AWS ML services


# AWS Transfer Family

- Is a product which provides managed file transfer service
- It allows us to transfer files to/from S3 or EFS
- It provides managed servers which provides various protocols. Allows us to upload/download data to S3 or EFS using protocols different the ones natively supported by S3 of EFS
- Allow us to interact with both of these services using the following protocols:
    - FTP (File Transfer Protocol): unencrypted file transfer protocol
    - FTPS (File Transfer Protocol Secure): file transfer protocol with TLS encryption
    - SFTP (SSH File Transfer Protocol): file transfer over SSH
    - Applicable Statement 2 (AS2): transfer structured B2B data
- Transfer Family supports a wide range of identities: service managed, Directory Service, custom (Lambda/APIGW)
- Managed File Transfer Workflows (MFTW): serverless file workflow engine:
    - Can be used when file are uploaded, we can define workflows as to what happened to the file as it gets uploaded

## Transfer Family Endpoint Types

- Within Transfer Family we create servers which we can think of as the front-end accesspoint to our storage
- They present S3 and EFS via one or more supported protocol
- How we access these servers depends on how configure the service's endpoints:
    - Public: runs on the AWS public zone, accessible to the public internet
        - No networking components to configure
        - Only supported protocol is SFTP
        - The endpoint has a dynamic IP which can change, we should use DNS to access it
        - We can't control who will access it using features such as NACLs or security groups
    - VPC - Internet Access
        - Runs in a VPC
        - We can use SFTP/FTPS and AS2 protocols
        - Anything that has connectivity to the VPC (DX/VPN) can access it as it was running inside the VPC
        - Transfer Family provides a static IP for it
        - SG/NACLs are supported
        - It is allocated an Elastic IP for it which is static, which allows it to be accessed over the public internet
    - VPC - Internal
        - Runs inside a VPC
        - We can use SFTP/FTPS/FTP and AS2 protocols
        - Anything that has connectivity to the VPC (DX/VPN) can access it as it was running inside the VPC
        - Transfer Family provides a static IP for it
        - SG/NACLs are supported

## Other Features

- It is multi-AZ => resilient and scalable
- Cost is based for provisioned server per hour + data transfer
- With FTP/FTPS only Directory Service and Custom IDP is supported
- FTP can only be used internally within a VPC
- AS2 has to be VPC Internet/Internal only, we cannot use the public endpoint type
- Use cases for Transfer Family:
    - In case we need access to S3/EFS but using the supported protocols
    - Integration with existing workflows
    - Using MFTW to create new workflows

# AWS Transit Gateway

- It is a network transit hub which connects VPCs to each other and to on-premise networks using Site-to-Site VPNs and Direct Connects
- It is designed to reduce the network architecture complexity in AWS
- It is a network gateway object, it is HA and scalable
- Attachments: we create attachments in order for the TGW to connect to VPCs and on-premise networks. Valid attachments are:
    - VPC attachments
    - Site-to-Site VPN attachments
    - Direct Connect Gateway attachments
- Attachments are configured in each subnet of the connected VPCs
- We can also peer transit gateways across cross regions and/or cross accounts
- We can also attach transit gateways to the DX connections
- Transit Gateway Considerations:
    - Supports transitive routing: single transit gateway with multiple attachments using route tables
    - Can be used to create global networks with peering
    - We can share transit gateways using AWS RAM
    - Transit Gateways offer less complex architectures compared to VPC peering solutions

## Transit Gateway - Deep Dive

- Transit gateway is a hub-and-spoke architecture, it can connect to various types of networking objects within AWS
- Integration with Direct Connect:
    - A Transit VIF is required which goes through a DX Gateway
    - The DX Gateway can be attached to the Transit Gateway with a Transit Gateway Attachment
    - 1 DX Gateway can be attached to 3 Transit Gateways
- Transit Gateway has a default route table which is populated from the attachments:
    - For the VPCs we have the CIDR ranges of these VPCs
    - For VPNs we have the routes learned via BGP
    - For DX Gateways with the Transit Gateway Attachment we define the networks within the attachment configured at the DX Gateway side
- We can peer TGWs with other TGWs between regions. We can peer a TGW with up to 50 other TGWs, and these TGWs can also peer with other TGWs
- A TGW by default has one route table
- All attachments use this RT for routing decisions, by default all attachments propagate routes to this route table, exception peering attachments
- All attachments can route to all other attachments by default

## Transit Gateway Peering

- In case of peering attachments routes are not shared, we need to use static routes, similar to VPC peering (AWS recommends using unique ASNs for future enhancements for route advertisements)
- Resolution of public DNS to private addressing is not supported over inter-region peers
- Data transfer over peering connection is encrypted and is sent over AWS network
- We can peer up to 50 peering attachments per TGW, these can be in different regions, different AWS accounts

## Transit Gateway Isolated Routing

- By default:
    - All attachments are associated with the same route table
    - All attachments propagate to the same route table, all attachments are aware of any other attachments
- Attachments can only be associated with 1 route table, route tables can be associated to many attachments
- Attachments can propagate to many RTs, event to those they are not associated with
- If we would want to isolate networks:
    - We create a route table and we configure all attachments to propagate to the route table
    - We associate the route table with only the attachments we would want to communicate with each other
    - We create another route and associate it to the attachment we don't want to communicate with each other. We configure other attachments to propagate to this route table

# Amazon Translate

- Is a text translation service based in ML
- Translates text from native language to other languages one word at a time
- Translation process has two parts:
    - Encoder reads the source text => outputs a semantic representation (meaning)
    - Decoder reads in the meaning => writes to the target language
- Attention mechanism ensures "meaning" is translated
- Textract is capable to detect the source text language
- Use cases:
    - Multilingual user experience
    - Translate incoming data (social media/news/communications)
    - Language-independence for other AWS services: we might have other services such as Comprehend, Transcribe and Polly which operate on information; Transcribe will make this services operate in a language independent way. It can used to analyze data stored in S3, RDS, DDB, etc.
    - Commonly used for integration with other services/Apps/platforms

# AWS Trusted Advisor

- Provides real time guidance to provision resources against AWS best practices
- It is an account level product, requires no agent to be installed
- Provides a number of checks and recommendations in 5 major areas:
    - Cost Optimization & Recommendations
    - Performance
    - Security
    - Fault Tolerance
    - Service Limit
- Trusted Advisor is not a free service, at least if we want to get out the most of it
- The free version is available if the account has basic or developer support plans
- The free version provides 7 basic core checks <span style="color: #ff5733;">(Remember them for EXAM)</span> :
    - S3 bucket permissions (open access permissions)
    - Security Groups - specific ports unrestricted
    - IAM use
    - MFA on Root Account
    - EBS Public Snapshots
    - RDS Public Snapshots
    - 50 service limit checks: checks the 50 most common service limits and identifies any where we are over 80% of that limit
- Anything beyond these basic checks requires business or enterprise support plans
- With business and enterprise support we get further 115 checks
- We also get access to the AWS Support API
- AWS Support API allows for programmatic access for AWS support functions:
    - We can get the names and identifiers for the checks AWS offers
    - We can request a Trusted Adviser check runs against accounts and resources
    - Allows to get summaries and detailed information programmatically
    - Allows request for Truster Advisor refresh
- AWS Support API allows to programmatically open support ticket, and manage them
- With business and enterprise support we get CloudWatch integration => we can define event driven responses to actions

## AWS Support Plans

- Basic Support:
    - Is included for AWS customers and it is free
    - For Trusted Advisor with this support plan we get 7 core checks (see them above)
- Developer:
    - For Trusted Advisor we get the same 7 base core checks (see them above)
- Business:
    - We ge the full set of checks and recommendation
    - We get programmatic access to Trusted Advisor
- Enterprise:
    - Same as business

## Good to Know

- We can check if an S3 bucket is made public, but we cannot check if objects are public in a bucket. Monitoring this we might use CloudWatch Events/S3 Events instead
- Service Limits:
    - Limits can only be monitored in Trusted Advisor
    - Cases have to be created manually in AWS Support Centre to increase limits

# VM Migrations AWS <=> On-Premises

## Application Discovery Service (AMS)

- Allows us to discover on-premises infrastructure:
    - What VM we have
    - What CPU and memory they are allocated
    - MAC addresses
    - Resource utilization
    - etc.
- It also tracks these properties over time for more effective migration
- AMS runs in 2 modes:
    - Agentless (Application Discovery Agentless Connector): 
        - It is an OVA based virtual appliance that integrates with VMWare
        - It can measure performance and resource usage, information which can be obtained from the outside of a VM
    - Agent Based mode (with CloudWatch Agent): offers additional information from inside of a VM
        - Offers data gathering for network, processes, performance
        - We can see applications running on a VM
        - We can even see dependencies between VM based on network activity
- AMS does not migrate anything, it helps us discover VM instances and relationships between them in order to be migrated
- This information is valuable if we have thousands of instances we want to migrate
- AMS integrates with AWS Migration Hub and Athena
- **AWS Migration Hub**: tracks migrations of different types in AWS. Migrations such as VM migrations and database migrations

## Server Migration Service (SMS)

- Used to migrate whole VMs into AWS (including OS, Data, Apps, etc.)
- This is the tool which actually performs the migration
- It runs in agentless mode using a connector. The connector is VM which runs on on-premises within our existing VM environment
- The connector integrates with VMware, Hyper-V and AzureVM
- SMS does incremental replication of live volumes
- Offers orchestration of multi-servers migrations
- Creates AMIs which can be used to create EC2 instances
- It can be used with other tooling such as CloudFormations to automate repeated deployment of instances
- It too integrates with AWS Migration Hub

## AWS Application Migration Service (MGN)

- Is used to migrate servers from on-prem to AWS
-  It allows companies to lift-and-shift a large number of physical, virtual, or cloud servers without compatibility issues, performance disruption, or long cutover windows
- AWS recommends agent-based replication when possible as it supports continuous data protection (CDP)
- AWS MGN provides this agent. MGN creates a Launch Template which is then used to launch EC2 instances
- AWS MGN provides a way to work out what kind of dependencies do we have between databases, app servers, web servers, etc. We can group these servers and migrate them together
- It can also provide CloudFormation templates for deployment
- Difference between SMS and MGN:
    - Server Migration Service utilizes incremental, snapshot-based replication and enables cutover windows in hours
    - Application Migration Service utilizes continuous, block-level replication and enables short cutover windows measured in minutes
- AWS recommends to use MGN instead of SMS
- We can migrate virtual and physical servers as well

# VPC Flow Logs

- Essential diagnostic tools for complex networks
- They only capture packet metadata, they do not capture packet content. For packet content a packet sniffer is required to be installed on an instance
- Metadata can include: source/destination IP, source/destination ports, packet size, other externally visible metadata, etc.
- Flow logs can capture data at various different points:
    - Applied to a VPC: all interfaces in that VPC
    - Subnet: every network interface in the subnet only
    - Network interface: only monitor traffic at a specific interface
- VPC Flow Logs are NOT realtime, there is delay between traffic leaving monitored interfaces and showing up in the flow logs <span style="color: red;">EXAM</span>
- Flow logs can be configured to use S3, CloudWatch Logs or Kinesis Firehose for the destination
- Flow logs can be cofigured to capture data only at accepted connections, only at rejected connections or they can capture metadata at all connections.

## VPC Flow Logs Record Content

- `<version>`
- `<account-id>`
- `<interface-id>`
- `<srcaddr>`: source IP address
- `<dstaddr>`: destination IP address
- `<srcport>`: source port, 0 if no port is used (example in case of ICMP ping)
- `<dscport>`: destination port
- `<protocol>`: ICMP=`1`, TPC=`6`, UDP=`17`, etc. <span style="color: red;">Need to remember for EXAM</span>
- `<packets>`
- `<bytes>`
- `<start>`
- `<end>`
- `<action>`: traffic is `ACCEPT`ed or `REJECT`ed
- `<log-status>`

## Notes

- VPC Flow Logs do not log all the traffic, things like the communication with the metadata IP (169.254.169.254), AWS time sync server (169.254.169.123), DHCP, Amazon DNS server and Amazon Windows license is not recorded


# VPC - Virtual Private Cloud

## Public vs Private Services

- Public service: a service which is accessed by using public endpoints
- Private service: a service which runs inside a VPC
- Either private or public, every service can have permissions in order to be accessible
- VPC: private network isolated from the internet. Can't communicate to the network unless we are allowing it. Nothing from the internet can reach the services from a VPC as long as we do not configure it otherwise
- Internet Gateway: we can connect it to a VPC, this will allow the services in the VPC to communicate with the public internet

## DHCP in a VPC

- DHCP - Dynamic Host Configuration Protocol: offers auto configuration for network resources
- Every device has a hard-coded MAC address (Layer 2 address)
- DHCP begins with a L2 broadcast to discover a DHCP server on the local network
- Once discovered a DHCP server and a DHCP clients communicate, meaning that the client will get in the end an IP address, a Subnet Mask and Default Gateway address (L3 configuration)
- DHCP also configures which DNS server should a resource use in a VPC
- Also configures NTP servers, NetBios Name Servers and Node types
- When we are setting which DNS service to use in a VPC we can either explicitly provide values or we can set `AmazonProvidedDNS`
- We also get allocated 1 or 2 DNS names for the services in the VPC. One can be public if the instance has a public IP address allocated
- Custom DNS names: we can give custom DNS names to EC2 instances if we use our own custom DNS servers. To accomplish these we can use DHCP option sets
- DHCP options sets:
    - Once created option sets can not be changed
    - Can be associated with 0 or more VPCs
    - Each VPC can have a max of 1 option set associated (it can have 0)
    - We we change a DHCP option set associated to the VPC, the change is immediate, but any new setting will only affect anything once a DHCP renew occurs
    - What we can configure in an option set:
        - DNS server (Route 53 resolver) what we can use in the VPC
        - NTP server

## VPC Router Deep Dive

- Is at the core of any network which involves AWS
- Is a virtual router in a VPC
- It is HA across al AZs in a region, no management overhead is required
- It is scalable, no management overhead required
- VPC routes routes traffic between subnets in a VPC
- Routes traffic from external network into the and vice-versa
- VPC router has an interface in every subnet in a VPC: `subnet+1` address (Default Gateway), the first IP address in each subnet after the network address itself
- We control how the VPC routes traffic using Route Tables

## VPC Route Tables

- Every VPC is created with a main Route Table (RT), which is the default for every VPC
- Custom route tables can be created for each subnet
- Subnets can be associated with only one RT which can be the main one or custom
- If we disassociate a custom RT form a subnet, the main RT will be attached to it
- Main RT should not be changed, custom RT should be used for any routing changes
- RT have routes, routes have an order, the most specific route wins
- Edge Association: a RT tables is associated with network gateway
- All RTs have at least one route: the local route which matches the VPC cidr range. These routes are un-editable

## NACL - Network Access Control Lists

- A NACL can be considered to be a traditional firewall in an AWS VPC
- NACLs are associated with subnets, every subnet has a NACL associated to it
- Connection inside a subnet are not affected by NACLs
- NACls can be considered stateless firewalls, so we can talk about the following type of rules:
    - Inbound rules: affect data coming into the subnet
    - Outbound rules: affects data leaving from the subnet
- Rules can explicitly **ALLOW** and explicitly **DENY** traffic
- Rules are processed in order:
    1. A NACL determines if a the inbound or outbound rules apply
    2. It starts from the lower rule number, evaluates traffic against each rule until is a match (based on IP range, port, protocol)
    3. Traffic is allowed/denied based on the rule
- Last rule is an implicit deny in every NACL, if no rule before that applies, traffic will be denied
- Default NACL: when a VPC is created, a default NACL is attached to it. The default NACL is allowing all traffic
- Custom NACLs: 
    - We can create them and attach them to subnets
    - Each NACL has a default rule that denies all traffic. This has the lowest priority
- NACLs can be associated to many different subnet, however each subnet can have only one NACL associated to it at any time
- NACL are not aware af any logical resources within a VPC, they are aware of IPs, CIDRs and protocols

## SG - Security Groups

- Security Groups are stateful firewalls, meaning they detect response traffic to a request and they automatically allow that traffic
- SGs do not have explicit **DENY** rules, they can be used to block bad actors (use NACLs for this)
- SGs support IP/CIDR rules and also allow to reference logical resources
- SGs are attached to Elastic Network Interfaces (ENI), when we attach a SG to an EC2, the SG will be attached to the primary ENI
- SGs are capable to reference logical resources, ex. other security groups or self referencing

## AWS Local Zones

- Parent Region: regular AWS region
- Local Zones are attached to parent regions and they operate in the same geographical region
- Local Zone naming: `us-east-las-1` - < parent region > - < Local Zone identifier (international city code) >. Examples: `us-west-2-lax-1a`, `us-west-2-lax-1b`
- We can have multiple Local Zones in the same city
- Local Zones operate as their own independent points, they have their own independent connection to the internet
- Generally, they support Direct Connect
- A VPC in a parent region can be extended with subnets from a Local Zone. In these subnets we create our resources as normal
- These resources will benefit from super low latencies (in case we want to access them from a business premises nearby)
- Some things within a Local Zone will still utilize the parent region: for example Local Zones will have private networking with the parent region, however if we create backups for an EBS in the Local Zone, this will utilize the S3 from the parent region
- Local Zones can be considered as one additional AZ (but near our location => lower latency), they don't have builtin AZ
- Not all AWS products support Local Zones. From the ones which do support, many of them are opt-in an also many of them have limitations
- Local Zones should be used when we need the highest performance

## Advanced VPC Routing

- **Subnets are associated with 1 route table (RT) only, no more noe less!**
- This route table is either the main route table from the VPC or a custom route table
- In case of a custom route table association with a subnet, the main route table is disassociated. In case the custom RT is removed, the main RT is associated again with the subnet
- RT can associated with an internet gateway (IGW) or virtual private gateway (VGW)
- IPv4/6 are handled separately within a RT
- Routes send traffic based on a destination to a target
- Route tables have a maximum of 50 static routes and 100 dynamic routes
- When a traffic arrives to an interface (IGW, VGW), it is matched to the relevant route table
- All routes from a route table are evaluated - highest-priority matching is used
- Route tables can contain 2 types of routes:
    - Static routes: added manually by us
    - Propagated routes: added when enabled by us on the VPC or on any individual RT
- Evaluation rule for the routes: 
    1. Longest prefix wins, example /32 wins over /24, /16 or /0. More specific routes always win!
    2. Static routes take priority over propagated routes
    3. For any routes learned by propagation:
        1. DX
        2. VPN Static
        3. VPN BGP
        4. AS_PATH (BPG term used to represent the path between two ASNs; it is the distance within two different autonomous systems): routes with a shorter AS_PATH would win over the longer AS_PATH ones

## Ingress Routing

- All outgoing traffic is routed to a security appliances
- The security appliance is sitting in the public subnet which has a RT assigned to it. This RT sends all unmatched traffic out through the IGW and anything for the corporate network through the VGW
- Ingress routing allows to assign route tables to gateways (Gateway route tables). **Gateway route tables** can be attached to internet gateways or virtual gateways and can be used to take action on inbound traffic (route to a security instance for assessment)
![Ingress Routing](images/AdvancedRouting5.png)

## IPv6 Capability in VPCs

- IPv6 addresses are all publicly routable
- NAT is not used for IPv6, IPv6 does not need network address translation simply because of the huge number of available IPv6 addresses
- IPv6 needs to be manually enabled on a VPC. We can either bring our own IP address in a VPC or utilize an AWS provided range
- In case of AWS provided IPv6 addresses, AWS will allocate an uniq /56 range to the VPC. This range will be entirely uniq and all addresses will be publicly routable
- If we chose to allocate an IP range for a VPC, AWS will use a hex pair to uniquely allocate IP addresses to the subnets
- Routing is handled separately for the IPv6 addresses, we will have IPv4 routes and IPv6 routes
- Egress only internet gateway: similar to NAT gateway, allows outbound traffic denying inbound traffic in case of IPv6 addressing. NAT gateways or instances do not support IPv6!
- Only one internet gateway can be associated with a VPC, but we can have both internet gateway and egress only internet gateway associated to the same VPC. They are 2 different things
![IPv6 Architecture](images/IPv6EOIGW.png)
- IPv6 can be set up while creating a VPC/subnet or we can migrate an existing VPC to IPv6
- We can enable IPv6 on specific subnets only
- We can point IPv6 traffic to internet gateway and egress only internet gateways as well
- Not every service in AWS supports IPv6!

## Advanced VPC Structure - How many AZs for HA?

- The number of AZ required for HA:
    - Buffer AZs: number of AZ-failures tolerated (usually 1 for exam questions)
    - Nominal AZs: the number of AZs we can use for normal operations: the number fo AZs available in a region - Buffer AZs (example: 6 AZs available, failure tolerated is 1 AZ => 6 - 1 = 5)
- Sometimes this calculation can influence which region we can use, since number of AZs can differ per region
- Nominal instances: the number instances required for the application for the business load
- Most efficient HA in with optimal costs: Nominal Instances / Nominal AZs => optimal number of instances per AZ

## Advanced VPC Structure - Subnets and Tiers

- Public subnets can be configured to not give public IP addresses to all instances by default. We can explicitly allocate public IP addresses to some resources
- If no public IP is addressed to a resource in a public subnet, it wont be accessible from the outside
- Security groups: we can restrict inbound traffic by allowing traffic from only selected instances
- How many subnets does an app need:
    - We don't need public and private subnets for addressing and security. This can be configured within one subnet. Exception to this: filter traffic using a NACL
    - We need different subnets for different routing
    - Internet-facing load balancers can communicates with private instances. Internet facing load balancer needs to run in a public subnet
    - Number of subnets needed: number of subnets needed for the APP * AZs
    - NAT Gateway: we cannot have the NAT Gateway in the same subnet in which we would want the resources to also use it. Reason: we cannot have 2 default routes in the Route Table


# VPNs

# IPSEC VPN Fundamentals

- IPSEC is a group of protocols
- Their aim is to set up secure tunnels across insecure networks. Example: connect two secure networks (peers) over the public internet
- IPSEC provides authentication
- Any traffic transferred through IPSEC is encrypted
- IPSEC is using asymmetric encryption to exchange symmetric keys and use these of ongoing encryption
- IPSEC has 2 main phases:
    - IKE (Internet Key Exchange) Phase 1
        - It is slow and heavy
        - It is a protocol of how keys are exchanged
        - It has 2 versions v1 (older) and v2 (newer)
        - Uses asymmetric encryption to agree on and create a shared symmetric key
        - The end of this phase is an IKE SA (security association) phase 1 tunnel
        ![IPSEC phase 1 architecture](images/IPSECvpn2.png)
    - IKE Phase 2
        - It is faster and more agile
        - Uses the keys agreed in phase 1
        - Is concerned with agreeing on encryption method and keys used for bulk data transfer
        - The end result is an IPSEC SA phase 2 tunnel (runs over phase 1)
        ![IPSEC phase 2 architecture](images/IPSECvpn3.png)
- There are two types of VPNs - how they match traffic:
    - Policy based VPNs: rule sets match traffic, we can have different rules for different types of traffic
    - Route based VPNs: target matching is done based on prefix. We have a single pair of security associations for each network prefix (less functionality, much simpler to set up)
    ![Route vs Policy Based VPNs](images/IPSECvpn4.png)

## AWS Site-to-Site VPN

- A Site-to-Site VPN is a logical connections between a VPC and an on-premise network running over the public internet. The connection is encrypted using IPSec
- Can be fully HA if it is implemented correctly
- It is quick to provision, it can be provisioned in less than an hour (contrast to DX)
- Components involved in creating a VPN connection:
    - **VPC**
    - **Virtual Private Gateway (VGW)**: it is a gateway object which can be the target of one or more rules in a Route Tables. It can be associated to a single VPC
    - **Customer Gateway (CGW)**: can refer to 2 different things:
        - Often is referred to the logical configuration in AWS
        - Physical on-premises router which the VPN connects to
    - **VPN Connection** itself: the connection linking the VGW from the AWS to the CGW
- Static vs Dynamic VPN:
    - **Static VPN**:
        - Uses static network configuration: static routes are added to the route tables AWS side, static networks has to be identified on the VPN connection on-premise side. 
        - It is simple, it just uses IPSec, works anywhere, having limitation on terms of load-balancing and multi-connection failover
    - **Dynamic VPN**:
        - Uses BGP protocol, if customer router does not support BGP, we can not use dynamic VPNs
        - BGP: allows routing on the fly, allows multiple links to be used at once between the same locations. Allows using HA available architectures
        - Static routes can still be added to the route tables manually
        - Route propagation: if enabled means that routes are added ro the Route Table automatically
- Considerations for VPN:
    - Speed Limitation for VPN with 2 tunnels: *1.25 Gbps*, AWS limitation. Customer router limitation might also apply
    - Latency considerations: can be inconsistent if the traffic goes through the public internet
    - Cost: hourly cost for outgoing traffic, on-premises data caps might also apply
    - Speed of setup: can done very quickly, within hours or less; IPSec is supported by a wide variety of devices, BGP support is less common. VPNs are always quicker to setup then any other private connection technologies
    - VPNs can be used for Direct Connect backup or they can be used over the Direct Connect for adding a layer of encryption

### Accelerated Site-to-Site VPN

- Performance enhancement for AWS Site-to-Site VPN that uses the AWS global network, the same network used for Global Accelerator and CloudFront
- Using a classic Site-to-Site VPN, the traffic goes through the public internet. In order to avoid this, some companies use a Site-to-Site VPN over Direct Connect. Direct Connect offers more better performance, but at a higher cost. Since DX is not an option for everybody, accelerated Site-to-Site VPN was created to improve performance compared to classic Site-to-Site VPNs
- Accelerated Site-to-Site VPN architecture:
![Accelerated Site-to-Site VPN](images/AcceleratedS2SVPN1.png)
- Acceleration can be enabled when creating a Transit Gateway attachment only! Not compatible with VPNs using Virtual Private Gateways (VGW)
- Accelerated Site-to-Site VPN has a fixed accelerator cost fee and a data transfer fee

## Client VPN

- Site-to-Site VPN is generally used for one or more business premisses to connect to AWS VPCs. ClientVPN is similar, but instead of sites connecting to AWS, we have individual clients
- A ClientVPN is a managed implementation of OpenVPN
- Any client device which can use the OpenVPN software is supported
- Architecturally we connect to a Client VPN endpoint which can be associated with one VPC and with one ore more Target Networks (high availability)
- Client VPN billing is based on network association and hourly fee for usage
- Client VPN setup:
    - We crate a Client VPN Endpoint and associate it with a VPC and one or more subnets from the VPC
    - This association places an ENI into the subnets associated
    - We can only pick one subnet per AZ
- Client VPN can use many different methods of authentication (certificates, Cognito User Pool, Federated Identities,  AWS Directory Service)
- We associate a route table to the Client VPN Endpoint in order to set up routing and connectivity (to internet via NAT Gateways, other VPCs with peering, etc.)
- This route table is pushed to any client which connects to the Client VPN Endpoint
- The default behavior is the Client VPN route table replaces any local routes on the client, meaning the client devices can not access anything locally on their local network without having communication going through the Client VPN Endpoint
- We can use split tunnel VPN, meaning that any routes from the Client VPN Endpoint are added to local client route tables. This solves the problem with the default behavior
- Split tunnel is not the default behavior. It must be enabled by the user, otherwise all the data (including connection to the public internet) will go via the tunnel

# Amazon Workspaces

- Managed desktop as a service product (DAAS) - dedicated virtual Windows/Linux desktop delivered as a managed service
- Ideal for home working
- Similar to Citrix/Remote Desktop - hosted within AWS
- It provides a consistent desktop accessible from anywhere, we can log off and log back in from different places, applications maintaining their state
- We can have Windows and Linux workspaces in various sizes
- We can use commercial applications on the workspaces
- Workspaces can be charged on monthly or hourly basis. There is an additional monthly infrastructure cost, which is applied even in case when we are billed hourly
- Workspaces use Directory Service (Simple, AD, AD Connector) for authentication and user management
- Each workspace uses an ENI (Elastic Network Interface) injected in a VPC
- Workspaces are accessed using client software from desktop/laptop, bandwidth is included free of charge. For any other internet access from the workspaces normal VPC infrastructure is used and charged accordingly
- Windows workspaces can access FSx and EC2 windows resources
- Any existing hybrid network can be also utilized for accessing on-premise resources
- Workspaces provide a system volume and an user volume, both can be encrypted

## Workspaces Architecture

![Workspaces Architecture](images/AmazonWorkspaces.png)

- Workspaces inject an ENI into customer managed VPCs, they run into AWS managed VPCs
- Directory services also inject ENIs into customer managed VPCs for file access, etc.
- Workspaces are not highly available by design
- We can distribute workspaces in different AZs, but a single workspace in particular can be affected by an AZ failure


# AWS X-Ray

- It is a distributed tracing application. It designed to track sessions through an application
- X-Ray takes data from many services (API Gateway, Lambda, DynamoDB) as part of an application and gives on single overview of the session flow
- Fundamental concepts of X-Ray:
    - **Tracing Header**: when an user connects to an application with X-Ray enabled, a **tracing ID** is generated an embedded into a tracing header. This header is used to track the request across all supported services
    - **Segments**: supported services send data to X-Ray using segments. Segments are data blocks containing host/ip, request, response, work done (times), issues information
    - **Subsegments**: segments can contain subsegments for more granularity. This can contain details to other services as part of the application component
    - **Service Graph**: JSON document detailing services and resources which make up the application
    - **Service Map**: visual representation of a service graph by the X-Ray console
- In order to provide X-Ray data to the AWS X-Ray service we can do the following:
    - EC2: install X-Ray Agent
    - ECS: agent is installed in any task
    - Lambda: enable X-Ray
    - Beanstalk: agent is preinstalled
    - API Gateway: can be enabled per stage option
    - SNS and SQS: can be enabled
- Services require IAM permission in order ot send data to X-Ray service