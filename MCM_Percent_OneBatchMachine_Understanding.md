# MCM Slot Percent — "Double Resource" / One-Batch-Machine — Analysis (NO CHANGES YET)

**Build:** `Mqm_8_0_4_build_1.4.1.3 double resource percent control`
**Status:** ✅ IMPLEMENTED 2026-06-03 (rule confirmed by Avi). Not yet compiled/tested.
**Date:** 2026-06-03

> Supersedes the earlier machine-parts-within-one-WC theory. The real mechanism is the
> **"one batch machine by group code"** feature on the **resource**.

---

## The mechanism ("double resource")

A work center contains **two resources, A and B** ("double resource"). The two resources
are linked as a **one-batch-machine group** via the resource field
`fli_WorkAsOneBatchMachineGroupCode` (same code on both). At load
(`UMPlan.pas:2127-2151`), each resource gets a pointer to its partner:
`Res.P_rscOfBatchMachinSameGrpCode := <the other resource with the same group code>`
and `p_ONE_BATCH_MACHINE_By_GROUP_CODE := true`.

The group **type** comes from `fli_OneBatchMachineGrouptype` (`UMPlan.pas:2051-2061`):
`COneBatchMachineGroupType = (Non_typ, Qty_typ, process_typ)` (`UMRes.pas:24`)
- `'1'` → **`Qty_typ`**  ← **the customer's setting**
- `'2'` → **`process_typ`** ← also needs the fix; uses the WC `CUseMachineParts` definition
- (a non-empty group code with no type defaults to `Qty_typ`, `UMPlan.pas:2060`)

### The scheduling control (works fine today)
`TMqmRes.CheckDatesOnOneBatchMachineByGroupCode` (`UMRes.pas:2757`):
- Looks at the **partner** resource B's spots over the job's period
  (`FindSchedInSpots`).
- **`Qty_typ`** → `CheckMaxQtyOnBatchMachinSameGrpCode` (combined max batch across A+B).
- **`process_typ`** → `CheckUsedAllMachinePartsProcessOnBatchMachinSameGrpCode`
  (`UMRes.pas:1980`), which uses `WrkCtr.GetUseAllMachinePartsByProcess(proc)` →
  `CUseMachineParts = (Mp_Non, Mp_All, Mp_RearPart, Mp_FrontPart)`. Blocks UNLESS one job
  is `Mp_RearPart` and the other `Mp_FrontPart` (the only true-parallel case).
- When blocked, the user **cannot** schedule on B for that period.

So: schedule a job on A for a period → partner B is **blocked** for that period.
This already works. **Only the percentage is wrong.**

---

## Why the percentage is 50% instead of 100%

`BuildWkcDailyCapacity` (`UMPlan.pas:~709-812`) builds the WC daily capacity by iterating
**all visible resources**; `WrkCtr := res.p_father`. Because A and B are **two separate
resources in the same WC**:

- **Available** (`AddHoursAvailableToWkcCapacity`): added for **both** A and B
  (the multi-res `MultiResList` dedup applies only to `Res.p_isMultiRes`, NOT to two
  separate resources). → WC available = `A_hours + B_hours` (≈ 2×).
- **Used** (`AddIdToWkcDailyCapacityList`, `UMWkCtr.pas:931-945`): a job on A adds only
  `A`'s hours. → used ≈ 1×.

Percent = used / available = `1× / 2×` = **50%**.

The capacity math never learns that scheduling on A **blocked B**. The blocked partner
capacity is missing from "used", so a fully-occupied double-resource shows 50%.

---

## Proposed fix (matches the existing multi-res pattern)

In `AddIdToWkcDailyCapacityList`, when the resource is in a one-batch-machine group **and
the job occupies the whole group**, multiply the day's `HoursUsed` by the **group size
(2 for a pair)** — exactly the way multi-res already multiplies by `NeededComponents`
(`UMWkCtr.pas:939`). Because available is already the natural `A+B` sum (2×), doubling the
used yields **100%**.

### When does a job "occupy the whole group"? (mirror the control's own logic)
- **`Qty_typ`** → **always** (a batch occupies the combined machine) → ×2.
- **`process_typ`** → only when the job's process resolves to **`Mp_All`** (uses the whole
  machine, blocks the partner) → ×2.
  - `Mp_RearPart` / `Mp_FrontPart` jobs occupy only their half; the partner can still run
    the complementary part in parallel → leave at 50% (already correct, **no change**).

### Why ×2 (doubling used) is correct in all cases — worked examples
*(A and B identical parallel machines; WC available = A+B.)*
| Scenario | used (today) | available | today | doubled used | fixed |
|---|---|---|---|---|---|
| 1 job on A, full week | 40h | 80h | 50% | 80h | **100%** ✓ |
| 1 job on A, 4h of 8h day | 4h | 16h | 25% | 8h | **50%** ✓ (machine busy half the day) |
| A 8-12 + B 13-17 (non-overlap) | 8h | 16h | 50% | 16h | **100%** ✓ |
| process_typ: A=Rear + B=Front parallel | 16h | 16h | 100% | (not doubled) | **100%** ✓ |
| process_typ: lone Rear job on A | 4h | 16h | 25% | (not doubled) | **25%** ✓ (front still free) |

Doubling is the right factor because the partner's blocked hours equal the job's own hours
on an identical parallel machine, and available is already counted for both machines.

---

## Open points to confirm before coding

1. **Same work center?** The fix assumes A and B are two resources **in the same WC**
   (that's what makes available = A+B and the slot read 50%). Confirm the "double
   resource" is one WC holding the linked pair. *(If they were in different WCs the slot
   math would already be per-resource and 50% wouldn't occur.)*
2. **Group size = 2 (pair)?** Setup stores a single partner
   (`P_rscOfBatchMachinSameGrpCode`), so factor = 2. If a group can legitimately have >2
   machines, we should count members sharing the group code instead of hard-coding 2.
3. **Rule confirmation:** `Qty_typ` → always full; `process_typ` → full only for `Mp_All`,
   leave `Front`/`Rear` at per-part. Agree?

---

## Files in scope (when we implement)

| File | Why |
|------|-----|
| `mqm\plan\UMWkCtr.pas` | `AddIdToWkcDailyCapacityList` — multiply used by group size when job occupies whole group. (Possibly `GetHintDataForPrdDailyCap` for the hover %.) |
| `mqm\plan\UMRes.pas` | source of `P_rscOfBatchMachinSameGrpCode`, `p_GROUP_TYPE_FOR_ONE_BATCH_MACHINE`, `GetUseAllMachinePartsByProcess`, the block-check helpers |
| `mqm\plan\UMPlan.pas` | (reference) load of group code/type + partner wiring; capacity build driver |

No change to the scheduling control itself — it already works. The change is **display
percentage only**.

---

## ✅ What was implemented (2026-06-03)

**Single file changed:** `mqm\plan\UMWkCtr.pas` → `TMqmWrkCtr.AddIdToWkcDailyCapacityList`.

After the job's daily `HoursUsed` is added to `DailyCapacity.Hours_Used`, a new block adds
the **blocked partner's working hours** for the same daily window, so the slot reads the
true occupancy:

```pascal
OBMRes := TMQMRes(ActArea.p_Res);
OBMPartner := OBMRes.P_rscOfBatchMachinSameGrpCode;
if Assigned(OBMPartner)
   and (TMqmWrkCtr(OBMPartner.p_father) = Self)   // partner shares THIS WC's capacity
   and (OBMPartner.p_PlanType = RPT_Real)          // partner is in the WC available sum
   and (OBMPartner.p_VisResCount > 0) then
begin
  OccupiesWholeGroup := false;
  case OBMRes.p_GROUP_TYPE_FOR_ONE_BATCH_MACHINE of
    Qty_typ:     OccupiesWholeGroup := true;
    process_typ: begin
                   p_sc.GetFldValue(Id, CSC_WkctProc, procVal, dataType);
                   OccupiesWholeGroup := (GetUseAllMachinePartsByProcess(procVal) = Mp_All);
                 end;
  end;
  if OccupiesWholeGroup then
  begin
    PartnerActArea := TMqmActArea(OBMPartner.p_VisRes[0].p_ActArea[0]);
    PartnerCal := PartnerActArea.GetCalendar;
    if (trunc(DateSchedEnd) = Trunc(CurrentDate)) then
      BlockedHours := PartnerCal.DiffWHNotRounded(CurrentDate, DatesInfo.endDate, PartnerActArea.m_CrossDownTmList)
    else
      BlockedHours := PartnerCal.DiffWHNotRounded(CurrentDate, trunc(CurrentDate + 1), PartnerActArea.m_CrossDownTmList);
    if BlockedHours > 0 then
      DailyCapacity.Hours_Used := DailyCapacity.Hours_Used + BlockedHours;
  end;
end;
```

### Why this exact shape
- **Adds the partner's *actual* hours** (not a blind ×2) → exact 100% even if A and B have
  different calendars. For identical machines it equals the job's own hours (the ×2 case).
- **Bumps only the day total** (`DailyCapacity.Hours_Used`), NOT `JobCapacity.JobHours` /
  `qty` → per-job quantities and the hover-hint job list stay accurate. The qty math
  (`HypoteticalExe`/`ExeTime`) is left on the real hours.
- **Three guards prevent over-counting / >100%:**
  1. `OBMPartner.p_father = Self` — only when the partner is in this very WC (so available
     already includes B). If B is elsewhere, this WC's available = A only and is already
     correct.
  2. `p_PlanType = RPT_Real` — only when B's capacity is actually in the available sum
     (`UMPlan.pas:799` skips non-real).
  3. `BlockedHours > 0` — no-op on non-working days.
- Flows automatically into BOTH the slot % (`GetDataForPrdDailyCap`) and the hover %
  (`GetHintDataForPrdDailyCap`) because both read `m_WkcDailyCapacityList`.

### Symbols verified in scope (Delphi 11)
`CSC_WkctProc`, `CScResPlanType`/`RPT_Real` ← `UMSchedContFunc` (in uses);
`Qty_typ`/`process_typ`, `P_rscOfBatchMachinSameGrpCode`, `p_GROUP_TYPE_FOR_ONE_BATCH_MACHINE`,
`p_PlanType`, `p_VisResCount`, `p_VisRes[0].p_ActArea[0]` ← `UMRes` (in uses, same pattern as
`CheckDatesOnOneBatchMachineByGroupCode`); `GetUseAllMachinePartsByProcess`/`Mp_All` ←
own class / same unit.

### Still to do
- Compile (Delphi 11, `/p:Platform=Win64` per IBX note) and test with the customer's
  Qty_typ double-resource WC; verify a single weekly job now shows 100%, and that a
  process_typ Front/Rear parallel pair still reads correctly.
