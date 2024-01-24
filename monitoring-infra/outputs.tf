
output "prometheus_dashboard_url" {
  description = "Prometheus instance dashboard"
  value       = "http://${aws_instance.monitoring_instance.public_ip}:9090/graph"
}

output "grafana_dashboard_url" {
  description = "Grafana instance dashboard"
  value       = "http://${aws_instance.monitoring_instance.public_ip}:3000"
}