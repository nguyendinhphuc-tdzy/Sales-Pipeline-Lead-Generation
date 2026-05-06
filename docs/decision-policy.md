# Lead Qualification Policy

## Overview

This document defines the automated decision logic for qualifying leads in the Sales Pipeline system.

## Qualification Criteria

A lead is marked **QUALIFIED** if ANY of the following conditions are met:

| Condition | Code Check | Rationale |
|-----------|------------|-----------|
| Slow Website | `pagespeed_score < 50` | Performance improvement opportunity |
| No SSL | `has_ssl == false` | Security upgrade needed |
| WordPress Site | `is_wordpress == true` | Customization/plugin opportunity |
| No AI Agent | `has_agent == false` | Sales opportunity for Quack |

A lead is marked **DISQUALIFIED** only if:
- All conditions above are false (high-performance, secure, non-WordPress site WITH existing AI agent)

## Code Reference

```python
# backend/routers/scan.py - Lines 143-149

has_agent = len(tech.get('agents', [])) > 0
is_slow = (speed is not None) and (speed < 50)

is_qualified = is_slow or not has_ssl or tech['is_wordpress'] or not has_agent
```

## Detailed Qualification Rules

### 1. PageSpeed Score

**Threshold:** Score < 50 (Mobile)

**Data Source:** Google PageSpeed Insights API v5

**Conditions:**
- Must successfully fetch a valid score
- `null` scores are ignored (treated as "unknown")
- Only mobile strategy is used

**Business Value:**
- Score < 50 indicates poor user experience
- Correlates with higher bounce rates
- Opportunity for performance optimization services

### 2. SSL Certificate

**Check:** Website URL starts with `https://`

**Data Source:** Direct URL inspection during scraping

**Business Value:**
- Missing SSL is a security red flag
- Required for modern web standards
- Opportunity for security consultation

### 3. WordPress Detection

**Detection Methods:**
1. Meta generator tag containing "wordpress"
2. Path signatures: `/wp-content/`, `/wp-includes/`
3. CDN signatures: `cdn.shopify.com` (excluded), `wix-bolt` (excluded)

**Business Value:**
- Large ecosystem of plugins/themes
- Often managed by smaller teams
- Opportunity for custom development

### 4. AI Agent Detection

**Detected Platforms:**
- Intercom, Drift, Zendesk
- Tawk.to, LiveChat, Crisp
- ManyChat, Chatbase, Voiceflow
- Stack AI, Botpress, Dialogflow, Tidio

**Business Value:**
- Companies without agents may lack automation
- Quack can complement or replace existing solutions
- Entry point for AI automation conversation

## Qualification Matrix

| SSL | PageSpeed | WordPress | Agent | Status | Reason if Disqualified |
|-----|-----------|-----------|-------|--------|------------------------|
| No  | Any       | Any       | Any   | QUALIFIED | - |
| Yes | < 50      | Any       | Any   | QUALIFIED | - |
| Yes | >= 50     | Yes       | Any   | QUALIFIED | - |
| Yes | >= 50     | No        | No    | QUALIFIED | - |
| Yes | >= 50     | No        | Yes   | DISQUALIFIED | High Performance Site |
| Yes | null      | No        | Yes   | DISQUALIFIED | High Performance Site |

## Fallback Query Logic

When initial search returns no results:

### Step 1: Gemini Query Relaxation
```
Input: "Marketing Agency 1-5 people English speaking SEO ops in Hanoi"
Output: "Marketing Agency English speaking SEO Hanoi"
```

### Step 2: Broader Suggestion
If still no results, Gemini suggests:
```
Input: "Marketing Agency 1-5 people English speaking SEO ops in Hanoi"
Output: "Marketing Agency"
```

### Step 3: Strict Mode Relaxation
- Initial search: Strict location matching
- Fallback search: Relaxed location matching (broader geographic area)

## Sales Strategy Assignment

Based on detected attributes, the system assigns a sales strategy:

| Detection | Strategy |
|-----------|----------|
| CRM = HubSpot | "Pitch Quack agent for better lead qualification inside their existing CRM" |
| is_wordpress = true | "Pitch custom plugin or integration to automate content/sales flow" |
| has_ssl = false | "Pitch Security & Infrastructure upgrade immediately" |
| Default | "Focus on Operational Efficiency using Maestro" |

## Contact Prioritization

When enriching decision makers:

**Target Roles (in order of priority):**
1. CEO / Founder
2. CTO / Technical Lead
3. Marketing Director
4. VP / C-Level executives

**Seniority Classification:**
- C-Level: CEO, CFO, CTO, COO, CMO, Founder, Co-Founder
- VP: Vice President, VP, Head of...
- Manager: Director, Manager, Head (non-VP)

## Email Product Matching

| Industry/Context | Product |
|------------------|---------|
| Finance, Retail, E-commerce | Colectia (Debt Collection) |
| Agency, Consulting | Quack (Sales Agent) |
| Technology, SaaS | Maestro (Orchestration) |

## Configuration Constants

```python
MAX_RESULTS_PER_SCAN = 5          # Default limit
PAGESPEED_THRESHOLD = 50          # Qualification threshold
GEMINI_TEMPERATURE_QUERY = 0.1     # Low temp for optimization
GEMINI_TEMPERATURE_SEARCH = 0.3    # Balanced for search
GEMINI_TEMPERATURE_DRAFT = 0.3     # Balanced for drafting
API_TIMEOUT_SECONDS = 60           # Gemini API timeout
SCRAPE_TIMEOUT_SECONDS = 10       # Website scrape timeout
```

## Future Improvements

### Planned Enhancements

1. **Revenue-based qualification** - Detect company size via Clearbit/Apollo
2. **Employee count scoring** - Weight by team size
3. **Tech stack scoring** - Score based on how "modern" their stack is
4. **Social proof scoring** - Analyze LinkedIn followers, engagement
5. **Intent signals** - Job postings, funding announcements

### Configurable Rules

Future versions should support:
- YAML-based rule configuration
- A/B testing different qualification thresholds
- Industry-specific rules
- Customer-specific overrides
