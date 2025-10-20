import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String }

  connect() {
    console.log("Navigator controller connected");
  }

  go() {
    Turbo.visit(this.urlValue);
  }
}
