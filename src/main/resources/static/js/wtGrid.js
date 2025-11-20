function gridInit({ columns, data }) {
    document.querySelector("#noticeTable") &&
        new gridjs.Grid({
            columns,
            data,
            sort: true,
            pagination: {
                limit: 3,
                summary: false,
                nextButton: true,
                prevButton: true
            },
            search: true,
            style: {
                tr: {
                    borderBottom: "1px solid #e9ebec"
                },
                td: {
                    border: "none"
                }
            }
        })
            .render(document.querySelector("#noticeTable"));
}