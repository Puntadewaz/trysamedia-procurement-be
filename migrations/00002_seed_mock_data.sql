-- +goose Up
INSERT INTO iam.tenants (id, code, name, status, created_by, updated_by, version)
VALUES
  ('11111111-1111-1111-1111-111111111111', 'acme', 'Acme Corporation', 'active', NULL, NULL, 1);

INSERT INTO iam.users (id, tenant_id, email, full_name, password_hash, mfa_enabled, status, created_by, updated_by, version)
VALUES
  ('22222222-2222-2222-2222-222222222201', '11111111-1111-1111-1111-111111111111', 'admin@acme.com', 'Super Admin', '$2a$10$WdtYyVOCT1kjJzGg33yEM./7aYEkCSjDyKY05w1yOQdQQ.vk1Zn6S', false, 'active', NULL, NULL, 1),
  ('22222222-2222-2222-2222-222222222202', '11111111-1111-1111-1111-111111111111', 'pmo@acme.com', 'PMO Lead', '$2a$10$WdtYyVOCT1kjJzGg33yEM./7aYEkCSjDyKY05w1yOQdQQ.vk1Zn6S', false, 'active', '22222222-2222-2222-2222-222222222201', '22222222-2222-2222-2222-222222222201', 1),
  ('22222222-2222-2222-2222-222222222203', '11111111-1111-1111-1111-111111111111', 'finance@acme.com', 'Finance Manager', '$2a$10$WdtYyVOCT1kjJzGg33yEM./7aYEkCSjDyKY05w1yOQdQQ.vk1Zn6S', false, 'active', '22222222-2222-2222-2222-222222222201', '22222222-2222-2222-2222-222222222201', 1),
  ('22222222-2222-2222-2222-222222222204', '11111111-1111-1111-1111-111111111111', 'exec@acme.com', 'Executive Sponsor', '$2a$10$WdtYyVOCT1kjJzGg33yEM./7aYEkCSjDyKY05w1yOQdQQ.vk1Zn6S', false, 'active', '22222222-2222-2222-2222-222222222201', '22222222-2222-2222-2222-222222222201', 1),
  ('22222222-2222-2222-2222-222222222205', '11111111-1111-1111-1111-111111111111', 'pm@acme.com', 'Project Manager', '$2a$10$WdtYyVOCT1kjJzGg33yEM./7aYEkCSjDyKY05w1yOQdQQ.vk1Zn6S', false, 'active', '22222222-2222-2222-2222-222222222201', '22222222-2222-2222-2222-222222222201', 1);

INSERT INTO iam.roles (id, tenant_id, code, name, is_system, created_by, updated_by, version)
VALUES
  ('33333333-3333-3333-3333-333333333301', '11111111-1111-1111-1111-111111111111', 'super_admin', 'Super Admin', true, '22222222-2222-2222-2222-222222222201', '22222222-2222-2222-2222-222222222201', 1),
  ('33333333-3333-3333-3333-333333333302', '11111111-1111-1111-1111-111111111111', 'pmo', 'PMO', true, '22222222-2222-2222-2222-222222222201', '22222222-2222-2222-2222-222222222201', 1),
  ('33333333-3333-3333-3333-333333333303', '11111111-1111-1111-1111-111111111111', 'finance', 'Finance', true, '22222222-2222-2222-2222-222222222201', '22222222-2222-2222-2222-222222222201', 1),
  ('33333333-3333-3333-3333-333333333304', '11111111-1111-1111-1111-111111111111', 'executive', 'Executive', true, '22222222-2222-2222-2222-222222222201', '22222222-2222-2222-2222-222222222201', 1),
  ('33333333-3333-3333-3333-333333333305', '11111111-1111-1111-1111-111111111111', 'viewer', 'Viewer', true, '22222222-2222-2222-2222-222222222201', '22222222-2222-2222-2222-222222222201', 1);

INSERT INTO iam.permissions (id, code, resource, action, description)
VALUES
  ('44444444-4444-4444-4444-444444444401', 'iam.user.read', 'iam.user', 'read', 'Read users'),
  ('44444444-4444-4444-4444-444444444402', 'iam.user.create', 'iam.user', 'create', 'Create users'),
  ('44444444-4444-4444-4444-444444444403', 'project.read', 'project', 'read', 'Read projects'),
  ('44444444-4444-4444-4444-444444444404', 'project.create', 'project', 'create', 'Create projects'),
  ('44444444-4444-4444-4444-444444444405', 'financial.read', 'financial', 'read', 'Read financials'),
  ('44444444-4444-4444-4444-444444444406', 'analytics.read.executive', 'analytics', 'read', 'Read executive analytics'),
  ('44444444-4444-4444-4444-444444444407', 'report.generate', 'report', 'generate', 'Generate reports'),
  ('44444444-4444-4444-4444-444444444408', 'audit.read', 'audit', 'read', 'Read audit logs');

INSERT INTO iam.role_permissions (tenant_id, role_id, permission_id, created_by)
VALUES
  ('11111111-1111-1111-1111-111111111111', '33333333-3333-3333-3333-333333333301', '44444444-4444-4444-4444-444444444401', '22222222-2222-2222-2222-222222222201'),
  ('11111111-1111-1111-1111-111111111111', '33333333-3333-3333-3333-333333333301', '44444444-4444-4444-4444-444444444402', '22222222-2222-2222-2222-222222222201'),
  ('11111111-1111-1111-1111-111111111111', '33333333-3333-3333-3333-333333333301', '44444444-4444-4444-4444-444444444403', '22222222-2222-2222-2222-222222222201'),
  ('11111111-1111-1111-1111-111111111111', '33333333-3333-3333-3333-333333333301', '44444444-4444-4444-4444-444444444404', '22222222-2222-2222-2222-222222222201'),
  ('11111111-1111-1111-1111-111111111111', '33333333-3333-3333-3333-333333333301', '44444444-4444-4444-4444-444444444405', '22222222-2222-2222-2222-222222222201'),
  ('11111111-1111-1111-1111-111111111111', '33333333-3333-3333-3333-333333333301', '44444444-4444-4444-4444-444444444406', '22222222-2222-2222-2222-222222222201'),
  ('11111111-1111-1111-1111-111111111111', '33333333-3333-3333-3333-333333333301', '44444444-4444-4444-4444-444444444407', '22222222-2222-2222-2222-222222222201'),
  ('11111111-1111-1111-1111-111111111111', '33333333-3333-3333-3333-333333333301', '44444444-4444-4444-4444-444444444408', '22222222-2222-2222-2222-222222222201'),
  ('11111111-1111-1111-1111-111111111111', '33333333-3333-3333-3333-333333333302', '44444444-4444-4444-4444-444444444403', '22222222-2222-2222-2222-222222222201'),
  ('11111111-1111-1111-1111-111111111111', '33333333-3333-3333-3333-333333333302', '44444444-4444-4444-4444-444444444404', '22222222-2222-2222-2222-222222222201'),
  ('11111111-1111-1111-1111-111111111111', '33333333-3333-3333-3333-333333333303', '44444444-4444-4444-4444-444444444405', '22222222-2222-2222-2222-222222222201'),
  ('11111111-1111-1111-1111-111111111111', '33333333-3333-3333-3333-333333333304', '44444444-4444-4444-4444-444444444406', '22222222-2222-2222-2222-222222222201');

INSERT INTO iam.user_roles (tenant_id, user_id, role_id, assigned_by)
VALUES
  ('11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222201', '33333333-3333-3333-3333-333333333301', '22222222-2222-2222-2222-222222222201'),
  ('11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222202', '33333333-3333-3333-3333-333333333302', '22222222-2222-2222-2222-222222222201'),
  ('11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222203', '33333333-3333-3333-3333-333333333303', '22222222-2222-2222-2222-222222222201'),
  ('11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222204', '33333333-3333-3333-3333-333333333304', '22222222-2222-2222-2222-222222222201'),
  ('11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222205', '33333333-3333-3333-3333-333333333305', '22222222-2222-2222-2222-222222222201');

INSERT INTO iam.refresh_sessions (id, tenant_id, user_id, token_hash, token_family_id, device_id, ip, user_agent, expires_at)
VALUES
  ('55555555-5555-5555-5555-555555555501', '11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222201', 'mock-token-hash-1', '55555555-5555-5555-5555-555555555599', 'dev-laptop', '127.0.0.1', 'mock-agent', now() + interval '7 day');

INSERT INTO iam.mfa_totp (id, tenant_id, user_id, secret_enc, recovery_codes_enc, enabled_at)
VALUES
  ('66666666-6666-6666-6666-666666666601', '11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222201', 'enc-secret', 'enc-recovery-codes', now());

INSERT INTO portfolio.portfolios (id, tenant_id, code, name, owner_user_id, status, start_date, end_date, created_by, updated_by, version)
VALUES
  ('77777777-7777-7777-7777-777777777701', '11111111-1111-1111-1111-111111111111', 'PORT-2026', 'Strategic Portfolio 2026', '22222222-2222-2222-2222-222222222202', 'active', '2026-01-01', '2026-12-31', '22222222-2222-2222-2222-222222222201', '22222222-2222-2222-2222-222222222201', 1);

INSERT INTO portfolio.portfolio_members (tenant_id, portfolio_id, user_id, member_role, created_by)
VALUES
  ('11111111-1111-1111-1111-111111111111', '77777777-7777-7777-7777-777777777701', '22222222-2222-2222-2222-222222222202', 'owner', '22222222-2222-2222-2222-222222222201'),
  ('11111111-1111-1111-1111-111111111111', '77777777-7777-7777-7777-777777777701', '22222222-2222-2222-2222-222222222205', 'manager', '22222222-2222-2222-2222-222222222201');

INSERT INTO project.projects (id, tenant_id, portfolio_id, code, name, status, manager_user_id, sponsor_user_id, planned_start, planned_end, created_by, updated_by, version)
VALUES
  ('88888888-8888-8888-8888-888888888801', '11111111-1111-1111-1111-111111111111', '77777777-7777-7777-7777-777777777701', 'PRJ-ALPHA', 'Project Alpha Governance', 'active', '22222222-2222-2222-2222-222222222205', '22222222-2222-2222-2222-222222222204', '2026-01-10', '2026-11-30', '22222222-2222-2222-2222-222222222201', '22222222-2222-2222-2222-222222222201', 1);

INSERT INTO project.project_members (tenant_id, project_id, user_id, project_role, created_by)
VALUES
  ('11111111-1111-1111-1111-111111111111', '88888888-8888-8888-8888-888888888801', '22222222-2222-2222-2222-222222222205', 'project_manager', '22222222-2222-2222-2222-222222222201'),
  ('11111111-1111-1111-1111-111111111111', '88888888-8888-8888-8888-888888888801', '22222222-2222-2222-2222-222222222203', 'finance_partner', '22222222-2222-2222-2222-222222222201');

INSERT INTO project.project_milestones (id, tenant_id, project_id, name, due_date, status, progress, created_by, updated_by, version)
VALUES
  ('99999999-9999-9999-9999-999999999901', '11111111-1111-1111-1111-111111111111', '88888888-8888-8888-8888-888888888801', 'Initiation Complete', '2026-02-15', 'completed', 100, '22222222-2222-2222-2222-222222222205', '22222222-2222-2222-2222-222222222205', 1),
  ('99999999-9999-9999-9999-999999999902', '11111111-1111-1111-1111-111111111111', '88888888-8888-8888-8888-888888888801', 'Governance Gate 1', '2026-05-31', 'planned', 40, '22222222-2222-2222-2222-222222222205', '22222222-2222-2222-2222-222222222205', 1);

INSERT INTO project.work_packages (id, tenant_id, project_id, code, name, owner_user_id, status, start_date, end_date, created_by, updated_by, version)
VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaa01', '11111111-1111-1111-1111-111111111111', '88888888-8888-8888-8888-888888888801', 'WP-001', 'Governance Controls Setup', '22222222-2222-2222-2222-222222222205', 'active', '2026-01-15', '2026-06-30', '22222222-2222-2222-2222-222222222205', '22222222-2222-2222-2222-222222222205', 1);

INSERT INTO financial.project_financials (id, tenant_id, project_id, as_of_date, currency, budget_total, forecast_total, actual_total, created_by, updated_by, version)
VALUES
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbb01', '11111111-1111-1111-1111-111111111111', '88888888-8888-8888-8888-888888888801', '2026-06-01', 'USD', 1000000, 980000, 420000, '22222222-2222-2222-2222-222222222203', '22222222-2222-2222-2222-222222222203', 1);

INSERT INTO financial.project_costs (id, tenant_id, project_id, cost_type, amount, cost_date, source_ref, created_by, updated_by, version)
VALUES
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbb11', '11111111-1111-1111-1111-111111111111', '88888888-8888-8888-8888-888888888801', 'labor', 250000, '2026-04-30', 'ERP-LAB-001', '22222222-2222-2222-2222-222222222203', '22222222-2222-2222-2222-222222222203', 1),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbb12', '11111111-1111-1111-1111-111111111111', '88888888-8888-8888-8888-888888888801', 'vendor', 170000, '2026-05-31', 'ERP-VEN-001', '22222222-2222-2222-2222-222222222203', '22222222-2222-2222-2222-222222222203', 1);

INSERT INTO financial.budget_baselines (id, tenant_id, project_id, baseline_version, amount, approved_by, approved_at, created_by, updated_by, version)
VALUES
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbb21', '11111111-1111-1111-1111-111111111111', '88888888-8888-8888-8888-888888888801', 1, 1000000, '22222222-2222-2222-2222-222222222204', now() - interval '120 day', '22222222-2222-2222-2222-222222222203', '22222222-2222-2222-2222-222222222203', 1);

INSERT INTO forecast.forecast_snapshots (id, tenant_id, project_id, scenario, forecast_date, forecast_amount, confidence, created_by, updated_by, version)
VALUES
  ('cccccccc-cccc-cccc-cccc-cccccccccc01', '11111111-1111-1111-1111-111111111111', '88888888-8888-8888-8888-888888888801', 'base', '2026-06-01', 980000, 82.5, '22222222-2222-2222-2222-222222222203', '22222222-2222-2222-2222-222222222203', 1);

INSERT INTO schedule.baseline_schedules (id, tenant_id, project_id, baseline_version, baseline_start, baseline_end, approved_at, created_by, updated_by, version)
VALUES
  ('dddddddd-dddd-dddd-dddd-dddddddddd01', '11111111-1111-1111-1111-111111111111', '88888888-8888-8888-8888-888888888801', 1, '2026-01-10', '2026-11-30', now() - interval '120 day', '22222222-2222-2222-2222-222222222205', '22222222-2222-2222-2222-222222222205', 1);

INSERT INTO schedule.project_schedule_snapshots (id, tenant_id, project_id, snapshot_date, planned_progress, actual_progress, variance_days, created_by, updated_by, version)
VALUES
  ('dddddddd-dddd-dddd-dddd-dddddddddd11', '11111111-1111-1111-1111-111111111111', '88888888-8888-8888-8888-888888888801', '2026-06-01', 45, 40, -7, '22222222-2222-2222-2222-222222222205', '22222222-2222-2222-2222-222222222205', 1);

INSERT INTO resource.resources (id, tenant_id, employee_code, full_name, role_title, manager_user_id, active, created_by, updated_by, version)
VALUES
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeee01', '11111111-1111-1111-1111-111111111111', 'EMP-001', 'Alice Resource', 'Senior Analyst', '22222222-2222-2222-2222-222222222205', true, '22222222-2222-2222-2222-222222222205', '22222222-2222-2222-2222-222222222205', 1),
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeee02', '11111111-1111-1111-1111-111111111111', 'EMP-002', 'Bob Resource', 'Project Engineer', '22222222-2222-2222-2222-222222222205', true, '22222222-2222-2222-2222-222222222205', '22222222-2222-2222-2222-222222222205', 1);

INSERT INTO resource.resource_capacity (id, tenant_id, resource_id, period_month, capacity_hours, available_hours, created_by, updated_by, version)
VALUES
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11', '11111111-1111-1111-1111-111111111111', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeee01', '2026-06-01', 160, 40, '22222222-2222-2222-2222-222222222205', '22222222-2222-2222-2222-222222222205', 1),
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeee12', '11111111-1111-1111-1111-111111111111', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeee02', '2026-06-01', 160, 70, '22222222-2222-2222-2222-222222222205', '22222222-2222-2222-2222-222222222205', 1);

INSERT INTO resource.resource_allocations (id, tenant_id, resource_id, project_id, period_month, allocation_percent, created_by, updated_by, version)
VALUES
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeee21', '11111111-1111-1111-1111-111111111111', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeee01', '88888888-8888-8888-8888-888888888801', '2026-06-01', 75, '22222222-2222-2222-2222-222222222205', '22222222-2222-2222-2222-222222222205', 1),
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeee22', '11111111-1111-1111-1111-111111111111', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeee02', '88888888-8888-8888-8888-888888888801', '2026-06-01', 55, '22222222-2222-2222-2222-222222222205', '22222222-2222-2222-2222-222222222205', 1);

INSERT INTO vendor.vendors (id, tenant_id, code, name, category, status, created_by, updated_by, version)
VALUES
  ('ffffffff-ffff-ffff-ffff-fffffffff001', '11111111-1111-1111-1111-111111111111', 'VEN-ACME-IT', 'Acme IT Services', 'technology', 'active', '22222222-2222-2222-2222-222222222201', '22222222-2222-2222-2222-222222222201', 1);

INSERT INTO vendor.contracts (id, tenant_id, vendor_id, contract_no, start_date, end_date, contract_value, status, created_by, updated_by, version)
VALUES
  ('ffffffff-ffff-ffff-ffff-fffffffff011', '11111111-1111-1111-1111-111111111111', 'ffffffff-ffff-ffff-ffff-fffffffff001', 'CON-2026-001', '2026-01-01', '2026-12-31', 300000, 'active', '22222222-2222-2222-2222-222222222203', '22222222-2222-2222-2222-222222222203', 1);

INSERT INTO vendor.vendor_performance (id, tenant_id, vendor_id, period_month, kpi_code, score, remarks, created_by, updated_by, version)
VALUES
  ('ffffffff-ffff-ffff-ffff-fffffffff021', '11111111-1111-1111-1111-111111111111', 'ffffffff-ffff-ffff-ffff-fffffffff001', '2026-06-01', 'SLA_UPTIME', 97.5, 'On track', '22222222-2222-2222-2222-222222222203', '22222222-2222-2222-2222-222222222203', 1);

INSERT INTO risk.risks (id, tenant_id, project_id, code, title, likelihood, impact, score, status, owner_user_id, created_by, updated_by, version)
VALUES
  ('12121212-1212-1212-1212-121212121201', '11111111-1111-1111-1111-111111111111', '88888888-8888-8888-8888-888888888801', 'RISK-001', 'Vendor delay may impact timeline', 4, 4, 16, 'open', '22222222-2222-2222-2222-222222222205', '22222222-2222-2222-2222-222222222205', '22222222-2222-2222-2222-222222222205', 1);

INSERT INTO risk.risk_mitigations (id, tenant_id, risk_id, action_plan, owner_user_id, due_date, status, created_by, updated_by, version)
VALUES
  ('12121212-1212-1212-1212-121212121211', '11111111-1111-1111-1111-111111111111', '12121212-1212-1212-1212-121212121201', 'Weekly vendor checkpoint and contingency sourcing', '22222222-2222-2222-2222-222222222205', '2026-07-15', 'open', '22222222-2222-2222-2222-222222222205', '22222222-2222-2222-2222-222222222205', 1);

INSERT INTO issue.issues (id, tenant_id, project_id, code, title, severity, status, assigned_to, raised_at, created_by, updated_by, version)
VALUES
  ('13131313-1313-1313-1313-131313131301', '11111111-1111-1111-1111-111111111111', '88888888-8888-8888-8888-888888888801', 'ISS-001', 'Late baseline sign-off', 'high', 'open', '22222222-2222-2222-2222-222222222205', now() - interval '5 day', '22222222-2222-2222-2222-222222222202', '22222222-2222-2222-2222-222222222202', 1);

INSERT INTO change_request.change_requests (id, tenant_id, project_id, code, change_type, requested_by, requested_at, status, impact_cost, impact_days, description, created_by, updated_by, version)
VALUES
  ('14141414-1414-1414-1414-141414141401', '11111111-1111-1111-1111-111111111111', '88888888-8888-8888-8888-888888888801', 'CR-001', 'timeline', '22222222-2222-2222-2222-222222222205', now() - interval '2 day', 'submitted', 25000, 10, 'Request additional timeline for integration hardening', '22222222-2222-2222-2222-222222222205', '22222222-2222-2222-2222-222222222205', 1);

INSERT INTO governance.governance_reviews (id, tenant_id, project_id, review_date, reviewer_user_id, outcome, notes, created_by, updated_by, version)
VALUES
  ('15151515-1515-1515-1515-151515151501', '11111111-1111-1111-1111-111111111111', '88888888-8888-8888-8888-888888888801', '2026-06-05', '22222222-2222-2222-2222-222222222202', 'conditional', 'Proceed with mitigation actions', '22222222-2222-2222-2222-222222222202', '22222222-2222-2222-2222-222222222202', 1);

INSERT INTO governance.review_findings (id, tenant_id, review_id, finding_type, severity, description, recommendation, created_by, updated_by, version)
VALUES
  ('15151515-1515-1515-1515-151515151511', '11111111-1111-1111-1111-111111111111', '15151515-1515-1515-1515-151515151501', 'schedule', 'medium', 'Milestone variance exceeds threshold', 'Increase monitoring cadence and vendor governance', '22222222-2222-2222-2222-222222222202', '22222222-2222-2222-2222-222222222202', 1);

INSERT INTO import_engine.import_jobs (id, tenant_id, source_type, file_name, file_checksum, status, submitted_by, submitted_at, started_at, completed_at, retry_count, created_by, updated_by, version)
VALUES
  ('16161616-1616-1616-1616-161616161601', '11111111-1111-1111-1111-111111111111', 'csv', 'project_costs_june.csv', 'checksum-june-001', 'completed', '22222222-2222-2222-2222-222222222203', now() - interval '1 day', now() - interval '1 day' + interval '2 minute', now() - interval '1 day' + interval '5 minute', 0, '22222222-2222-2222-2222-222222222203', '22222222-2222-2222-2222-222222222203', 1);

INSERT INTO import_engine.import_templates (id, tenant_id, domain, template_name, version, is_active, created_by, updated_by, version_lock)
VALUES
  ('16161616-1616-1616-1616-161616161611', '11111111-1111-1111-1111-111111111111', 'financial', 'Financial Cost Import', 1, true, '22222222-2222-2222-2222-222222222203', '22222222-2222-2222-2222-222222222203', 1);

INSERT INTO import_engine.import_mappings (id, tenant_id, template_id, source_column, target_field, transform_rule, required, created_by, updated_by, version)
VALUES
  ('16161616-1616-1616-1616-161616161621', '11111111-1111-1111-1111-111111111111', '16161616-1616-1616-1616-161616161611', 'project_code', 'project_id', 'lookup:project.code', true, '22222222-2222-2222-2222-222222222203', '22222222-2222-2222-2222-222222222203', 1),
  ('16161616-1616-1616-1616-161616161622', '11111111-1111-1111-1111-111111111111', '16161616-1616-1616-1616-161616161611', 'amount', 'amount', 'decimal', true, '22222222-2222-2222-2222-222222222203', '22222222-2222-2222-2222-222222222203', 1);

INSERT INTO import_engine.import_staging_rows (tenant_id, job_id, row_number, payload, normalized, row_status, dedupe_key)
VALUES
  ('11111111-1111-1111-1111-111111111111', '16161616-1616-1616-1616-161616161601', 1, '{"project_code":"PRJ-ALPHA","amount":"12000.50","cost_type":"labor"}', '{"project_id":"88888888-8888-8888-8888-888888888801","amount":12000.50,"cost_type":"labor"}', 'applied', 'dedupe-1'),
  ('11111111-1111-1111-1111-111111111111', '16161616-1616-1616-1616-161616161601', 2, '{"project_code":"PRJ-ALPHA","amount":"BAD","cost_type":"vendor"}', '{"project_id":"88888888-8888-8888-8888-888888888801","cost_type":"vendor"}', 'error', 'dedupe-2');

INSERT INTO import_engine.import_errors (id, tenant_id, job_id, row_number, field_name, error_code, error_message)
VALUES
  ('16161616-1616-1616-1616-161616161631', '11111111-1111-1111-1111-111111111111', '16161616-1616-1616-1616-161616161601', 2, 'amount', 'INVALID_DECIMAL', 'Amount is not a valid decimal');

INSERT INTO analytics.portfolio_summary (tenant_id, as_of_date, portfolio_id, project_count, health_score, budget_variance, risk_count, refreshed_at)
VALUES
  ('11111111-1111-1111-1111-111111111111', '2026-06-01', '77777777-7777-7777-7777-777777777701', 1, 78.5, -20000, 1, now());

INSERT INTO analytics.project_summary (tenant_id, as_of_date, project_id, spi, cpi, progress, status, refreshed_at)
VALUES
  ('11111111-1111-1111-1111-111111111111', '2026-06-01', '88888888-8888-8888-8888-888888888801', 0.93, 0.97, 40, 'active', now());

INSERT INTO analytics.financial_summary (tenant_id, as_of_date, project_id, budget, actual, forecast, variance, refreshed_at)
VALUES
  ('11111111-1111-1111-1111-111111111111', '2026-06-01', '88888888-8888-8888-8888-888888888801', 1000000, 420000, 980000, -20000, now());

INSERT INTO analytics.resource_summary (tenant_id, as_of_date, resource_id, utilization_percent, allocation_percent, refreshed_at)
VALUES
  ('11111111-1111-1111-1111-111111111111', '2026-06-01', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeee01', 75, 75, now());

INSERT INTO analytics.vendor_summary (tenant_id, as_of_date, vendor_id, avg_score, active_contracts, on_time_rate, refreshed_at)
VALUES
  ('11111111-1111-1111-1111-111111111111', '2026-06-01', 'ffffffff-ffff-ffff-ffff-fffffffff001', 97.5, 1, 92, now());

INSERT INTO analytics.risk_summary (tenant_id, as_of_date, project_id, open_risk_count, high_risk_count, avg_score, refreshed_at)
VALUES
  ('11111111-1111-1111-1111-111111111111', '2026-06-01', '88888888-8888-8888-8888-888888888801', 1, 1, 16, now());

INSERT INTO analytics.executive_dashboard_snapshots (tenant_id, snapshot_at, widget_key, payload, refresh_version)
VALUES
  ('11111111-1111-1111-1111-111111111111', now(), 'executive_briefing', '{"portfolio_health":78.5,"budget_variance":-20000,"open_risks":1}', 1);

INSERT INTO reporting.reports (id, tenant_id, name, report_type, filters, created_by, updated_by, version)
VALUES
  ('17171717-1717-1717-1717-171717171701', '11111111-1111-1111-1111-111111111111', 'Executive Weekly', 'executive', '{"portfolio_code":"PORT-2026","period":"2026-W23"}', '22222222-2222-2222-2222-222222222204', '22222222-2222-2222-2222-222222222204', 1);

INSERT INTO reporting.report_exports (id, tenant_id, report_id, format, storage_url, generated_at, generated_by)
VALUES
  ('17171717-1717-1717-1717-171717171711', '11111111-1111-1111-1111-111111111111', '17171717-1717-1717-1717-171717171701', 'pdf', 'https://example.local/reports/executive-weekly.pdf', now(), '22222222-2222-2222-2222-222222222204');

INSERT INTO audit.audit_logs (tenant_id, actor_user_id, action, object_type, object_id, before_state, after_state, request_id, ip, user_agent, occurred_at)
VALUES
  ('11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222201', 'project.update', 'project', '88888888-8888-8888-8888-888888888801', '{"status":"draft"}', '{"status":"active"}', 'req-mock-001', '127.0.0.1', 'mock-client', now());

INSERT INTO audit.activity_logs (tenant_id, actor_user_id, module, activity, metadata, request_id, occurred_at)
VALUES
  ('11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222205', 'import_engine', 'import.completed', '{"job_id":"16161616-1616-1616-1616-161616161601","rows":2}', 'req-mock-002', now());

INSERT INTO integration.integration_connections (id, tenant_id, name, integration_type, config_enc, status, last_sync_at, created_by, updated_by, version)
VALUES
  ('18181818-1818-1818-1818-181818181801', '11111111-1111-1111-1111-111111111111', 'ERP Export Feed', 'erp', 'enc-config', 'active', now() - interval '2 hour', '22222222-2222-2222-2222-222222222201', '22222222-2222-2222-2222-222222222201', 1);

INSERT INTO integration.integration_sync_runs (id, tenant_id, connection_id, run_started_at, run_finished_at, status, records_total, records_success, records_failed, error_summary)
VALUES
  ('18181818-1818-1818-1818-181818181811', '11111111-1111-1111-1111-111111111111', '18181818-1818-1818-1818-181818181801', now() - interval '2 hour', now() - interval '1 hour 55 minute', 'completed', 120, 118, 2, '2 records failed validation');

-- +goose Down
DELETE FROM integration.integration_sync_runs WHERE id = '18181818-1818-1818-1818-181818181811';
DELETE FROM integration.integration_connections WHERE id = '18181818-1818-1818-1818-181818181801';

DELETE FROM audit.activity_logs WHERE request_id IN ('req-mock-002');
DELETE FROM audit.audit_logs WHERE request_id IN ('req-mock-001');

DELETE FROM reporting.report_exports WHERE id = '17171717-1717-1717-1717-171717171711';
DELETE FROM reporting.reports WHERE id = '17171717-1717-1717-1717-171717171701';

DELETE FROM analytics.executive_dashboard_snapshots WHERE tenant_id = '11111111-1111-1111-1111-111111111111' AND widget_key = 'executive_briefing';
DELETE FROM analytics.risk_summary WHERE tenant_id = '11111111-1111-1111-1111-111111111111' AND project_id = '88888888-8888-8888-8888-888888888801';
DELETE FROM analytics.vendor_summary WHERE tenant_id = '11111111-1111-1111-1111-111111111111' AND vendor_id = 'ffffffff-ffff-ffff-ffff-fffffffff001';
DELETE FROM analytics.resource_summary WHERE tenant_id = '11111111-1111-1111-1111-111111111111' AND resource_id = 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeee01';
DELETE FROM analytics.financial_summary WHERE tenant_id = '11111111-1111-1111-1111-111111111111' AND project_id = '88888888-8888-8888-8888-888888888801';
DELETE FROM analytics.project_summary WHERE tenant_id = '11111111-1111-1111-1111-111111111111' AND project_id = '88888888-8888-8888-8888-888888888801';
DELETE FROM analytics.portfolio_summary WHERE tenant_id = '11111111-1111-1111-1111-111111111111' AND portfolio_id = '77777777-7777-7777-7777-777777777701';

DELETE FROM import_engine.import_errors WHERE id = '16161616-1616-1616-1616-161616161631';
DELETE FROM import_engine.import_staging_rows WHERE tenant_id = '11111111-1111-1111-1111-111111111111' AND job_id = '16161616-1616-1616-1616-161616161601';
DELETE FROM import_engine.import_mappings WHERE id IN ('16161616-1616-1616-1616-161616161621', '16161616-1616-1616-1616-161616161622');
DELETE FROM import_engine.import_templates WHERE id = '16161616-1616-1616-1616-161616161611';
DELETE FROM import_engine.import_jobs WHERE id = '16161616-1616-1616-1616-161616161601';

DELETE FROM governance.review_findings WHERE id = '15151515-1515-1515-1515-151515151511';
DELETE FROM governance.governance_reviews WHERE id = '15151515-1515-1515-1515-151515151501';

DELETE FROM change_request.change_requests WHERE id = '14141414-1414-1414-1414-141414141401';
DELETE FROM issue.issues WHERE id = '13131313-1313-1313-1313-131313131301';
DELETE FROM risk.risk_mitigations WHERE id = '12121212-1212-1212-1212-121212121211';
DELETE FROM risk.risks WHERE id = '12121212-1212-1212-1212-121212121201';

DELETE FROM vendor.vendor_performance WHERE id = 'ffffffff-ffff-ffff-ffff-fffffffff021';
DELETE FROM vendor.contracts WHERE id = 'ffffffff-ffff-ffff-ffff-fffffffff011';
DELETE FROM vendor.vendors WHERE id = 'ffffffff-ffff-ffff-ffff-fffffffff001';

DELETE FROM resource.resource_allocations WHERE id IN ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeee21', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeee22');
DELETE FROM resource.resource_capacity WHERE id IN ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeee12');
DELETE FROM resource.resources WHERE id IN ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeee01', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeee02');

DELETE FROM schedule.project_schedule_snapshots WHERE id = 'dddddddd-dddd-dddd-dddd-dddddddddd11';
DELETE FROM schedule.baseline_schedules WHERE id = 'dddddddd-dddd-dddd-dddd-dddddddddd01';

DELETE FROM forecast.forecast_snapshots WHERE id = 'cccccccc-cccc-cccc-cccc-cccccccccc01';
DELETE FROM financial.budget_baselines WHERE id = 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbb21';
DELETE FROM financial.project_costs WHERE id IN ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbb11', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbb12');
DELETE FROM financial.project_financials WHERE id = 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbb01';

DELETE FROM project.work_packages WHERE id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaa01';
DELETE FROM project.project_milestones WHERE id IN ('99999999-9999-9999-9999-999999999901', '99999999-9999-9999-9999-999999999902');
DELETE FROM project.project_members WHERE tenant_id = '11111111-1111-1111-1111-111111111111' AND project_id = '88888888-8888-8888-8888-888888888801';
DELETE FROM project.projects WHERE id = '88888888-8888-8888-8888-888888888801';

DELETE FROM portfolio.portfolio_members WHERE tenant_id = '11111111-1111-1111-1111-111111111111' AND portfolio_id = '77777777-7777-7777-7777-777777777701';
DELETE FROM portfolio.portfolios WHERE id = '77777777-7777-7777-7777-777777777701';

DELETE FROM iam.mfa_totp WHERE id = '66666666-6666-6666-6666-666666666601';
DELETE FROM iam.refresh_sessions WHERE id = '55555555-5555-5555-5555-555555555501';
DELETE FROM iam.user_roles WHERE tenant_id = '11111111-1111-1111-1111-111111111111' AND user_id IN (
  '22222222-2222-2222-2222-222222222201',
  '22222222-2222-2222-2222-222222222202',
  '22222222-2222-2222-2222-222222222203',
  '22222222-2222-2222-2222-222222222204',
  '22222222-2222-2222-2222-222222222205'
);
DELETE FROM iam.role_permissions WHERE tenant_id = '11111111-1111-1111-1111-111111111111';
DELETE FROM iam.permissions WHERE id IN (
  '44444444-4444-4444-4444-444444444401',
  '44444444-4444-4444-4444-444444444402',
  '44444444-4444-4444-4444-444444444403',
  '44444444-4444-4444-4444-444444444404',
  '44444444-4444-4444-4444-444444444405',
  '44444444-4444-4444-4444-444444444406',
  '44444444-4444-4444-4444-444444444407',
  '44444444-4444-4444-4444-444444444408'
);
DELETE FROM iam.roles WHERE id IN (
  '33333333-3333-3333-3333-333333333301',
  '33333333-3333-3333-3333-333333333302',
  '33333333-3333-3333-3333-333333333303',
  '33333333-3333-3333-3333-333333333304',
  '33333333-3333-3333-3333-333333333305'
);
DELETE FROM iam.users WHERE id IN (
  '22222222-2222-2222-2222-222222222201',
  '22222222-2222-2222-2222-222222222202',
  '22222222-2222-2222-2222-222222222203',
  '22222222-2222-2222-2222-222222222204',
  '22222222-2222-2222-2222-222222222205'
);
DELETE FROM iam.tenants WHERE id = '11111111-1111-1111-1111-111111111111';
