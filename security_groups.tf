resource "aws_security_group" "main" {
  count = var.create_security_group ? 1 : 0

  name   = "${var.instance_name}-main"
  vpc_id = var.vpc_id

  tags = var.tags
}

resource "aws_security_group_rule" "ingress" {
  # Cant use for_each here due to https://github.com/hashicorp/terraform/issues/22405. Workaround in issue results in needing multi stage applies.
  count = var.create_security_group ? length(var.ingress_security_group_rules) : 0

  security_group_id = aws_security_group.main[0].id

  description = "Terraform Managed Rule : Ingress : Protocol ${var.ingress_security_group_rules[count.index]["protocol"]} : Port ${var.ingress_security_group_rules[count.index]["from_port"]}-${var.ingress_security_group_rules[count.index]["to_port"]}"

  type      = "ingress"
  from_port = var.ingress_security_group_rules[count.index]["from_port"]
  to_port   = var.ingress_security_group_rules[count.index]["to_port"]
  protocol  = var.ingress_security_group_rules[count.index]["protocol"]

  cidr_blocks              = lookup(var.ingress_security_group_rules[count.index], "cidr_blocks", null)
  source_security_group_id = lookup(var.ingress_security_group_rules[count.index], "source_security_group_id", null)
}

resource "aws_security_group_rule" "egress" {
  # Cant use for_each here due to https://github.com/hashicorp/terraform/issues/22405. Workaround in issue results in needing multi stage applies.
  count = var.create_security_group ? length(var.egress_security_group_rules) : 0

  security_group_id = aws_security_group.main[0].id

  description = "Terraform Managed Rule : Egress : Protocol ${var.egress_security_group_rules[count.index]["protocol"]} : Port ${var.egress_security_group_rules[count.index]["from_port"]}-${var.egress_security_group_rules[count.index]["to_port"]}"

  type      = "egress"
  from_port = var.egress_security_group_rules[count.index]["from_port"]
  to_port   = var.egress_security_group_rules[count.index]["to_port"]
  protocol  = var.egress_security_group_rules[count.index]["protocol"]

  cidr_blocks              = lookup(var.egress_security_group_rules[count.index], "cidr_blocks", null)
  source_security_group_id = lookup(var.egress_security_group_rules[count.index], "source_security_group_id", null)
}
