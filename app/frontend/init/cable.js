import { createCable } from "@anycable/web";

const logLevel = document.documentElement.classList.contains("debug")
  ? "debug"
  : "error";

const cable = createCable({
  logLevel
});

export default cable;
