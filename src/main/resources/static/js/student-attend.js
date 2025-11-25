(function () {
    const ABSENCE_FAIL_THRESHOLD = 0.25; // 25% absence -> F
    const TARDY_TO_ABSENCE = 3;          // 3 tardies = 1 absence

    const loadingEl = document.getElementById("attend-loading");
    const errorEl = document.getElementById("attend-error");
    const contentEl = document.getElementById("attend-content");
    const listEl = document.getElementById("attend-list");
    const attendRateText = document.getElementById("attend-rate-text");
    const attendRateBar = document.getElementById("attend-rate-bar");
    const tardyCountText = document.getElementById("tardy-count-text");
    const tardyRateBar = document.getElementById("tardy-rate-bar");
    const absenceCountText = document.getElementById("absence-count-text");
    const absenceRateBar = document.getElementById("absence-rate-bar");

    function clampPct(value) {
        return Math.min(100, Math.max(0, value || 0));
    }

    function showLoading(show) {
        loadingEl.style.display = show ? "block" : "none";
    }

    function showError(msg) {
        errorEl.textContent = msg;
        errorEl.classList.remove("d-none");
        contentEl.classList.add("d-none");
    }

    function hideError() {
        errorEl.classList.add("d-none");
    }

    function badge(code) {
        if (code === "1") return '<span class="badge bg-success">출석</span>';
        if (code === "2") return '<span class="badge bg-warning text-dark">지각</span>';
        if (code === "0") return '<span class="badge bg-danger">결석</span>';
        return '<span class="badge bg-secondary">Unknown</span>';
    }

    function formatDate(index, baseDate) {
        if (!baseDate || baseDate.length < 8) return "";

        const initDate = new Date(
            baseDate.substring(0, 4),
            baseDate.substring(4, 6) - 1,
            baseDate.substring(6, 8)
        );
        initDate.setDate(initDate.getDate() + (7 * index));

        const year = initDate.getFullYear();
        const month = String(initDate.getMonth() + 1).padStart(2, "0");
        const day = String(initDate.getDate()).padStart(2, "0");

        return `${year}.${month}.${day}`;
    }

    function buildSummary(list, summaryFromServer) {
        const total = summaryFromServer?.total ?? list.length ?? 0;
        const attendCount = summaryFromServer?.attendCount ?? list.filter(r => r.atendSttusCode === "1").length;
        const lateCount = summaryFromServer?.lateCount ?? list.filter(r => r.atendSttusCode === "2").length;
        const rawAbsentCount = summaryFromServer?.rawAbsentCount ?? list.filter(r => (r.atendSttusCode !== "1" && r.atendSttusCode !== "2")).length;
        const tardyAsAbsence = summaryFromServer?.tardyAsAbsence ?? Math.floor(lateCount / TARDY_TO_ABSENCE);
        const adjustedAbsentCount = summaryFromServer?.absentCount ?? (rawAbsentCount + tardyAsAbsence);
        const absenceThreshold = summaryFromServer?.absenceThreshold ?? (total * ABSENCE_FAIL_THRESHOLD);
        const attendanceRate = summaryFromServer?.attendanceRate ?? (total === 0 ? 0 : (attendCount * 100) / total);
        const absenceRate = summaryFromServer?.absenceRate ?? (absenceThreshold === 0 ? 0 : Math.min(100, (adjustedAbsentCount * 100) / absenceThreshold));

        return {
            total,
            attendCount,
            lateCount,
            rawAbsentCount,
            tardyAsAbsence,
            absentCount: adjustedAbsentCount,
            absenceThreshold,
            attendanceRate,
            absenceRate
        };
    }

    function render(data, summary) {
        const attendCount = summary.attendCount || 0;
        const lateCount = summary.lateCount || 0;
        const absentCount = summary.absentCount || 0;
        const tardyAsAbsence = summary.tardyAsAbsence || 0;
        const total = summary.total || 0;
        const attendance = clampPct(summary.attendanceRate);
        const absence = clampPct(summary.absenceRate);
        const tardyProgress = clampPct((lateCount * 100) / TARDY_TO_ABSENCE);
        const absenceDenominator = summary.absenceThreshold || total;

        attendRateText.textContent = attendance.toFixed(1) + "%";
        attendRateBar.style.width = attendance + "%";
        attendRateBar.setAttribute("aria-valuenow", attendance.toString());

        if (tardyCountText && tardyRateBar) {
            tardyCountText.textContent = `지각 ${lateCount} (결석횟수 + ${tardyAsAbsence})`;
            tardyRateBar.style.width = tardyProgress + "%";
            tardyRateBar.setAttribute("aria-valuenow", tardyProgress.toString());
        }

        const absenceCountDenominator = Math.max(1, Math.round(absenceDenominator));
        absenceCountText.textContent = absentCount + " / " + absenceCountDenominator;
        absenceRateBar.style.width = absence + "%";
        absenceRateBar.setAttribute("aria-valuenow", absence.toString());

        listEl.innerHTML = "";
        if (!data.length) {
            const empty = document.createElement("div");
            empty.className = "list-group-item text-muted";
            empty.textContent = "No attendance records.";
            listEl.appendChild(empty);
        } else {
            data.forEach((row, i) => {
                const item = document.createElement("div");
                item.className = "list-group-item d-flex align-items-center justify-content-between";

                const left = document.createElement("div");
                left.className = "d-flex flex-column";
                const week = document.createElement("span");
                week.className = "fw-semibold";
                week.textContent = (i + 1) + "주차";
                const std = document.createElement("span");
                std.className = "text-muted small";
                std.textContent = formatDate(i, row.lctreDe);
                left.appendChild(week);
                left.appendChild(std);

                const right = document.createElement("div");
                right.innerHTML = badge(String(row.atendSttusCode));

                item.appendChild(left);
                item.appendChild(right);
                listEl.appendChild(item);
            });
        }

        contentEl.classList.remove("d-none");
    }

    function fetchAttend() {
        const estbllctreCode = new URLSearchParams(window.location.search).get("lecNo") || "";
        if (!estbllctreCode) {
            showError("Lecture info is missing.");
            return;
        }

        showLoading(true);
        hideError();
        fetch("/learning/student/attend?estbllctreCode=" + encodeURIComponent(estbllctreCode))
            .then(resp => resp.json().then(body => ({ resp, body })))
            .then(({ resp, body }) => {
                if (!resp.ok) {
                    const msg = (body && body.message) ? body.message : ("Failed to load attendance. (" + resp.status + ")");
                    throw new Error(msg);
                }
                const payload = body || {};
                const list = payload.data || (Array.isArray(body) ? body : []);
                const summary = buildSummary(list, payload.summary);
                render(list, summary);
            })
            .catch(err => showError(err.message || "Failed to load attendance."))
            .finally(() => showLoading(false));
    }

    document.addEventListener("DOMContentLoaded", fetchAttend);
})();
