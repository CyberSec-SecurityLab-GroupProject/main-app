resource "aws_guardduty_detector" "this" {
  enable = true
}

output "detector_id" {
  value = aws_guardduty_detector.this.id
}
