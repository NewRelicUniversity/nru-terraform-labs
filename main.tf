terraform {
  required_version = "~> 1.0"
  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
    }
  }
}

# New Relic provider
provider "newrelic" {
  account_id = var.account_id
  api_key = var.api_key   # usually prefixed with 'NRAK'
  region = var.region     # Valid regions are US and EU
}
