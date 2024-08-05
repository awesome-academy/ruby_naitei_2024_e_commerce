import { Controller } from '@hotwired/stimulus'

// Connects to data-controller='vouchers'
export default class extends Controller {
  connect() {
    console.log('hello')
  }

  initialize(){
    this.element.setAttribute('data-action', 'change->vouchers#applyVoucher')
  }

  async applyVoucher() {
    const localeMetaTag = document.querySelector('meta[name="locale"]');
    const locale = localeMetaTag.getAttribute('content');
    const selectedTotal = this.element.options[this.element.selectedIndex].value
    console.log(selectedTotal)
    const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
    console.log(csrfToken)
    try {
      const response = await fetch(`/${locale}/bills/update_total`, {
        method: 'PATCH',
        headers: {
          'Accept': 'text/html, text/vnd.turbo-stream.html',
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken
        },
        body: JSON.stringify({ voucher_id: selectedTotal })
      }).then (response => response.text())
      .then(html => Turbo.renderStreamMessage(html));
    } catch (error) {
      console.error('Error:', error);
    }
  }
}
