import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  search() {
    const form = this.element;
    const formData = new FormData(form);
    const params = new URLSearchParams(formData);
    const newUrl = `${form.action}?${params.toString()}`;

    Turbo.visit(newUrl, { frame: "categories_frame" });
    history.pushState({}, "", newUrl);
  }
}
