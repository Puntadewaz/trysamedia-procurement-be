-- +goose Up
CREATE EXTENSION IF NOT EXISTS citext;

CREATE SCHEMA IF NOT EXISTS iam;
CREATE SCHEMA IF NOT EXISTS portfolio;
CREATE SCHEMA IF NOT EXISTS project;
CREATE SCHEMA IF NOT EXISTS financial;
CREATE SCHEMA IF NOT EXISTS forecast;
CREATE SCHEMA IF NOT EXISTS schedule;
CREATE SCHEMA IF NOT EXISTS resource;
CREATE SCHEMA IF NOT EXISTS vendor;
CREATE SCHEMA IF NOT EXISTS risk;
CREATE SCHEMA IF NOT EXISTS issue;
CREATE SCHEMA IF NOT EXISTS change_request;
CREATE SCHEMA IF NOT EXISTS governance;
CREATE SCHEMA IF NOT EXISTS import_engine;
CREATE SCHEMA IF NOT EXISTS analytics;
CREATE SCHEMA IF NOT EXISTS reporting;
CREATE SCHEMA IF NOT EXISTS audit;
CREATE SCHEMA IF NOT EXISTS integration;

CREATE TABLE IF NOT EXISTS iam.tenants (
  id uuid PRIMARY KEY,
  code varchar(50) NOT NULL UNIQUE,
  name varchar(200) NOT NULL,
  status varchar(20) NOT NULL DEFAULT 'active',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  created_by uuid,
  updated_by uuid,
  version bigint NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS iam.users (
  id uuid PRIMARY KEY,
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  email citext NOT NULL,
  full_name varchar(150) NOT NULL,
  password_hash text NOT NULL,
  mfa_enabled boolean NOT NULL DEFAULT false,
  status varchar(20) NOT NULL DEFAULT 'active',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  created_by uuid,
  updated_by uuid,
  version bigint NOT NULL DEFAULT 1,
  UNIQUE(tenant_id, email)
);

CREATE TABLE IF NOT EXISTS iam.roles (
  id uuid PRIMARY KEY,
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  code varchar(50) NOT NULL,
  name varchar(100) NOT NULL,
  is_system boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  created_by uuid,
  updated_by uuid,
  version bigint NOT NULL DEFAULT 1,
  UNIQUE(tenant_id, code)
);

CREATE TABLE IF NOT EXISTS iam.permissions (
  id uuid PRIMARY KEY,
  code varchar(100) NOT NULL UNIQUE,
  resource varchar(50) NOT NULL,
  action varchar(20) NOT NULL,
  description text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS iam.role_permissions (
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  role_id uuid NOT NULL REFERENCES iam.roles(id),
  permission_id uuid NOT NULL REFERENCES iam.permissions(id),
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  PRIMARY KEY(tenant_id, role_id, permission_id)
);

CREATE TABLE IF NOT EXISTS iam.user_roles (
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  user_id uuid NOT NULL REFERENCES iam.users(id),
  role_id uuid NOT NULL REFERENCES iam.roles(id),
  assigned_at timestamptz NOT NULL DEFAULT now(),
  assigned_by uuid,
  PRIMARY KEY(tenant_id, user_id, role_id)
);

CREATE TABLE IF NOT EXISTS iam.refresh_sessions (
  id uuid PRIMARY KEY,
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  user_id uuid NOT NULL REFERENCES iam.users(id),
  token_hash text NOT NULL UNIQUE,
  token_family_id uuid NOT NULL,
  device_id varchar(100),
  ip inet,
  user_agent text,
  expires_at timestamptz NOT NULL,
  revoked_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS iam.mfa_totp (
  id uuid PRIMARY KEY,
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  user_id uuid NOT NULL REFERENCES iam.users(id),
  secret_enc text NOT NULL,
  recovery_codes_enc text,
  enabled_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE(tenant_id, user_id)
);

CREATE TABLE IF NOT EXISTS portfolio.portfolios (
  id uuid PRIMARY KEY,
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  code varchar(40) NOT NULL,
  name varchar(200) NOT NULL,
  owner_user_id uuid REFERENCES iam.users(id),
  status varchar(20) NOT NULL DEFAULT 'active',
  start_date date,
  end_date date,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  created_by uuid,
  updated_by uuid,
  version bigint NOT NULL DEFAULT 1,
  UNIQUE(tenant_id, code)
);

CREATE TABLE IF NOT EXISTS portfolio.portfolio_members (
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  portfolio_id uuid NOT NULL REFERENCES portfolio.portfolios(id),
  user_id uuid NOT NULL REFERENCES iam.users(id),
  member_role varchar(30) NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  PRIMARY KEY(tenant_id, portfolio_id, user_id)
);

CREATE TABLE IF NOT EXISTS project.projects (
  id uuid PRIMARY KEY,
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  portfolio_id uuid NOT NULL REFERENCES portfolio.portfolios(id),
  code varchar(50) NOT NULL,
  name varchar(250) NOT NULL,
  status varchar(20) NOT NULL DEFAULT 'draft',
  manager_user_id uuid REFERENCES iam.users(id),
  sponsor_user_id uuid REFERENCES iam.users(id),
  planned_start date,
  planned_end date,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  created_by uuid,
  updated_by uuid,
  version bigint NOT NULL DEFAULT 1,
  UNIQUE(tenant_id, code)
);

CREATE TABLE IF NOT EXISTS project.project_members (
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  project_id uuid NOT NULL REFERENCES project.projects(id),
  user_id uuid NOT NULL REFERENCES iam.users(id),
  project_role varchar(30) NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  PRIMARY KEY(tenant_id, project_id, user_id)
);

CREATE TABLE IF NOT EXISTS project.project_milestones (
  id uuid PRIMARY KEY,
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  project_id uuid NOT NULL REFERENCES project.projects(id),
  name varchar(150) NOT NULL,
  due_date date,
  status varchar(20) NOT NULL DEFAULT 'planned',
  progress numeric(5,2) NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  created_by uuid,
  updated_by uuid,
  version bigint NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS project.work_packages (
  id uuid PRIMARY KEY,
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  project_id uuid NOT NULL REFERENCES project.projects(id),
  code varchar(40) NOT NULL,
  name varchar(180) NOT NULL,
  owner_user_id uuid REFERENCES iam.users(id),
  status varchar(20) NOT NULL DEFAULT 'planned',
  start_date date,
  end_date date,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  created_by uuid,
  updated_by uuid,
  version bigint NOT NULL DEFAULT 1,
  UNIQUE(tenant_id, project_id, code)
);

CREATE TABLE IF NOT EXISTS financial.project_financials (
  id uuid PRIMARY KEY,
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  project_id uuid NOT NULL REFERENCES project.projects(id),
  as_of_date date NOT NULL,
  currency char(3) NOT NULL,
  budget_total numeric(18,2) NOT NULL DEFAULT 0,
  forecast_total numeric(18,2) NOT NULL DEFAULT 0,
  actual_total numeric(18,2) NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  created_by uuid,
  updated_by uuid,
  version bigint NOT NULL DEFAULT 1,
  UNIQUE(tenant_id, project_id, as_of_date)
);

CREATE TABLE IF NOT EXISTS financial.project_costs (
  id uuid PRIMARY KEY,
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  project_id uuid NOT NULL REFERENCES project.projects(id),
  cost_type varchar(40) NOT NULL,
  amount numeric(18,2) NOT NULL CHECK (amount >= 0),
  cost_date date NOT NULL,
  source_ref varchar(100),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  created_by uuid,
  updated_by uuid,
  version bigint NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS financial.budget_baselines (
  id uuid PRIMARY KEY,
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  project_id uuid NOT NULL REFERENCES project.projects(id),
  baseline_version integer NOT NULL,
  amount numeric(18,2) NOT NULL CHECK (amount >= 0),
  approved_by uuid REFERENCES iam.users(id),
  approved_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  created_by uuid,
  updated_by uuid,
  version bigint NOT NULL DEFAULT 1,
  UNIQUE(tenant_id, project_id, baseline_version)
);

CREATE TABLE IF NOT EXISTS forecast.forecast_snapshots (
  id uuid PRIMARY KEY,
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  project_id uuid NOT NULL REFERENCES project.projects(id),
  scenario varchar(30) NOT NULL,
  forecast_date date NOT NULL,
  forecast_amount numeric(18,2) NOT NULL CHECK (forecast_amount >= 0),
  confidence numeric(5,2) NOT NULL DEFAULT 0 CHECK (confidence >= 0 AND confidence <= 100),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  created_by uuid,
  updated_by uuid,
  version bigint NOT NULL DEFAULT 1,
  UNIQUE(tenant_id, project_id, scenario, forecast_date)
);

CREATE TABLE IF NOT EXISTS schedule.baseline_schedules (
  id uuid PRIMARY KEY,
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  project_id uuid NOT NULL REFERENCES project.projects(id),
  baseline_version integer NOT NULL,
  baseline_start date,
  baseline_end date,
  approved_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  created_by uuid,
  updated_by uuid,
  version bigint NOT NULL DEFAULT 1,
  UNIQUE(tenant_id, project_id, baseline_version)
);

CREATE TABLE IF NOT EXISTS schedule.project_schedule_snapshots (
  id uuid PRIMARY KEY,
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  project_id uuid NOT NULL REFERENCES project.projects(id),
  snapshot_date date NOT NULL,
  planned_progress numeric(5,2) NOT NULL DEFAULT 0,
  actual_progress numeric(5,2) NOT NULL DEFAULT 0,
  variance_days integer NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  created_by uuid,
  updated_by uuid,
  version bigint NOT NULL DEFAULT 1,
  UNIQUE(tenant_id, project_id, snapshot_date)
);

CREATE TABLE IF NOT EXISTS resource.resources (
  id uuid PRIMARY KEY,
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  employee_code varchar(50) NOT NULL,
  full_name varchar(150) NOT NULL,
  role_title varchar(100) NOT NULL,
  manager_user_id uuid REFERENCES iam.users(id),
  active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  created_by uuid,
  updated_by uuid,
  version bigint NOT NULL DEFAULT 1,
  UNIQUE(tenant_id, employee_code)
);

CREATE TABLE IF NOT EXISTS resource.resource_capacity (
  id uuid PRIMARY KEY,
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  resource_id uuid NOT NULL REFERENCES resource.resources(id),
  period_month date NOT NULL,
  capacity_hours numeric(10,2) NOT NULL DEFAULT 0,
  available_hours numeric(10,2) NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  created_by uuid,
  updated_by uuid,
  version bigint NOT NULL DEFAULT 1,
  UNIQUE(tenant_id, resource_id, period_month)
);

CREATE TABLE IF NOT EXISTS resource.resource_allocations (
  id uuid PRIMARY KEY,
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  resource_id uuid NOT NULL REFERENCES resource.resources(id),
  project_id uuid NOT NULL REFERENCES project.projects(id),
  period_month date NOT NULL,
  allocation_percent numeric(5,2) NOT NULL CHECK (allocation_percent >= 0 AND allocation_percent <= 100),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  created_by uuid,
  updated_by uuid,
  version bigint NOT NULL DEFAULT 1,
  UNIQUE(tenant_id, resource_id, project_id, period_month)
);

CREATE TABLE IF NOT EXISTS vendor.vendors (
  id uuid PRIMARY KEY,
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  code varchar(40) NOT NULL,
  name varchar(200) NOT NULL,
  category varchar(80),
  status varchar(20) NOT NULL DEFAULT 'active',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  created_by uuid,
  updated_by uuid,
  version bigint NOT NULL DEFAULT 1,
  UNIQUE(tenant_id, code)
);

CREATE TABLE IF NOT EXISTS vendor.contracts (
  id uuid PRIMARY KEY,
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  vendor_id uuid NOT NULL REFERENCES vendor.vendors(id),
  contract_no varchar(60) NOT NULL,
  start_date date,
  end_date date,
  contract_value numeric(18,2) NOT NULL DEFAULT 0 CHECK (contract_value >= 0),
  status varchar(20) NOT NULL DEFAULT 'active',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  created_by uuid,
  updated_by uuid,
  version bigint NOT NULL DEFAULT 1,
  UNIQUE(tenant_id, vendor_id, contract_no)
);

CREATE TABLE IF NOT EXISTS vendor.vendor_performance (
  id uuid PRIMARY KEY,
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  vendor_id uuid NOT NULL REFERENCES vendor.vendors(id),
  period_month date NOT NULL,
  kpi_code varchar(40) NOT NULL,
  score numeric(6,2) NOT NULL CHECK (score >= 0),
  remarks text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  created_by uuid,
  updated_by uuid,
  version bigint NOT NULL DEFAULT 1,
  UNIQUE(tenant_id, vendor_id, period_month, kpi_code)
);

CREATE TABLE IF NOT EXISTS risk.risks (
  id uuid PRIMARY KEY,
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  project_id uuid NOT NULL REFERENCES project.projects(id),
  code varchar(40) NOT NULL,
  title varchar(250) NOT NULL,
  likelihood integer NOT NULL CHECK (likelihood BETWEEN 1 AND 5),
  impact integer NOT NULL CHECK (impact BETWEEN 1 AND 5),
  score integer NOT NULL CHECK (score BETWEEN 1 AND 25),
  status varchar(20) NOT NULL DEFAULT 'open',
  owner_user_id uuid REFERENCES iam.users(id),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  created_by uuid,
  updated_by uuid,
  version bigint NOT NULL DEFAULT 1,
  UNIQUE(tenant_id, project_id, code)
);

CREATE TABLE IF NOT EXISTS risk.risk_mitigations (
  id uuid PRIMARY KEY,
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  risk_id uuid NOT NULL REFERENCES risk.risks(id),
  action_plan text NOT NULL,
  owner_user_id uuid REFERENCES iam.users(id),
  due_date date,
  status varchar(20) NOT NULL DEFAULT 'open',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  created_by uuid,
  updated_by uuid,
  version bigint NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS issue.issues (
  id uuid PRIMARY KEY,
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  project_id uuid NOT NULL REFERENCES project.projects(id),
  code varchar(40) NOT NULL,
  title varchar(250) NOT NULL,
  severity varchar(20) NOT NULL,
  status varchar(20) NOT NULL DEFAULT 'open',
  assigned_to uuid REFERENCES iam.users(id),
  raised_at timestamptz NOT NULL DEFAULT now(),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  created_by uuid,
  updated_by uuid,
  version bigint NOT NULL DEFAULT 1,
  UNIQUE(tenant_id, project_id, code)
);

CREATE TABLE IF NOT EXISTS change_request.change_requests (
  id uuid PRIMARY KEY,
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  project_id uuid NOT NULL REFERENCES project.projects(id),
  code varchar(40) NOT NULL,
  change_type varchar(30) NOT NULL,
  requested_by uuid REFERENCES iam.users(id),
  requested_at timestamptz NOT NULL DEFAULT now(),
  status varchar(20) NOT NULL DEFAULT 'submitted',
  impact_cost numeric(18,2) NOT NULL DEFAULT 0,
  impact_days integer NOT NULL DEFAULT 0,
  description text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  created_by uuid,
  updated_by uuid,
  version bigint NOT NULL DEFAULT 1,
  UNIQUE(tenant_id, project_id, code)
);

CREATE TABLE IF NOT EXISTS governance.governance_reviews (
  id uuid PRIMARY KEY,
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  project_id uuid NOT NULL REFERENCES project.projects(id),
  review_date date NOT NULL,
  reviewer_user_id uuid REFERENCES iam.users(id),
  outcome varchar(20) NOT NULL,
  notes text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  created_by uuid,
  updated_by uuid,
  version bigint NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS governance.review_findings (
  id uuid PRIMARY KEY,
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  review_id uuid NOT NULL REFERENCES governance.governance_reviews(id),
  finding_type varchar(40) NOT NULL,
  severity varchar(20) NOT NULL,
  description text NOT NULL,
  recommendation text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  created_by uuid,
  updated_by uuid,
  version bigint NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS import_engine.import_jobs (
  id uuid PRIMARY KEY,
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  source_type varchar(20) NOT NULL,
  file_name varchar(255) NOT NULL,
  file_checksum varchar(128) NOT NULL,
  status varchar(20) NOT NULL DEFAULT 'queued',
  submitted_by uuid REFERENCES iam.users(id),
  submitted_at timestamptz NOT NULL DEFAULT now(),
  started_at timestamptz,
  completed_at timestamptz,
  retry_count integer NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  created_by uuid,
  updated_by uuid,
  version bigint NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS import_engine.import_templates (
  id uuid PRIMARY KEY,
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  domain varchar(40) NOT NULL,
  template_name varchar(120) NOT NULL,
  version integer NOT NULL,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  created_by uuid,
  updated_by uuid,
  version_lock bigint NOT NULL DEFAULT 1,
  UNIQUE(tenant_id, domain, version)
);

CREATE TABLE IF NOT EXISTS import_engine.import_mappings (
  id uuid PRIMARY KEY,
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  template_id uuid NOT NULL REFERENCES import_engine.import_templates(id),
  source_column varchar(120) NOT NULL,
  target_field varchar(120) NOT NULL,
  transform_rule text,
  required boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  created_by uuid,
  updated_by uuid,
  version bigint NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS import_engine.import_staging_rows (
  id bigserial PRIMARY KEY,
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  job_id uuid NOT NULL REFERENCES import_engine.import_jobs(id),
  row_number integer NOT NULL,
  payload jsonb NOT NULL,
  normalized jsonb,
  row_status varchar(20) NOT NULL DEFAULT 'pending',
  dedupe_key varchar(128),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE(tenant_id, job_id, row_number)
);

CREATE TABLE IF NOT EXISTS import_engine.import_errors (
  id uuid PRIMARY KEY,
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  job_id uuid NOT NULL REFERENCES import_engine.import_jobs(id),
  row_number integer NOT NULL,
  field_name varchar(120),
  error_code varchar(60) NOT NULL,
  error_message text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS analytics.portfolio_summary (
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  as_of_date date NOT NULL,
  portfolio_id uuid NOT NULL REFERENCES portfolio.portfolios(id),
  project_count integer NOT NULL DEFAULT 0,
  health_score numeric(6,2) NOT NULL DEFAULT 0,
  budget_variance numeric(18,2) NOT NULL DEFAULT 0,
  risk_count integer NOT NULL DEFAULT 0,
  refreshed_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY(tenant_id, as_of_date, portfolio_id)
);

CREATE TABLE IF NOT EXISTS analytics.project_summary (
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  as_of_date date NOT NULL,
  project_id uuid NOT NULL REFERENCES project.projects(id),
  spi numeric(6,2) NOT NULL DEFAULT 0,
  cpi numeric(6,2) NOT NULL DEFAULT 0,
  progress numeric(5,2) NOT NULL DEFAULT 0,
  status varchar(20) NOT NULL DEFAULT 'unknown',
  refreshed_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY(tenant_id, as_of_date, project_id)
);

CREATE TABLE IF NOT EXISTS analytics.financial_summary (
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  as_of_date date NOT NULL,
  project_id uuid NOT NULL REFERENCES project.projects(id),
  budget numeric(18,2) NOT NULL DEFAULT 0,
  actual numeric(18,2) NOT NULL DEFAULT 0,
  forecast numeric(18,2) NOT NULL DEFAULT 0,
  variance numeric(18,2) NOT NULL DEFAULT 0,
  refreshed_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY(tenant_id, as_of_date, project_id)
);

CREATE TABLE IF NOT EXISTS analytics.resource_summary (
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  as_of_date date NOT NULL,
  resource_id uuid NOT NULL REFERENCES resource.resources(id),
  utilization_percent numeric(5,2) NOT NULL DEFAULT 0,
  allocation_percent numeric(5,2) NOT NULL DEFAULT 0,
  refreshed_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY(tenant_id, as_of_date, resource_id)
);

CREATE TABLE IF NOT EXISTS analytics.vendor_summary (
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  as_of_date date NOT NULL,
  vendor_id uuid NOT NULL REFERENCES vendor.vendors(id),
  avg_score numeric(6,2) NOT NULL DEFAULT 0,
  active_contracts integer NOT NULL DEFAULT 0,
  on_time_rate numeric(5,2) NOT NULL DEFAULT 0,
  refreshed_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY(tenant_id, as_of_date, vendor_id)
);

CREATE TABLE IF NOT EXISTS analytics.risk_summary (
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  as_of_date date NOT NULL,
  project_id uuid NOT NULL REFERENCES project.projects(id),
  open_risk_count integer NOT NULL DEFAULT 0,
  high_risk_count integer NOT NULL DEFAULT 0,
  avg_score numeric(6,2) NOT NULL DEFAULT 0,
  refreshed_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY(tenant_id, as_of_date, project_id)
);

CREATE TABLE IF NOT EXISTS analytics.executive_dashboard_snapshots (
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  snapshot_at timestamptz NOT NULL,
  widget_key varchar(80) NOT NULL,
  payload jsonb NOT NULL,
  refresh_version bigint NOT NULL DEFAULT 1,
  PRIMARY KEY(tenant_id, snapshot_at, widget_key)
);

CREATE TABLE IF NOT EXISTS reporting.reports (
  id uuid PRIMARY KEY,
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  name varchar(150) NOT NULL,
  report_type varchar(40) NOT NULL,
  filters jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  created_by uuid,
  updated_by uuid,
  version bigint NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS reporting.report_exports (
  id uuid PRIMARY KEY,
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  report_id uuid NOT NULL REFERENCES reporting.reports(id),
  format varchar(20) NOT NULL,
  storage_url text NOT NULL,
  generated_at timestamptz NOT NULL DEFAULT now(),
  generated_by uuid REFERENCES iam.users(id)
);

CREATE TABLE IF NOT EXISTS audit.audit_logs (
  id bigserial PRIMARY KEY,
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  actor_user_id uuid REFERENCES iam.users(id),
  action varchar(50) NOT NULL,
  object_type varchar(50) NOT NULL,
  object_id uuid,
  before_state jsonb,
  after_state jsonb,
  request_id varchar(64),
  ip inet,
  user_agent text,
  occurred_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS audit.activity_logs (
  id bigserial PRIMARY KEY,
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  actor_user_id uuid REFERENCES iam.users(id),
  module varchar(40) NOT NULL,
  activity varchar(80) NOT NULL,
  metadata jsonb,
  request_id varchar(64),
  occurred_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS integration.integration_connections (
  id uuid PRIMARY KEY,
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  name varchar(120) NOT NULL,
  integration_type varchar(30) NOT NULL,
  config_enc text NOT NULL,
  status varchar(20) NOT NULL DEFAULT 'active',
  last_sync_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  created_by uuid,
  updated_by uuid,
  version bigint NOT NULL DEFAULT 1,
  UNIQUE(tenant_id, name)
);

CREATE TABLE IF NOT EXISTS integration.integration_sync_runs (
  id uuid PRIMARY KEY,
  tenant_id uuid NOT NULL REFERENCES iam.tenants(id),
  connection_id uuid NOT NULL REFERENCES integration.integration_connections(id),
  run_started_at timestamptz NOT NULL DEFAULT now(),
  run_finished_at timestamptz,
  status varchar(20) NOT NULL DEFAULT 'running',
  records_total integer NOT NULL DEFAULT 0,
  records_success integer NOT NULL DEFAULT 0,
  records_failed integer NOT NULL DEFAULT 0,
  error_summary text
);

CREATE INDEX IF NOT EXISTS idx_users_tenant_status ON iam.users (tenant_id, status);
CREATE INDEX IF NOT EXISTS idx_roles_tenant ON iam.roles (tenant_id);
CREATE INDEX IF NOT EXISTS idx_projects_tenant_portfolio_status ON project.projects (tenant_id, portfolio_id, status);
CREATE INDEX IF NOT EXISTS idx_project_financials_tenant_project_date ON financial.project_financials (tenant_id, project_id, as_of_date DESC);
CREATE INDEX IF NOT EXISTS idx_resource_alloc_tenant_proj_period ON resource.resource_allocations (tenant_id, project_id, period_month);
CREATE INDEX IF NOT EXISTS idx_import_jobs_tenant_status_submitted ON import_engine.import_jobs (tenant_id, status, submitted_at DESC);
CREATE INDEX IF NOT EXISTS idx_import_errors_tenant_job_row ON import_engine.import_errors (tenant_id, job_id, row_number);
CREATE INDEX IF NOT EXISTS idx_audit_tenant_occurred ON audit.audit_logs (tenant_id, occurred_at DESC);
CREATE INDEX IF NOT EXISTS idx_exec_snapshots_tenant_snapshot ON analytics.executive_dashboard_snapshots (tenant_id, snapshot_at DESC);
CREATE INDEX IF NOT EXISTS idx_reports_tenant_type ON reporting.reports (tenant_id, report_type, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_staging_rows_tenant_job_status ON import_engine.import_staging_rows (tenant_id, job_id, row_status);
CREATE INDEX IF NOT EXISTS gin_staging_payload ON import_engine.import_staging_rows USING gin(payload);
CREATE INDEX IF NOT EXISTS gin_audit_after_state ON audit.audit_logs USING gin(after_state);

-- +goose Down
DROP SCHEMA IF EXISTS integration CASCADE;
DROP SCHEMA IF EXISTS audit CASCADE;
DROP SCHEMA IF EXISTS reporting CASCADE;
DROP SCHEMA IF EXISTS analytics CASCADE;
DROP SCHEMA IF EXISTS import_engine CASCADE;
DROP SCHEMA IF EXISTS governance CASCADE;
DROP SCHEMA IF EXISTS change_request CASCADE;
DROP SCHEMA IF EXISTS issue CASCADE;
DROP SCHEMA IF EXISTS risk CASCADE;
DROP SCHEMA IF EXISTS vendor CASCADE;
DROP SCHEMA IF EXISTS resource CASCADE;
DROP SCHEMA IF EXISTS schedule CASCADE;
DROP SCHEMA IF EXISTS forecast CASCADE;
DROP SCHEMA IF EXISTS financial CASCADE;
DROP SCHEMA IF EXISTS project CASCADE;
DROP SCHEMA IF EXISTS portfolio CASCADE;
DROP SCHEMA IF EXISTS iam CASCADE;
