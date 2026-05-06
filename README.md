# Sales Pipeline - Lead Generation System

An AI-powered B2B lead generation and qualification system that automates the discovery, analysis, and enrichment of potential business customers.

## Overview

This system helps sales teams identify and qualify leads by:
1. **Scanning** - Discovering businesses via Google Maps using keyword searches
2. **Qualifying** - Evaluating technical readiness (performance, SSL, CMS, existing agents)
3. **Enriching** - Finding key decision makers using AI with web search
4. **Drafting** - Generating personalized cold email templates

## Tech Stack

| Layer | Technology |
|-------|------------|
| Frontend | Next.js 16 (App Router), React 19, TypeScript, Tailwind CSS, Radix UI |
| Backend | Python FastAPI |
| AI | Google Gemini 2.5 Flash with Search Grounding |
| Data | Supabase (PostgreSQL) |
| Crawling | Apify (Google Places Crawler) |
| Deployment | Vercel (Frontend), Railway/Render (Python Backend) |

## Quick Start

### Prerequisites

- Node.js 20+
- Python 3.10+
- Supabase account
- Google Cloud account (for Gemini API + PageSpeed)
- Apify account

### Environment Setup

**Frontend (Next.js)**
```bash
cp .env.example .env.local
# Configure NEXT_PUBLIC_SUPABASE_URL
# Configure NEXT_PUBLIC_SUPABASE_ANON_KEY
# Configure NEXT_PUBLIC_API_URL (your Python backend URL)
```

**Backend (Python)**
```bash
cd backend
cp .env.example .env
# Configure SUPABASE_URL
# Configure SUPABASE_KEY
# Configure GOOGLE_API_KEY
# Configure APIFY_API_TOKEN
```

### Running Locally

```bash
# Frontend
npm install
npm run dev

# Backend (separate terminal)
cd backend
pip install -r requirements.txt
uvicorn main:app --reload --port 8000
```

## Features

### Lead Scanning
- Keyword-based Google Maps search via Apify
- Location-based filtering with fuzzy matching
- Automatic query optimization using AI
- Fallback to broader queries when no results found

### Lead Qualification
Companies are automatically scored based on:
- **PageSpeed < 50** - Performance improvement opportunity
- **No SSL** - Security upgrade needed
- **WordPress site** - Customization/plugin opportunity
- **No existing AI agents** - Sales opportunity for Quack

### Decision Maker Enrichment
- AI-powered web search using Gemini with grounding
- Extracts CEO, Founder, CTO, Marketing Director contacts
- Includes LinkedIn profile URLs when available

### Email Drafting
- Personalized cold emails based on contact and company data
- Product matching based on industry (Colectia, Quack, Maestro)
- Context-aware messaging referencing detected tech stack

## Project Structure

```
dantalabs-pipeline-v2-python/
├── app/                          # Next.js App Router
│   ├── api/                      # API route handlers (proxies to Python)
│   │   ├── scan/route.ts
│   │   ├── enrich/route.ts
│   │   └── draft/route.ts
│   ├── companies/[id]/page.tsx   # Company detail page
│   └── page.tsx                  # Main dashboard
├── backend/                      # Python FastAPI backend
│   ├── routers/                  # API endpoints
│   │   ├── scan.py              # Lead scanning logic
│   │   ├── enrich.py            # Contact enrichment
│   │   ├── draft.py             # Email drafting
│   │   └── contacts.py          # Contact management
│   ├── services/
│   │   └── gemini.py            # Gemini AI client
│   └── utils/
│       ├── scraper.py           # Website content extraction
│       └── tech_detector.py     # Technology stack detection
├── src/
│   ├── components/              # React components
│   └── lib/                    # Utilities & Supabase client
├── docs/                       # Technical documentation
└── examples/                   # Sample data
```

## API Reference

### POST /api/scan
Initiates a lead scan with keyword and optional location.

```json
{
  "keyword": "Real Estate",
  "location": "Ho Chi Minh City",
  "limit": 5
}
```

### POST /api/enrich
Enriches a company with decision maker information.

```json
{
  "companyId": "uuid",
  "companyName": "Acme Corp"
}
```

### POST /api/draft
Generates a personalized cold email draft.

```json
{
  "contactName": "John Smith",
  "position": "CEO",
  "companyName": "Acme Corp",
  "website": "https://acme.com",
  "industry": "Technology",
  "hasSSL": true,
  "pageSpeed": 45
}
```

## Cost Estimation

| Component | Cost Model | Est. Per Lead |
|-----------|------------|---------------|
| Apify Crawler | Per run | $0.10 - $0.50 |
| Gemini API | Per token | $0.001 - $0.01 |
| PageSpeed API | Per request | $0.005 |
| Supabase | Usage-based | $0.001 |

**Total estimated cost per lead: $0.01 - $0.05**

## Documentation

- [Architecture Overview](docs/architecture.md)
- [Lead Qualification Policy](docs/decision-policy.md)
- [Security & Risk Assessment](docs/security-and-risk.md)

## Financial & Private Equity Extensions

This pipeline can be extended for **Finance, Merchant Banking, and Private Equity** use cases.

### Target Environments

| Environment | Key Focus | Data Needs |
|-------------|-----------|------------|
| **Merchant Bank** | M&A advisory, capital raising | Company financials, deal flow |
| **Private Equity** | Portfolio management, due diligence | Operational metrics, exits |
| **Investment Bank** | IPO, debt restructuring | Market data, valuations |
| **Venture Capital** | Startup investing | Funding rounds, traction |

### Extension Modules

| Module | Purpose | Data Sources |
|--------|---------|-------------|
| `financial_scraper` | Extract financials from public filings | SEC EDGAR, annual reports |
| `due_diligence` | AI-powered DD checklist & scoring | Company websites, news |
| `deal_sourcing` | Identify acquisition targets | Google Maps, Crunchbase |
| `portfolio_tracker` | Monitor portfolio company health | Job listings, news, reviews |
| `valuation_model` | AI-assisted DCF/comps analysis | Market data APIs |

### Example Use Cases

```
# 1. Due Diligence Automation
POST /api/dd/company
Input: { "company_name": "Target Corp" }
Output: { "financials": {...}, "news_sentiment": "...", "risk_score": 0.85 }

# 2. Deal Sourcing
POST /api/scan/deals
Input: { "sector": "SaaS", "revenue_min": 5_000_000, "location": "Southeast Asia" }
Output: { "companies": [...], "enrichment": {...} }

# 3. Portfolio Monitoring
POST /api/monitor/portfolio
Input: { "portfolio_ids": [...] }
Output: { "health_scores": [...], "alerts": [...] }
```

## 20in20 Financial Projects

### Core Modules to Build

| # | Module | Purpose | Priority |
|---|--------|---------|----------|
| 1 | `sec_scraper` | Fetch 10-K, 10-Q, 8-K from SEC EDGAR | High |
| 2 | `financial_parser` | Parse income statement, balance sheet, cash flow | High |
| 3 | `stock_api` | Real-time quotes from Yahoo Finance / Alpha Vantage | High |
| 4 | `news_aggregator` | Collect financial news by ticker/industry | Medium |
| 5 | `sentiment_analyzer` | AI sentiment scoring for news & reports | Medium |
| 6 | `competitor_map` | Map competitors by industry & metrics | Medium |
| 7 | `deal_radar` | Track M&A activity, IPO filings | Medium |
| 8 | `esg_scorer` | Rate companies on ESG criteria | Low |
| 9 | `export_engine` | Export to PDF/Excel pitch deck format | Low |
| 10 | `alert_system` | Monitor portfolio & send notifications | Low |

### Data Sources

| Source | Data Type | API/Method |
|--------|-----------|------------|
| SEC EDGAR | 10-K, 10-Q, 8-K, S-1 | Free XML/JSON |
| Yahoo Finance | Prices, fundamentals, historical | yfinance (Python) |
| Alpha Vantage | Stock data, FX, crypto | Free API key |
| Crunchbase | Funding, revenue, team | Paid API |
| LinkedIn | Company size, growth | Scraping (careful) |
| Glassdoor | Salaries, reviews, culture | Scraping |
| Google News | Financial news, press releases | RSS/API |

### Project Roadmap

```python
# Week 1: Core Financial Data
# - Day 1-2: SEC EDGAR scraper
# - Day 3-4: Financial statement parser
# - Day 5: Integration with existing scraper

# Week 2: Market Intelligence  
# - Day 6-7: Stock API integration
# - Day 8-9: News aggregation
# - Day 10: Sentiment analysis

# Week 3: Deal Flow
# - Day 11-12: Competitor mapping
# - Day 13-14: M&A radar
# - Day 15: Deal scoring model

# Week 4: Output & Polish
# - Day 16-17: Export engine (PDF/Excel)
# - Day 18-19: Alert system
# - Day 20: UI dashboard
```

## License
