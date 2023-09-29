resource "aws_iam_role" "md_eb_role_dev_uswest2" {
  name = "md_eb_role_dev_uswest2"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "md_eb_policy_AWSElasticBeanstalkService_dev_uswest2" {
  name       = "elastic-beanstalk-service"
  roles      = ["${aws_iam_role.md_eb_role_dev_uswest2.id}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
}

resource "aws_iam_policy_attachment" "md_eb_policy_AWSElasticBeanstalkEnhancedHealth_dev_uswest2" {
  name       = "elastic-beanstalk-service-health"
  roles      = ["${aws_iam_role.md_eb_role_dev_uswest2.id}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
}

resource "aws_iam_policy_attachment" "md_eb_policy_AWSElasticBeanstalkWorkerTier_dev_uswest2" {
  name       = "elastic-beanstalk-ec2-worker"
  roles      = ["${aws_iam_role.md_eb_role_dev_uswest2.id}"]
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
}

resource "aws_iam_policy_attachment" "md_eb_policy_AWSElasticBeanstalkWebTier_dev_uswest2" {
  name       = "elastic-beanstalk-ec2-web"
  roles      = ["${aws_iam_role.md_eb_role_dev_uswest2.id}"]
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_policy_attachment" "md_eb_policy_AWSElasticBeanstalkMulticontainerDocker_dev_uswest2" {
  name       = "elastic-beanstalk-ec2-container"
  roles      = ["${aws_iam_role.md_eb_role_dev_uswest2.id}"]
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
}

resource "aws_iam_instance_profile" "md_ec2_profile_dev_uswest2" {
  name = "md_eb_profile_dev_uswest2"
  role = aws_iam_role.md_eb_role_dev_uswest2.name
}
