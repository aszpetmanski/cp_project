# AWS S3 Bucket and CloudFront Distribution Terraform Configuration

## Description
This Terraform script sets up an AWS S3 bucket with secure configurations, applies server-side encryption, enables versioning, and establishes a CloudFront distribution to serve content from the S3 bucket securely.

## Prerequisites
- [Terraform](https://www.terraform.io/downloads.html) installed (version 0.12 or later)
- AWS credentials properly configured (in ENV variables preferably)

## Installation
1. Clone the repository:
    ```bash
    git clone https://github.com/aszpetmanski/cp_project.git
    cd terraform-aws-s3-cloudfront
    ```

2. Initialize Terraform:
    ```bash
    terraform init
    ```

3. Adjust Configuration:
    - Modify the `variables.tf` file to suit your preferences or requirements (if needed).
    - Update the `index.html` file with your desired content.

4. Deploy the infrastructure:
    ```bash
    terraform apply
    ```

5. Verify the setup in the AWS Management Console.

## Usage
This Terraform script creates:
- An S3 bucket (`aws_s3_bucket.site_origin`) with server-side encryption, versioning enabled, and public access blocked.
- An AWS S3 object (`aws_s3_object.content`) containing the `index.html` file from the local directory.
- A CloudFront distribution (`aws_cloudfront_distribution.site_access`) serving content from the S3 bucket.

### Accessing the Website
Once the setup is complete, you can access your website using the CloudFront domain name provided in the output.

Example:
- Website URL: `https://your-cloudfront-domain-name.com`

## Output
After successful deployment, Terraform concole output will provide the URL to access the website.

