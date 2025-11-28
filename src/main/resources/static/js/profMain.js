const statusLabel = { "1": "출석", "2": "지각", "3": "조퇴" };
const mapStatus = code => statusLabel[code] || "결석";
const toggle = (el, show) => el?.classList.toggle("d-none", !show);

const todayStr = () => new Date().toISOString().slice(0, 10);
const shiftDate = (iso, delta) => {
    const d = new Date(iso);
    d.setDate(d.getDate() + delta);
    return d.toISOString().slice(0, 10);
};
const normalizeDate = raw => {
    if (!raw) return "";
    const cleaned = raw.replace(/[.\s]/g, "-");
    if (cleaned.includes("-")) return cleaned.slice(0, 10);
    if (cleaned.length === 8) return `${cleaned.slice(0, 4)}-${cleaned.slice(4, 6)}-${cleaned.slice(6, 8)}`;
    if (cleaned.length === 6) return `20${cleaned.slice(0,2)}-${cleaned.slice(2,4)}-${cleaned.slice(4,6)}`
    return cleaned;
};
const toISODate = val => {
    const norm = normalizeDate(val);
    const d = new Date(norm);
    return isNaN(d) ? todayStr() : d.toISOString().slice(0, 10);
};
const formatLabel = iso => {
    const norm = normalizeDate(iso);
    if (norm.length < 10) return norm || "";
    const [y, m, d] = norm.split("-");
    return `${y}. ${m}. ${d}`;
};

document.addEventListener("DOMContentLoaded", () => {
    const root = document.querySelector("#prof-main");
    if (!root) return;

    const lecNo = root.dataset.lecNo || new URLSearchParams(location.search).get("lecNo") || "";
    const tabButtons = root.querySelectorAll("[data-tab-target]");
    const tabPanes = root.querySelectorAll(".learning-tab-pane");

    const loader = document.querySelector("#attendance-loader");
    const empty = document.querySelector("#attendance-empty");
    const gridNode = document.querySelector("#attendance-grid");
    const status = document.querySelector("#attendance-status");

    const prevBtn = document.querySelector("#attendance-prev");
    const nextBtn = document.querySelector("#attendance-next");
    const dateLabel = document.querySelector("#attendance-date");
    const datePicker = document.querySelector("#attendance-date-picker");
    const calendarBtn = document.querySelector("#attendance-calendar-btn");

    const state = {
        attendanceLoaded: false,
        attendDate: todayStr(),
        allRows: []
    };

    const updateDateLabel = () => {
        state.attendDate = toISODate(state.attendDate);
        if (dateLabel) dateLabel.textContent = formatLabel(state.attendDate);
        if (datePicker) datePicker.value = state.attendDate;
    };

    const formatStatusBadge = code => {
        const txt = mapStatus(code);
        const cls = code === "1" ? "success" : code === "2" ? "warning" : "danger";
        return `<span class="badge bg-${cls}">${txt}</span>`;
    };

    const renderAttendance = rows => {
        if (!gridNode) return;
        if (!rows.length) {
            toggle(empty, true);
            gridNode.innerHTML = "";
            if (status) status.textContent = "데이터 없음";
            return;
        }

        toggle(empty, false);
        gridNode.innerHTML = "";

        const data = rows.map(item => {
            const stdnt = item.stdntVO || {};
            const stdntNo = stdnt.stdntNo || item.stdntNo || "";
            const stdntNm = stdnt.stdntNm || "";
            const deptNm = stdnt.subjctVO?.subjctNm || ""; // 학과명
            const lctreDe = normalizeDate(item.lctreDe);
            return [stdntNo, stdntNm, deptNm, lctreDe, formatStatusBadge(item.atendSttusCode)];
        });

        if (typeof gridInit === "function") {
            gridInit({
                columns: [
                    {
                        name: "학번",
                        sort: true
                    },
                    {
                        name: "이름",
                        sort: true
                    },
                    {
                        name: "학과",
                        sort: false
                    },
                    { name: "상태", formatter: cell => gridjs.html(cell) },
                    { name: "", formatter: cell => gridjs.html(`<button class="btn btn-ghost-primary btn-icon" type="button"><li class="mdi-format-align-justify"/></button>`)}
                ],
                data
            }, gridNode);
        } else {
            gridNode.textContent = "gridInit 함수를 찾을 수 없습니다.";
        }
        if (status) status.textContent = `총 ${rows.length}건`;
    };

    const renderFiltered = () => {
        const filtered = state.allRows.filter(
            row => normalizeDate(row.lctreDe) === normalizeDate(state.attendDate)
        );
        renderAttendance(filtered);
    };

    const setActiveTab = target => {
        tabButtons.forEach(btn => {
            const isMatch = btn.dataset.tabTarget === target;
            btn.classList.toggle("active", isMatch);
        });
        tabPanes.forEach(pane => {
            const isMatch = pane.dataset.tab === target;
            pane.classList.toggle("show", isMatch);
            pane.classList.toggle("active", isMatch);
        });
    };

    const loadAttendance = async () => {
        if (!lecNo) {
            toggle(empty, true);
            if (empty) empty.textContent = "lecNo 파라미터가 없어 출결을 불러올 수 없습니다.";
            if (status) status.textContent = "lecNo 필요";
            return;
        }

        toggle(loader, true);
        toggle(empty, false);
        if (status) status.textContent = "불러오는 중";

        try {
            const resp = await fetch(`/learning/prof/attendance?estbllctreCode=${encodeURIComponent(lecNo)}`);
            const payload = await resp.json().catch(() => ({ status: "error" }));
            if (!resp.ok || payload.status !== "success") {
                throw new Error(payload.message || `요청 실패 (${resp.status})`);
            }

            state.allRows = payload.data || [];
            state.attendanceLoaded = true;
            if (state.allRows.length) {
                state.attendDate = normalizeDate(state.allRows[0].lctreDe);
                updateDateLabel();
            }
            renderFiltered();
        } catch (err) {
            toggle(empty, true);
            if (empty) empty.textContent = "출결 데이터를 불러오지 못했습니다.";
            if (status) status.textContent = err.message;
        } finally {
            toggle(loader, false);
        }
    };

    const changeDate = delta => {
        const base = toISODate(state.attendDate);
        state.attendDate = typeof delta === "number" ? shiftDate(base, delta) : toISODate(delta);
        updateDateLabel();
        renderFiltered(); // 항상 필터/재렌더
    };

    tabButtons.forEach(btn => {
        btn.addEventListener("click", () => {
            const target = btn.dataset.tabTarget;
            setActiveTab(target);
            if (target === "attendance" && !state.attendanceLoaded) {
                loadAttendance();
            }
        });
    });

    prevBtn?.addEventListener("click", () => changeDate(-1));
    nextBtn?.addEventListener("click", () => changeDate(1));
    calendarBtn?.addEventListener("click", () => datePicker?.showPicker?.() || datePicker?.click());
    datePicker?.addEventListener("change", e => e.target.value && changeDate(e.target.value));

    updateDateLabel();
    setActiveTab("task");
});