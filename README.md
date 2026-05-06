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

## License

MIT License - See LICENSE file for details.
