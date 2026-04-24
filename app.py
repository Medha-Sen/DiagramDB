import streamlit as st
import sqlite3
import pandas as pd
import json
import os
from PIL import Image

# --- PAGE CONFIGURATION ---
st.set_page_config(
    page_title="DiagramDB Explorer",
    layout="wide",
    initial_sidebar_state="expanded",
    page_icon="◈"
)

# --- THEME & CSS ---
st.markdown("""
<style>
@import url('https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@300;400;500;600;700&family=JetBrains+Mono:wght@300;400;500;600&display=swap');

:root {
    --bg:           #080b12;
    --surface:      #0e1219;
    --surface2:     #141824;
    --surface3:     #1b2030;
    --border:       #1f2535;
    --border-hi:    #2d3550;

    --blue:         #4d9fff;
    --blue-glow:    rgba(77,159,255,0.18);
    --blue-border:  rgba(77,159,255,0.3);
    --violet:       #a78bfa;
    --violet-glow:  rgba(167,139,250,0.15);
    --violet-border:rgba(167,139,250,0.3);
    --cyan:         #22d3ee;
    --cyan-glow:    rgba(34,211,238,0.15);
    --cyan-border:  rgba(34,211,238,0.28);
    --green:        #34d399;
    --green-glow:   rgba(52,211,153,0.15);
    --green-border: rgba(52,211,153,0.28);
    --amber:        #fbbf24;
    --amber-glow:   rgba(251,191,36,0.15);
    --rose:         #fb7185;
    --rose-glow:    rgba(251,113,133,0.15);
    --rose-border:  rgba(251,113,133,0.3);

    --text:         #e8ecf4;
    --text-muted:   #6b7898;
    --text-faint:   #323a52;
    --mono:         'JetBrains Mono', monospace;
    --sans:         'Space Grotesk', sans-serif;
}

html, body, [class*="css"] {
    font-family: var(--sans) !important;
    background-color: var(--bg) !important;
    color: var(--text) !important;
}

#MainMenu, footer, header { visibility: hidden; }
.block-container { padding: 0 2rem 4rem !important; max-width: 100% !important; }

/* ── SIDEBAR ── */
section[data-testid="stSidebar"] {
    background: var(--surface) !important;
    border-right: 1px solid var(--border) !important;
    box-shadow: 4px 0 24px rgba(0,0,0,0.4);
}
section[data-testid="stSidebar"] .block-container { padding: 2rem 1.25rem !important; }

.brand { margin-bottom: 2rem; padding-bottom: 1.5rem; border-bottom: 1px solid var(--border); }
.brand-logo { display: flex; align-items: center; gap: 0.75rem; margin-bottom: 0.4rem; }
.brand-icon {
    width: 36px; height: 36px; border-radius: 8px;
    background: linear-gradient(135deg, #4d9fff, #a78bfa);
    display: flex; align-items: center; justify-content: center;
    font-size: 1rem; box-shadow: 0 4px 12px rgba(77,159,255,0.35);
}
.brand-name {
    font-family: var(--sans); font-size: 1.1rem; font-weight: 700;
    background: linear-gradient(90deg, #4d9fff, #a78bfa);
    -webkit-background-clip: text; -webkit-text-fill-color: transparent;
    letter-spacing: -0.01em;
}
.brand-version {
    font-family: var(--mono); font-size: 0.62rem;
    color: var(--text-faint); letter-spacing: 0.08em; margin-left: 44px;
}
.nav-label {
    font-family: var(--mono); font-size: 0.6rem; font-weight: 600;
    letter-spacing: 0.14em; text-transform: uppercase;
    color: var(--text-faint); margin: 1.5rem 0 0.5rem 0;
}

div[data-testid="stRadio"] label {
    font-family: var(--sans) !important; font-size: 0.82rem !important;
    font-weight: 400 !important; color: var(--text-muted) !important;
    padding: 0.4rem 0.65rem !important; border-radius: 6px !important; transition: all 0.15s !important;
}
div[data-testid="stRadio"] label:hover { color: var(--text) !important; background: var(--surface2) !important; }
div[data-testid="stRadio"] [aria-checked="true"] + label {
    color: var(--blue) !important; background: var(--blue-glow) !important; font-weight: 500 !important;
}

div[data-testid="stSelectbox"] > div > div {
    background: var(--surface2) !important; border: 1px solid var(--border-hi) !important;
    border-radius: 8px !important; font-family: var(--sans) !important;
    font-size: 0.82rem !important; color: var(--text) !important;
}
div[data-testid="stSelectbox"] > div > div:focus-within {
    border-color: var(--blue) !important; box-shadow: 0 0 0 3px var(--blue-glow) !important;
}

/* ── PAGE HERO ── */
.page-hero {
    background: linear-gradient(135deg, #0e1219 0%, #121828 50%, #0f1520 100%);
    border-bottom: 1px solid var(--border);
    padding: 2.5rem 2.5rem 2rem; margin: 0 -2rem 2.5rem;
    position: relative; overflow: hidden;
}
.page-hero::before {
    content: ''; position: absolute; top: -60px; right: -60px;
    width: 300px; height: 300px;
    background: radial-gradient(circle, rgba(77,159,255,0.07) 0%, transparent 70%);
    border-radius: 50%;
}
.page-hero::after {
    content: ''; position: absolute; bottom: -80px; left: 30%;
    width: 400px; height: 200px;
    background: radial-gradient(circle, rgba(167,139,250,0.05) 0%, transparent 70%);
    border-radius: 50%;
}
.hero-inner { display: flex; align-items: flex-end; justify-content: space-between; position: relative; z-index: 1; }
.hero-eyebrow {
    font-family: var(--mono); font-size: 0.62rem; letter-spacing: 0.2em;
    text-transform: uppercase; color: var(--blue); margin-bottom: 0.5rem;
    display: flex; align-items: center; gap: 0.5rem;
}
.hero-eyebrow::before { content: ''; display: inline-block; width: 18px; height: 1px; background: var(--blue); }
.hero-title { font-size: 2.2rem; font-weight: 700; letter-spacing: -0.03em; line-height: 1; margin: 0 0 0.6rem 0; }
.hero-title .grad {
    background: linear-gradient(90deg, #4d9fff 0%, #a78bfa 50%, #22d3ee 100%);
    -webkit-background-clip: text; -webkit-text-fill-color: transparent;
}
.hero-sub { font-size: 0.85rem; color: var(--text-muted); font-weight: 300; max-width: 480px; line-height: 1.6; }
.hero-badges { display: flex; gap: 0.6rem; flex-direction: column; align-items: flex-end; }
.hero-badge {
    font-family: var(--mono); font-size: 0.62rem; letter-spacing: 0.08em;
    text-transform: uppercase; padding: 0.28rem 0.7rem; border-radius: 100px;
    display: flex; align-items: center; gap: 0.4rem;
}
.badge-green { background: var(--green-glow); border: 1px solid var(--green-border); color: var(--green); }
.badge-blue  { background: var(--blue-glow);  border: 1px solid var(--blue-border);  color: var(--blue); }
.badge-violet{ background: var(--violet-glow);border: 1px solid var(--violet-border);color: var(--violet); }
.pulse { width: 6px; height: 6px; border-radius: 50%; background: currentColor; display: inline-block; animation: pulse 2s infinite; }
@keyframes pulse { 0%,100%{opacity:1} 50%{opacity:0.3} }

/* ── SECTION HEADERS ── */
.sec-head { display: flex; align-items: center; gap: 1rem; margin-bottom: 1.5rem; }
.sec-num {
    font-family: var(--mono); font-size: 0.6rem; font-weight: 600;
    color: var(--text-faint); letter-spacing: 0.1em;
    background: var(--surface2); border: 1px solid var(--border);
    padding: 0.2rem 0.55rem; border-radius: 4px;
}
.sec-title { font-size: 1.05rem; font-weight: 600; color: var(--text); margin: 0; letter-spacing: -0.01em; }
.sec-rule { flex: 1; height: 1px; background: linear-gradient(90deg, var(--border) 0%, transparent 100%); }

/* ── IMAGE PANELS ── */
.img-panel {
    border-radius: 12px; overflow: hidden;
    border: 1px solid var(--border); background: var(--surface);
    transition: border-color 0.25s, box-shadow 0.25s;
}
.img-panel:hover { border-color: var(--border-hi); box-shadow: 0 8px 40px rgba(0,0,0,0.5); }
.img-panel-header {
    padding: 0.65rem 1rem; display: flex; align-items: center;
    justify-content: space-between; border-bottom: 1px solid var(--border);
    background: var(--surface2);
}
.img-panel-title { font-family: var(--mono); font-size: 0.65rem; font-weight: 500; letter-spacing: 0.1em; text-transform: uppercase; }
.tag-original { color: var(--blue); }
.tag-tikz     { color: var(--violet); }
.img-panel-dots { display: flex; gap: 5px; }
.img-panel-dots span { width: 8px; height: 8px; border-radius: 50%; display: inline-block; }
.dot-r { background: #ff5f57; } .dot-y { background: #febc2e; } .dot-g { background: #28c840; }
.img-panel-body { padding: 0; background: #040609; }
.img-panel-footer {
    padding: 0.5rem 1rem; border-top: 1px solid var(--border);
    display: flex; align-items: center; justify-content: space-between;
    background: var(--surface2);
}
.img-panel-filename { font-family: var(--mono); font-size: 0.62rem; color: var(--text-faint); }
.img-status {
    font-family: var(--mono); font-size: 0.6rem; padding: 0.15rem 0.5rem;
    border-radius: 4px; display: flex; align-items: center; gap: 0.35rem;
}
.s-ok   { background: var(--green-glow);  color: var(--green);  border: 1px solid var(--green-border); }
.s-warn { background: var(--amber-glow);  color: var(--amber); }
.s-err  { background: var(--rose-glow);   color: var(--rose);   border: 1px solid var(--rose-border); }

/* ── JSON PANEL ── */
.json-panel {
    background: var(--surface); border: 1px solid var(--border);
    border-radius: 12px; overflow: hidden; margin-top: 1.5rem;
}
.json-panel-header {
    padding: 0.75rem 1.25rem; border-bottom: 1px solid var(--border);
    background: var(--surface2); display: flex; align-items: center; justify-content: space-between;
}
.json-header-left { display: flex; align-items: center; gap: 0.75rem; }
.json-icon {
    width: 32px; height: 32px; border-radius: 7px;
    background: linear-gradient(135deg, var(--cyan), var(--blue));
    display: flex; align-items: center; justify-content: center;
    font-size: 0.72rem; color: #000; font-weight: 700; font-family: var(--mono);
}
.json-label { font-family: var(--sans); font-size: 0.88rem; font-weight: 600; color: var(--text); }
.json-sublabel { font-family: var(--mono); font-size: 0.62rem; color: var(--text-muted); margin-top: 1px; }
.json-badge {
    font-family: var(--mono); font-size: 0.6rem; color: var(--cyan);
    background: var(--cyan-glow); border: 1px solid var(--cyan-border);
    padding: 0.2rem 0.7rem; border-radius: 100px; letter-spacing: 0.06em;
}
.json-panel-body { padding: 0.75rem; }

/* ── META STRIP ── */
.meta-strip { display: flex; gap: 0.75rem; align-items: center; flex-wrap: wrap; margin-bottom: 1.5rem; }
.meta-chip {
    display: inline-flex; align-items: center; gap: 0.45rem;
    font-family: var(--mono); font-size: 0.68rem;
    background: var(--surface2); border: 1px solid var(--border-hi);
    color: var(--text-muted); padding: 0.3rem 0.75rem; border-radius: 6px;
}
.meta-chip strong { color: var(--text); }
.chip-dot { width: 5px; height: 5px; border-radius: 50%; }
.chip-blue   { background: var(--blue);   box-shadow: 0 0 6px var(--blue); }
.chip-violet { background: var(--violet); box-shadow: 0 0 6px var(--violet); }

/* ── TABLE HEADS ── */
.tbl-head { display: flex; align-items: center; gap: 0.6rem; margin-bottom: 0.65rem; }
.tbl-icon {
    width: 22px; height: 22px; border-radius: 5px;
    display: flex; align-items: center; justify-content: center;
    font-size: 0.65rem; font-weight: 700; font-family: var(--mono);
}
.ti-blue   { background: var(--blue-glow);   color: var(--blue); }
.ti-violet { background: var(--violet-glow); color: var(--violet); }
.tbl-title {
    font-family: var(--mono); font-size: 0.65rem; font-weight: 600;
    letter-spacing: 0.1em; text-transform: uppercase; color: var(--text-muted);
}

/* ── DATAFRAMES ── */
div[data-testid="stDataFrame"] { border-radius: 8px !important; overflow: hidden !important; border: 1px solid var(--border) !important; }
div[data-testid="stDataFrame"] table { font-family: var(--mono) !important; font-size: 0.72rem !important; }
div[data-testid="stDataFrame"] th {
    background: var(--surface3) !important; color: var(--text-muted) !important;
    font-size: 0.63rem !important; letter-spacing: 0.1em !important; text-transform: uppercase !important;
    border-bottom: 1px solid var(--border-hi) !important; padding: 0.5rem 0.85rem !important; font-weight: 600 !important;
}
div[data-testid="stDataFrame"] td { color: var(--text) !important; border-bottom: 1px solid var(--border) !important; padding: 0.45rem 0.85rem !important; }
div[data-testid="stDataFrame"] tr:hover td { background: var(--surface2) !important; }
div[data-testid="stDataFrame"] tr:last-child td { border-bottom: none !important; }

/* ── QUERY ENGINE ── */
.q-label {
    font-family: var(--mono); font-size: 0.6rem; font-weight: 600;
    letter-spacing: 0.14em; text-transform: uppercase; color: var(--text-faint); margin-bottom: 0.5rem;
}
.question-card {
    background: linear-gradient(135deg, var(--surface2), var(--surface3));
    border: 1px solid var(--border-hi); border-left: 3px solid var(--blue);
    border-radius: 0 10px 10px 0; padding: 1.1rem 1.25rem 1.1rem 2rem;
    margin: 0.75rem 0 1.5rem; font-size: 0.98rem; font-weight: 500;
    color: var(--text); line-height: 1.55; position: relative;
}
.question-card::before {
    content: '"'; position: absolute; top: -0.2rem; left: 0.75rem;
    font-size: 3rem; color: var(--blue-border); font-family: Georgia, serif; line-height: 1;
}
.sql-label {
    font-family: var(--mono); font-size: 0.6rem; font-weight: 600;
    letter-spacing: 0.14em; text-transform: uppercase; color: var(--text-faint);
    margin-bottom: 0.5rem; display: flex; align-items: center; gap: 0.5rem;
}
.sql-label::before {
    content: 'SQL'; background: var(--surface3); border: 1px solid var(--border-hi);
    padding: 0.1rem 0.4rem; border-radius: 3px; color: var(--cyan); font-size: 0.58rem;
}

div[data-testid="stTextArea"] textarea {
    background: #040609 !important; border: 1px solid var(--border-hi) !important;
    border-radius: 8px !important; font-family: var(--mono) !important;
    font-size: 0.76rem !important; color: #7dd3fc !important; line-height: 1.75 !important; padding: 1rem 1.1rem !important;
}
div[data-testid="stTextArea"] textarea:focus {
    border-color: var(--blue) !important; box-shadow: 0 0 0 3px var(--blue-glow) !important;
}

div[data-testid="stButton"] button[kind="primary"] {
    background: linear-gradient(135deg, #3b82f6, #7c3aed) !important;
    color: #fff !important; border: none !important; border-radius: 8px !important;
    font-family: var(--sans) !important; font-size: 0.82rem !important; font-weight: 600 !important;
    letter-spacing: 0.02em !important; padding: 0.6rem 1.75rem !important;
    transition: all 0.2s !important; box-shadow: 0 4px 14px rgba(79,70,229,0.35) !important;
}
div[data-testid="stButton"] button[kind="primary"]:hover {
    transform: translateY(-1px) !important; box-shadow: 0 6px 20px rgba(79,70,229,0.5) !important;
}

.res-banner {
    display: flex; align-items: center; gap: 0.75rem;
    padding: 0.65rem 1rem; border-radius: 8px; margin: 1.5rem 0 0.75rem;
    font-family: var(--mono); font-size: 0.68rem; font-weight: 600;
    letter-spacing: 0.08em; text-transform: uppercase;
}
.rb-green { background: var(--green-glow); border: 1px solid var(--green-border); color: var(--green); }
.rb-amber { background: var(--amber-glow); border: 1px solid rgba(251,191,36,0.3); color: var(--amber); }

div[data-testid="stCode"] {
    background: #040609 !important; border: 1px solid var(--border-hi) !important;
    border-radius: 8px !important; font-family: var(--mono) !important; font-size: 0.76rem !important;
}
div[data-testid="stJson"] {
    background: #040609 !important; border-radius: 0 !important;
    font-family: var(--mono) !important; font-size: 0.73rem !important;
}

hr { border-color: var(--border) !important; margin: 2.5rem 0 !important; }
div[data-testid="stSpinner"] { font-family: var(--mono) !important; font-size: 0.78rem !important; }
div[data-testid="stAlert"] { border-radius: 8px !important; font-family: var(--sans) !important; }
</style>
""", unsafe_allow_html=True)


# --- GALLERY BUILDER ---
@st.cache_data
def build_gallery():
    gallery = {"Flowcharts": [], "Complex Diagrams": [], "Charts": []}
    image_dir = "images"
    if os.path.exists(image_dir):
        for filename in os.listdir(image_dir):
            if filename.lower().endswith((".png", ".jpg", ".jpeg")):
                base_name = os.path.splitext(filename)[0]
                if filename.startswith(("Break", "Connect", "Normal")):
                    gallery["Flowcharts"].append({"name": base_name, "id": base_name, "img": filename, "db": "flowchart_diagramdb.sqlite"})
                elif filename.startswith("chart"):
                    gallery["Charts"].append({"name": base_name, "id": base_name, "img": filename, "db": "charts.sqlite"})
                else:
                    gallery["Complex Diagrams"].append({"name": base_name, "id": base_name, "img": filename, "db": "diff_diagram.sqlite"})
    for cat in gallery:
        gallery[cat] = sorted(gallery[cat], key=lambda x: x["name"])
    return gallery

GALLERY = build_gallery()

# --- HELPERS ---
def load_json(filename):
    filepath = os.path.join("jsons", f"{filename}.json")
    if os.path.exists(filepath):
        with open(filepath, 'r') as f:
            return json.load(f)
    return {"error": f"JSON file not found at {filepath}"}

def run_query(db_name, query):
    if not os.path.exists(db_name):
        return pd.DataFrame({"Error": [f"Database '{db_name}' not found."]})
    try:
        conn = sqlite3.connect(db_name)
        df = pd.read_sql_query(query, conn)
        conn.close()
        return df
    except Exception as e:
        return pd.DataFrame({"SQL Error": [str(e)]})

def parse_sql_file(diagram_id):
    filepath = os.path.join("queries", f"{diagram_id}.sql")
    if not os.path.exists(filepath):
        return []
    with open(filepath, 'r') as f:
        content = f.read()
    blocks = content.split('============================================================')
    parsed_queries = []
    for block in blocks:
        block = block.strip()
        if not block:
            continue
        lines = block.split('\n')
        question, sql_lines, answer_lines, parsing_mode = "Unknown Question", [], [], 'init'
        for line in lines:
            if line.startswith('-- Question:'):
                question = line.replace('-- Question:', '').strip(); parsing_mode = 'sql'
            elif line.startswith('-- Verifiable Database Answer:'):
                parsing_mode = 'answer'
            elif parsing_mode == 'sql':
                if not line.startswith('-- Auto-generated'): sql_lines.append(line)
            elif parsing_mode == 'answer':
                clean = line.replace('--', '').strip()
                if clean: answer_lines.append(clean)
        sql_query = '\n'.join(sql_lines).strip()
        if sql_query.endswith(';;'): sql_query = sql_query[:-2]
        expected = '\n'.join(answer_lines).strip()
        if question != "Unknown Question":
            parsed_queries.append({"question": question, "sql": sql_query, "expected": expected})
    return parsed_queries


# ══════════════════════════════════════════════════════
#  SIDEBAR
# ══════════════════════════════════════════════════════
with st.sidebar:
    st.markdown("""
    <div class="brand">
        <div class="brand-logo">
            <div class="brand-icon">◈</div>
            <div class="brand-name">DiagramDB</div>
        </div>
        <div class="brand-version">Explorer · v1.0.0</div>
    </div>
    """, unsafe_allow_html=True)

    if not any(GALLERY.values()):
        st.error("No images found in 'images/' folder.")
        st.stop()

    st.markdown('<div class="nav-label">Diagram Type</div>', unsafe_allow_html=True)
    category = st.radio("type", list(GALLERY.keys()), label_visibility="collapsed")

    if not GALLERY[category]:
        st.warning(f"No images in '{category}'.")
        st.stop()

    st.markdown('<div class="nav-label">Select Image</div>', unsafe_allow_html=True)
    selection = st.selectbox("image", [item["name"] for item in GALLERY[category]], label_visibility="collapsed")

current_item = next(item for item in GALLERY[category] if item["name"] == selection)
diagram_id   = current_item["id"]
db_file      = current_item["db"]


# ══════════════════════════════════════════════════════
#  PAGE HERO
# ══════════════════════════════════════════════════════
st.markdown(f"""
<div class="page-hero">
    <div class="hero-inner">
        <div>
            <div class="hero-eyebrow">Research Pipeline</div>
            <h1 class="hero-title"><span class="grad">DiagramDB</span> Explorer</h1>
            <p class="hero-sub">Transforming raw pixels into structured relational space.
            Inspect the neuro-symbolic pipeline from raster image to grounded SQL.</p>
        </div>
        <div class="hero-badges">
            <div class="hero-badge badge-green"><span class="pulse"></span>System Active</div>
            <div class="hero-badge badge-blue">DB · {db_file}</div>
            <div class="hero-badge badge-violet">ID · {diagram_id}</div>
        </div>
    </div>
</div>
""", unsafe_allow_html=True)


# ══════════════════════════════════════════════════════
#  SECTION 1 — LARGE SIDE-BY-SIDE IMAGES + JSON BELOW
# ══════════════════════════════════════════════════════
st.markdown("""
<div class="sec-head">
    <span class="sec-num">01</span>
    <h2 class="sec-title">Visual Code Space Comparison</h2>
    <div class="sec-rule"></div>
</div>
""", unsafe_allow_html=True)

img_col1, img_col2 = st.columns(2, gap="large")

# ── Original Raster (LEFT) ──
with img_col1:
    img_path   = os.path.join("images", current_item["img"])
    img_exists = os.path.exists(img_path)
    s_class    = "s-ok" if img_exists else "s-err"
    s_label    = "LOADED" if img_exists else "MISSING"
    st.markdown(f"""
    <div class="img-panel">
        <div class="img-panel-header">
            <div class="img-panel-dots"><span class="dot-r"></span><span class="dot-y"></span><span class="dot-g"></span></div>
            <span class="img-panel-title tag-original">▸ Original Raster</span>
            <span class="img-status {s_class}"><span class="pulse"></span>{s_label}</span>
        </div>
        <div class="img-panel-body">
    """, unsafe_allow_html=True)
    if img_exists:
        st.image(Image.open(img_path), use_column_width=True)
    else:
        st.warning("Image file not found.")
    st.markdown(f"""
        </div>
        <div class="img-panel-footer">
            <span class="img-panel-filename">{current_item['img']}</span>
            <span class="img-status s-ok">PNG · RASTER</span>
        </div>
    </div>
    """, unsafe_allow_html=True)

# ── TikZ Reconstruction (RIGHT) ──
with img_col2:
    tikz_path   = os.path.join("tikz_images", current_item["img"])
    tikz_exists = os.path.exists(tikz_path)
    t_class     = "s-ok" if tikz_exists else "s-warn"
    t_label     = "RENDERED" if tikz_exists else "PENDING"
    st.markdown(f"""
    <div class="img-panel">
        <div class="img-panel-header">
            <div class="img-panel-dots"><span class="dot-r"></span><span class="dot-y"></span><span class="dot-g"></span></div>
            <span class="img-panel-title tag-tikz">▸ TikZ Reconstruction</span>
            <span class="img-status {t_class}"><span class="pulse"></span>{t_label}</span>
        </div>
        <div class="img-panel-body">
    """, unsafe_allow_html=True)
    if tikz_exists:
        st.image(Image.open(tikz_path), use_column_width=True)
    else:
        st.info("TikZ reconstruction not yet available for this image.")
    st.markdown(f"""
        </div>
        <div class="img-panel-footer">
            <span class="img-panel-filename">{current_item['img']}</span>
            <span class="img-status {t_class}">TEX · VECTOR</span>
        </div>
    </div>
    """, unsafe_allow_html=True)

# ── JSON Graph — full width below ──
json_data = load_json(diagram_id)
st.markdown(f"""
<div class="json-panel">
    <div class="json-panel-header">
        <div class="json-header-left">
            <div class="json-icon">&#123;&#125;</div>
            <div>
                <div class="json-label">Extracted JSON Graph</div>
                <div class="json-sublabel">Structured representation of diagram topology</div>
            </div>
        </div>
        <div class="json-badge">&#x2713; PARSED · {diagram_id}</div>
    </div>
    <div class="json-panel-body">
""", unsafe_allow_html=True)
with st.container(height=400):
    st.json(json_data)
st.markdown("</div></div>", unsafe_allow_html=True)


# ══════════════════════════════════════════════════════
#  SECTION 2 — RELATIONAL SCHEMA
# ══════════════════════════════════════════════════════
st.markdown("<hr>", unsafe_allow_html=True)
st.markdown("""
<div class="sec-head">
    <span class="sec-num">02</span>
    <h2 class="sec-title">Grounded Relational Schema</h2>
    <div class="sec-rule"></div>
</div>
""", unsafe_allow_html=True)

st.markdown(f"""
<div class="meta-strip">
    <div class="meta-chip"><span class="chip-dot chip-blue"></span>&nbsp;Database&nbsp;<strong>{db_file}</strong></div>
    <div class="meta-chip"><span class="chip-dot chip-violet"></span>&nbsp;Active ID&nbsp;<strong>{diagram_id}</strong></div>
</div>
""", unsafe_allow_html=True)

t1, t2 = st.columns(2, gap="large")

if db_file in ["flowchart_diagramdb.sqlite", "diff_diagram.sqlite"]:
    with t1:
        st.markdown('<div class="tbl-head"><div class="tbl-icon ti-blue">N</div><span class="tbl-title">Nodes Table</span></div>', unsafe_allow_html=True)
        st.dataframe(run_query(db_file, f"SELECT * FROM Nodes WHERE DiagramID = '{diagram_id}'"), use_container_width=True, hide_index=True)
    with t2:
        st.markdown('<div class="tbl-head"><div class="tbl-icon ti-violet">E</div><span class="tbl-title">Edges Table</span></div>', unsafe_allow_html=True)
        st.dataframe(run_query(db_file, f"SELECT * FROM Edges WHERE DiagramID = '{diagram_id}'"), use_container_width=True, hide_index=True)
elif db_file == "charts.sqlite":
    with t1:
        st.markdown('<div class="tbl-head"><div class="tbl-icon ti-blue">M</div><span class="tbl-title">Chart Metadata</span></div>', unsafe_allow_html=True)
        st.dataframe(run_query(db_file, f"SELECT * FROM ChartMetadata WHERE ChartID = '{diagram_id}'"), use_container_width=True, hide_index=True)
    with t2:
        st.markdown('<div class="tbl-head"><div class="tbl-icon ti-violet">D</div><span class="tbl-title">Data Points</span></div>', unsafe_allow_html=True)
        st.dataframe(run_query(db_file, f"SELECT * FROM ChartData WHERE ChartID = '{diagram_id}'"), use_container_width=True, hide_index=True)


# ══════════════════════════════════════════════════════
#  SECTION 3 — QUERY ENGINE
# ══════════════════════════════════════════════════════
st.markdown("<hr>", unsafe_allow_html=True)
st.markdown("""
<div class="sec-head">
    <span class="sec-num">03</span>
    <h2 class="sec-title">Neuro-Symbolic Query Engine</h2>
    <div class="sec-rule"></div>
</div>
""", unsafe_allow_html=True)

parsed_data = parse_sql_file(diagram_id)

if parsed_data:
    query_dict    = {item['question']: item for item in parsed_data}
    question_list = list(query_dict.keys())

    st.markdown('<div class="q-label">Natural language question</div>', unsafe_allow_html=True)
    selected_q = st.selectbox("Question", question_list, label_visibility="collapsed")

    st.markdown(f'<div class="question-card">{selected_q}</div>', unsafe_allow_html=True)

    selected_sql = query_dict[selected_q]['sql']
    expected_ans = query_dict[selected_q]['expected']

    st.markdown('<div class="sql-label">Generated SQL Translation</div>', unsafe_allow_html=True)
    user_query = st.text_area("SQL", value=selected_sql, height=220, label_visibility="collapsed")

    if st.button("⬡  Execute Query", type="primary"):
        with st.spinner("Running neuro-symbolic inference..."):
            result_df = run_query(db_file, user_query)

        st.markdown('<div class="res-banner rb-green"><span>✦</span> Execution Result</div>', unsafe_allow_html=True)
        if not result_df.empty:
            st.dataframe(result_df, use_container_width=True, hide_index=True)
        else:
            st.info("Query executed successfully — returned 0 rows.")

        st.markdown('<div class="res-banner rb-amber"><span>◉</span> Expected Verifiable Answer</div>', unsafe_allow_html=True)
        st.code(expected_ans, language="python")

else:
    st.info(f"No pre-generated queries for **{diagram_id}**. Enter SQL manually below.")
    st.markdown('<div class="sql-label">Manual SQL Input</div>', unsafe_allow_html=True)
    user_query = st.text_area("SQL", height=160, label_visibility="collapsed")

    if st.button("⬡  Execute Query", type="primary"):
        with st.spinner("Executing..."):
            result_df = run_query(db_file, user_query)
        st.markdown('<div class="res-banner rb-green"><span>✦</span> Execution Result</div>', unsafe_allow_html=True)
        st.dataframe(result_df, use_container_width=True, hide_index=True)