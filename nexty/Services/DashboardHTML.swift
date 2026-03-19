enum DashboardHTML {
    static let html = #"""
    <!DOCTYPE html>
    <html lang="en">
    <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <title>Nexty Schedule</title>
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

    .lang-select {
        position: fixed;
        top: 12px;
        right: 12px;
        z-index: 100;
        background: var(--card-bg);
        border: 1.5px solid var(--input-border);
        color: var(--text-secondary);
        font-family: var(--font);
        font-size: 13px;
        font-weight: 700;
        padding: 6px 28px 6px 10px;
        border-radius: var(--radius-sm);
        cursor: pointer;
        outline: none;
        -webkit-appearance: none;
        appearance: none;
        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%236E6E73' d='M6 8L1 3h10z'/%3E%3C/svg%3E");
        background-repeat: no-repeat;
        background-position: right 8px center;
    }

    [dir="rtl"] .lang-select {
        right: 12px;
        left: auto;
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
    </style>
    </head>
    <body>
    <select class="lang-select" id="langSelect" onchange="setLang(this.value)">
        <option value="en">English</option>
        <option value="he">עברית</option>
    </select>
    <div class="container">
        <div class="header">
            <div class="logo-group">
                <div class="logo-icon">N</div>
                <h1 id="pageTitle">Nexty Schedule</h1>
            </div>
        </div>
        <div class="tabs" id="kidTabs" style="display:none"></div>
        <div class="tabs">
            <button class="tab active" id="tabToday" onclick="switchTab('today')"><span id="tabTodayLabel">Today</span></button>
            <button class="tab" id="tabTomorrow" onclick="switchTab('tomorrow')"><span id="tabTomorrowLabel">Tomorrow</span></button>
        </div>
        <div class="activity-list" id="list"></div>
        <div class="actions">
            <button class="copy-btn" id="copyBtn" onclick="copyFromToday()" style="display:none">
                <span id="copyBtnLabel">Copy from Today</span>
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
        en: { title:'Nexty Schedule', add:'Add Activity', save:'Save Changes', saved:'Saved!', error:'Error saving', noConn:'Connection failed', empty:'No activities yet', today:'Today', tomorrow:'Tomorrow', copy:'Copy from Today' },
        he: { title:'לוח זמנים', add:'הוספת פעילות', save:'שמירה', saved:'!נשמר', error:'שגיאה בשמירה', noConn:'אין חיבור', empty:'אין פעילויות עדיין', today:'היום', tomorrow:'מחר', copy:'העתק מהיום' }
    };

    let kids = [];
    let selectedKidId = null;
    let todayActivities = [];
    let tomorrowActivities = [];
    let activities = [];
    let activeTab = 'today';
    let lang = localStorage.getItem('nextyLang') || 'en';

    function activityName(key) {
        const a = ACTIVITIES[key];
        return a ? a[lang] : key;
    }

    function sortActivities() {
        activities.sort((a, b) => (a.hour * 60 + a.minute) - (b.hour * 60 + b.minute));
    }

    function selectActivity(idx, key) {
        activities[idx].titleKey = key;
        const a = ACTIVITIES[key];
        if (a && a.icon) activities[idx].imageName = a.icon;
        render();
    }

    function setTime(idx, field, value) {
        activities[idx][field] = +value;
        sortActivities();
        render();
    }

    function switchTab(tab) {
        if (activeTab === tab) return;
        syncToStore();
        activeTab = tab;
        activities = activeTab === 'today' ? todayActivities : tomorrowActivities;
        document.getElementById('tabToday').className = 'tab' + (tab === 'today' ? ' active' : '');
        document.getElementById('tabTomorrow').className = 'tab' + (tab === 'tomorrow' ? ' active' : '');
        document.getElementById('copyBtn').style.display = tab === 'tomorrow' ? '' : 'none';
        render();
    }

    function syncToStore() {
        if (activeTab === 'today') todayActivities = activities;
        else tomorrowActivities = activities;
    }

    function copyFromToday() {
        tomorrowActivities = JSON.parse(JSON.stringify(todayActivities));
        tomorrowActivities.forEach(a => a.id = uuid());
        activities = tomorrowActivities;
        render();
    }

    function kidParam() {
        return selectedKidId ? '?kid=' + selectedKidId : '';
    }

    function selectKid(id) {
        if (selectedKidId === id) return;
        selectedKidId = id;
        loadActivitiesForKid();
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

    async function loadActivitiesForKid() {
        const q = kidParam();
        const [todayRes, tomorrowRes] = await Promise.all([
            fetch('/activities' + q),
            fetch('/activities/tomorrow' + q)
        ]);
        todayActivities = await todayRes.json();
        tomorrowActivities = await tomorrowRes.json();
        todayActivities.sort((a, b) => (a.hour * 60 + a.minute) - (b.hour * 60 + b.minute));
        tomorrowActivities.sort((a, b) => (a.hour * 60 + a.minute) - (b.hour * 60 + b.minute));
        activities = activeTab === 'today' ? todayActivities : tomorrowActivities;
        render();
    }

    function setLang(l) {
        lang = l;
        localStorage.setItem('nextyLang', lang);
        applyLang();
        render();
    }

    function applyLang() {
        const u = UI[lang];
        document.getElementById('pageTitle').textContent = u.title;
        document.getElementById('addBtnLabel').textContent = u.add;
        document.getElementById('saveBtnLabel').textContent = u.save;
        document.getElementById('tabTodayLabel').textContent = u.today;
        document.getElementById('tabTomorrowLabel').textContent = u.tomorrow;
        document.getElementById('copyBtnLabel').textContent = u.copy;
        document.getElementById('langSelect').value = lang;
        document.documentElement.dir = lang === 'he' ? 'rtl' : 'ltr';
        document.documentElement.lang = lang;
    }

    async function load() {
        const kidsRes = await fetch('/kids');
        kids = await kidsRes.json();
        if (kids.length > 0) selectedKidId = kids[0].id;
        renderKidTabs();
        await loadActivitiesForKid();
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

            const titleOptions = Object.keys(ACTIVITIES).map(k =>
                `<option value="${k}" ${k===a.titleKey?'selected':''}>${activityName(k)}</option>`
            ).join('');

            card.innerHTML = `
                <div class="icon-badge hue-${i % 8}">${String(a.hour).padStart(2,'0')}<br>${String(a.minute).padStart(2,'0')}</div>
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
        sortActivities();
        render();
    }

    async function save() {
        syncToStore();
        const u = UI[lang];
        const btn = document.getElementById('saveBtn');
        btn.style.transform = 'scale(0.96)';
        setTimeout(() => btn.style.transform = '', 150);
        const endpoint = (activeTab === 'today' ? '/activities' : '/activities/tomorrow') + kidParam();
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
