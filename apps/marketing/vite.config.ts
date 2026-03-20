import { defineConfig } from "vite";
import { svelte } from "@sveltejs/vite-plugin-svelte";
import path from "path";

export default defineConfig({
  plugins: [svelte()],
  server: {
    port: 5180,
    strictPort: true
  },
  clearScreen: false,
  // Reuse repo-level `assets/` for images, sounds, and other static marketing media.
  publicDir: path.resolve(__dirname, "../../assets")
});
