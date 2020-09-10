# run freud in AWS batch:
1. Deploy cloudformation from edge-infrastructure/verification-tool/cloudformation/batch.yaml
2. Edit launch configuration in user data to add the credentials, larger disk space (1024)
3. Change in autoscaling group to the new launch configuration and terminate the running server
4. Submit a job