// ==UserScript==
// @name Qutebrowser UI Glow
// @namespace qutebrowser-glow
// @include qute://*
// @run-at document-start
// ==/UserScript==

(function() {
    const style = document.createElement('style');
    style.textContent = `
        /* Glow on selected elements */
        #tabs .selected {
            box-shadow: 0 0 10px rgba(255, 255, 255, 0.5),
                        0 0 20px rgba(255, 255, 255, 0.3) !important;
        }
        
        /* Glow on statusbar */
        #statusbar {
            box-shadow: 0 0 15px rgba(200, 168, 130, 0.3) !important;
        }
    `;
    document.head.appendChild(style);
})();
