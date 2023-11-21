# Terraform-ECS-deploy
## Configuration Files
### provider.tf
 Configure AWS Region: Change your preferred AWS region in the provider.tf file.
### variables.tf
 Variable Names: Change variable names if necessary (optional).
### main.tf
  #### ECS Task Definition:
   Enter your image name in the ecs_task_definition image tag.
   Enter the port number in the ecs_task_definition port mappings tag that the image is using.
  #### Security Group:
   Specify the identical port number from the ecs_task_definition in both the from_port and to_port tags of the security group's ingress.

  #### ECS Service:
   Set the desired count in the ECS service for the number of tasks you want.
 ### Usage
 Clone the repository to your local machine.
  
`git clone <repository-url>`
  
`cd <repository-directory>`

1.Modify the necessary configuration files according to the instructions above.

2.Initialize the Terraform configuration.
  
`terraform init`

3.Review the planned changes.
  
`terraform plan`

4.Apply the changes.
  
`terraform apply -auto-approve`

## NOTES
  Ensure that you have valid AWS credentials configured locally.
  Make sure to review and modify the variables and configurations as needed for your specific deployment.

### Feel free to reach out for any further assistance or customization. Happy deploying!
    
   
    
    

    
    

