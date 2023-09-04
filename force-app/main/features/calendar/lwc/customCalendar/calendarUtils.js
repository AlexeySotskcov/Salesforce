import labelCalendar from "@salesforce/label/c.labelCalendar";
import labelNew from "@salesforce/label/c.labelNew";
import labelToday from "@salesforce/label/c.labelToday";

export const calendarLabels = {
    calendar: labelCalendar,
    new: labelNew,
    today: labelToday
};
export const calendarViewOptions = [
    {
        label: "Day",
        viewName: "timeGridDay",
        checked: false
    },
    {
        label: "Week",
        viewName: "timeGridWeek",
        checked: false
    },
    {
        label: "Month",
        viewName: "dayGridMonth",
        checked: true
    },
    {
        label: "Table",
        viewName: "listView",
        checked: false
    }
];
