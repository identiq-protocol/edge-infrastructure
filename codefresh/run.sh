#!/bin/bash
echo "terraform {" > backend.tf
echo "  backend \"s3\" {" >> backend.tf
echo "    region  = \"us-east-1\"" >> backend.tf
echo "    bucket  = \"identiq-production-terraform\"" >> backend.tf
echo "    key     = \"dev/aws/edge-infrastructure$(pwd)\"" >> backend.tf
echo "    encrypt = \"true\"" >> backend.tf
echo "  }" >> backend.tf
echo "}" >> backend.tf
