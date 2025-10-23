import * as Turbo from "@hotwired/turbo";
window.Turbo = Turbo;

import { StreamActions } from "@hotwired/turbo";

// Use AnyCable Turbo integration: https://github.com/anycable/anycable-client/tree/master/packages/turbo-stream
import cable from "./cable";
import { start } from "@anycable/turbo-stream";
start(cable, {delayedUnsubscribe: true});

// Use morphing for all updates
import { Idiomorph } from "idiomorph/dist/idiomorph.esm";
// Use view transitions
import {
  shouldPerformTransition,
  performTransition,
} from "turbo-view-transitions";

let prevPath = window.location.pathname;

const morphRender = (prevEl, newEl, opts = {}) => {
  return Idiomorph.morph(prevEl, newEl, {
    ...opts,
    callbacks: {
      beforeNodeMorphed: (fromEl, toEl) => {
        if (typeof fromEl !== "object" || !fromEl.hasAttribute) return true;
        if (fromEl.isEqualNode(toEl)) return false;

        if (
          fromEl.hasAttribute("data-morph-permanent") &&
          toEl.hasAttribute("data-morph-permanent")
        ) {
          return false;
        }

        // Turbo Stream sources must be re-connected, so we don't morph them
        if (
          fromEl.tagName === "TURBO-CABLE-STREAM-SOURCE" &&
          fromEl.getAttribute("signed-stream-name") !==
            toEl.getAttribute("signed-stream-name")
        ) {
          fromEl.replaceWith(toEl);
          return false;
        }

        return true;
      },
    },
  });
};

document.addEventListener("turbo:before-render", (event) => {
  if (Turbo.navigator.currentVisit) {
    Turbo.navigator.currentVisit.scrolled =
      prevPath === window.location.pathname || (!!document.head.querySelector('meta[name="turbo-refresh-scroll"][content="preserve"]'));
  }
  prevPath = window.location.pathname;

  event.detail.render = async (prevEl, newEl) => {
    await new Promise((resolve) => setTimeout(() => resolve(), 0));
    await morphRender(prevEl, newEl);
  };

  if (shouldPerformTransition()) {
    // Make sure rendering is synchronous in this case
    event.detail.render = (prevEl, newEl) => {
      morphRender(prevEl, newEl);
    };

    event.preventDefault();

    performTransition(document.body, event.detail.newBody, async () => {
      await event.detail.resume();
    });
  }
});

document.addEventListener("turbo:before-frame-render", (event) => {
  event.detail.render = (prevEl, newEl) => {
    morphRender(prevEl, newEl.children, { morphStyle: "innerHTML" });
  };
});

document.addEventListener("turbo:before-stream-render", (event) => {
  if (shouldPerformTransition()) {
    const fallbackToDefaultActions = event.detail.render;

    event.detail.render = (streamEl) => {
      if (streamEl.action == "update" || streamEl.action == "replace") {
        const [target] = streamEl.targetElements;

        if (target) {
          return performTransition(
            target,
            streamEl.templateElement.content,
            async () => {
              await fallbackToDefaultActions(streamEl);
            },
            { transitionAttr: "data-turbo-stream-transition" }
          );
        }
      }
      return fallbackToDefaultActions(streamEl);
    };
  }
});

// Make replace morphing aware
StreamActions.replace = function () {
  this.targetElements.forEach((prevEl) => {
    morphRender(prevEl, this.templateContent.firstElementChild, {
      morphStyle: "outerHTML",
    });
  });
};

StreamActions.update = function () {
  this.targetElements.forEach((prevEl) => {
    morphRender(prevEl, this.templateContent.firstElementChild, {
      morphStyle: "innerHTML",
    });
  });
};

document.addEventListener("turbo:load", () => {
  if (shouldPerformTransition()) Turbo.cache.exemptPageFromCache();
});
