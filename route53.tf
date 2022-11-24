
# create a route53 record for the cloudfront distribution
resource "aws_route53_record" "s3_distribution" {
  count   = length(var.s3_buckets)
  zone_id = aws_route53_zone.s3_distribution.zone_id
  name    = "${var.s3_buckets[count.index]}.${aws_route53_zone.s3_distribution.zone_id}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution[count.index].domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution[count.index].hosted_zone_id
    evaluate_target_health = false
  }
}

# create a route53 zone for the cloudfront distribution
resource "aws_route53_zone" "s3_distribution" {
  name = var.domain_name
}