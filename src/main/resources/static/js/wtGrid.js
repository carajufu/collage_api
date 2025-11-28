const DEFAULT_GRID_OPTIONS= {
    sort: true,
    pagination: {
        limit: 10,
        summary: false,
        nextButton: true,
        prevButton: true
    },
    style: {
        tr: {
            borderBottom: "1px solid #e9ebec"
        },
        td: {
            border: "none"
        }
    }
}

function gridInit(config, node) {
    if(!node) return;

    const { columns, data, ...options} = config;
    const gridOptions = {
        columns,
        data,
        ...DEFAULT_GRID_OPTIONS,
        ...options
    }

    new gridjs.Grid(gridOptions).render(node);
}