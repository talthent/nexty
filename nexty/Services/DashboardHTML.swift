enum DashboardHTML {
    static let html = """
    <!DOCTYPE html>
    <html lang="en">
    <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nexty Schedule</title>
    <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        background: linear-gradient(135deg, #a8c8e8 0%, #6b8db5 100%);
        min-height: 100vh; padding: 20px;
    }
    .container { max-width: 500px; margin: 0 auto; }
    h1 {
        text-align: center; color: #fff; font-size: 28px; font-weight: 700;
        margin-bottom: 20px; text-shadow: 0 1px 3px rgba(0,0,0,0.2);
    }
    .card {
        background: #fff; border-radius: 16px; padding: 16px;
        margin-bottom: 12px; box-shadow: 0 2px 12px rgba(0,0,0,0.1);
        display: flex; align-items: center; gap: 12px;
        cursor: grab; transition: transform 0.15s, box-shadow 0.15s;
    }
    .card.dragging { opacity: 0.5; transform: scale(0.97); }
    .card.drag-over { border-top: 3px solid #4a90d9; }
    .emoji { font-size: 32px; min-width: 40px; text-align: center; }
    .fields { flex: 1; display: flex; flex-direction: column; gap: 6px; }
    .row { display: flex; gap: 8px; align-items: center; }
    input, select {
        font-size: 16px; padding: 8px 10px; border: 1px solid #ddd;
        border-radius: 10px; background: #f8f9fa; outline: none;
    }
    input:focus, select:focus { border-color: #4a90d9; }
    .title-input { flex: 1; }
    .time-input { width: 70px; text-align: center; }
    .icon-input { flex: 1; font-size: 14px; }
    .delete-btn {
        background: none; border: none; font-size: 22px; cursor: pointer;
        color: #ccc; padding: 8px; border-radius: 8px; transition: color 0.15s;
    }
    .delete-btn:hover { color: #e74c3c; }
    .add-btn {
        display: block; width: 100%; padding: 16px; border: 2px dashed #fff;
        border-radius: 16px; background: rgba(255,255,255,0.2); color: #fff;
        font-size: 18px; font-weight: 600; cursor: pointer; text-align: center;
        margin-bottom: 12px; transition: background 0.15s;
    }
    .add-btn:hover { background: rgba(255,255,255,0.35); }
    .save-btn {
        display: block; width: 100%; padding: 16px; border: none;
        border-radius: 16px; background: #2ecc71; color: #fff;
        font-size: 20px; font-weight: 700; cursor: pointer;
        box-shadow: 0 4px 12px rgba(46,204,113,0.4); transition: transform 0.1s;
    }
    .save-btn:hover { transform: scale(1.02); }
    .save-btn:active { transform: scale(0.98); }
    .toast {
        position: fixed; bottom: 30px; left: 50%; transform: translateX(-50%);
        background: #333; color: #fff; padding: 12px 24px; border-radius: 12px;
        font-size: 16px; font-weight: 600; opacity: 0; transition: opacity 0.3s;
        pointer-events: none;
    }
    .toast.show { opacity: 1; }
    </style>
    </head>
    <body>
    <div class="container">
        <h1>\\u{1F31F} Nexty Schedule</h1>
        <div id="list"></div>
        <button class="add-btn" onclick="addActivity()">+ Add Activity</button>
        <button class="save-btn" onclick="save()">Save Changes</button>
    </div>
    <div class="toast" id="toast"></div>
    <script>
    const ICONS = {
        'sun.max.fill':'\\u2600\\uFE0F','fork.knife':'\\uD83C\\uDF7D\\uFE0F','mouth.fill':'\\uD83E\\uDDB7',
        'tshirt.fill':'\\uD83D\\uDC55','backpack.fill':'\\uD83C\\uDF92','carrot.fill':'\\uD83E\\uDD55',
        'gamecontroller.fill':'\\uD83C\\uDFAE','figure.martial.arts':'\\uD83E\\uDD4B',
        'bathtub.fill':'\\uD83D\\uDEC1','book.fill':'\\uD83D\\uDCDA','moon.zzz.fill':'\\uD83C\\uDF19',
        'star.fill':'\\u2B50','heart.fill':'\\u2764\\uFE0F','music.note':'\\uD83C\\uDFB5',
        'bicycle':'\\uD83D\\uDEB2','paintbrush.fill':'\\uD83C\\uDFA8','leaf.fill':'\\uD83C\\uDF3F',
        'cup.and.saucer.fill':'\\u2615','pencil':'\\u270F\\uFE0F','graduationcap.fill':'\\uD83C\\uDF93'
    };
    const TITLES = [
        'activity.wakeUp','activity.breakfast','activity.teeth','activity.getDressed',
        'activity.school','activity.lunch','activity.play','activity.judo',
        'activity.dinner','activity.bath','activity.story','activity.sleep'
    ];
    let activities = [];
    let dragIdx = null;

    async function load() {
        const res = await fetch('/activities');
        activities = await res.json();
        render();
    }

    function render() {
        const list = document.getElementById('list');
        list.innerHTML = '';
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
            const emoji = ICONS[a.imageName] || '\\u2B50';
            card.innerHTML = `
                <div class="emoji">${emoji}</div>
                <div class="fields">
                    <div class="row">
                        <input class="title-input" value="${a.titleKey}" list="titles"
                            oninput="activities[${i}].titleKey=this.value">
                        <input class="time-input" type="number" min="0" max="23" value="${a.hour}"
                            oninput="activities[${i}].hour=+this.value">
                        <span style="color:#666">:</span>
                        <input class="time-input" type="number" min="0" max="59" value="${String(a.minute).padStart(2,'0')}"
                            oninput="activities[${i}].minute=+this.value">
                    </div>
                    <div class="row">
                        <select class="icon-input" onchange="activities[${i}].imageName=this.value;render()">
                            ${Object.keys(ICONS).map(k => `<option value="${k}" ${k===a.imageName?'selected':''}>${ICONS[k]} ${k}</option>`).join('')}
                        </select>
                    </div>
                </div>
                <button class="delete-btn" onclick="activities.splice(${i},1);render()">\\u2715</button>
            `;
            list.appendChild(card);
        });
    }

    function addActivity() {
        activities.push({
            id: crypto.randomUUID(),
            titleKey: 'activity.new',
            imageName: 'star.fill',
            hour: 12, minute: 0
        });
        render();
        window.scrollTo(0, document.body.scrollHeight);
    }

    async function save() {
        try {
            const res = await fetch('/activities', {
                method: 'PUT',
                headers: {'Content-Type':'application/json'},
                body: JSON.stringify(activities)
            });
            if (res.ok) showToast('\\u2705 Saved!');
            else showToast('\\u274C Error saving');
        } catch { showToast('\\u274C Connection failed'); }
    }

    function showToast(msg) {
        const t = document.getElementById('toast');
        t.textContent = msg;
        t.classList.add('show');
        setTimeout(() => t.classList.remove('show'), 2000);
    }

    load();
    </script>
    <datalist id="titles">
        <option value="activity.wakeUp"><option value="activity.breakfast">
        <option value="activity.teeth"><option value="activity.getDressed">
        <option value="activity.school"><option value="activity.lunch">
        <option value="activity.play"><option value="activity.judo">
        <option value="activity.dinner"><option value="activity.bath">
        <option value="activity.story"><option value="activity.sleep">
    </datalist>
    </body>
    </html>
    """
}
