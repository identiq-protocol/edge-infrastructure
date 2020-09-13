# Freud in AWS batch

### Deploy Template
1. Sign in to AWS Console and navigate to cloud formation deploy cloudformation from edge-infrastructure/verification-tool/cloudformation/batch.yaml
2. Fill in the variable according to their description in the template.
3. Wait 15 minutes for the template to deploy and the compute environment to finish starting.
4. Submit a job from AWS Batch -> Jobs -> Submit a job. 
    * Name it: IdentiqFreud1
    * Job definition: IdentiqFreudJobDef:1 
    * Job queue field choose: IdentiqFreudJobQueue
    * Compute environment field choose: IdentiqFreudComputeEnv
