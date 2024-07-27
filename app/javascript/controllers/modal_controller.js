import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
    static targets = ['modal', 'k1']
    connect() {
        this.fetchData();
        this.interval = setInterval(() => this.fetchData(), 5000);
    }

    disconnect(url) {
        clearInterval(this.interval);
        if (url && url.length) {
            Turbo.visit(url);
        }
    }


    async fetchData() {
        const k1 = this.k1Target.value
        const response = await fetch(`${window.location.origin}/login?k1=${k1}`)
        if (response.status === 200) {
            const json = await response.json();
            this.disconnect(json.url);
        }
    }

    close() {
        const k1 = this.k1Target.value
        this.modalTarget.classList.add("hidden");
        setTimeout(() => {
            this.element.remove();
        }, 500);
    }
}
