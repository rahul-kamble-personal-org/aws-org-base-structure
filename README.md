# AWS First Personal Project

## Infrastructure Components

1. **Virtual Private Cloud (VPC)**
   - Created with DNS support enabled

2. **Internet Gateway**
   - Set up for public internet access

3. **Subnets**
   - Public subnet for internet-facing resources
   - Private subnet for internal resources

4. **Routing**
   - Route tables created for both public and private subnets
   - Subnets associated with their respective route tables

5. **Security**
   - Security group established to manage internal VPC traffic

6. **VPC Endpoints**
   - DynamoDB: For efficient, private access to DynamoDB
   - Lambda: For secure, private access to Lambda functions

7. **Cost Optimization**
   - NAT Gateway setup commented out to reduce costs

## Notes
- The infrastructure is defined using Terraform
- Resource tagging is implemented for better organization and management
- Default tags are merged with resource-specific tags for consistency
