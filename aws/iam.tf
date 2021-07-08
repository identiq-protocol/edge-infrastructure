resource "aws_iam_policy" "lb_controller_policy" {
  name = "IdentiqAWSLoadBalancerControllerIAMPolicy"
  policy = data.http.iam_policy.body
  depends_on = [data.http.iam_policy]
}

data "http" "iam_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json"
}
