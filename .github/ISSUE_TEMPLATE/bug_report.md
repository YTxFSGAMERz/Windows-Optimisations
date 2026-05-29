---
name: "🚨 System Anomaly Report"
about: "Submit a technical anomaly or kernel diagnostic report"
title: "[BUG] - "
labels: ["bug"]
assignees: []
---

```ini
========================================================================
                     WinAurex SYSTEM ANOMALY REPORT
========================================================================
[ ANOMALY ID ] : AUTO-GENERATED
[ ENGINE STAT ] : FAULT DETECTED
========================================================================
```

### 🔴 1. ANOMALY IDENTIFIER
> Provide a concise, technical description of the unexpected behavior.

### ⚙️ 2. SYSTEM TELEMETRY
*Please populate your current physical/virtual node parameters:*
- **Windows OS Build:** `[e.g., Windows 11 Pro 23H2 (22631.3527)]`
- **CPU Architecture:** `[e.g., AMD Ryzen 7 5800X / Intel Core i7-13700K]`
- **System Memory:** `[e.g., 32 GB DDR4 3600MHz]`
- **Target OS Storage Drive:** `[e.g., NVMe Gen 4 SSD / SATA SSD]`
- **Active Profile Applied:** `[e.g., Desktop-Ultra / Gaming-Min-Latency / Default]`

### 📡 3. DIAGNOSTIC LOGS / TELEMETRY
> Provide any command line output, event log errors, or script failures. Wrap code in blocks.
```powershell
# Insert terminal output here if applicable
```

### 🎯 4. EXPECTED VS. ACTUAL STATE
**Expected Execution Blueprint:**
> What should the framework have successfully executed?

**Observed State Deviation:**
> What actually occurred? (Include screenshots of errors, dashboard issues, or high latency).

### 🔄 5. RECOVERY MANIFEST (CRITICAL)
- Did you run the **Rollback Engine** (`Launch_Dashboard.ps1` -> Option 7 or direct rollback script)?
  - `[ ] YES, System reverted perfectly`
  - `[ ] YES, but some changes persisted`
  - `[ ] NO, I have not attempted recovery yet`
- If recovery failed, specify which module did not revert:
  - `[e.g., Advanced HPET scheduler did not restore default Windows values]`
