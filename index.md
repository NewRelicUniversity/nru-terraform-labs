# Prerequisites

To complete these labs, you will need: 
- A personal New Relic account. If you don’t have one, you may sign up for a free account here: [https://newrelic.com/signup](https://newrelic.com/signup). 
- A personal [Github account](https://github.com).

# Start the lab environment and configure the New Relic Terraform provider

## Step 1
Log into your Github account and navigate to [https://github.com/codespaces](https://github.com/codespaces). Click the New codespace button in the upper right corner.

## Step 2
On the Create a new codespace page, click _Select a repository_ and search for **NewRelicUniversity/nru-terraform-labs**. Click the _Create codespace_ button at the bottom of the page.

## Step 3
In your New Relic account, copy a USER key from the [API keys](https://one.newrelic.com/launcher/api-keys-ui.api-keys-launcher) page. If there are no USER keys, click the _Create a key_ button in the upper right to create one, then copy it.

## Step 4
In your codespace, select the **variables.tf** tab and replace the api_key XXXXXX placeholder with the value you copied in Step 1.

## Step 5
Back in New Relic, [locate your account ID](https://docs.newrelic.com/docs/accounts/accounts-billing/account-structure/account-id/) and copy it.

## Step 6
In your codespace, select the **variables.tf** tab and replace the account_id XXXXXX placeholder with the value you copied in Step 3.

## Step 7
If your account is based in the EU, change the default region in **variables.tf** to **EU**.

## Step 8
Initialize Terraform by entering the following command in the terminal: `terraform init`. You'll receive a success message when Terraform finishes installing and registering the New Relic provider.

---

# _Lab:_ Using Terraform to create an alert condition and policy

## Step 1
In your codespace, select the **main.tf** file and position the cursor at the end of the file. Paste the following code to create a New Relic application entity:
```
data "newrelic_entity" "my_app" {
  name = "Your App Name"    # Must be an exact match to your application name in New Relic
  domain = "APM"            # or BROWSER, INFRA, MOBILE, SYNTH, depending on your entity's domain
  type = "APPLICATION"
}
```

## Step 2
Paste the following code at the end of **main.tf** to create a `newrelic_alert_policy`, giving the policy a dynamic name based on your application’s name:
```
resource "newrelic_alert_policy" "golden_signal_policy" {
  name = "Golden Signals - ${data.newrelic_entity.my_app.name}"
}
```

## Step 3
Paste the following code at the end of **main.tf** to add an alert condition to your policy:
```
# Response time - Create Alert Condition
resource "newrelic_nrql_alert_condition" "response_time_alert" {
  policy_id                    = newrelic_alert_policy.golden_signal_policy.id
  type                         = "static"
  name                         = "Response Time - ${data.newrelic_entity.my_app.name}"
  description                  = "High Transaction Response Time"
# runbook_url                  = "https://www.example.com"
  enabled                      = true
  violation_time_limit_seconds = 3600

  nrql {
    query = "SELECT average(apm.service.transaction.duration) * 1000 AS 'Response time (ms)' FROM Metric WHERE entity.guid = '${data.newrelic_entity.my_app.guid}'"
  }

  critical {
    operator              = "above"
    threshold             = 500
    threshold_duration    = 300
    threshold_occurrences = "all"
  }
}
```

## Step 4
Enter the following command in the terminal to preview the changes: `terraform plan`

## Step 5
To apply the changes, enter the following command in the terminal: `terraform apply`

## Step 6
Go back to your New Relic account and confirm that the new alert policy and condition exist there.

## Additional resources
- [Getting started with New Relic and Terraform](https://docs.newrelic.com/docs/more-integrations/terraform/terraform-intro/)
- [New Relic Terraform provider documentation](https://registry.terraform.io/providers/newrelic/newrelic/latest/docs)

---

# TODO: Using Terraform to create dashboards

- [Creating dashboards with Terraform and JSON templates ](https://newrelic.com/blog/how-to-relic/create-nr-dashboards-with-terraform-part-1)
- [Dynamically creating New Relic dashboards with Terraform ](https://newrelic.com/blog/how-to-relic/create-nr-dashboards-with-terraform-part-2)
- [Using Terraform to generate New Relic dashboards from NRQL queries](https://newrelic.com/blog/how-to-relic/create-nr-dashboards-with-terraform-part-3)

---

# TODO: Using Terraform to create Synthetic monitors

[Synthetic monitoring as code](https://newrelic.com/blog/how-to-relic/examples-observability-as-code-part-two#toc-synthetic-monitoring-as-code)
