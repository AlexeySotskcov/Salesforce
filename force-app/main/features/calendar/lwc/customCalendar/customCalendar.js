import { LightningElement } from "lwc";
import { loadStyle, loadScript } from "lightning/platformResourceLoader";
import FullCalendarJS from "@salesforce/resourceUrl/FullCalendar";

export default class CustomCalendar extends LightningElement {
    connectedCallback() {
        Promise.all([
            loadStyle(this, FullCalendarJS + "/lib/main.css"),
            loadScript(this, FullCalendarJS + "/lib/main.js")
        ])
            .then(() => {
                this.initializeCalendar();
            })
            .catch((error) => console.log(error));
    }

    initializeCalendar() {
        const calendar = new FullCalendar.Calendar(this.refs.calendar, {});
        calendar.render();
    }
}
