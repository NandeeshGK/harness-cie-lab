module "platform" {
  source  = "app.harness.io/Nqvj4rBDR2KoKrjGhauyVg/cloudaws/aws"
  version = "2.0.1"

  # ---- Required ----
  org_id     = "default"
  project_id = "platform_demo"

  # ---- Create vs. reuse a project ----
  create_project = true                 # default false; if false, project_id must exist
  project_name   = "Platform Demo"      # display name when creating

  # ---- Cloud connector (AWS OIDC) ----
  create_cloud_connector     = true     # default true
  cloud_connector_identifier = "aws_oidc"
  cloud_connector_name       = "AWS OIDC Connector"
  iam_role_arn               = "arn:aws:iam::<YOUR_ACCT_ID>:role/<your-oidc-role>"  # OVERRIDE the demo default
  cloud_region               = "us-east-1"
  execute_on_delegate        = false
  delegate_selectors         = []       # set if execute_on_delegate = true / OIDC inheritance
  cloud_connector_tags       = ["env:demo"]

  # If reusing an existing connector instead:
  # create_cloud_connector = false
  # cloud_connector_ref    = "existing_connector_id"

  # ---- CD stack (service + envs + infra) ----
  create_cd_stack    = true
  deployment_type    = "ECS"
  service_identifier = "platform_service"
  service_name       = "Platform Service"

  service_definition_manifest_path = "/platform/service-definition.json"
  task_definition_manifest_path    = "/platform/task-definition.json"

  # ---- Environments (override the default dev/stage/testing/prod map as needed) ----
  environments = {
    dev = {
      name    = "Dev"
      type    = "PreProduction"
      cluster = "dev-cluster"
    }
    prod = {
      name    = "Prod"
      type    = "Production"
      cluster = "prod-cluster"
    }
  }

  # Per-environment cluster overrides (alternative to setting cluster inline above)
  create_infra_overrides = false
  # ---- Tags (tags merged over default_tags; same key wins) ----
  default_tags = { team = "platform" }
  tags         = { owner = "you", costcenter = "1234" }

  # ---- Cloud API retry tuning (optional) ----
  fixed_backoff = 2000   # ms; leave null to omit
  retry_count   = 3      # only used when fixed_backoff is set
