import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="menu"
export default class extends Controller {
    static targets = ['menu'];

    toggle() {
        console.log('jiji')
        this.menuTarget.classList.toggle("hidden");
    }
}
