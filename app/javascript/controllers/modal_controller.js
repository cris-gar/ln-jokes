import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
    static targets = ['modal', 'k1']
    connect() {
    }

    close() {
        const k1 = this.k1Target.value
        console.log('k1', k1)
        this.modalTarget.classList.add("hidden");
    }
}
