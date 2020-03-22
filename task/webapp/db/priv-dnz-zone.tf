resource "aws_route53_zone" "priv_dns_zone" {
  name = "task.int"
  comment = "Private hosted zone for the task, managed by Terraform"

  vpc {
    vpc_id = var.vpc_id
  }
}

resource "aws_route53_record" "dns_rec_for_db" {
  zone_id = aws_route53_zone.priv_dns_zone.zone_id
  name    = "db.task.int"
  type    = "A"
  ttl     = "300"
  records = [trimsuffix(aws_db_instance.my-db.endpoint, ":3306")]
}