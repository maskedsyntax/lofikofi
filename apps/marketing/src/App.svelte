<script lang="ts">
  import { onMount } from "svelte";
  import { fade, fly } from "svelte/transition";
  import Activity from "@lucide/svelte/icons/activity";
  import Apple from "@lucide/svelte/icons/apple";
  import ArrowRight from "@lucide/svelte/icons/arrow-right";
  import AudioLines from "@lucide/svelte/icons/audio-lines";
  import ClipboardList from "@lucide/svelte/icons/clipboard-list";
  import CloudRain from "@lucide/svelte/icons/cloud-rain";
  import Download from "@lucide/svelte/icons/download";
  import Feather from "@lucide/svelte/icons/feather";
  import HardDrive from "@lucide/svelte/icons/hard-drive";
  import Headphones from "@lucide/svelte/icons/headphones";
  import Heart from "@lucide/svelte/icons/heart";
  import KanbanSquare from "@lucide/svelte/icons/kanban-square";
  import LayoutGrid from "@lucide/svelte/icons/layout-grid";
  import ListOrdered from "@lucide/svelte/icons/list-ordered";
  import Menu from "@lucide/svelte/icons/menu";
  import Monitor from "@lucide/svelte/icons/monitor";
  import Moon from "@lucide/svelte/icons/moon";
  import Repeat2 from "@lucide/svelte/icons/repeat-2";
  import ShieldCheck from "@lucide/svelte/icons/shield-check";
  import Sparkles from "@lucide/svelte/icons/sparkles";
  import Sun from "@lucide/svelte/icons/sun";
  import Terminal from "@lucide/svelte/icons/terminal";
  import Timer from "@lucide/svelte/icons/timer";
  import WifiOff from "@lucide/svelte/icons/wifi-off";
  import X from "@lucide/svelte/icons/x";

  type Theme = "light" | "dark";
  const STORAGE_KEY = "lofikofi:marketing-theme";

  const iconProps = { size: 20, strokeWidth: 1.65, "aria-hidden": true as const };

  let theme: Theme = "light";
  let mobileMenuOpen = false;

  const links = [
    { label: "Features", href: "#features", Icon: LayoutGrid },
    { label: "How it works", href: "#workflow", Icon: ListOrdered },
    { label: "Download", href: "#download", Icon: Download }
  ];

  const featureCards = [
    {
      title: "Atmospheric Soundscapes",
      body: "Layer rain, forest, cafe ambience, ocean, and fireplace to create your personal focus environment.",
      Icon: Headphones,
      accent: "warm"
    },
    {
      title: "Focus System",
      body: "Switch between Pomodoro and deep work modes with clear, distraction-free session controls.",
      Icon: Timer,
      accent: "cool"
    },
    {
      title: "Calm Planning Surface",
      body: "Organize lightweight boards and daily micro-todos without the weight of complex project software.",
      Icon: KanbanSquare,
      accent: "neutral"
    },
    {
      title: "Offline-First Desktop",
      body: "Lofikofi runs locally, starts fast, and stays reliable even when your internet does not.",
      Icon: HardDrive,
      accent: "muted"
    }
  ] as const;

  const metrics = [
    {
      title: "Offline first",
      body: "Everything essential works locally on your machine.",
      Icon: WifiOff
    },
    {
      title: "Minimal by design",
      body: "A focused set of tools with no unnecessary bloat.",
      Icon: Feather
    },
    {
      title: "Built for consistency",
      body: "One coherent workspace for repeatable deep work sessions.",
      Icon: Repeat2
    }
  ] as const;

  const steps = [
    {
      n: "01",
      title: "Set your atmosphere",
      body: "Choose a sound scene that matches your current energy and context.",
      Icon: CloudRain
    },
    {
      n: "02",
      title: "Start your focus block",
      body: "Run a Pomodoro or deep work timer with clear, minimal controls.",
      Icon: Timer
    },
    {
      n: "03",
      title: "Capture only what matters",
      body: "Use micro-todos and boards to stay organized without context switching.",
      Icon: ClipboardList
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

  function closeMobileMenu() {
    mobileMenuOpen = false;
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

    <nav class="desktop-nav" aria-label="Primary">
      {#each links as link}
        {@const NavIcon = link.Icon}
        <a class="nav-link" href={link.href}>
          <NavIcon {...iconProps} size={17} class="nav-link-icon" />
          {link.label}
        </a>
      {/each}
    </nav>

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
        <span class="theme-toggle-label">{theme === "light" ? "Dark" : "Light"}</span>
      </button>
      <a class="btn btn-primary" href="#download">
        <Download {...iconProps} size={18} />
        Get app
      </a>
      <button
        class="mobile-menu"
        type="button"
        on:click={() => (mobileMenuOpen = !mobileMenuOpen)}
        aria-expanded={mobileMenuOpen}
        aria-label={mobileMenuOpen ? "Close menu" : "Open menu"}
      >
        {#if mobileMenuOpen}
          <X {...iconProps} size={20} />
        {:else}
          <Menu {...iconProps} size={20} />
        {/if}
      </button>
    </div>
  </header>

  {#if mobileMenuOpen}
    <div class="mobile-drawer" transition:fade={{ duration: 160 }}>
      {#each links as link}
        {@const DrawerIcon = link.Icon}
        <a class="mobile-drawer-link" href={link.href} on:click={closeMobileMenu}>
          <DrawerIcon {...iconProps} size={18} />
          {link.label}
        </a>
      {/each}
      <a class="mobile-drawer-link mobile-drawer-cta" href="#download" on:click={closeMobileMenu}>
        <Download {...iconProps} size={18} />
        Download
      </a>
    </div>
  {/if}

  <main id="top">
    <section class="hero">
      <div class="hero-copy" in:fly={{ x: -24, duration: 450 }}>
        <p class="eyebrow">
          <Sparkles {...iconProps} size={14} class="eyebrow-icon" />
          Calm desktop coworking space
        </p>
        <h1>A quieter place to get meaningful work done.</h1>
        <p class="lead">
          Lofikofi combines ambient sound, focused timing, and lightweight planning into one immersive workspace
          designed for deep concentration.
        </p>

        <ul class="hero-pills" aria-label="Product highlights">
          <li><WifiOff {...iconProps} size={15} /> Offline-ready</li>
          <li><LayoutGrid {...iconProps} size={15} /> Modular layout</li>
          <li><AudioLines {...iconProps} size={15} /> Layered audio</li>
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
            Rain + cafe mix · Pomodoro off
          </p>
          <div class="chips">
            <span><Timer {...iconProps} size={14} /> Focus timer</span>
            <span><AudioLines {...iconProps} size={14} /> Ambient mixer</span>
            <span><KanbanSquare {...iconProps} size={14} /> Daily board</span>
          </div>
        </div>
        <div class="hero-side-card">
          <p class="side-title">This week</p>
          <p class="side-stat">12 <span>sessions</span></p>
          <p class="side-hint">
            <Repeat2 {...iconProps} size={14} class="inline-icon" />
            Steady rhythm beats streaks.
          </p>
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

    <section id="features" class="features">
      <div class="section-head">
        <p class="eyebrow">
          <LayoutGrid {...iconProps} size={14} class="eyebrow-icon" />
          What you get
        </p>
        <h2>Everything your focus ritual needs.</h2>
        <p class="section-lead">Sound, timing, and light structure—without turning your desk into a dashboard.</p>
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
      <div class="section-head section-head--split">
        <div>
          <p class="eyebrow">
            <ListOrdered {...iconProps} size={14} class="eyebrow-icon" />
            How it works
          </p>
          <h2>Open app. Start scene. Enter flow.</h2>
        </div>
        <p class="section-lead section-lead--right">
          Three calm steps you repeat until focus feels automatic.
        </p>
      </div>

      <div class="steps">
        {#each steps as step, i}
          {@const StepIcon = step.Icon}
          <article class="step">
            {#if i < steps.length - 1}
              <div class="step-connector" aria-hidden="true"></div>
            {/if}
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
            Pick your platform—installers and release notes will land here as builds ship.
          </p>
          <ul class="download-trust">
            <li><HardDrive {...iconProps} size={16} /> Local-first app</li>
            <li><ShieldCheck {...iconProps} size={16} /> No account required</li>
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
        <p>A calmer desktop workspace—not another task manager.</p>
      </div>
    </div>
    <nav class="footer-nav" aria-label="Footer">
      <a href="#features">Features</a>
      <a href="#workflow">Workflow</a>
      <a href="#download">Download</a>
    </nav>
    <p class="footer-meta">
      <Heart {...iconProps} size={14} class="footer-heart" />
      Built for focus · Gruvbox-inspired
    </p>
  </footer>
</div>
