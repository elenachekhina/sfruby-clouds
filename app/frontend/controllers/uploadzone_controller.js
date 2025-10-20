import { Controller } from "@hotwired/stimulus";
import { DirectUpload } from "@rails/activestorage";

export default class extends Controller {
  static targets = ["input", "preview", "previewArea", "dropArea", "progress", "submitBtn", "blobInput"];

  connect() {
    this.element.addEventListener("dragover", this.preventDragDefaults);
    this.element.addEventListener("dragenter", this.preventDragDefaults);
  }

  disconnect() {
    this.element.removeEventListener("dragover", this.preventDragDefaults);
    this.element.removeEventListener("dragenter", this.preventDragDefaults);
  }

  preventDragDefaults(e) {
    e.preventDefault();
    e.stopPropagation();
  }

  trigger() {
    this.inputTarget.click();
  }

  reset() {
    this.previewTarget.removeAttribute("src");
    this.previewAreaTarget.classList.add("hidden");
    this.dropAreaTarget.classList.remove("hidden");
    this.inputTarget.value = "";
    this.submitBtnTarget.disabled = true;
    this.inputTarget.disabled = false;
  }

  acceptFiles(event) {
    event.preventDefault();
    const files = event.dataTransfer ? event.dataTransfer.files : event.target.files;
    [...files].forEach((f) => {
      if (f.size > 10 * 1024 * 1024) {
        alert("File size must be less than 10MB");
        return;
      }
      const upload = new DirectUpload(f, "/rails/active_storage/direct_uploads", this);

      this.previewTarget.src = URL.createObjectURL(f);
      this.previewAreaTarget.classList.remove("hidden");
      this.dropAreaTarget.classList.add("hidden");

      upload.create((error, blob) => {
        if (error) {
          // Handle the error
        } else {
          this.submitBtnTarget.disabled = false;
          this.blobInputTarget.value = blob.signed_id;
          this.inputTarget.disabled = true;
        }
      });
    });
  }

  directUploadWillStoreFileWithXHR(request) {
    request.upload.addEventListener("progress", (event) => this.updateProgress(event));
  }

  updateProgress(event) {
    const percentage = (event.loaded / event.total) * 100;
    if (this.hasProgressTarget) {
      this.progressTarget.style.transform = `translateX(-${100 - percentage}%)`;
    }
  }
}
