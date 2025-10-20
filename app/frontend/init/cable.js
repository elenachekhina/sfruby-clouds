import { createCable } from "@anycable/web";

const logLevel = document.documentElement.classList.contains("debug")
  ? "debug"
  : "error";

const cable = createCable({
  logLevel,
  websocketAuthStrategy: "sub-protocol"
});

export default cable;
