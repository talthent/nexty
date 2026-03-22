enum DashboardHTML {
    static let html = #"""
    <!DOCTYPE html>
    <html lang="en">
    <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <title>Nexty Schedule</title>
    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.min.js"></script>
    <style>
    @import url('https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&display=swap');

    :root {
        --bg: #F5F5F7;
        --card-bg: #FFFFFF;
        --card-shadow: 0 1px 3px rgba(0,0,0,0.08), 0 1px 2px rgba(0,0,0,0.04);
        --card-hover: 0 4px 12px rgba(0,0,0,0.1);
        --accent: #3478F6;
        --accent-light: rgba(52,120,246,0.1);
        --accent-glow: rgba(52,120,246,0.25);
        --red: #E5484D;
        --red-light: rgba(229,72,77,0.1);
        --text-primary: #1D1D1F;
        --text-secondary: #6E6E73;
        --text-muted: #AEAEB2;
        --input-bg: #F5F5F7;
        --input-border: #D2D2D7;
        --input-focus: #3478F6;
        --radius-lg: 16px;
        --radius-md: 12px;
        --radius-sm: 8px;
        --font: 'Nunito', -apple-system, sans-serif;
    }

    * { margin: 0; padding: 0; box-sizing: border-box; -webkit-tap-highlight-color: transparent; }

    body {
        font-family: var(--font);
        background: var(--bg);
        min-height: 100vh;
        min-height: 100dvh;
        padding: 16px 16px 40px;
        overflow-x: hidden;
    }

    .container {
        max-width: 460px;
        margin: 0 auto;
        position: relative;
        z-index: 1;
    }

    /* ---- HEADER ---- */
    .header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 24px;
        padding: 8px 0;
        position: relative;
    }

    .logo-group {
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .logo-icon {
        width: 38px;
        height: 38px;
        background: var(--accent);
        border-radius: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 20px;
        color: #fff;
    }

    h1 {
        font-family: var(--font);
        color: var(--text-primary);
        font-size: 24px;
        font-weight: 800;
        letter-spacing: -0.3px;
    }

    .settings-btn {
        background: none;
        border: none;
        color: var(--text-muted);
        cursor: pointer;
        padding: 8px;
        border-radius: var(--radius-sm);
        transition: all 0.2s ease;
        display: flex;
        align-items: center;
    }
    .settings-btn:hover { color: var(--text-primary); background: rgba(0,0,0,0.05); }

    .settings-row {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 14px 0;
        border-bottom: 1px solid var(--input-bg);
    }
    .settings-row:last-child { border-bottom: none; }
    .settings-label {
        font-family: var(--font);
        font-size: 15px;
        font-weight: 700;
        color: var(--text-primary);
    }
    .settings-control select {
        font-family: var(--font);
        font-size: 14px;
        font-weight: 600;
        padding: 8px 28px 8px 10px;
        border: 1.5px solid var(--input-border);
        border-radius: var(--radius-sm);
        background: var(--input-bg);
        color: var(--text-primary);
        cursor: pointer;
    }
    .settings-control button {
        font-family: var(--font);
        font-size: 14px;
        font-weight: 700;
        padding: 8px 16px;
        border: 1.5px solid var(--input-border);
        border-radius: var(--radius-sm);
        background: var(--input-bg);
        color: var(--accent);
        cursor: pointer;
        transition: all 0.15s ease;
    }
    .settings-control button:hover { background: var(--accent-light); border-color: var(--accent); }

    .lang-select-placeholder {
        /* removed — now in settings */
        cursor: pointer;
        outline: none;
        -webkit-appearance: none;
        appearance: none;
        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%236E6E73' d='M6 8L1 3h10z'/%3E%3C/svg%3E");
        background-repeat: no-repeat;
        background-position: right 8px center;
    }

    /* ---- ACTIVITY CARDS ---- */
    .activity-list {
        display: flex;
        flex-direction: column;
        gap: 10px;
        margin-bottom: 16px;
    }

    .card {
        background: var(--card-bg);
        border-radius: var(--radius-md);
        padding: 14px;
        box-shadow: var(--card-shadow);
        display: flex;
        align-items: center;
        gap: 12px;
        transition: all 0.2s ease;
        border: 1.5px solid transparent;
    }

    .card:hover { box-shadow: var(--card-hover); }

    /* ---- ICON BADGE ---- */
    .icon-badge {
        width: 44px;
        height: 44px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 13px;
        font-weight: 700;
        color: #fff;
        flex-shrink: 0;
        text-align: center;
        line-height: 1.15;
        padding: 4px;
    }

    .icon-badge.hue-0 { background: #E5484D; }
    .icon-badge.hue-1 { background: #2B9A66; }
    .icon-badge.hue-2 { background: #6E56CF; }
    .icon-badge.hue-3 { background: #E54666; }
    .icon-badge.hue-4 { background: #F5A623; color: #fff; }
    .icon-badge.hue-5 { background: #3478F6; }
    .icon-badge.hue-6 { background: #12A594; }
    .icon-badge.hue-7 { background: #E54D2E; }

    /* ---- FIELDS ---- */
    .fields {
        flex: 1;
        display: flex;
        flex-direction: column;
        gap: 8px;
        min-width: 0;
    }

    .row {
        display: flex;
        gap: 8px;
        align-items: center;
    }

    select, input[type="number"] {
        font-family: var(--font);
        font-size: 15px;
        font-weight: 600;
        padding: 9px 10px;
        border: 1.5px solid var(--input-border);
        border-radius: var(--radius-sm);
        background: var(--input-bg);
        color: var(--text-primary);
        outline: none;
        transition: all 0.2s ease;
        -webkit-appearance: none;
        appearance: none;
    }

    select {
        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%236E6E73' d='M6 8L1 3h10z'/%3E%3C/svg%3E");
        background-repeat: no-repeat;
        background-position: right 10px center;
        padding-right: 28px;
    }

    select:focus, input[type="number"]:focus {
        border-color: var(--accent);
        box-shadow: 0 0 0 3px var(--accent-light);
        background: #fff;
    }

    .title-select {
        flex: 1;
        min-width: 0;
        font-size: 15px;
    }

    .time-group {
        display: flex;
        align-items: center;
        gap: 2px;
        background: var(--input-bg);
        border: 1.5px solid var(--input-border);
        border-radius: var(--radius-sm);
        padding: 0 4px;
        transition: all 0.2s ease;
    }

    .time-group:focus-within {
        border-color: var(--accent);
        box-shadow: 0 0 0 3px var(--accent-light);
        background: #fff;
    }

    .time-input {
        width: 40px;
        text-align: center;
        border: none !important;
        background: transparent !important;
        padding: 9px 2px !important;
        font-family: var(--font);
        font-size: 17px !important;
        font-weight: 700 !important;
        color: var(--text-primary);
        box-shadow: none !important;
    }

    .time-input:focus { box-shadow: none !important; }

    .time-sep {
        font-family: var(--font);
        font-size: 18px;
        font-weight: 800;
        color: var(--text-muted);
        margin: 0 1px;
    }

    .icon-select {
        flex: 1;
        font-size: 13px;
        min-width: 0;
    }

    /* ---- DELETE BUTTON ---- */
    .delete-btn {
        background: none;
        border: none;
        width: 36px;
        height: 36px;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        color: var(--text-muted);
        border-radius: 10px;
        transition: all 0.2s ease;
        flex-shrink: 0;
        font-size: 0;
    }

    .delete-btn svg {
        width: 18px;
        height: 18px;
        transition: transform 0.2s ease;
    }

    .delete-btn:hover {
        background: var(--red-light);
        color: var(--red);
    }

    .delete-btn:hover svg { transform: scale(1.15); }
    .delete-btn:active svg { transform: scale(0.9); }

    /* ---- ACTION BUTTONS ---- */
    .actions {
        display: flex;
        flex-direction: column;
        gap: 10px;
        margin-top: 4px;
    }

    .add-btn {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        width: 100%;
        padding: 14px;
        border: 2px dashed var(--input-border);
        border-radius: var(--radius-md);
        background: transparent;
        color: var(--text-secondary);
        font-family: var(--font);
        font-size: 15px;
        font-weight: 700;
        cursor: pointer;
        transition: all 0.2s ease;
    }

    .add-btn:hover {
        border-color: var(--accent);
        color: var(--accent);
        background: var(--accent-light);
    }

    .add-btn:active { transform: scale(0.98); }

    .add-btn .plus-icon {
        width: 22px;
        height: 22px;
        background: var(--accent);
        border-radius: 6px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #fff;
        font-size: 15px;
        font-weight: 800;
        line-height: 1;
    }

    .save-btn {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        width: 100%;
        padding: 16px;
        border: none;
        border-radius: var(--radius-md);
        background: var(--accent);
        color: #fff;
        font-family: var(--font);
        font-size: 17px;
        font-weight: 800;
        cursor: pointer;
        box-shadow: 0 4px 14px var(--accent-glow);
        transition: all 0.2s ease;
    }

    .save-btn:hover {
        transform: translateY(-1px);
        box-shadow: 0 6px 20px var(--accent-glow);
    }

    .save-btn:active {
        transform: scale(0.98);
    }

    .save-btn svg {
        width: 20px;
        height: 20px;
    }

    /* ---- TOAST ---- */
    .toast {
        position: fixed;
        bottom: 32px;
        left: 50%;
        transform: translateX(-50%) translateY(20px);
        background: var(--text-primary);
        color: #fff;
        padding: 14px 28px;
        border-radius: var(--radius-md);
        font-family: var(--font);
        font-size: 15px;
        font-weight: 700;
        opacity: 0;
        transition: all 0.3s ease;
        pointer-events: none;
        z-index: 1000;
        box-shadow: 0 4px 20px rgba(0,0,0,0.15);
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .toast.show {
        opacity: 1;
        transform: translateX(-50%) translateY(0);
    }

    .toast-icon {
        font-size: 18px;
    }

    /* ---- EMPTY STATE ---- */
    .empty-state {
        text-align: center;
        padding: 40px 20px;
        color: var(--text-muted);
    }

    .empty-state .empty-emoji {
        font-size: 40px;
        margin-bottom: 12px;
        display: block;
    }

    .empty-state p {
        font-family: var(--font);
        font-size: 15px;
        font-weight: 600;
    }

    /* ---- RTL ---- */
    [dir="rtl"] .card { direction: rtl; }
    [dir="rtl"] select {
        background-position: left 10px center;
        padding-right: 10px;
        padding-left: 28px;
        text-align: right;
    }
    [dir="rtl"] input { text-align: right; }
    [dir="rtl"] .time-input { text-align: center !important; }
    [dir="rtl"] .time-group { direction: ltr; }

    /* ---- TABS ---- */
    .tabs {
        display: flex;
        gap: 4px;
        margin-bottom: 20px;
        background: rgba(0,0,0,0.05);
        border-radius: var(--radius-sm);
        padding: 3px;
    }

    .tab {
        flex: 1;
        padding: 10px 16px;
        border: none;
        border-radius: 6px;
        background: transparent;
        font-family: var(--font);
        font-size: 14px;
        font-weight: 700;
        color: var(--text-muted);
        cursor: pointer;
        transition: all 0.2s ease;
    }

    .tab.active {
        background: var(--card-bg);
        color: var(--text-primary);
        box-shadow: 0 1px 3px rgba(0,0,0,0.1);
    }

    .tab:not(.active):hover {
        color: var(--text-secondary);
    }

    .copy-btn {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        width: 100%;
        padding: 13px;
        border: 2px dashed var(--input-border);
        border-radius: var(--radius-md);
        background: transparent;
        color: var(--text-secondary);
        font-family: var(--font);
        font-size: 14px;
        font-weight: 700;
        cursor: pointer;
        transition: all 0.2s ease;
        margin-bottom: 10px;
    }

    .copy-btn:hover {
        border-color: var(--accent);
        color: var(--accent);
        background: var(--accent-light);
    }

    .copy-btn:active { transform: scale(0.98); }

    /* ---- SCROLLBAR ---- */
    ::-webkit-scrollbar { width: 4px; }
    ::-webkit-scrollbar-track { background: transparent; }
    ::-webkit-scrollbar-thumb { background: rgba(0,0,0,0.1); border-radius: 4px; }

    /* input number spinner hide */
    input[type="number"]::-webkit-inner-spin-button,
    input[type="number"]::-webkit-outer-spin-button {
        -webkit-appearance: none;
        margin: 0;
    }
    input[type="number"] { -moz-appearance: textfield; }

    /* ---- ADD ACTIVITY MODAL ---- */
    .modal-overlay {
        position: fixed;
        inset: 0;
        background: rgba(0,0,0,0.45);
        z-index: 500;
        display: flex;
        align-items: center;
        justify-content: center;
        opacity: 0;
        pointer-events: none;
        transition: opacity 0.25s ease;
    }
    .modal-overlay.show { opacity: 1; pointer-events: auto; }
    .modal {
        background: var(--card-bg);
        border-radius: var(--radius-lg);
        padding: 24px;
        width: 90%;
        max-width: 420px;
        max-height: 85vh;
        overflow-y: auto;
        box-shadow: 0 12px 40px rgba(0,0,0,0.2);
        transform: translateY(20px);
        transition: transform 0.25s ease;
    }
    .modal-overlay.show .modal { transform: translateY(0); }
    .modal h2 {
        font-family: var(--font);
        font-size: 20px;
        font-weight: 800;
        color: var(--text-primary);
        margin-bottom: 18px;
        text-align: center;
    }
    .preset-grid {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 8px;
        margin-bottom: 16px;
    }
    .preset-btn {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 4px;
        padding: 12px 6px;
        border: 2px solid transparent;
        border-radius: var(--radius-sm);
        background: var(--input-bg);
        cursor: pointer;
        transition: all 0.15s ease;
        font-family: var(--font);
    }
    .preset-btn:hover { border-color: var(--accent); background: var(--accent-light); }
    .preset-btn.selected { border-color: var(--accent); background: var(--accent-light); }
    .preset-btn .p-icon { font-size: 22px; }
    .preset-btn .p-label { font-size: 12px; font-weight: 700; color: var(--text-primary); text-align: center; line-height: 1.2; }
    .custom-toggle {
        width: 100%;
        padding: 12px;
        border: 2px dashed var(--input-border);
        border-radius: var(--radius-sm);
        background: transparent;
        color: var(--text-secondary);
        font-family: var(--font);
        font-size: 14px;
        font-weight: 700;
        cursor: pointer;
        transition: all 0.15s ease;
        margin-bottom: 16px;
    }
    .custom-toggle:hover { border-color: var(--accent); color: var(--accent); }
    .custom-toggle.selected { border-color: var(--accent); color: var(--accent); background: var(--accent-light); }
    .modal-time {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 4px;
        margin-bottom: 16px;
    }
    .modal-time input {
        width: 60px;
        text-align: center;
        font-size: 22px !important;
        font-weight: 800 !important;
        padding: 10px 4px !important;
    }
    .modal-time .time-sep { font-size: 22px; }
    .custom-fields { margin-bottom: 16px; display: flex; flex-direction: column; gap: 8px; }
    .custom-fields input[type="text"] {
        font-family: var(--font);
        font-size: 15px;
        font-weight: 600;
        padding: 10px 12px;
        border: 1.5px solid var(--input-border);
        border-radius: var(--radius-sm);
        background: var(--input-bg);
        color: var(--text-primary);
        outline: none;
        width: 100%;
        transition: all 0.2s ease;
    }
    .custom-fields input[type="text"]:focus { border-color: var(--accent); box-shadow: 0 0 0 3px var(--accent-light); background: #fff; }
    .icon-grid {
        display: grid;
        grid-template-columns: repeat(6, 1fr);
        gap: 6px;
    }
    .icon-btn {
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 8px;
        border: 2px solid transparent;
        border-radius: var(--radius-sm);
        background: var(--input-bg);
        cursor: pointer;
        font-size: 18px;
        transition: all 0.15s ease;
    }
    .icon-btn:hover { border-color: var(--accent); }
    .icon-btn.selected { border-color: var(--accent); background: var(--accent-light); }

    /* ---- ICON PICKER ---- */
    .icon-picker-trigger {
        display: flex;
        align-items: center;
        gap: 10px;
        width: 100%;
        padding: 10px 14px;
        border: 1.5px solid var(--input-border);
        border-radius: var(--radius-sm);
        background: var(--input-bg);
        cursor: pointer;
        font-family: var(--font);
        font-size: 14px;
        font-weight: 600;
        color: var(--text-secondary);
        transition: all 0.15s;
    }
    .icon-picker-trigger:hover { border-color: var(--accent); }
    .icon-picker-trigger .trigger-preview {
        width: 28px; height: 28px;
        display: flex; align-items: center; justify-content: center;
        background: var(--accent-light); border-radius: 6px; color: var(--accent);
    }
    .icon-picker-search {
        width: 100%;
        padding: 10px 12px 10px 34px;
        border: 1.5px solid var(--input-border);
        border-radius: var(--radius-sm);
        background: var(--input-bg);
        font-family: var(--font);
        font-size: 14px;
        font-weight: 600;
        color: var(--text-primary);
        outline: none;
        transition: all 0.2s;
    }
    .icon-picker-search:focus { border-color: var(--accent); box-shadow: 0 0 0 3px var(--accent-light); background: #fff; }
    .icon-picker-search-wrap {
        position: relative; margin-bottom: 12px;
    }
    .icon-picker-search-wrap svg {
        position: absolute; left: 10px; top: 50%; transform: translateY(-50%);
        color: var(--text-muted); pointer-events: none;
    }
    [dir="rtl"] .icon-picker-search { padding: 10px 34px 10px 12px; }
    [dir="rtl"] .icon-picker-search-wrap svg { left: auto; right: 10px; }
    .icon-picker-category {
        font-family: var(--font);
        font-size: 11px;
        font-weight: 800;
        color: var(--text-muted);
        text-transform: uppercase;
        letter-spacing: 0.5px;
        margin: 12px 0 6px;
    }
    .icon-picker-category:first-child { margin-top: 0; }
    .icon-picker-grid {
        display: grid;
        grid-template-columns: repeat(5, 1fr);
        gap: 6px;
    }
    .icon-pick {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 3px;
        padding: 8px 4px 6px;
        border: 2px solid transparent;
        border-radius: var(--radius-sm);
        background: transparent;
        cursor: pointer;
        transition: all 0.12s;
        font-family: var(--font);
    }
    .icon-pick:hover { background: var(--input-bg); }
    .icon-pick.selected { border-color: var(--accent); background: var(--accent-light); }
    .icon-pick .ip-icon { width: 24px; height: 24px; color: var(--text-primary); }
    .icon-pick .ip-label {
        font-size: 9px; font-weight: 600; color: var(--text-muted);
        text-align: center; line-height: 1.1; max-width: 60px;
        overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
    }
    .icon-picker-body {
        max-height: 320px;
        overflow-y: auto;
        scrollbar-width: thin;
    }
    .icon-picker-empty {
        text-align: center; padding: 24px; color: var(--text-muted);
        font-family: var(--font); font-size: 13px; font-weight: 600;
    }
    .modal-actions {
        display: flex;
        gap: 8px;
    }
    .modal-actions button {
        flex: 1;
        padding: 14px;
        border: none;
        border-radius: var(--radius-sm);
        font-family: var(--font);
        font-size: 15px;
        font-weight: 800;
        cursor: pointer;
        transition: all 0.15s ease;
    }
    .modal-add-btn { background: var(--accent); color: #fff; }
    .modal-add-btn:hover { filter: brightness(1.1); }
    .modal-add-btn:disabled { opacity: 0.4; cursor: default; filter: none; }
    .modal-cancel-btn { background: var(--input-bg); color: var(--text-secondary); }
    .modal-cancel-btn:hover { background: #e8e8ed; }

    /* ---- DAY TABS ---- */
    .day-tabs {
        display: flex;
        gap: 3px;
        margin-bottom: 14px;
    }
    .day-tab {
        flex: 1;
        padding: 8px 4px;
        border: none;
        border-radius: 6px;
        background: var(--input-bg);
        font-family: var(--font);
        font-size: 13px;
        font-weight: 700;
        color: var(--text-muted);
        cursor: pointer;
        transition: all 0.15s ease;
        text-align: center;
    }
    .day-tab.active { background: var(--accent); color: #fff; }
    .day-tab.today-marker { box-shadow: inset 0 -2px 0 var(--accent); }
    .day-tab:not(.active):hover { color: var(--text-secondary); background: #e8e8ed; }
    .day-tab .day-date { display: block; font-size: 10px; font-weight: 600; opacity: 0.7; margin-top: 2px; }

    /* ---- TEMPLATE MODE ---- */
    body.template-mode {
        background: #EDE9FE;
    }
    body.template-mode .card {
        border-color: #C4B5FD;
    }
    body.template-mode .day-tab.active {
        background: #7C3AED;
    }
    body.template-mode .day-tab.today-marker {
        box-shadow: inset 0 -2px 0 #7C3AED;
    }
    body.template-mode .save-btn {
        background: #7C3AED;
        box-shadow: 0 4px 14px rgba(124,58,237,0.25);
    }
    body.template-mode .save-btn:hover {
        box-shadow: 0 6px 20px rgba(124,58,237,0.35);
    }
    body.template-mode .add-btn:hover {
        border-color: #7C3AED;
        color: #7C3AED;
        background: rgba(124,58,237,0.08);
    }
    .back-bar {
        display: flex;
        align-items: center;
        gap: 10px;
        margin-bottom: 18px;
        cursor: pointer;
        padding: 10px 14px;
        border-radius: var(--radius-md);
        transition: background 0.15s;
    }
    .back-bar:hover { background: rgba(124,58,237,0.08); }
    .back-bar svg { flex-shrink: 0; }
    .back-bar-text {
        font-family: var(--font);
        font-size: 14px;
        font-weight: 700;
        color: #7C3AED;
    }

    /* slide transition */
    .container { transition: transform 0.3s ease, opacity 0.3s ease; }
    .container.slide-out { transform: translateX(-30px); opacity: 0; }
    .container.slide-in { transform: translateX(30px); opacity: 0; }
    [dir="rtl"] .container.slide-out { transform: translateX(30px); opacity: 0; }
    [dir="rtl"] .container.slide-in { transform: translateX(-30px); opacity: 0; }
    </style>
    </head>
    <body>
    <div class="container">
        <div class="header">
            <div class="logo-group">
                <div class="logo-icon">N</div>
                <h1 id="pageTitle">Nexty Schedule</h1>
            </div>
            <button class="settings-btn" onclick="openSettings()">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="22" height="22"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 1 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 1 1-2.83-2.83l.06-.06A1.65 1.65 0 0 0 4.68 15a1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 1 1 2.83-2.83l.06.06A1.65 1.65 0 0 0 9 4.68a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 1 1 2.83 2.83l-.06.06A1.65 1.65 0 0 0 19.4 9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"/></svg>
            </button>
        </div>
        <div class="tabs" id="kidTabs" style="display:none"></div>
        <div class="back-bar" id="backBar" style="display:none" onclick="switchWeeklyMode('thisWeek')">
            <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="#7C3AED" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"/></svg>
            <span class="back-bar-text" id="backBarText">Back to Schedule</span>
        </div>
        <div class="day-tabs" id="dayTabs"></div>
        <div class="activity-list" id="list"></div>
        <div class="actions">
            <button class="copy-btn" id="copyBtn" onclick="copyAction()" style="display:none">
                <span id="copyBtnLabel">Copy from Template</span>
            </button>
            <button class="add-btn" id="addBtn" onclick="addActivity()">
                <span class="plus-icon">+</span>
                <span id="addBtnLabel">Add Activity</span>
            </button>
            <button class="save-btn" id="saveBtn" onclick="save()">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
                <span id="saveBtnLabel">Save Changes</span>
            </button>
        </div>
    </div>
    <div class="toast" id="toast"><span class="toast-icon"></span><span id="toastMsg"></span></div>
    <div class="modal-overlay" id="addModal" onclick="if(event.target===this)closeModal()">
        <div class="modal" id="addModalContent"></div>
    </div>
    <div class="modal-overlay" id="settingsModal" onclick="if(event.target===this)closeSettings()">
        <div class="modal" id="settingsContent"></div>
    </div>
    <div class="modal-overlay" id="iconPickerModal" onclick="if(event.target===this)closeIconPicker()">
        <div class="modal" style="max-width:380px" id="iconPickerContent"></div>
    </div>
    <script>
    const ACTIVITIES = {
        'activity.wakeUp':       {en:'Wake Up',       he:'השכמה',        icon:'sun.max.fill'},
        'activity.breakfast':    {en:'Breakfast',      he:'ארוחת בוקר',   icon:'fork.knife'},
        'activity.teeth':        {en:'Brush Teeth',    he:'צחצוח שיניים', icon:'mouth.fill'},
        'activity.getDressed':   {en:'Get Dressed',    he:'להתלבש',      icon:'tshirt.fill'},
        'activity.kindergarten': {en:'Kindergarten',   he:'גן',           icon:'backpack.fill'},
        'activity.lunch':        {en:'Lunch',          he:'ארוחת צהריים', icon:'carrot.fill'},
        'activity.play':         {en:'Play',           he:'משחק',         icon:'gamecontroller.fill'},
        'activity.judo':         {en:'Judo',           he:"ג'ודו",       icon:'figure.martial.arts'},
        'activity.dinner':       {en:'Dinner',         he:'ארוחת ערב',    icon:'fork.knife'},
        'activity.bath':         {en:'Bath',           he:'אמבטיה',       icon:'bathtub.fill'},
        'activity.story':        {en:'Story Time',     he:'סיפור',        icon:'book.fill'},
        'activity.sleep':        {en:'Sleep',          he:'שינה',         icon:'moon.zzz.fill'}
    };

    const UI = {
        en: { title:'Nexty Schedule', templateTitle:'Weekly Template', add:'Add Activity', save:'Save Changes', saved:'Saved!', error:'Error saving', noConn:'Connection failed', empty:'No activities yet',
              copyTemplate:'Copy from Template', backToWeek:'Back to Schedule',
              days:['Sun','Mon','Tue','Wed','Thu','Fri','Sat'] },
        he: { title:'לוח זמנים', templateTitle:'תבנית שבועית', add:'הוספת פעילות', save:'שמירה', saved:'!נשמר', error:'שגיאה בשמירה', noConn:'אין חיבור', empty:'אין פעילויות עדיין',
              copyTemplate:'העתק מתבנית', backToWeek:'חזרה ללוח זמנים',
              days:['א׳','ב׳','ג׳','ד׳','ה׳','ו׳','ש׳'] }
    };

    let kids = [];
    let selectedKidId = null;
    let activities = [];
    let lang = localStorage.getItem('nextyLang') || 'en';
    let weekStartDay = +(localStorage.getItem('nextyWeekStart') || '0'); // 0=Sun, 1=Mon

    let weeklyMode = localStorage.getItem('nextyWeeklyMode') || 'thisWeek';
    let selectedWeekDay = 0; // index into ordered days (0=first day of week)
    let templateData = {};   // {0:[], 1:[], ...} keyed by canonical day (0=Sun)
    let weekData = {};       // {"2026-03-15":[], ...}
    let weekDates = [];      // 7 date strings
    let dayOrder = [];       // [0,1,2,3,4,5,6] or [1,2,3,4,5,6,0] based on weekStartDay

    function activityName(key, customTitle) {
        if (customTitle) return customTitle;
        const a = ACTIVITIES[key];
        return a ? a[lang] : key;
    }

    function sortActivities() {
        activities.sort((a, b) => (a.hour * 60 + a.minute) - (b.hour * 60 + b.minute));
    }

    function selectActivity(idx, key) {
        if (key === '__custom__') {
            activities[idx].titleKey = 'custom';
            activities[idx].customTitle = activities[idx].customTitle || (lang === 'he' ? 'פעילות חדשה' : 'New Activity');
            activities[idx].imageName = 'star.fill';
        } else {
            activities[idx].titleKey = key;
            activities[idx].customTitle = null;
            const a = ACTIVITIES[key];
            if (a && a.icon) activities[idx].imageName = a.icon;
        }
        render();
    }

    function setCustomTitle(idx, value) {
        activities[idx].customTitle = value;
    }

    function setTime(idx, field, value) {
        activities[idx][field] = +value;
        sortActivities();
        render();
    }

    function syncToStore() {
        const canonicalDay = dayOrder[selectedWeekDay];
        if (weeklyMode === 'template') {
            templateData[canonicalDay] = activities;
        } else {
            weekData[weekDates[selectedWeekDay]] = activities;
        }
    }

    function copyAction() {
        const canonicalDay = dayOrder[selectedWeekDay];
        const tpl = templateData[canonicalDay] || [];
        const copied = JSON.parse(JSON.stringify(tpl));
        copied.forEach(a => a.id = uuid());
        weekData[weekDates[selectedWeekDay]] = copied;
        activities = copied;
        render();
    }

    function kidParam() {
        return selectedKidId ? '?kid=' + selectedKidId : '';
    }

    function selectKid(id) {
        if (selectedKidId === id) return;
        selectedKidId = id;
        loadWeeklyData();
        renderKidTabs();
    }

    function renderKidTabs() {
        const container = document.getElementById('kidTabs');
        if (kids.length <= 1) { container.style.display = 'none'; return; }
        container.style.display = 'flex';
        container.innerHTML = kids.map(k =>
            `<button class="tab${k.id === selectedKidId ? ' active' : ''}" onclick="selectKid('${k.id}')">${k.name}</button>`
        ).join('');
    }

    function computeDayOrder() {
        dayOrder = Array.from({length:7}, (_, i) => (i + weekStartDay) % 7);
    }

    function getWeekDates() {
        const now = new Date();
        const currentDay = now.getDay(); // 0=Sun
        const offset = (currentDay - weekStartDay + 7) % 7;
        const start = new Date(now);
        start.setDate(now.getDate() - offset);
        return Array.from({length:7}, (_, i) => {
            const d = new Date(start);
            d.setDate(start.getDate() + i);
            return d.getFullYear() + '-' + String(d.getMonth()+1).padStart(2,'0') + '-' + String(d.getDate()).padStart(2,'0');
        });
    }

    function todayDateString() {
        const d = new Date();
        return d.getFullYear() + '-' + String(d.getMonth()+1).padStart(2,'0') + '-' + String(d.getDate()).padStart(2,'0');
    }

    function switchWeeklyMode(mode) {
        if (weeklyMode === mode) return;
        syncToStore();
        const container = document.querySelector('.container');
        const slideOut = mode === 'template' ? 'slide-out' : 'slide-in';
        const slideIn = mode === 'template' ? 'slide-in' : 'slide-out';
        container.classList.add(slideOut);
        setTimeout(() => {
            weeklyMode = mode;
            localStorage.setItem('nextyWeeklyMode', mode);
            const isTemplate = mode === 'template';
            document.body.classList.toggle('template-mode', isTemplate);
            document.getElementById('backBar').style.display = isTemplate ? '' : 'none';
            const u = UI[lang];
            document.getElementById('pageTitle').textContent = isTemplate ? u.templateTitle : u.title;
            // Hide settings button in template mode
            document.querySelector('.settings-btn').style.display = isTemplate ? 'none' : '';
            setWeeklyActivities();
            updateCopyBtn();
            renderDayTabs();
            render();
            container.classList.remove(slideOut);
            container.classList.add(slideIn);
            requestAnimationFrame(() => {
                requestAnimationFrame(() => container.classList.remove(slideIn));
            });
        }, 200);
    }

    function switchWeekDay(day) {
        if (selectedWeekDay === day) return;
        syncToStore();
        selectedWeekDay = day;
        setWeeklyActivities();
        renderDayTabs();
        render();
    }

    function setWeeklyActivities() {
        const canonicalDay = dayOrder[selectedWeekDay];
        if (weeklyMode === 'template') {
            activities = templateData[canonicalDay] || [];
            templateData[canonicalDay] = activities;
        } else {
            const dateKey = weekDates[selectedWeekDay];
            activities = weekData[dateKey] || [];
            weekData[dateKey] = activities;
        }
    }

    async function loadWeeklyData() {
        computeDayOrder();
        weekDates = getWeekDates();
        const q = kidParam();
        const [tplRes, weekRes] = await Promise.all([
            fetch('/weekly/template/all' + q),
            fetch('/weekly/week' + q + (q ? '&' : '?') + 'weekStart=' + weekDates[0])
        ]);
        const tplJson = await tplRes.json();
        const weekJson = await weekRes.json();
        templateData = {};
        for (let i = 0; i < 7; i++) {
            const arr = tplJson[String(i)] || [];
            arr.sort((a, b) => (a.hour * 60 + a.minute) - (b.hour * 60 + b.minute));
            templateData[i] = arr;
        }
        weekData = {};
        for (const dateStr of weekDates) {
            const arr = weekJson[dateStr] || [];
            arr.sort((a, b) => (a.hour * 60 + a.minute) - (b.hour * 60 + b.minute));
            weekData[dateStr] = arr;
        }
        setWeeklyActivities();
        renderDayTabs();
        updateCopyBtn();
        render();
    }

    function renderDayTabs() {
        const container = document.getElementById('dayTabs');
        const u = UI[lang];
        const today = todayDateString();
        container.innerHTML = dayOrder.map((canonicalDay, i) => {
            let cls = 'day-tab';
            if (i === selectedWeekDay) cls += ' active';
            if (weeklyMode === 'thisWeek' && weekDates[i] === today) cls += ' today-marker';
            const dateLabel = weeklyMode === 'thisWeek' && weekDates[i] ? weekDates[i].slice(5) : '';
            return `<button class="${cls}" onclick="switchWeekDay(${i})">
                ${u.days[canonicalDay]}${dateLabel ? `<span class="day-date">${dateLabel}</span>` : ''}
            </button>`;
        }).join('');
    }

    function updateCopyBtn() {
        const btn = document.getElementById('copyBtn');
        const label = document.getElementById('copyBtnLabel');
        const u = UI[lang];
        btn.style.display = weeklyMode === 'thisWeek' ? '' : 'none';
        label.textContent = u.copyTemplate;
    }

    // MARK: Settings

    function openSettings() {
        renderSettings();
        document.getElementById('settingsModal').classList.add('show');
    }

    function closeSettings() {
        document.getElementById('settingsModal').classList.remove('show');
    }

    function renderSettings() {
        const u = UI[lang];
        const isHe = lang === 'he';
        const settingsTitle = isHe ? 'הגדרות' : 'Settings';
        const langLabel = isHe ? 'שפה' : 'Language';
        const weekStartLabel = isHe ? 'תחילת שבוע' : 'Week starts on';
        const templateLabel = isHe ? 'עריכת תבנית שבועית' : 'Edit Weekly Template';
        const doneLabel = isHe ? 'סיום' : 'Done';
        const sunLabel = isHe ? 'יום ראשון' : 'Sunday';
        const monLabel = isHe ? 'יום שני' : 'Monday';

        document.getElementById('settingsContent').innerHTML = `
            <h2>${settingsTitle}</h2>
            <div class="settings-row">
                <span class="settings-label">${langLabel}</span>
                <span class="settings-control">
                    <select onchange="setLang(this.value)">
                        <option value="en" ${lang==='en'?'selected':''}>English</option>
                        <option value="he" ${lang==='he'?'selected':''}>עברית</option>
                    </select>
                </span>
            </div>
            <div class="settings-row">
                <span class="settings-label">${weekStartLabel}</span>
                <span class="settings-control">
                    <select onchange="setWeekStart(+this.value)">
                        <option value="0" ${weekStartDay===0?'selected':''}>${sunLabel}</option>
                        <option value="1" ${weekStartDay===1?'selected':''}>${monLabel}</option>
                    </select>
                </span>
            </div>
            <div class="settings-row">
                <span class="settings-label">${templateLabel}</span>
                <span class="settings-control">
                    <button onclick="closeSettings();switchWeeklyMode('template')">${isHe?'עריכה':'Edit'}</button>
                </span>
            </div>
            <div style="margin-top:18px">
                <button class="modal-cancel-btn" style="width:100%;padding:14px;border-radius:var(--radius-sm);font-family:var(--font);font-size:15px;font-weight:800;cursor:pointer" onclick="closeSettings()">${doneLabel}</button>
            </div>`;
    }

    function setLang(l) {
        lang = l;
        localStorage.setItem('nextyLang', lang);
        applyLang();
        renderSettings();
        render();
    }

    function setWeekStart(day) {
        weekStartDay = day;
        localStorage.setItem('nextyWeekStart', String(day));
        computeDayOrder();
        // Recalculate dates and reload
        syncToStore();
        loadWeeklyData();
        renderSettings();
    }

    function applyLang() {
        const u = UI[lang];
        document.getElementById('pageTitle').textContent = weeklyMode === 'template' ? u.templateTitle : u.title;
        document.getElementById('addBtnLabel').textContent = u.add;
        document.getElementById('saveBtnLabel').textContent = u.save;
        document.getElementById('backBarText').textContent = u.backToWeek;
        document.documentElement.dir = lang === 'he' ? 'rtl' : 'ltr';
        document.documentElement.lang = lang;
        updateCopyBtn();
        renderDayTabs();
    }

    async function load() {
        computeDayOrder();
        // Set selectedWeekDay to today's position in the ordered week
        const todayCanonical = new Date().getDay();
        selectedWeekDay = dayOrder.indexOf(todayCanonical);
        if (selectedWeekDay < 0) selectedWeekDay = 0;
        const kidsRes = await fetch('/kids');
        kids = await kidsRes.json();
        if (kids.length > 0) selectedKidId = kids[0].id;
        renderKidTabs();
        await loadWeeklyData();
        // Restore template mode if it was active before page reload
        const isTemplate = weeklyMode === 'template';
        document.body.classList.toggle('template-mode', isTemplate);
        document.getElementById('backBar').style.display = isTemplate ? '' : 'none';
        document.querySelector('.settings-btn').style.display = isTemplate ? 'none' : '';
        applyLang();
    }

    function render() {
        const list = document.getElementById('list');
        list.innerHTML = '';

        if (activities.length === 0) {
            const empty = document.createElement('div');
            empty.className = 'empty-state';
            empty.innerHTML = `<span class="empty-emoji">📋</span><p>${UI[lang].empty}</p>`;
            list.appendChild(empty);
            return;
        }

        activities.forEach((a, i) => {
            const card = document.createElement('div');
            card.className = 'card';

            const isCustom = !!a.customTitle;
            const titleOptions = Object.keys(ACTIVITIES).map(k =>
                `<option value="${k}" ${!isCustom && k===a.titleKey?'selected':''}>${activityName(k)}</option>`
            ).join('') + `<option value="__custom__" ${isCustom?'selected':''}>${lang==='he'?'מותאם אישית':'Custom'}</option>`;

            card.innerHTML = `
                <div class="icon-badge hue-${i % 8}">${lucideIcon(a.imageName, 22)}</div>
                <div class="fields">
                    <div class="row">
                        <select class="title-select" onchange="selectActivity(${i}, this.value)">
                            ${titleOptions}
                        </select>
                        <div class="time-group">
                            <input class="time-input" type="number" min="0" max="23" value="${a.hour}"
                                onchange="setTime(${i},'hour',this.value)"
                                onfocus="this.select()">
                            <span class="time-sep">:</span>
                            <input class="time-input" type="number" min="0" max="59" value="${String(a.minute).padStart(2,'0')}"
                                onchange="setTime(${i},'minute',this.value)"
                                onfocus="this.select()">
                        </div>
                    </div>
                    ${isCustom ? `<div class="row" style="margin-top:8px">
                        <input class="title-select" type="text" value="${(a.customTitle||'').replace(/"/g,'&quot;')}"
                            placeholder="${lang==='he'?'שם הפעילות':'Activity name'}"
                            oninput="setCustomTitle(${i}, this.value)"
                            style="flex:1">
                        <input class="title-select" type="text" value="${a.imageName}"
                            placeholder="${lang==='he'?'אייקון':'Icon'}"
                            oninput="activities[${i}].imageName=this.value"
                            style="width:140px;font-size:12px">
                    </div>` : ''}
                </div>
                <button class="delete-btn" onclick="activities.splice(${i},1);render()">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                </button>
            `;
            list.appendChild(card);
        });
        hydrateIcons();
    }

    function uuid() {
        return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, c => {
            const r = Math.random() * 16 | 0;
            return (c === 'x' ? r : (r & 0x3 | 0x8)).toString(16);
        }).toUpperCase();
    }

    // SF Symbol → Lucide icon mapping (for legacy data stored as SF Symbol names)
    const SF_TO_LUCIDE = {
        'sun.max.fill':'sun','fork.knife':'utensils','mouth.fill':'sparkles',
        'tshirt.fill':'shirt','backpack.fill':'backpack','carrot.fill':'carrot',
        'gamecontroller.fill':'gamepad-2','figure.martial.arts':'swords',
        'bathtub.fill':'bath','book.fill':'book-open','moon.zzz.fill':'moon',
        'star.fill':'star','heart.fill':'heart','paintbrush.fill':'paintbrush',
        'music.note':'music','bicycle':'bike','figure.walk':'footprints',
        'figure.run':'person-standing','figure.pool.swim':'waves',
        'soccerball':'circle-dot','basketball.fill':'circle-dot','tennisball.fill':'circle',
        'figure.dance':'person-standing','pencil.and.ruler.fill':'ruler',
        'puzzlepiece.fill':'puzzle','theatermasks.fill':'drama','pianokeys':'piano',
        'cart.fill':'shopping-cart','house.fill':'house','car.fill':'car','bus.fill':'bus',
        'leaf.fill':'leaf','dog.fill':'dog','cat.fill':'cat','pawprint.fill':'paw-print',
        // Lucide names map to themselves (for icons stored directly as Lucide names)
        'sun':'sun','utensils':'utensils','sparkles':'sparkles','shirt':'shirt',
        'backpack':'backpack','carrot':'carrot','gamepad-2':'gamepad-2','swords':'swords',
        'bath':'bath','book-open':'book-open','moon':'moon','star':'star','heart':'heart',
        'paintbrush':'paintbrush','music':'music','bike':'bike','footprints':'footprints',
        'person-standing':'person-standing','waves':'waves','ruler':'ruler','puzzle':'puzzle',
        'drama':'drama','piano':'piano','shopping-cart':'shopping-cart','house':'house',
        'car':'car','bus':'bus','leaf':'leaf','dog':'dog','cat':'cat','paw-print':'paw-print',
        'cloud':'cloud','alarm-clock':'alarm-clock','bed':'bed','glasses':'glasses',
        'apple':'apple','pizza':'pizza','sandwich':'sandwich','cup-soda':'cup-soda',
        'cookie':'cookie','cake-slice':'cake-slice','milk':'milk','trophy':'trophy',
        'dumbbell':'dumbbell','mountain':'mountain','volleyball':'volleyball',
        'pencil':'pencil','palette':'palette','school':'school','plane':'plane',
        'store':'store','building':'building','flower':'flower','tree-pine':'tree-pine',
        'bird':'bird','fish':'fish','bug':'bug','tv':'tv','camera':'camera',
        'smile':'smile','party-popper':'party-popper','gift':'gift','phone':'phone',
        'circle-dot':'circle-dot'
    };

    function lucideIcon(sfName, size) {
        const name = SF_TO_LUCIDE[sfName] || 'circle';
        const s = size || 20;
        return `<i data-lucide="${name}" style="width:${s}px;height:${s}px"></i>`;
    }

    function hydrateIcons() {
        if (typeof lucide !== 'undefined') lucide.createIcons();
    }

    // Rich categorized icon catalog for the picker
    const ICON_CATALOG = [
        { cat: {en:'Daily Routine', he:'שגרה יומית'}, icons: [
            {lucide:'sun', label:'Sun'}, {lucide:'moon', label:'Moon'}, {lucide:'cloud', label:'Cloud'},
            {lucide:'alarm-clock', label:'Alarm'}, {lucide:'bed', label:'Bed'}, {lucide:'bath', label:'Bath'},
            {lucide:'sparkles', label:'Sparkles'}, {lucide:'shirt', label:'Shirt'}, {lucide:'glasses', label:'Glasses'},
        ]},
        { cat: {en:'Food & Drink', he:'אוכל ושתייה'}, icons: [
            {lucide:'utensils', label:'Utensils'}, {lucide:'carrot', label:'Carrot'}, {lucide:'apple', label:'Apple'},
            {lucide:'pizza', label:'Pizza'}, {lucide:'sandwich', label:'Sandwich'}, {lucide:'cup-soda', label:'Drink'},
            {lucide:'cookie', label:'Cookie'}, {lucide:'cake-slice', label:'Cake'}, {lucide:'milk', label:'Milk'},
        ]},
        { cat: {en:'Sports & Activity', he:'ספורט ופעילות'}, icons: [
            {lucide:'bike', label:'Bike'}, {lucide:'footprints', label:'Walk'}, {lucide:'person-standing', label:'Person'},
            {lucide:'waves', label:'Swim'}, {lucide:'swords', label:'Martial Arts'}, {lucide:'trophy', label:'Trophy'},
            {lucide:'dumbbell', label:'Gym'}, {lucide:'mountain', label:'Hike'}, {lucide:'volleyball', label:'Ball'},
        ]},
        { cat: {en:'Learning & Art', he:'לימוד ויצירה'}, icons: [
            {lucide:'book-open', label:'Book'}, {lucide:'pencil', label:'Pencil'}, {lucide:'ruler', label:'Ruler'},
            {lucide:'paintbrush', label:'Paint'}, {lucide:'music', label:'Music'}, {lucide:'piano', label:'Piano'},
            {lucide:'puzzle', label:'Puzzle'}, {lucide:'drama', label:'Theater'}, {lucide:'palette', label:'Palette'},
        ]},
        { cat: {en:'Travel & Places', he:'מקומות'}, icons: [
            {lucide:'house', label:'Home'}, {lucide:'school', label:'School'}, {lucide:'backpack', label:'Backpack'},
            {lucide:'car', label:'Car'}, {lucide:'bus', label:'Bus'}, {lucide:'plane', label:'Plane'},
            {lucide:'shopping-cart', label:'Shopping'}, {lucide:'store', label:'Store'}, {lucide:'building', label:'Building'},
        ]},
        { cat: {en:'Nature & Animals', he:'טבע ובעלי חיים'}, icons: [
            {lucide:'leaf', label:'Leaf'}, {lucide:'flower', label:'Flower'}, {lucide:'tree-pine', label:'Tree'},
            {lucide:'dog', label:'Dog'}, {lucide:'cat', label:'Cat'}, {lucide:'paw-print', label:'Paw'},
            {lucide:'bird', label:'Bird'}, {lucide:'fish', label:'Fish'}, {lucide:'bug', label:'Bug'},
        ]},
        { cat: {en:'Fun & Social', he:'כיף וחברה'}, icons: [
            {lucide:'gamepad-2', label:'Game'}, {lucide:'tv', label:'TV'}, {lucide:'camera', label:'Camera'},
            {lucide:'star', label:'Star'}, {lucide:'heart', label:'Heart'}, {lucide:'smile', label:'Smile'},
            {lucide:'party-popper', label:'Party'}, {lucide:'gift', label:'Gift'}, {lucide:'phone', label:'Phone'},
        ]},
    ];

    // Build flat lookup: lucide name → SF symbol name (for storage compatibility)
    const LUCIDE_TO_SF = {};
    Object.entries(SF_TO_LUCIDE).forEach(([sf, lc]) => { if (!LUCIDE_TO_SF[lc]) LUCIDE_TO_SF[lc] = sf; });

    function sfNameForLucide(lucideName) {
        return LUCIDE_TO_SF[lucideName] || lucideName;
    }

    // Keep CUSTOM_ICONS for backward compat but it's no longer used for rendering
    const CUSTOM_ICONS = ICON_CATALOG.flatMap(c => c.icons).map(ic => ({sf: sfNameForLucide(ic.lucide)}));

    let modalState = { selectedKey: null, isCustom: false, customName: '', customIcon: CUSTOM_ICONS[0].sf, hour: 12, minute: 0 };

    function addActivity() {
        modalState = { selectedKey: null, isCustom: false, customName: '', customIcon: CUSTOM_ICONS[0].sf, hour: 12, minute: 0 };
        renderModal();
        document.getElementById('addModal').classList.add('show');
    }

    function closeModal() {
        document.getElementById('addModal').classList.remove('show');
    }

    function selectModalPreset(key) {
        modalState.selectedKey = key;
        modalState.isCustom = false;
        renderModal();
    }

    function selectModalCustom() {
        modalState.selectedKey = null;
        modalState.isCustom = true;
        renderModal();
    }

    function selectModalIcon(sf) {
        modalState.customIcon = sf;
        renderModal();
    }

    let iconSearchQuery = '';

    function openIconPicker() {
        iconSearchQuery = '';
        renderIconPicker();
        document.getElementById('iconPickerModal').classList.add('show');
    }

    function closeIconPicker() {
        document.getElementById('iconPickerModal').classList.remove('show');
    }

    function pickIcon(lucideName) {
        const sf = sfNameForLucide(lucideName);
        // Ensure this lucide name is in SF_TO_LUCIDE for future lookups
        if (!SF_TO_LUCIDE[sf] && sf === lucideName) SF_TO_LUCIDE[lucideName] = lucideName;
        modalState.customIcon = sf;
        closeIconPicker();
        renderModal();
    }

    function onIconSearch(val) {
        iconSearchQuery = val.toLowerCase().trim();
        renderIconPicker();
    }

    function renderIconPicker() {
        const m = document.getElementById('iconPickerContent');
        const u = lang === 'he';
        const title = u ? 'בחירת אייקון' : 'Choose Icon';
        const searchPh = u ? 'חיפוש...' : 'Search icons...';
        const noResults = u ? 'לא נמצאו תוצאות' : 'No icons found';
        const q = iconSearchQuery;
        const selectedSf = modalState.customIcon;
        const selectedLucide = SF_TO_LUCIDE[selectedSf] || selectedSf;

        let bodyHtml = '';
        let anyResults = false;

        for (const group of ICON_CATALOG) {
            const filtered = q ? group.icons.filter(ic => ic.label.toLowerCase().includes(q) || ic.lucide.includes(q)) : group.icons;
            if (filtered.length === 0) continue;
            anyResults = true;
            const catName = group.cat[lang] || group.cat.en;
            bodyHtml += `<div class="icon-picker-category">${catName}</div>`;
            bodyHtml += `<div class="icon-picker-grid">`;
            for (const ic of filtered) {
                const sel = ic.lucide === selectedLucide ? ' selected' : '';
                bodyHtml += `<button class="icon-pick${sel}" onclick="pickIcon('${ic.lucide}')" title="${ic.label}">
                    <span class="ip-icon"><i data-lucide="${ic.lucide}" style="width:22px;height:22px"></i></span>
                    <span class="ip-label">${ic.label}</span>
                </button>`;
            }
            bodyHtml += `</div>`;
        }

        if (!anyResults) {
            bodyHtml = `<div class="icon-picker-empty">${noResults}</div>`;
        }

        m.innerHTML = `<h2>${title}</h2>
            <div class="icon-picker-search-wrap">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg>
                <input class="icon-picker-search" type="text" placeholder="${searchPh}" value="${iconSearchQuery}"
                    oninput="onIconSearch(this.value)">
            </div>
            <div class="icon-picker-body">${bodyHtml}</div>`;
        hydrateIcons();
        // Focus search field
        const input = m.querySelector('.icon-picker-search');
        if (input) setTimeout(() => input.focus(), 50);
    }

    function confirmAddActivity() {
        let a;
        if (modalState.selectedKey) {
            const preset = ACTIVITIES[modalState.selectedKey];
            a = { id: uuid(), titleKey: modalState.selectedKey, imageName: preset.icon, hour: modalState.hour, minute: modalState.minute, customTitle: null };
        } else if (modalState.isCustom && modalState.customName.trim()) {
            a = { id: uuid(), titleKey: 'custom', imageName: modalState.customIcon, hour: modalState.hour, minute: modalState.minute, customTitle: modalState.customName.trim() };
        } else {
            return;
        }
        activities.push(a);
        sortActivities();
        render();
        closeModal();
    }

    function renderModal() {
        const m = document.getElementById('addModalContent');
        const u = lang === 'he';
        const title = u ? 'הוספת פעילות' : 'Add Activity';
        const customLabel = u ? 'פעילות מותאמת' : 'Custom Activity';
        const addLabel = u ? 'הוספה' : 'Add';
        const cancelLabel = u ? 'ביטול' : 'Cancel';
        const namePh = u ? 'שם הפעילות' : 'Activity name';

        const presetKeys = Object.keys(ACTIVITIES);
        const presetBtns = presetKeys.map(k =>
            `<button class="preset-btn ${modalState.selectedKey===k?'selected':''}" onclick="selectModalPreset('${k}')">
                <span class="p-icon">${lucideIcon(ACTIVITIES[k].icon, 24)}</span>
                <span class="p-label">${activityName(k)}</span>
            </button>`
        ).join('');

        const customToggle = `<button class="custom-toggle ${modalState.isCustom?'selected':''}" onclick="selectModalCustom()">+ ${customLabel}</button>`;

        const chooseIconLabel = u ? 'בחר אייקון' : 'Choose Icon';
        const selectedLucide = SF_TO_LUCIDE[modalState.customIcon] || 'circle';
        const customFields = modalState.isCustom ? `<div class="custom-fields">
            <input type="text" value="${(modalState.customName||'').replace(/"/g,'&quot;')}" placeholder="${namePh}"
                oninput="modalState.customName=this.value;updateModalAddBtn()">
            <button class="icon-picker-trigger" onclick="openIconPicker()">
                <span class="trigger-preview"><i data-lucide="${selectedLucide}" style="width:20px;height:20px"></i></span>
                <span>${chooseIconLabel}</span>
            </button>
        </div>` : '';

        const canAdd = modalState.selectedKey || (modalState.isCustom && modalState.customName.trim());

        m.innerHTML = `<h2>${title}</h2>
            <div class="preset-grid">${presetBtns}</div>
            ${customToggle}
            ${customFields}
            <div class="modal-time">
                <input type="number" min="0" max="23" value="${modalState.hour}"
                    onchange="modalState.hour=+this.value" onfocus="this.select()">
                <span class="time-sep">:</span>
                <input type="number" min="0" max="59" value="${String(modalState.minute).padStart(2,'0')}"
                    onchange="modalState.minute=+this.value" onfocus="this.select()">
            </div>
            <div class="modal-actions">
                <button class="modal-add-btn" onclick="confirmAddActivity()" ${canAdd?'':'disabled'}>${addLabel}</button>
                <button class="modal-cancel-btn" onclick="closeModal()">${cancelLabel}</button>
            </div>`;
        hydrateIcons();
    }

    function updateModalAddBtn() {
        const btn = document.querySelector('.modal-add-btn');
        if (btn) btn.disabled = !(modalState.selectedKey || (modalState.isCustom && modalState.customName.trim()));
    }

    async function save() {
        syncToStore();
        const u = UI[lang];
        const btn = document.getElementById('saveBtn');
        btn.style.transform = 'scale(0.96)';
        setTimeout(() => btn.style.transform = '', 150);
        let endpoint;
        const qSep = kidParam() ? '&' : '?';
        if (weeklyMode === 'template') {
            const canonicalDay = dayOrder[selectedWeekDay];
            endpoint = '/weekly/template' + kidParam() + qSep + 'day=' + canonicalDay;
        } else {
            const dateStr = weekDates[selectedWeekDay];
            endpoint = '/weekly/day' + kidParam() + qSep + 'date=' + dateStr;
        }
        try {
            const res = await fetch(endpoint, {
                method: 'PUT',
                headers: {'Content-Type':'application/json'},
                body: JSON.stringify(activities)
            });
            if (res.ok) showToast(u.saved, true);
            else showToast(u.error, false);
        } catch { showToast(u.noConn, false); }
    }

    function showToast(msg, success) {
        const t = document.getElementById('toast');
        const icon = document.querySelector('.toast-icon');
        const msgEl = document.getElementById('toastMsg');
        icon.textContent = success ? '\u2714' : '\u2716';
        msgEl.textContent = msg;
        t.style.background = success ? '#2B9A66' : '#E5484D';
        t.classList.add('show');
        setTimeout(() => t.classList.remove('show'), 2500);
    }

    load();
    </script>
    </body>
    </html>
    """#
}
