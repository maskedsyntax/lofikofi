<script lang="ts">
  import { onMount, afterUpdate } from "svelte";
  import { fade, fly } from "svelte/transition";
  import Activity from "@lucide/svelte/icons/activity";
  import Apple from "@lucide/svelte/icons/apple";
  import ArrowRight from "@lucide/svelte/icons/arrow-right";
  import AudioLines from "@lucide/svelte/icons/audio-lines";
  import ClipboardList from "@lucide/svelte/icons/clipboard-list";
  import CloudRain from "@lucide/svelte/icons/cloud-rain";
  import Download from "@lucide/svelte/icons/download";
  import Feather from "@lucide/svelte/icons/feather";
  import Github from "@lucide/svelte/icons/github";
  import HardDrive from "@lucide/svelte/icons/hard-drive";
  import Headphones from "@lucide/svelte/icons/headphones";
  import Heart from "@lucide/svelte/icons/heart";
  import KanbanSquare from "@lucide/svelte/icons/kanban-square";
  import LayoutGrid from "@lucide/svelte/icons/layout-grid";
  import ListOrdered from "@lucide/svelte/icons/list-ordered";
  import Monitor from "@lucide/svelte/icons/monitor";
  import Moon from "@lucide/svelte/icons/moon";
  import Repeat2 from "@lucide/svelte/icons/repeat-2";
  import ShieldCheck from "@lucide/svelte/icons/shield-check";
  import Sparkles from "@lucide/svelte/icons/sparkles";
  import Sun from "@lucide/svelte/icons/sun";
  import Terminal from "@lucide/svelte/icons/terminal";
  import Timer from "@lucide/svelte/icons/timer";
  import WifiOff from "@lucide/svelte/icons/wifi-off";

  type Theme = "light" | "dark";
  const STORAGE_KEY = "lofikofi:marketing-theme";

  const iconProps = { size: 20, strokeWidth: 1.65, "aria-hidden": true as const };

  let theme: Theme = "light";
  let activePreview = 0;

  function syncPreview() {
    document.querySelectorAll<HTMLElement>("[data-panel-idx]").forEach((el) => {
      el.style.display = Number(el.dataset.panelIdx) === activePreview ? "" : "none";
    });
    document.querySelectorAll<HTMLElement>("[data-tab-idx]").forEach((el) => {
      el.classList.toggle("preview-tab--active", Number(el.dataset.tabIdx) === activePreview);
    });
    const tab = previewTabs[activePreview];
    const labelEl = document.getElementById("preview-label");
    const captionEl = document.getElementById("preview-caption");
    if (labelEl) labelEl.textContent = tab.label;
    if (captionEl) captionEl.textContent = tab.caption;
  }

  function selectTab(index: number) {
    activePreview = index;
    syncPreview();
  }

  afterUpdate(syncPreview);
  onMount(syncPreview);

  const featureCards = [
    {
      title: "Atmospheric Soundscapes",
      body: "Layer rain, forest, cafe ambience, ocean, and fireplace. Control each layer's volume, then save your favorite blend as a scene.",
      Icon: Headphones,
      accent: "warm"
    },
    {
      title: "Focus System",
      body: "Run Pomodoro or deep work sessions with minimal, glanceable controls. Stay interruption-free and in rhythm.",
      Icon: Timer,
      accent: "cool"
    },
    {
      title: "Micro To-Dos & Boards",
      body: "Capture micro-todos and lightweight kanban boards. Keep your thoughts organized without heavy project management.",
      Icon: KanbanSquare,
      accent: "neutral"
    },
    {
      title: "Layout & Theming",
      body: "Drag, resize, and toggle modular panels to shape your workspace. Choose light/dark, accent colors, and calm backgrounds.",
      Icon: Sparkles,
      accent: "muted"
    }
  ] as const;

  const metrics = [
    {
      title: "Atmosphere first",
      body: "Sound is the first interface: blend scenes until it feels right for you.",
      Icon: AudioLines
    },
    {
      title: "Consistency over complexity",
      body: "A narrow, predictable set of tools - quiet, familiar, and ready for focus.",
      Icon: Repeat2
    },
    {
      title: "Offline first",
      body: "A local-first app that stays ready even when you're offline.",
      Icon: WifiOff
    }
  ] as const;

  const steps = [
    {
      n: "01",
      title: "Set your atmosphere",
      body: "Pick a scene, then blend layers until it matches how you want to feel.",
      Icon: CloudRain
    },
    {
      n: "02",
      title: "Start your focus block",
      body: "Start Pomodoro or deep work. Minimal controls, clear status, zero noise.",
      Icon: Timer
    },
    {
      n: "03",
      title: "Capture only what matters",
      body: "Add micro-todos or cards, then return to the timer - stay in flow.",
      Icon: ClipboardList
    }
  ] as const;

  const previewTabs = [
    {
      label: "Ambient",
      Icon: Headphones,
      caption: "Blend layered soundscapes until it feels right."
    },
    {
      label: "Focus",
      Icon: Timer,
      caption: "Start Pomodoro or deep work and stay interruption-free."
    },
    {
      label: "Boards",
      Icon: KanbanSquare,
      caption: "Lightweight boards for calm organization and quick capture."
    },
    {
      label: "To-dos",
      Icon: ClipboardList,
      caption: "Micro-todos with a daily reset to keep things fresh."
    }
  ] as const;

  const downloads = [
    {
      title: "macOS",
      subtitle: "Universal (Apple Silicon + Intel)",
      href: "/downloads/lofikofi-macos",
      Icon: Apple
    },
    {
      title: "Windows",
      subtitle: "Installer (.exe)",
      href: "/downloads/lofikofi-windows",
      Icon: Monitor
    },
    {
      title: "Linux",
      subtitle: "AppImage / Debian package",
      href: "/downloads/lofikofi-linux",
      Icon: Terminal
    }
  ] as const;

  function applyTheme(next: Theme) {
    theme = next;
    if (typeof document === "undefined") return;
    document.documentElement.dataset.theme = next;
    try {
      window.localStorage.setItem(STORAGE_KEY, next);
    } catch {
      // no-op
    }
  }

  function toggleTheme() {
    applyTheme(theme === "light" ? "dark" : "light");
  }

  onMount(() => {
    let initial: Theme = "light";
    try {
      const stored = window.localStorage.getItem(STORAGE_KEY) as Theme | null;
      if (stored === "light" || stored === "dark") {
        initial = stored;
      } else if (window.matchMedia("(prefers-color-scheme: dark)").matches) {
        initial = "dark";
      }
    } catch {
      // no-op
    }

    applyTheme(initial);
  });
</script>

<div class="page-bg" aria-hidden="true"></div>

<div class="page">
  <header class="site-header">
    <a class="brand" href="#top">
      <span class="brand-mark">
        <Sparkles {...iconProps} size={22} />
      </span>
      <span class="brand-text">lofikofi</span>
    </a>

    <div class="header-actions">
      <button
        class="theme-toggle"
        type="button"
        on:click={toggleTheme}
        aria-label={theme === "light" ? "Switch to dark theme" : "Switch to light theme"}
      >
        {#if theme === "light"}
          <Moon {...iconProps} size={18} />
        {:else}
          <Sun {...iconProps} size={18} />
        {/if}
      </button>
      <a class="btn btn-primary btn-header-cta" href="#download">
        <Download {...iconProps} size={18} />
        Get app
      </a>
    </div>
  </header>

  <main id="top">
    <section class="hero">
      <div class="hero-copy" in:fly={{ x: -24, duration: 450 }}>
        <p class="eyebrow">
          <Sparkles {...iconProps} size={14} class="eyebrow-icon" />
          A calm digital room for focus
        </p>
        <h1>A quieter place to start work - and stay in flow.</h1>
        <p class="lead">
          Lofikofi is a distraction-free workspace you open before work. Blend ambient soundscapes, start a focused
          timer, and keep organization light.
        </p>

        <ul class="hero-pills" aria-label="Product highlights">
          <li><WifiOff {...iconProps} size={15} /> Offline-ready</li>
          <li><LayoutGrid {...iconProps} size={15} /> Rearrangeable panels</li>
        </ul>

        <div class="hero-cta">
          <a class="btn btn-primary" href="#download">
            <Download {...iconProps} size={18} />
            Download now
            <ArrowRight {...iconProps} size={17} class="btn-chevron" />
          </a>
          <a class="btn btn-ghost" href="#features">
            <LayoutGrid {...iconProps} size={18} />
            Explore features
          </a>
        </div>
      </div>

      <div class="hero-visual" in:fly={{ x: 24, duration: 450, delay: 120 }}>
        <div class="hero-card">
          <div class="hero-card-top">
            <div class="live-pill">
              <span class="live-dot" aria-hidden="true"></span>
              <Activity {...iconProps} size={15} />
              Live session
            </div>
            <span class="hero-card-tag">Deep work</span>
          </div>
          <div class="timer">48:12</div>
          <p class="card-subtitle">
            <CloudRain {...iconProps} size={16} class="inline-icon" />
            Rain + cafe mix · Pomodoro or deep work
          </p>
          <div class="chips">
            <span><Timer {...iconProps} size={14} /> Focus timer</span>
            <span><AudioLines {...iconProps} size={14} /> Ambient mixer</span>
            <span><KanbanSquare {...iconProps} size={14} /> Daily board</span>
          </div>
        </div>
      </div>
    </section>

    <section class="metrics" aria-label="Why Lofikofi">
      {#each metrics as m, i}
        {@const MetricIcon = m.Icon}
        <article in:fade={{ duration: 350, delay: 80 + i * 80 }}>
          <div class="metric-icon-wrap">
            <MetricIcon {...iconProps} size={22} />
          </div>
          <h3>{m.title}</h3>
          <p>{m.body}</p>
        </article>
      {/each}
    </section>

    <section id="preview" class="preview">
      <div class="section-head section-head--split section-head--preview">
        <div>
          <p class="eyebrow">
            <Sparkles {...iconProps} size={14} class="eyebrow-icon" />
            See the app
          </p>
          <h2>Get a feel for the room before you download.</h2>
          <p class="section-lead section-lead--right section-lead--preview">
            A quick, distraction-free preview of the main surfaces: ambient, focus, boards, and micro-todos.
          </p>
        </div>
      </div>

      <div class="preview-card">
        <div class="preview-tabs" role="tablist" aria-label="App preview tabs">
            <div class="preview-tabs-track">
              <button type="button" class="preview-tab preview-tab--active" data-tab-idx="0" on:click={() => selectTab(0)}>Ambient</button>
              <button type="button" class="preview-tab" data-tab-idx="1" on:click={() => selectTab(1)}>Focus</button>
              <button type="button" class="preview-tab" data-tab-idx="2" on:click={() => selectTab(2)}>Boards</button>
              <button type="button" class="preview-tab" data-tab-idx="3" on:click={() => selectTab(3)}>To-dos</button>
              <span class="preview-tabs-divider" aria-hidden="true"></span>
              <button type="button" class="preview-settings" aria-label="Toggle theme" on:click={toggleTheme}>
                {#if theme === "light"}
                  <Moon {...iconProps} size={14} />
                {:else}
                  <Sun {...iconProps} size={14} />
                {/if}
              </button>
            </div>
        </div>

          <div class="mock-app-media" aria-label="Mock app UI preview">
            <div class="mock-app">
              <div class="mock-app-body">
                <div class="mock-ambient" data-panel-idx="0">
                  <div class="mock-ambient-left">
                    <div class="mock-section-title">
                      Ambient mixer <span class="mock-live-dot" aria-hidden="true"></span>
                    </div>
                    <div class="mock-section-subtitle">1 layer playing</div>

                    <div class="mock-sound-list" role="list" aria-label="Sound layers">
                      <div class="mock-sound-row" role="listitem">
                        <span class="mock-radio" aria-hidden="true"></span>
                        <div>
                          <div class="mock-sound-name">Rain</div>
                          <div class="mock-sound-sub">Steady rainfall</div>
                        </div>
                      </div>
                      <div class="mock-sound-row" role="listitem">
                        <span class="mock-radio mock-radio--muted" aria-hidden="true"></span>
                        <div>
                          <div class="mock-sound-name">Calm rain</div>
                          <div class="mock-sound-sub">Gentle drizzle</div>
                        </div>
                      </div>
                      <div class="mock-sound-row" role="listitem">
                        <span class="mock-radio mock-radio--muted" aria-hidden="true"></span>
                        <div>
                          <div class="mock-sound-name">Rain + birds</div>
                          <div class="mock-sound-sub">Tropical shower</div>
                        </div>
                      </div>
                    </div>

                    <div class="mock-slider-card">
                      <div class="mock-slider-title">
                        Café <span class="mock-mini-dot" aria-hidden="true"></span>
                      </div>
                      <div class="mock-slider-bar" aria-hidden="true">
                        <div class="mock-slider-track"></div>
                        <div class="mock-slider-thumb"></div>
                      </div>
                    </div>
                  </div>

                  <div class="mock-ambient-right" aria-hidden="true">
                    <div class="mock-mic-circle">
                      <div class="mock-mic-shape"></div>
                    </div>
                    <div class="mock-wave-bars">
                      <span></span><span></span><span></span><span></span><span></span>
                      <span></span><span></span><span></span><span></span><span></span>
                    </div>
                  </div>
                </div>

                <div class="mock-focus" data-panel-idx="1" style="display:none">
                  <div class="mock-focus-mode-pill">
                    <span class="mock-focus-mode-pill__label">Focus timer</span>
                    <span class="mock-focus-mode-pill__badge">IDLE</span>
                  </div>
                  <div class="mock-focus-timer">25:00</div>
                  <div class="mock-focus-sub">25 minute focus, 5 minute break.</div>
                  <div class="mock-focus-buttons">
                    <button type="button" class="mock-pill-btn mock-pill-btn--active">Pomodoro</button>
                    <button type="button" class="mock-pill-btn">Deep work</button>
                  </div>
                  <div class="mock-focus-actions">
                    <button type="button" class="mock-action-btn mock-action-btn--primary">Start</button>
                    <button type="button" class="mock-action-btn">Reset</button>
                  </div>
                  <div class="mock-focus-hint">Space to start / pause, R to reset.</div>
                </div>

                <div class="mock-boards" data-panel-idx="2" style="display:none">
                  <div class="mock-board-desc">
                    Workspace board <span class="mock-board-desc-icon" aria-hidden="true"></span>
                    <div class="mock-board-sub">Drag-free kanban. Move cards with arrows.</div>
                  </div>
                  <div class="mock-board-columns" aria-hidden="true">
                    <div class="mock-board-col">
                      <div class="mock-board-col-title">TODAY</div>
                      <div class="mock-board-add">Add card...</div>
                    </div>
                    <div class="mock-board-col">
                      <div class="mock-board-col-title">THIS WEEK</div>
                      <div class="mock-board-add">Add card...</div>
                    </div>
                    <div class="mock-board-col">
                      <div class="mock-board-col-title">LATER</div>
                      <div class="mock-board-add">Add card...</div>
                    </div>
                  </div>
                </div>

                <div class="mock-todos" data-panel-idx="3" style="display:none">
                  <div class="mock-todos-tag">Micro-todos</div>
                  <div class="mock-todos-sub">Daily tasks. Resets each morning.</div>
                  <div class="mock-todos-input-row">
                    <div class="mock-todos-input" aria-hidden="true">Add a task...</div>
                    <button type="button" class="mock-todos-add-btn">Add</button>
                  </div>
                  <div class="mock-todos-empty">No tasks yet. Add one above.</div>
                  <div class="mock-todos-bottom">0 open</div>
                </div>
              </div>
            </div>
          </div>

        <div class="preview-caption">
          <div class="preview-caption-left">
            <span class="preview-caption-dot" aria-hidden="true"></span>
            <strong id="preview-label">Ambient</strong>
          </div>
          <span class="preview-caption-text" id="preview-caption">Blend layered soundscapes until it feels right.</span>
            <span class="preview-caption-hint">Interactive mock</span>
        </div>
      </div>
    </section>

    <section id="features" class="features">
      <div class="section-head">
        <p class="eyebrow">
          <LayoutGrid {...iconProps} size={14} class="eyebrow-icon" />
          What you get
        </p>
        <h2>Sound, focus, and lightweight planning - kept intentionally minimal.</h2>
        <p class="section-lead">
          Ambient soundscapes, a focused timer, and calm organization - without turning your desk into a dashboard.
        </p>
      </div>

      <div class="feature-grid">
        {#each featureCards as card, idx}
          {@const CardIcon = card.Icon}
          <article
            class="feature-card feature-card--{card.accent}"
            class:feature-card--hero={idx === 0}
            in:fade={{ duration: 300, delay: 100 + idx * 80 }}
          >
            <div class="feature-card-head">
              <span class="feature-icon-wrap">
                <CardIcon {...iconProps} size={24} />
              </span>
              <ArrowRight {...iconProps} size={18} class="feature-card-arrow" />
            </div>
            <h3>{card.title}</h3>
            <p>{card.body}</p>
          </article>
        {/each}
      </div>
    </section>

    <section id="workflow" class="workflow">
      <div class="section-head">
        <p class="eyebrow">
          <ListOrdered {...iconProps} size={14} class="eyebrow-icon" />
          How it works
        </p>
        <h2>Sit down. Start a scene. Begin your focus session.</h2>
        <p class="section-lead">Three calm steps you repeat until focus feels automatic.</p>
      </div>

      <div class="steps">
        {#each steps as step}
          {@const StepIcon = step.Icon}
          <article class="step">
            <div class="step-icon-row">
              <span class="step-badge">{step.n}</span>
              <div class="step-icon-wrap">
                <StepIcon {...iconProps} size={22} />
              </div>
            </div>
            <h3>{step.title}</h3>
            <p>{step.body}</p>
          </article>
        {/each}
      </div>
    </section>

    <section id="download" class="download">
      <div class="download-inner">
        <div class="download-copy">
          <p class="eyebrow">
            <Download {...iconProps} size={14} class="eyebrow-icon" />
            Get Lofikofi
          </p>
          <h2>Download for your operating system.</h2>
          <p class="lead">
            Choose your platform and download the app. It runs locally and stays ready for focus offline.
          </p>
          <ul class="download-trust">
            <li><HardDrive {...iconProps} size={16} /> Local-first, offline-ready</li>
            <li><ShieldCheck {...iconProps} size={16} /> No login required</li>
          </ul>
        </div>
        <div class="download-grid">
          {#each downloads as d}
            {@const OsIcon = d.Icon}
            <a class="download-btn" href={d.href} aria-label="Download for {d.title}">
              <span class="download-btn-icon">
                <OsIcon {...iconProps} size={26} />
              </span>
              <span class="download-btn-text">
                <strong>{d.title}</strong>
                <span>{d.subtitle}</span>
              </span>
              <ArrowRight {...iconProps} size={18} class="download-btn-arrow" />
            </a>
          {/each}
        </div>
      </div>
    </section>
  </main>

  <footer class="site-footer">
    <div class="footer-brand">
      <span class="brand-mark footer-brand-mark">
        <Sparkles {...iconProps} size={20} />
      </span>
      <div>
        <strong>lofikofi</strong>
        <p>A calm desktop workspace for focus, atmosphere, and steady sessions.</p>
      </div>
    </div>
    <div class="footer-cta">
      <p class="footer-cta-title">Want to help shape Lofikofi?</p>
      <a class="btn btn-primary btn-header-cta" href="https://github.com/maskedsyntax/lofikofi" target="_blank" rel="noreferrer">
        <Github {...iconProps} size={17} />
        Contribute on GitHub
      </a>
    </div>
    <p class="footer-meta">
      <Heart {...iconProps} size={14} class="footer-heart" />
      Built for focus
    </p>
  </footer>
</div>
