enum DashboardHTML {
    static let html = #"""
    <!DOCTYPE html>
    <html lang="en">
    <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <title>Nexty Schedule</title>
    <style>
    @import url('https://fonts.googleapis.com/css2?family=Baloo+2:wght@500;600;700;800&family=Nunito:wght@400;600;700;800&display=swap');

    :root {
        --bg-top: #FFF5E6;
        --bg-bottom: #FFE0F0;
        --card-bg: #FFFFFF;
        --card-shadow: 0 4px 20px rgba(0,0,0,0.06), 0 1px 4px rgba(0,0,0,0.04);
        --card-hover: 0 8px 32px rgba(0,0,0,0.1), 0 2px 8px rgba(0,0,0,0.06);
        --accent: #FF6B6B;
        --accent-glow: rgba(255,107,107,0.3);
        --accent-secondary: #4ECDC4;
        --accent-tertiary: #FFE66D;
        --text-primary: #2D3436;
        --text-secondary: #636E72;
        --text-muted: #B2BEC3;
        --input-bg: #F8F7FF;
        --input-border: #E8E4F0;
        --input-focus: #4ECDC4;
        --delete-color: #FD79A8;
        --delete-hover: #E84393;
        --radius-lg: 20px;
        --radius-md: 14px;
        --radius-sm: 10px;
        --font-display: 'Baloo 2', cursive;
        --font-body: 'Nunito', sans-serif;
    }

    * { margin: 0; padding: 0; box-sizing: border-box; -webkit-tap-highlight-color: transparent; }

    body {
        font-family: var(--font-body);
        background: linear-gradient(165deg, var(--bg-top) 0%, var(--bg-bottom) 50%, #E0E7FF 100%);
        min-height: 100vh;
        min-height: 100dvh;
        padding: 16px 16px 40px;
        overflow-x: hidden;
        position: relative;
    }

    body::before {
        content: '';
        position: fixed;
        top: -120px;
        right: -80px;
        width: 300px;
        height: 300px;
        background: radial-gradient(circle, rgba(255,230,109,0.35) 0%, transparent 70%);
        border-radius: 50%;
        pointer-events: none;
        z-index: 0;
    }

    body::after {
        content: '';
        position: fixed;
        bottom: -100px;
        left: -60px;
        width: 280px;
        height: 280px;
        background: radial-gradient(circle, rgba(78,205,196,0.2) 0%, transparent 70%);
        border-radius: 50%;
        pointer-events: none;
        z-index: 0;
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
        justify-content: center;
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
        width: 42px;
        height: 42px;
        background: linear-gradient(135deg, var(--accent) 0%, #FF8E53 100%);
        border-radius: 14px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 22px;
        box-shadow: 0 4px 14px var(--accent-glow);
        animation: logoPulse 3s ease-in-out infinite;
    }

    @keyframes logoPulse {
        0%, 100% { transform: scale(1) rotate(0deg); }
        50% { transform: scale(1.05) rotate(2deg); }
    }

    h1 {
        font-family: var(--font-display);
        color: var(--text-primary);
        font-size: 26px;
        font-weight: 800;
        letter-spacing: -0.3px;
        background: linear-gradient(135deg, var(--accent) 0%, #FF8E53 60%, var(--accent-tertiary) 100%);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
    }

    .lang-btn {
        position: absolute;
        right: 0;
        top: 50%;
        transform: translateY(-50%);
        background: var(--card-bg);
        border: 2px solid var(--input-border);
        color: var(--text-secondary);
        font-family: var(--font-body);
        font-size: 13px;
        font-weight: 700;
        padding: 7px 14px;
        border-radius: var(--radius-sm);
        cursor: pointer;
        transition: all 0.2s ease;
        letter-spacing: 0.3px;
    }

    .lang-btn:hover {
        border-color: var(--accent-secondary);
        color: var(--accent-secondary);
        box-shadow: 0 2px 12px rgba(78,205,196,0.2);
    }

    .lang-btn:active { transform: translateY(-50%) scale(0.95); }

    /* ---- ACTIVITY CARDS ---- */
    .activity-list {
        display: flex;
        flex-direction: column;
        gap: 10px;
        margin-bottom: 16px;
    }

    .card {
        background: var(--card-bg);
        border-radius: var(--radius-lg);
        padding: 14px;
        box-shadow: var(--card-shadow);
        display: flex;
        align-items: center;
        gap: 12px;
        cursor: grab;
        transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
        border: 2px solid transparent;
        position: relative;
        overflow: hidden;
    }

    .card::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 3px;
        background: linear-gradient(90deg, var(--accent-secondary), var(--accent-tertiary), var(--accent));
        opacity: 0;
        transition: opacity 0.3s ease;
    }

    .card:hover::before { opacity: 1; }
    .card:hover { box-shadow: var(--card-hover); transform: translateY(-1px); }
    .card:active { cursor: grabbing; }

    .card.dragging {
        opacity: 0.4;
        transform: scale(0.95) rotate(1deg);
        box-shadow: none;
    }

    .card.drag-over {
        border-color: var(--accent-secondary);
        background: linear-gradient(180deg, rgba(78,205,196,0.06) 0%, var(--card-bg) 100%);
    }

    /* ---- DRAG HANDLE ---- */
    .drag-handle {
        display: flex;
        flex-direction: column;
        gap: 3px;
        padding: 6px 2px;
        opacity: 0.25;
        transition: opacity 0.2s;
        flex-shrink: 0;
    }

    .card:hover .drag-handle { opacity: 0.5; }

    .drag-handle span {
        display: block;
        width: 14px;
        height: 2px;
        background: var(--text-secondary);
        border-radius: 2px;
    }

    /* ---- ICON BADGE ---- */
    .icon-badge {
        width: 48px;
        height: 48px;
        border-radius: 14px;
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
        letter-spacing: -0.2px;
        text-shadow: 0 1px 2px rgba(0,0,0,0.15);
        position: relative;
        overflow: hidden;
    }

    .icon-badge::after {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: linear-gradient(135deg, rgba(255,255,255,0.25) 0%, transparent 50%);
        border-radius: inherit;
    }

    .icon-badge.hue-0 { background: linear-gradient(135deg, #FF6B6B, #EE5A24); }
    .icon-badge.hue-1 { background: linear-gradient(135deg, #4ECDC4, #00B894); }
    .icon-badge.hue-2 { background: linear-gradient(135deg, #A29BFE, #6C5CE7); }
    .icon-badge.hue-3 { background: linear-gradient(135deg, #FD79A8, #E84393); }
    .icon-badge.hue-4 { background: linear-gradient(135deg, #FFEAA7, #FDCB6E); color: #6D4C00; text-shadow: none; }
    .icon-badge.hue-5 { background: linear-gradient(135deg, #74B9FF, #0984E3); }
    .icon-badge.hue-6 { background: linear-gradient(135deg, #55EFC4, #00CEC9); }
    .icon-badge.hue-7 { background: linear-gradient(135deg, #FAB1A0, #E17055); }

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
        font-family: var(--font-body);
        font-size: 15px;
        font-weight: 600;
        padding: 9px 10px;
        border: 2px solid var(--input-border);
        border-radius: var(--radius-sm);
        background: var(--input-bg);
        color: var(--text-primary);
        outline: none;
        transition: all 0.2s ease;
        -webkit-appearance: none;
        appearance: none;
    }

    select {
        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%23636E72' d='M6 8L1 3h10z'/%3E%3C/svg%3E");
        background-repeat: no-repeat;
        background-position: right 10px center;
        padding-right: 28px;
    }

    select:focus, input[type="number"]:focus {
        border-color: var(--input-focus);
        box-shadow: 0 0 0 3px rgba(78,205,196,0.15);
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
        border: 2px solid var(--input-border);
        border-radius: var(--radius-sm);
        padding: 0 4px;
        transition: all 0.2s ease;
    }

    .time-group:focus-within {
        border-color: var(--input-focus);
        box-shadow: 0 0 0 3px rgba(78,205,196,0.15);
        background: #fff;
    }

    .time-input {
        width: 40px;
        text-align: center;
        border: none !important;
        background: transparent !important;
        padding: 9px 2px !important;
        font-family: var(--font-display);
        font-size: 17px !important;
        font-weight: 700 !important;
        color: var(--text-primary);
        box-shadow: none !important;
    }

    .time-input:focus { box-shadow: none !important; }

    .time-sep {
        font-family: var(--font-display);
        font-size: 18px;
        font-weight: 800;
        color: var(--accent);
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
        background: rgba(253,121,168,0.1);
        color: var(--delete-hover);
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
        padding: 15px;
        border: 2.5px dashed rgba(78,205,196,0.5);
        border-radius: var(--radius-lg);
        background: rgba(78,205,196,0.06);
        color: var(--accent-secondary);
        font-family: var(--font-body);
        font-size: 16px;
        font-weight: 700;
        cursor: pointer;
        transition: all 0.25s ease;
    }

    .add-btn:hover {
        border-color: var(--accent-secondary);
        background: rgba(78,205,196,0.12);
        transform: translateY(-1px);
    }

    .add-btn:active { transform: translateY(0) scale(0.98); }

    .add-btn .plus-icon {
        width: 24px;
        height: 24px;
        background: var(--accent-secondary);
        border-radius: 8px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #fff;
        font-size: 16px;
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
        border-radius: var(--radius-lg);
        background: linear-gradient(135deg, var(--accent) 0%, #FF8E53 100%);
        color: #fff;
        font-family: var(--font-display);
        font-size: 19px;
        font-weight: 800;
        cursor: pointer;
        box-shadow: 0 6px 24px var(--accent-glow);
        transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
        letter-spacing: 0.3px;
    }

    .save-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 10px 32px rgba(255,107,107,0.4);
    }

    .save-btn:active {
        transform: translateY(0) scale(0.98);
        box-shadow: 0 4px 16px var(--accent-glow);
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
        border-radius: 16px;
        font-family: var(--font-body);
        font-size: 15px;
        font-weight: 700;
        opacity: 0;
        transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        pointer-events: none;
        z-index: 1000;
        box-shadow: 0 8px 32px rgba(0,0,0,0.2);
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
        font-size: 48px;
        margin-bottom: 12px;
        display: block;
        animation: emptyBounce 2s ease-in-out infinite;
    }

    @keyframes emptyBounce {
        0%, 100% { transform: translateY(0); }
        50% { transform: translateY(-8px); }
    }

    .empty-state p {
        font-family: var(--font-body);
        font-size: 16px;
        font-weight: 600;
    }

    /* ---- RTL ---- */
    [dir="rtl"] .lang-btn { right: auto; left: 0; }
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
    </style>
    </head>
    <body>
    <div class="container">
        <div class="header">
            <div class="logo-group">
                <div class="logo-icon">N</div>
                <h1 id="pageTitle">Nexty Schedule</h1>
            </div>
            <button class="lang-btn" onclick="toggleLang()" id="langBtn">עברית</button>
        </div>
        <div class="activity-list" id="list"></div>
        <div class="actions">
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
        'activity.sleep':        {en:'Sleep',          he:'שינה',         icon:'moon.zzz.fill'},
        'activity.new':          {en:'New Activity',   he:'פעילות חדשה',  icon:'star.fill'}
    };

    const UI = {
        en: { title:'Nexty Schedule', add:'Add Activity', save:'Save Changes', saved:'Saved!', error:'Error saving', noConn:'Connection failed', empty:'No activities yet' },
        he: { title:'לוח זמנים', add:'הוספת פעילות', save:'שמירה', saved:'!נשמר', error:'שגיאה בשמירה', noConn:'אין חיבור', empty:'אין פעילויות עדיין' }
    };

    let activities = [];
    let lang = localStorage.getItem('nextyLang') || 'en';
    let dragIdx = null;

    function activityName(key) {
        const a = ACTIVITIES[key];
        return a ? a[lang] : key;
    }

    function selectActivity(idx, key) {
        activities[idx].titleKey = key;
        const a = ACTIVITIES[key];
        if (a && a.icon) activities[idx].imageName = a.icon;
        render();
    }

    function toggleLang() {
        lang = lang === 'en' ? 'he' : 'en';
        localStorage.setItem('nextyLang', lang);
        applyLang();
        render();
    }

    function applyLang() {
        const u = UI[lang];
        document.getElementById('pageTitle').textContent = u.title;
        document.getElementById('addBtnLabel').textContent = u.add;
        document.getElementById('saveBtnLabel').textContent = u.save;
        document.getElementById('langBtn').textContent = lang === 'en' ? 'עברית' : 'English';
        document.documentElement.dir = lang === 'he' ? 'rtl' : 'ltr';
        document.documentElement.lang = lang;
    }

    async function load() {
        const res = await fetch('/activities');
        activities = await res.json();
        applyLang();
        render();
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
            card.draggable = true;
            card.dataset.index = i;

            card.ondragstart = e => { dragIdx = i; card.classList.add('dragging'); };
            card.ondragend = () => { dragIdx = null; card.classList.remove('dragging'); };
            card.ondragover = e => { e.preventDefault(); card.classList.add('drag-over'); };
            card.ondragleave = () => card.classList.remove('drag-over');
            card.ondrop = e => {
                e.preventDefault(); card.classList.remove('drag-over');
                if (dragIdx !== null && dragIdx !== i) {
                    const item = activities.splice(dragIdx, 1)[0];
                    activities.splice(i, 0, item);
                    render();
                }
            };

            // Touch drag support
            let touchStartY = 0;
            let touchClone = null;
            card.addEventListener('touchstart', e => {
                dragIdx = i;
                touchStartY = e.touches[0].clientY;
            }, {passive: true});
            card.addEventListener('touchmove', e => {
                e.preventDefault();
            }, {passive: false});
            card.addEventListener('touchend', e => {
                const endY = e.changedTouches[0].clientY;
                const cards = document.querySelectorAll('.card');
                let targetIdx = i;
                cards.forEach((c, ci) => {
                    const rect = c.getBoundingClientRect();
                    if (endY > rect.top && endY < rect.bottom && ci !== i) {
                        targetIdx = ci;
                    }
                });
                if (targetIdx !== i) {
                    const item = activities.splice(i, 1)[0];
                    activities.splice(targetIdx, 0, item);
                    render();
                }
                dragIdx = null;
            });

            const titleOptions = Object.keys(ACTIVITIES).map(k =>
                `<option value="${k}" ${k===a.titleKey?'selected':''}>${activityName(k)}</option>`
            ).join('');

            card.innerHTML = `
                <div class="drag-handle"><span></span><span></span><span></span></div>
                <div class="fields">
                    <div class="row">
                        <select class="title-select" onchange="selectActivity(${i}, this.value)">
                            ${titleOptions}
                        </select>
                        <div class="time-group">
                            <input class="time-input" type="number" min="0" max="23" value="${a.hour}"
                                oninput="activities[${i}].hour=+this.value"
                                onfocus="this.select()">
                            <span class="time-sep">:</span>
                            <input class="time-input" type="number" min="0" max="59" value="${String(a.minute).padStart(2,'0')}"
                                oninput="activities[${i}].minute=+this.value"
                                onfocus="this.select()">
                        </div>
                    </div>
                </div>
                <button class="delete-btn" onclick="activities.splice(${i},1);render()">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                </button>
            `;
            list.appendChild(card);
        });
    }

    function uuid() {
        return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, c => {
            const r = Math.random() * 16 | 0;
            return (c === 'x' ? r : (r & 0x3 | 0x8)).toString(16);
        }).toUpperCase();
    }

    function addActivity() {
        activities.push({
            id: uuid(),
            titleKey: 'activity.new',
            imageName: 'star.fill',
            hour: 12,
            minute: 0
        });
        render();
        setTimeout(() => window.scrollTo({top: document.body.scrollHeight, behavior: 'smooth'}), 50);
    }

    async function save() {
        const u = UI[lang];
        const btn = document.getElementById('saveBtn');
        btn.style.transform = 'scale(0.96)';
        setTimeout(() => btn.style.transform = '', 150);
        try {
            const res = await fetch('/activities', {
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
        t.style.background = success ? '#00B894' : '#E17055';
        t.classList.add('show');
        setTimeout(() => t.classList.remove('show'), 2500);
    }

    load();
    </script>
    </body>
    </html>
    """#
}
