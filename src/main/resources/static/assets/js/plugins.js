(() => {
    const loadScript = (src) => new Promise((resolve, reject) => {
        const script = document.createElement('script');
        script.src = src;
        script.defer = true;
        script.onload = resolve;
        script.onerror = reject;
        document.head.appendChild(script);
    });

    const needsToastify = document.querySelector('[toast-list]');
    const needsChoices = document.querySelector('[data-choices]');
    const needsFlatpickr = document.querySelector('[data-provider]');

    const tasks = [];

    if (needsToastify) tasks.push(loadScript('/assets/libs/toastify-js/src/toastify.js'));
    if (needsChoices) tasks.push(loadScript('/assets/libs/choices.js/public/assets/scripts/choices.min.js'));
    if (needsFlatpickr) tasks.push(loadScript('/assets/libs/flatpickr/flatpickr.min.js'));

    Promise.all(tasks).catch(console.error);
})();
