(() => {
    const statusLabel = {
        "1": "출석",
        "2": "지각",
        "3": "조퇴"
    };

    const mapStatus = code => statusLabel[code] || "결석";

    const toggle = (el, show) => {
        if (!el) return;
        el.classList.toggle("d-none", !show);
    };

    document.addEventListener("DOMContentLoaded", () => {
        const root = document.querySelector("#prof-main");
        if (!root) return;

        const lecNo = root.dataset.lecNo || new URLSearchParams(window.location.search).get("lecNo") || "";
        const tabButtons = root.querySelectorAll("[data-tab-target]");
        const tabPanes = root.querySelectorAll(".learning-tab-pane");

        const loader = document.querySelector("#attendance-loader");
        const empty = document.querySelector("#attendance-empty");
        const gridNode = document.querySelector("#attendance-grid");
        const status = document.querySelector("#attendance-status");

        const state = {
            attendanceLoaded: false
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
                const week = item.weekAcctoLrnVO?.week ?? "";
                const stdntNo = item.stdntVO?.stdntNo || item.stdntNo || "";
                const stdntNm = item.stdntVO?.stdntNm || "";
                const lctreDe = item.lctreDe || "";
                const statusText = mapStatus(item.atendSttusCode);

                return [week, stdntNo, stdntNm, lctreDe, statusText];
            });

            if (typeof gridInit === "function") {
                gridInit({
                    columns: ["주차", "학번", "이름", "출결일", "상태"],
                    data
                }, gridNode);
            } else {
                gridNode.textContent = "gridInit 함수를 찾을 수 없습니다.";
            }

            if (status) status.textContent = `총 ${rows.length}건`;
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
                    const message = payload.message || `요청 실패 (${resp.status})`;
                    throw new Error(message);
                }

                const rows = payload.data || [];
                renderAttendance(rows);
                state.attendanceLoaded = true;
            } catch (err) {
                toggle(empty, true);
                if (empty) empty.textContent = "출결 데이터를 불러오지 못했습니다.";
                if (status) status.textContent = err.message;
            } finally {
                toggle(loader, false);
            }
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

        // Ensure default tab state
        setActiveTab("task");
    });
})();
