# Sprint 4 – Security Engineer Summary

**Owner:** TaZahnae  
**Branch:** `feat/sprint4-security`

## Scope
- Add security Terraform modules (GuardDuty, CloudTrail, WAF, SNS alerts)
- Add security incident response playbook
- Add CI validation for Terraform

## What’s ready (no AWS creds needed)
- Terraform scaffold created under `terraform/`
- Playbook created under `docs/playbooks/incident_response.md`
- CI workflow added under `.github/workflows/terraform-ci.yml`
- Evidence folder created under `docs/evidence/`

## What’s pending (needs AWS creds)
- `terraform apply` to deploy GuardDuty, CloudTrail, WAF, SNS in **us-east-2**
- Run SQLi test against API Gateway and capture 403 (WAF)
- Save SNS/GuardDuty screenshots into `docs/evidence/`