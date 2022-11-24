output "cdn_domain" {
    value = "${aws_cloudfront_distribution.s3_distribution.*.domain_name}"
}

output "route53_domain" {
  value = "${aws_route53_record.s3_distribution.*.fqdn}"
}
