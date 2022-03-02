
resource "aws_security_group" "worker_group_mgmt_frontend" {
  name_prefix = "worker_group_mgmt_frontend"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "worker_group_mgmt_frontend_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/16"]
  security_group_id = aws_security_group.worker_group_mgmt_frontend
}

resource "aws_security_group" "worker_group_mgmt_backend" {
  name_prefix = "worker_group_mgmt_backend"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "worker_group_mgmt_backend_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/16"]
  security_group_id = aws_security_group.worker_group_mgmt_backend
}

resource "aws_security_group" "all_worker_mgmt" {
  name_prefix = "all_worker_management"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "all_worker_mgmt_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/16"]
  security_group_id = aws_security_group.all_worker_mgmt
}