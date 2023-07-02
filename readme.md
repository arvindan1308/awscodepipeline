![CALL](https://github.com/arvindan1308/awscodepipeline/assets/52846982/5e771b02-a79f-4d84-aeb8-a14082e0258d)

## Prerequisite
1. Terraform
2. AWS cli 
3. Docker 
4. Node 

## Creating docker image for the source code 
1. Create a Dockerfile in the source code directory 
2. Then run 'docker build -t <imagename>:<tag> . '
3. Once the image is created, run 'docker run -it -p <port> <image id>'
4. open the browser and run 'http://localhost:<port>'
5. Push the code to the git repository

## Create terraform file 
1. Create 'main.tf' file for writing the code and 'variable.tf' for storing the security details like access key and secret key
2. Using terraform, we are going to create ECR, Codepipeline,s3 bucket and codebuild.
3. After that run, 'terraform init' to initialize the process, 'terraform validate' to validate the code and finally 'terraform apply' for applying the changes.
4. Once the Amazon Elastic Container Registry (ECR) is created, push the image into the repository by running the .sh file which is given
6. After that, once the codepipeline is build it will start to work automatically and any changes in the git repo it will execute after that without doing manually.
