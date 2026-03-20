<script lang="ts">
  import { onMount } from "svelte";
  import { fade, fly } from "svelte/transition";
  import Activity from "@lucide/svelte/icons/activity";
  import Apple from "@lucide/svelte/icons/apple";
  import AudioLines from "@lucide/svelte/icons/audio-lines";
  import ClipboardList from "@lucide/svelte/icons/clipboard-list";
  import CloudRain from "@lucide/svelte/icons/cloud-rain";
  import Download from "@lucide/svelte/icons/download";
  import LayoutGrid from "@lucide/svelte/icons/layout-grid";
  import Monitor from "@lucide/svelte/icons/monitor";
  import Moon from "@lucide/svelte/icons/moon";
  import Sun from "@lucide/svelte/icons/sun";
  import Terminal from "@lucide/svelte/icons/terminal";
  import Timer from "@lucide/svelte/icons/timer";
  import KanbanSquare from "@lucide/svelte/icons/kanban-square";
  import ListTodo from "@lucide/svelte/icons/list-todo";
  import Waves from "@lucide/svelte/icons/waves";
  import Sparkles from "@lucide/svelte/icons/sparkles";
  import HardDrive from "@lucide/svelte/icons/hard-drive";
  import ShieldCheck from "@lucide/svelte/icons/shield-check";
  import Heart from "@lucide/svelte/icons/heart";
  import Menu from "@lucide/svelte/icons/menu";
  import X from "@lucide/svelte/icons/x";

  type Theme = "light" | "dark";
  const STORAGE_KEY = "lofikofi:marketing-theme";

  const iconProps = { size: 20, strokeWidth: 1.65, "aria-hidden": true as const };

  let theme: Theme = "light";
  let activePage = "Ambient";
  let mobileMenuOpen = false;

  const tabs = [
    { label: "Ambient", Icon: Waves },
    { label: "Focus", Icon: Timer },
    { label: "Boards", Icon: KanbanSquare },
    { label: "To-dos", Icon: ListTodo }
  ];

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
    <div class="header-main">
      <div class="app-nav-container">
        <div class="app-nav">
          <div class="nav-indicator" style="transform: translateX({tabs.findIndex(t => t.label === activePage) * 100}%)"></div>
          {#each tabs as tab}
            <button 
              class="nav-tab" 
              class:active={activePage === tab.label}
              on:click={() => activePage = tab.label}
            >
              {tab.label}
            </button>
          {/each}
        </div>
        <div class="nav-divider"></div>
        <button
          class="nav-theme-toggle"
          on:click={toggleTheme}
          aria-label="Toggle theme"
        >
          {#if theme === "light"}
            <Moon size={14} />
          {:else}
            <Sun size={14} />
          {/if}
        </button>
      </div>
    </div>

    <div class="header-actions">
      <a class="btn btn-primary" href="#download">
        <Download size={16} />
        Download
      </a>
    </div>
  </header>

  <main>
    <section class="hero">
      <div class="hero-content">
        <div class="hero-copy">
          <p class="eyebrow">
            <Sparkles size={14} class="eyebrow-icon" />
            Deep work companion
          </p>
          <h1>{activePage === 'Ambient' ? 'Find your frequency.' : activePage === 'Focus' ? 'Protect your time.' : 'Plan with clarity.'}</h1>
          <p class="lead">
            {#if activePage === 'Ambient'}
              Mix layered soundscapes to drown out distractions. From steady rain to bustling cafes, create the perfect acoustic shield for your thoughts.
            {:else}
              Use Pomodoro or Deep Work timers to stay in the zone. Simple, visual countdowns designed to keep you focused without the stress.
            {:else}
              Lightweight boards and micro-todos to keep your day organized. No complex project management, just simple structure for deep work.
            {/if}
          </p>
          <div class="hero-cta">
            <a class="btn btn-primary btn-lg" href="#download">Get Lofikofi for Free</a>
          </div>
        </div>

        <div class="hero-app-preview">
          <div class="mock-window">
            <div class="window-controls">
              <span class="dot close"></span>
              <span class="dot minimize"></span>
              <span class="dot expand"></span>
              <span class="window-title">lofikofi</span>
            </div>
            
            <div class="window-nav-mock">
               <div class="mock-tabs">
                  {#each tabs as tab}
                    <span class:active={activePage === tab.label}>{tab.label}</span>
                  {/each}
                  <div class="mock-nav-divider"></div>
                  <div class="mock-theme">
                    <Moon size={10} />
                  </div>
               </div>
            </div>

            <div class="window-content-mock">
              {#if activePage === 'Ambient'}
                <div class="ambient-mock" in:fade>
                  <div class="mixer-side">
                    <div class="mixer-row active">
                      <div class="mixer-dot active"></div>
                      <div class="mixer-text">
                        <span class="label">Rain</span>
                        <span class="hint">Steady rainfall</span>
                      </div>
                      <div class="mixer-slider"></div>
                    </div>
                    <div class="mixer-row">
                      <div class="mixer-dot"></div>
                      <div class="mixer-text">
                        <span class="label">Forest</span>
                        <span class="hint">Woodland ambience</span>
                      </div>
                    </div>
                    <div class="mixer-row active">
                      <div class="mixer-dot active"></div>
                      <div class="mixer-text">
                        <span class="label">Café</span>
                        <span class="hint">Coffee shop murmur</span>
                      </div>
                      <div class="mixer-slider"></div>
                    </div>
                  </div>
                  <div class="visualizer-side">
                    <div class="mock-visualizer-icon">
                      <CloudRain size={40} />
                    </div>
                    <div class="mock-visualizer-bars">
                      {#each Array(12) as _, i}
                        <div class="bar" style="height: {10 + Math.random() * 20}px"></div>
                      {/each}
                    </div>
                  </div>
                </div>
              {:else if activePage === 'Focus'}
                <div class="focus-mock" in:fade>
                   <div class="timer-pill">Focus timer</div>
                   <div class="timer-display">24:58</div>
                   <div class="timer-status">IN SESSION</div>
                   <div class="timer-controls">
                     <div class="btn-mock primary">Pause</div>
                     <div class="btn-mock">Reset</div>
                   </div>
                </div>
              {:else}
                <div class="placeholder-mock" in:fade>
                  <div class="mock-empty">
                    <LayoutGrid size={32} opacity={0.3} />
                    <p>Structure for your deep work sessions.</p>
                  </div>
                </div>
              {/if}
            </div>
          </div>
        </div>
      </div>
    </section>

    <section id="download" class="download">
      <div class="download-inner">
        <div class="download-copy">
          <p class="eyebrow">Get the App</p>
          <h2>Ready to enter flow?</h2>
          <p class="lead">Lofikofi is free, offline-first, and respects your privacy. No accounts, no tracking.</p>
          <div class="os-grid">
             <div class="os-card">
               <Apple size={24} />
               <span>macOS</span>
             </div>
             <div class="os-card">
               <Monitor size={24} />
               <span>Windows</span>
             </div>
             <div class="os-card">
               <Terminal size={24} />
               <span>Linux</span>
             </div>
          </div>
        </div>
      </div>
    </section>
  </main>

  <footer class="site-footer">
    <div class="footer-content">
      <div class="footer-brand">
        <Sparkles size={18} />
        <strong>lofikofi</strong>
      </div>
      <p>Built for deep work. Inspired by Gruvbox.</p>
      <div class="footer-meta">
        <Heart size={14} /> 2026 Lofikofi Team
      </div>
    </div>
  </footer>
</div>
