# Configure AWS provider
provider "aws" {
  region = "us-east-1"  # Update with your desired region
  access_key = var.access_key
  secret_key = var.secret_key
}

# Create the ECR repository
resource "aws_ecr_repository" "my_repository" {
  name = "my-docker-repo"  # Replace with your desired repository name
}

# resource "null_resource" "docker_build" {
#   provisioner "local-exec" {
#     command = <<-EOT
#      aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 588933971286.dkr.ecr.us-east-1.amazonaws.com
#      docker build -t testcases:latest .
#      docker tag testcases:latest 588933971286.dkr.ecr.us-east-1.amazonaws.com/my-docker-repo
#      docker push 588933971286.dkr.ecr.us-east-1.amazonaws.com/my-docker-repo
#     EOT
#   }
# }


resource "aws_s3_bucket" "example" {
  bucket = "awscodepipelinesample"
  # Additional bucket configurations as needed
}

resource "aws_codepipeline" "example" {
  name     = "example-pipeline"
  role_arn = aws_iam_role.example.arn

  artifact_store {
    location = "my-bucket"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name            = "SourceAction"
      category        = "Source"
      owner           = "ThirdParty"
      provider        = "GitHub"
      version         = "1"
      output_artifacts = ["SourceOutput"]

      configuration = {
        OAuthToken    = var.github_token
        Owner         = var.github_owner
        Repo          = var.github_repo
        Branch        = var.github_branch
        
      }
    }
  }

  stage {
    name = "Build"

    action {
      name            = "BuildAction"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["SourceOutput"]
      output_artifacts = ["BuildOutput"]

      configuration = {
        ProjectName = aws_codebuild_project.example.name
      }
    }
  }
}

resource "aws_codebuild_project" "example" {
  name       = "example-project"
  description = "Example CodeBuild project"
  service_role = aws_iam_role.codebuild_role.arn
  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:5.0"
    type         = "LINUX_CONTAINER"
  }
  source {
    type = "CODEPIPELINE"
    buildspec = file("buildspec.yml")
  }
}

resource "aws_iam_role" "example" {
  name = "example-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role" "codebuild_role" {
  name = "example-codebuild-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
