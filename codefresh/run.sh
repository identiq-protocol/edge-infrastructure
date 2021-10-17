#!/bin/bash
echo "terraform {"
echo "  backend \"s3\" {"
echo "    region  = \"us-east-1\""
echo "    bucket  = \"identiq-production-terraform\""
echo "    key     = \"dev/aws/edge-infrastructure/$(pwd)\""
echo "    encrypt = \"true\""
echo "  }"
echo "}"
