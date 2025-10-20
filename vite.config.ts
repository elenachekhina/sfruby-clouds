import { defineConfig } from "vite";
import tailwindcss from "@tailwindcss/vite";
import RubyPlugin from "vite-plugin-ruby";
import { resolve } from 'path';

export default defineConfig({
  plugins: [tailwindcss(), RubyPlugin()],
  resolve: {
    alias: {
      '@assets': resolve(__dirname, 'app/assets'),
    },
  },
});
