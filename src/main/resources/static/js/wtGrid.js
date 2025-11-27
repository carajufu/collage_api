function gridInit({ columns, data }, node) {
    if(!node) return;

    new gridjs.Grid({
        columns,
        data,
        sort: true,
        pagination: {
            limit: 4,
            summary: false,
            nextButton: true,
            prevButton: true
        },
        style: {
            tr: {
                borderBottom: "1px solid #e9ebec",
                hover: {
                    backgroundColor: "rgba(39, 42, 58, 0.04)",
                    cursor: "pointer"
                }
            },
            td: {
                border: "none"
            }
        }
    })
        .render(node);
}