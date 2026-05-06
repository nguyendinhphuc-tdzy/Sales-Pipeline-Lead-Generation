# Architecture Overview

## System Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                           USER INTERFACE                                │
│                     (Next.js 16 - Vercel)                              │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │  Dashboard  │  │   Company   │  │  Analytics  │  │   Scan UI   │     │
│  │    View     │  │   Detail    │  │   Charts    │  │   Dialog    │     │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘     │
└─────────┼────────────────┼────────────────┼────────────────┼───────────┘
          │                │                │                │
          │                │                │                │
          ▼                ▼                ▼                ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                        API PROXY LAYER                                 │
│                     (Next.js Route Handlers)                            │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐                      │
│  │  /api/scan  │  │ /api/enrich │  │  /api/draft │                      │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘                      │
└─────────┼────────────────┼────────────────┼─────────────────────────────┘
          │                │                │
          │ HTTP POST       │ HTTP POST       │ HTTP POST
          │                │                │
          ▼                ▼                ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                      BACKEND API LAYER                                  │
│                     (Python FastAPI)                                    │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │  /scan      │  │  /enrich    │  │  /draft     │  │ /contacts   │     │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘     │
└─────────┼────────────────┼────────────────┼────────────────┼─────────────┘
          │                │                │                │
          ▼                ▼                ▼                ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                          AI SERVICES                                    │
│  ┌─────────────────────────────────────────────────────────────────┐    │
│  │                      Gemini 2.5 Flash                           │    │
│  │  • Query Optimization (temperature=0.1)                        │    │
│  │  • Decision Maker Search (with web grounding)                  │    │
│  │  • Email Draft Generation (temperature=0.3)                    │    │
│  └─────────────────────────────────────────────────────────────────┘    │
│  ┌─────────────────────────────────────────────────────────────────┐    │
│  │                    Google PageSpeed API                         │    │
│  │  • Mobile performance scoring                                   │    │
│  └─────────────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────────────┘
          │                │
          ▼                ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                           DATA LAYER                                    │
│  ┌──────────────────────┐    ┌──────────────────────┐                  │
│  │   Apify Actor         │    │    Supabase           │                  │
│  │   (Google Places)     │    │    (PostgreSQL)       │                  │
│  │   compass/crawler-    │    │    • companies table  │                  │
│  │    google-places      │    │    • contacts table   │                  │
│  └──────────────────────┘    └──────────────────────┘                  │
└─────────────────────────────────────────────────────────────────────────┘
```

## Data Flow

### Lead Scanning Flow

```
User Input
    │
    ▼
┌─────────────────┐
│ ScanDialog.tsx  │
│ keyword: string │
│ location: string│
└────────┬────────┘
         │ POST /api/scan
         ▼
┌─────────────────┐
│ route.ts        │
│ (proxy)         │
└────────┬────────┘
         │ POST /scan
         ▼
┌─────────────────┐     ┌─────────────────┐
│ GeminiClient    │────▶│ optimize_search │
│ .optimize_      │     │ _term()         │
│ search_term()   │     └────────┬────────┘
└────────┬────────┘              │
         │ optimized_query       │
         ▼                       │
┌─────────────────┐               │
│ ApifyClient     │◀──────────────┘
│ compass/        │
│ crawler-google- │
│ places          │
└────────┬────────┘
         │ raw results
         ▼
┌─────────────────┐     ┌─────────────────┐
│ TechDetector    │────▶│ detect()        │
│ .detect()       │     │ - CMS detection│
└────────┬────────┘     │ - Frontend      │
         │ tech_stack   │ - Agents        │
         ▼              └─────────────────┘
┌─────────────────┐
│ WebsiteScraper  │
│ .scrape()       │
└────────┬────────┘
         │ emails, socials, description
         ▼
┌─────────────────┐     ┌─────────────────┐
│ Qualification   │────▶│ is_qualified =  │
│ Logic          │     │   is_slow OR    │
│                │     │   not has_ssl OR│
│                │     │   is_wordpress  │
│                │     │   OR            │
│                │     │   not has_agent │
└────────┬────────┘     └─────────────────┘
         │ qualified companies
         ▼
┌─────────────────┐
│ Supabase        │
│ companies.insert│
└─────────────────┘
```

### Decision Maker Enrichment Flow

```
User clicks "Find Decision Makers"
    │
    ▼
┌─────────────────┐
│ EnrichButton    │
└────────┬────────┘
         │ POST /api/enrich
         ▼
┌─────────────────┐
│ route.ts        │
└────────┬────────┘
         │ POST /enrich
         ▼
┌─────────────────┐     ┌─────────────────────────┐
│ GeminiClient    │────▶│ generate_with_search()  │
│                 │     │ - Tool: google_search   │
│                 │     │ - Temperature: 0.3       │
└────────┬────────┘     └──────────┬──────────────┘
         │ contact data            │ Web-grounded results
         ▼                        │
┌─────────────────┐               │
│ clean_and_parse │◀──────────────┘
│ _json()         │
└────────┬────────┘
         │ parsed_contacts
         ▼
┌─────────────────┐
│ Supabase        │
│ contacts.insert │
└─────────────────┘
```

## Database Schema

### companies table

| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Primary key |
| name | TEXT | Company name |
| website_url | TEXT | Company website |
| google_maps_url | TEXT | Google Maps listing URL |
| industry | TEXT | Business category |
| address | TEXT | Physical address |
| phone | TEXT | Contact phone |
| has_ssl | BOOLEAN | SSL certificate present |
| pagespeed_score | INTEGER | Mobile PageSpeed (0-100) |
| is_wordpress | BOOLEAN | WordPress CMS detected |
| crm_system | TEXT | Detected CRM (HubSpot, Salesforce, etc.) |
| tech_stack | JSONB | Detected technologies |
| emails | TEXT[] | Scraped email addresses |
| socials | JSONB | Social media links |
| description | TEXT | Website meta description |
| status | TEXT | "QUALIFIED" or "DISQUALIFIED" |
| disqualify_reason | TEXT | Reason if not qualified |
| search_keyword | TEXT | Original search query |
| created_at | TIMESTAMP | Record creation time |

### contacts table

| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Primary key |
| company_id | UUID | Foreign key to companies |
| full_name | TEXT | Contact name |
| position | TEXT | Job title |
| linkedin_url | TEXT | LinkedIn profile URL |
| email | TEXT | Email address (usually null) |
| is_primary_decision_maker | BOOLEAN | AI assessment |
| seniority | TEXT | C-Level, VP, Manager |
| years_in_company | TEXT | Tenure information |
| status | TEXT | Contact status |

## Security Architecture

### Authentication
- Supabase Auth with magic link / OAuth
- Row Level Security (RLS) policies on tables
- Anon key for client, service role for backend

### API Security
- CORS configured for known origins only
- Environment variables for all secrets
- No secrets in client-side code

### Data Protection
- HTTPS enforced everywhere
- SSL verification disabled only for internal scrapers
- Rate limiting at API gateway level (Vercel Pro)

## Scalability Considerations

### Current Limitations
- Sequential processing of scraped websites
- Single Apify actor instance per scan
- Synchronous Gemini calls

### Scaling Strategies
- Webhook-based async processing for large scans
- Batch processing with queue (Redis/BullMQ)
- Parallel tech detection with asyncio
- Gemini API batching for multiple enrichment calls
