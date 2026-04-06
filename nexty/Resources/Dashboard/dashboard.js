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
