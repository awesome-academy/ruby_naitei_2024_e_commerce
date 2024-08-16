import { Controller } from '@hotwired/stimulus';
import { get } from '@rails/request.js'
// Connects to data-controller="address"
export default class extends Controller {
  static targets = ["countrySelect", "stateSelect", "citySelect"]
  change(event){
    let country = event.target.selectedOptions[0].value
    let target = this.stateSelectTarget.id
    get(`/bills/states?target=${target}&country=${country}`, {
      responseKind: "turbo-stream"
    })

  }
  change_city(event){
    let state = event.target.selectedOptions[0].value
    let target = this.citySelectTarget.id
    get(`/bills/cities?target=${target}&state=${state}`, {
      responseKind: "turbo-stream"
    })
  }
}
