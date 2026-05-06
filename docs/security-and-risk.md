# Security & Risk Assessment

## Overview

This document outlines the security posture, identified risks, and mitigation strategies for the Sales Pipeline system.

## Security Architecture

### Authentication & Authorization

| Component | Mechanism | Status |
|-----------|-----------|--------|
| Frontend | Supabase Auth (Magic Link, OAuth) | Implemented |
| Database | Row Level Security (RLS) | Implemented |
| API | Environment-based config | Partial |
| Backend | Service role key | Protected |

### Data Flow Security

```
User Session (Browser)
    │
    ▼ HTTPS
Supabase Auth (Magic Link/OAuth)
    │
    ▼ JWT Token
Next.js App (Authenticated)
    │
    ▼ HTTP POST (proxy)
Python Backend (API Key via env)
    │
    ▼
Supabase (Service Role)
```

## Identified Risks

### Critical Risks

#### 1. API Key Exposure

**Risk Level:** HIGH

**Description:**
- `GOOGLE_API_KEY` grants access to Gemini AI and PageSpeed APIs
- `APIFY_API_TOKEN` grants access to web scraping infrastructure
- Keys stored in environment variables could be committed to git

**Current Mitigation:**
- `.env*` patterns in `.gitignore`
- No actual keys in repository (assumed)

**Recommended Actions:**
- [x] Verify `.gitignore` excludes `.env*` files
- [ ] Use secret management (Vercel Secrets, Railway Variables)
- [ ] Implement key rotation policy
- [ ] Add API key usage monitoring/alerts
- [ ] Set per-key API quotas

#### 2. Database Credential Exposure

**Risk Level:** HIGH

**Description:**
- `SUPABASE_URL` and `SUPABASE_KEY` in environment
- Service role key has admin access to entire database

**Current Mitigation:**
- RLS policies on tables
- Environment variable storage

**Recommended Actions:**
- [ ] Separate anon key (client) from service role (backend)
- [ ] Implement key rotation
- [ ] Add database access logging
- [ ] Review RLS policies quarterly

#### 3. Web Scraping Legal Risk

**Risk Level:** MEDIUM

**Description:**
- Scraping company websites for emails and data
- May violate some websites' terms of service
- GDPR implications for EU companies

**Current Mitigation:**
- Only scrapes publicly available information
- Respects robots.txt (implicit via requests library)

**Recommended Actions:**
- [ ] Add robots.txt checking before scraping
- [ ] Implement rate limiting per domain
- [ ] Add user-agent identification
- [ ] Include legal disclaimer in data processing

### Medium Risks

#### 4. CORS Misconfiguration

**Risk Level:** MEDIUM

**Description:**
Current allowed origins:
```python
origins = [
    "http://localhost:3000",
    "http://127.0.0.1:3000",
]
```

**Issue:** Development-only origins, no production domains configured.

**Recommended Actions:**
- [ ] Add production domains to CORS config
- [ ] Use environment-based origin whitelist
- [ ] Consider using a request signing mechanism

#### 5. SSL Verification Disabled

**Risk Level:** MEDIUM

**Description:**
In `backend/utils/tech_detector.py`:
```python
response = requests.get(url, headers=self.headers, timeout=10, verify=False)
```

**Risk:** Man-in-the-middle attack potential during tech detection.

**Recommended Actions:**
- [ ] Only disable for internal/private IPs
- [ ] Log when verification is bypassed
- [ ] Consider adding certificate pinning for known domains

#### 6. AI Hallucination Risk

**Risk Level:** MEDIUM

**Description:**
- Gemini may generate fake contact names/emails
- Query optimization may drift from user intent

**Current Mitigation:**
- Temperature set low (0.1-0.3)
- JSON parsing with validation
- Null handling for missing data

**Recommended Actions:**
- [ ] Add contact verification step (LinkedIn API)
- [ ] Implement confidence scores
- [ ] Human review for high-value leads
- [ ] Log all AI-generated data for audit

#### 7. Rate Limiting

**Risk Level:** MEDIUM

**Description:**
- No rate limiting on API endpoints
- Single user could exhaust API quotas
- DoS vulnerability

**Recommended Actions:**
- [ ] Implement rate limiting middleware
- [ ] Add per-user/per-IP limits
- [ ] Set up quota alerts

### Low Risks

#### 8. Data Retention

**Risk Level:** LOW

**Description:**
- No automatic data retention/deletion policy
- Companies and contacts stored indefinitely

**Recommended Actions:**
- [ ] Implement data retention policy
- [ ] Add scheduled cleanup jobs
- [ ] Allow users to delete their data

#### 9. Input Validation

**Risk Level:** LOW

**Description:**
- User inputs (keywords, locations) not strictly validated
- Potential for injection in search queries

**Current Mitigation:**
- Pydantic models for request validation
- SQL parameterization via Supabase SDK

**Recommended Actions:**
- [ ] Add input sanitization
- [ ] Limit keyword length
- [ ] Block special characters in search

## Operational Risks

### Cost Overruns

| API | Risk | Mitigation |
|-----|------|------------|
| Gemini | Unbounded token usage | Set max tokens in generation config |
| Apify | Per-run costs | Limit results per scan |
| PageSpeed | Per-request costs | Only call for websites with URLs |
| Supabase | Bandwidth/storage | Monitor usage dashboard |

### Service Dependencies

| Service | Downtime Impact | Fallback |
|---------|-----------------|----------|
| Gemini API | Total enrichment failure | Return error, allow retry |
| Apify | Total scanning failure | Return error, allow retry |
| PageSpeed | Graceful degradation | Set null score, skip qualification |
| Supabase | Complete system failure | Show error to user |
| Google Maps | N/A | Using Apify abstraction |

### Data Quality Issues

| Issue | Frequency | Impact |
|-------|-----------|--------|
| Empty scraped emails | High | Skip enrichment |
| No PageSpeed score | Medium | Graceful skip |
| Wrong location results | Low | Strict filtering |
| Fake AI contacts | Low | LinkedIn verification (future) |

## Compliance Considerations

### GDPR (European Companies)

**Relevant Articles:**
- Article 6: Lawful processing basis (legitimate interest)
- Article 12-22: Data subject rights
- Article 32: Security measures

**Required Actions:**
- [ ] Privacy policy for EU users
- [ ] Data export functionality
- [ ] Data deletion capability
- [ ] Consent mechanism for enrichment

### Data Processing Agreement

**Required:**
- [ ] DPA with Supabase
- [ ] DPA with Google (Gemini)
- [ ] DPA with Apify
- [ ] Terms of Service document

## Security Checklist

### Pre-Production

- [x] `.gitignore` configured
- [x] No secrets in code
- [ ] Environment variables in production secrets manager
- [ ] CORS configured for production domains
- [ ] RLS policies verified
- [ ] API key quotas set
- [ ] Rate limiting implemented
- [ ] SSL verification fixed or scoped
- [ ] Monitoring/alerting configured

### Post-Deployment

- [ ] Security audit completed
- [ ] Penetration testing (if high-value)
- [ ] Incident response plan documented
- [ ] Backup/restore tested
- [ ] Key rotation procedure documented

## Incident Response

### Suspected Breach

1. **Immediate:** Rotate all API keys
2. **24h:** Audit Supabase access logs
3. **48h:** Review Gemini API usage
4. **72h:** Complete security review

### API Quota Exhaustion

1. **Immediate:** Pause non-critical operations
2. **Identify:** Check which operation consumed quota
3. **Mitigate:** Add usage limits
4. **Prevent:** Set budget alerts

## Dependencies Vulnerability

| Package | Version | Last Audit | Status |
|---------|---------|------------|--------|
| fastapi | 0.128.0 | - | Monitor |
| requests | 2.32.5 | April 2024 | OK |
| supabase | latest | - | Monitor |
| google-generative-ai | 0.24.1 | - | Monitor |

**Recommendation:** Run `pip-audit` regularly and subscribe to security advisories.
