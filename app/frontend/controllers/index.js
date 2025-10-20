import { Application } from "@hotwired/stimulus";

const application = Application.start();
// Configure Stimulus development experience
application.debug = document.documentElement.classList.contains("debug");
window.Stimulus = application;

import { registerControllers } from "stimulus-vite-helpers";

const controllers = import.meta.glob("./**/*_controller.*", { eager: true });
registerControllers(application, controllers);

for (const [path, module] of Object.entries(controllers)) {
  const name = path
    .replace(/^.\//, "")
    .replace("/", "--")
    .replace(/_controller\.js$/, "");
  application.register(name, module.default);
}
