import { LightningElement, api } from "lwc";
import { loadStyle, loadScript } from "lightning/platformResourceLoader";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import { calendarViewOptions, calendarLabels } from "./calendarUtils";
import customCalendar from "@salesforce/resourceUrl/fullCalendar";

export default class CustomCalendar extends LightningElement {
    @api
    objectApiName = "Account";

    labels = { ...calendarLabels };

    calendar;
    viewOptions = [...calendarViewOptions];

    connectedCallback() {
        Promise.all([
            loadStyle(this, customCalendar + "/lib/main.css"),
            loadScript(this, customCalendar + "/lib/main.js")
        ])
            .catch((error) => {
                this.dispatchToast(
                    "Loading library error",
                    "Something went wrong. Library could not be loaded! ",
                    "Error"
                );
            })
            .then(() => {
                this.initializeCalendar();
            })
            .catch((error) => {
                this.dispatchToast("Init library error", "Something went wrong. Library could not be init!", "error");
            });
    }

    initializeCalendar() {
        this.calendar = new FullCalendar.Calendar(this.refs.calendar, {
            headerToolbar: false,
            initialDate: new Date(),
            showNonCurrentDates: false,
            fixedWeekCount: false,
            allDaySlot: false,
            navLinks: false
        });
        this.calendar.render();
        this.calendar.setOption("contentHeight", 550);
    }

    dispatchToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title,
                message,
                variant
            })
        );
    }

    calendarActionsHandler(event) {
        switch (event.target.value) {
            case "previous":
                this.calendar.prev();
                break;
            case "today":
                this.calendar.today();
                break;
            case "next":
                this.calendar.next();
                break;
            case "new":
                // add logic for new event
                this.dispatchToast("Warning", "Action new is not implemented!", "warning");
                break;
            default:
                break;
            // refresh
        }
    }

    changeViewHandler(event) {
        const viewName = event.detail.value;
        if (viewName != "listView") {
            this.calendar.changeView(viewName);
            const options = [...calendarViewOptions];
            options.forEach((element) => {
                element.checked = element.viewName === viewName ? true : false;
            });
            this.viewOptions = options;
        } else {
            // add logic for display recent events
            this.dispatchToast("Warning", "Action display related events is not implemented!", "warning");
        }
    }

    get calendarTitle() {
        return this.calendar ? this.calendar.view.title : "";
    }
}
