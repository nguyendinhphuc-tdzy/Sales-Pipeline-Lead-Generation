# MASTER PROMPT CONTEXT (Reusable)
## For Project Analysis -> Refactor -> GitHub Showcase (20in20 Partners)

Copy this prompt into a new chat for each project and replace placeholders.

---

## 1) Project Context
I am preparing project portfolios for an AI Automation Intern application at 20in20 Partners (merchant bank focused on advising and investing in Vietnam's emerging champions, strong in Private Equity).

I need each project to be:
- technically accurate,
- presentation-ready for non-technical + technical reviewers,
- sanitized for public GitHub,
- easy to hand over.

Project name: `<PROJECT_NAME>`
Project folder: `<PROJECT_FOLDER_PATH>`
Main workflow/system files: `<KEY_FILES>`
Current status: `<DRAFT / WORKING / NEEDS_REWRITE>`

---

## 2) Your Role
Act as my technical analyst + documentation engineer + GitHub packaging assistant.

You must:
1. Analyze the real implementation from code/workflow files first.
2. Validate whether current docs match actual behavior.
3. Rewrite documentation in a clear showcase format.
4. Identify risks, inaccuracies, and upgrade opportunities.
5. Prepare repo files for public-safe GitHub publication.

---

## 3) Required Deliverables
Please produce all items below:

### A. Deep Technical Analysis
- End-to-end architecture and data flow.
- Core logic and decision/routing rules.
- Reliability mechanisms (dedup, retries, fallback, error handling).
- Security risks and operational risks.
- Scalability assessment.

### B. Documentation Rewrite
- A complete architecture/technical document.
- A concise `README.md` for portfolio reviewers.
- A clear “business value” section for stakeholders.

### C. Upgrade Strategy
- Short-term fixes (must-fix before sharing).
- Mid-term improvements (scalability and maintainability).
- Optional advanced roadmap (model strategy, observability, governance).

### D. Public GitHub Readiness
- Sanitize secrets/tokens/IDs/tenant-specific links.
- Add/verify `.gitignore`.
- Add a publish checklist.
- Prepare a clean repository structure for showcase.

---

## 4) Mandatory Evaluation Topics
For each project, explicitly evaluate:
- Detail and accuracy level of existing docs.
- Whether workflow behavior matches stated goals.
- Scalability for multi-channel and larger team usage.
- Model portability (e.g., Gemini -> Claude or other providers).
- Data/storage alternatives (e.g., Sheets vs DB vs knowledge tools).
- Current duplication and hallucination prevention controls.
- Estimated cost per execution (assumptions + range).

---

## 5) Output Format
Please respond in this structure:
1. **Findings (critical issues first)**
2. **What is already good**
3. **Rewritten docs/files created**
4. **Upgrade roadmap**
5. **GitHub publish status/checklist**
6. **Next actions for me**

Keep explanations concise but complete. Prioritize practical recommendations.

---

## 6) Working Rules
- Do not skip file-level analysis.
- Do not assume behavior without reading workflow/code.
- Do not include secrets in output files.
- If something is uncertain, state assumptions clearly.
- Prefer creating/editing real files over only suggesting.

---

## 7) Repository Structure Target
Use this structure when appropriate:
- `README.md`
- `docs/architecture.md`
- `docs/decision-policy.md`
- `docs/security-and-risk.md`
- `workflows/<workflow-export>.json` (sanitized)
- `examples/sample-input-output.json`
- `assets/architecture-diagram.png` (optional)
- `.gitignore`
- `GITHUB_PUBLISH_CHECKLIST.md`

---

## 8) Inputs for This Run
Files to analyze:
- `<FILE_1>`
- `<FILE_2>`
- `<FILE_3>`

Main objective for this run:
`<WHAT_I_WANT_DONE_NOW>`

Constraints:
- `<TIME_CONSTRAINT>`
- `<CONFIDENTIALITY_CONSTRAINT>`
- `<STACK/TOOL_CONSTRAINT>`

---

## 9) Final Request
Start by reading all provided files, then perform analysis, then implement required file updates directly in the project folder.
