//
/**
 * Copyright (C) 2018 HAT Data Exchange Ltd
 *
 * SPDX-License-Identifier: MPL2
 *
 * This file is part of the Hub of All Things project (HAT).
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/
 */

// MARK: Struct

public struct HATGoogleCalendarDataObject: HATObject {

    // MARK: - Variables
    
    /// The kind of the event, default is "calendar#event"
    public var kind: String = ""
    /// ETag of the resource, eg. \"2936510004024000\"
    public var etag: String = ""
    /// The id of the calendar event
    public var `id`: String = ""
    /// Status of the event. Optional. Possible values are:
    /// - **"confirmed"** - The event is confirmed. This is the default status.
    /// - **"tentative"** - The event is tentatively confirmed.
    /// - **"cancelled"** - The event is cancelled.
    public var status: String?
    /// An absolute link to this event in the Google Calendar Web UI.
    public var htmlLink: String = ""
    /// Date the event created in ISO format
    public var created: String = ""
    /// Date the event updated in ISO format
    public var updated: String = ""
    /// The title of the event
    public var summary: String = ""
    /// The description of the event
    public var description: String?
    /// Geographic location of the event as free-form text
    public var location: String?
    /// The color of the event. This is an ID referring to an entry in the event section of the colors definition [see the colors endpoint](https://developers.google.com/google-apps/calendar/v3/reference/colors).
    public var colorId: String?
    /// The creator of the event
    public var creator: HATGoogleCalendarCreatorObject = HATGoogleCalendarCreatorObject()
    ///The organizer of the event. If the organizer is also an attendee, this is indicated with a separate entry in attendees with the organizer field set to True. To change the organizer, use the [move](https://developers.google.com/google-apps/calendar/v3/reference/events/move) operation. Read-only, except when importing an event.
    public var organizer: HATGoogleCalendarOrganizerObject = HATGoogleCalendarOrganizerObject()
    /// The (inclusive) start time of the event. For a recurring event, this is the start time of the first instance.
    public var start: HATGoogleCalendarStartObject = HATGoogleCalendarStartObject()
    /// The (exclusive) end time of the event. For a recurring event, this is the end time of the first instance.
    public var end: HATGoogleCalendarEndObject = HATGoogleCalendarEndObject()
    /// Whether the end time is actually unspecified. An end time is still provided for compatibility reasons, even if this attribute is set to True. The default is False.
    public var endTimeUnspecified: Bool?
    /// List of RRULE, EXRULE, RDATE and EXDATE lines for a recurring event, as specified in RFC5545. Note that DTSTART and DTEND lines are not allowed in this field; event start and end times are specified in the start and end fields. This field is omitted for single events or instances of recurring events.
    public var recurrence: [String]?
    /// For an instance of a recurring event, this is the id of the recurring event to which this instance belongs. Immutable.
    public var recurringEventId: String?
    /// For an instance of a recurring event, this is the time at which this event would start according to the recurrence data in the recurring event identified by recurringEventId. Immutable.
    public var originalStartTime: HATGoogleCalendarStartObject?
    /// Whether the event blocks time on the calendar. Optional. Possible values are:
    /// - "opaque" - Default value. The event does block time on the calendar. This is equivalent to setting Show me as to Busy in the Calendar UI.
    /// - "transparent" - The event does not block time on the calendar. This is equivalent to setting Show me as to Available in the Calendar UI.
    public var transparency: String?
    /// Visibility of the event. Optional. Possible values are:
    /// - **"default"** - Uses the default visibility for events on the calendar. This is the default value.
    /// - **"public"** - The event is public and event details are visible to all readers of the calendar.
    /// - **"private"** - The event is private and only event attendees may view event details.
    /// - **"confidential"** - The event is private. This value is provided for compatibility reasons.
    public var visibility: String?
    /// Event unique identifier as defined in RFC5545. It is used to uniquely identify events accross calendaring systems and must be supplied when importing events via the [import](https://developers.google.com/google-apps/calendar/v3/reference/events/import) method.
    /// Note that the icalUID and the id are not identical and only one of them should be supplied at event creation time. One difference in their semantics is that in recurring events, all occurrences of one event have different ids while they all share the same icalUIDs.
    public var iCalUID: String = ""
    /// Sequence number as per iCalendar.
    public var sequence: Int = 0
    /// The attendees of the event. See the [Events with attendees](https://developers.google.com/google-apps/calendar/concepts/#events_with_attendees) guide for more information on scheduling events with other calendar users.
    public var attendees: [HATGoogleCalendarAttendeesObject]?
    /// Whether attendees may have been omitted from the event's representation. When retrieving an event, this may be due to a restriction specified by the **maxAttendee** query parameter. When updating an event, this can be used to only update the participant's response. Optional. The default is False.
    public var attendeesOmitted: Bool?
    /// Extended properties of the event.
    public var extendedProperties: HATGoogleCalendarExtendedPropertiesObject?
    /// An absolute link to the Google+ hangout associated with this event. Read-only.
    public var hangoutLink: String?
    /// The conference-related information, such as details of a Hangouts Meet conference. To create new conference details use the **createRequest** field. To persist your changes, remember to set the **conferenceDataVersion** request parameter to **1<\code> for all event modification requests.**
    public var conferenceData: HATGoogleCalendarConferenceDataObject?
    /// A gadget that extends this event.
    public var gadget: HATGoogleCalendarGadgetObject?
    /// Whether anyone can invite themselves to the event (currently works for Google+ events only). Optional. The default is False.
    public var anyoneCanAddSelf: Bool?
    /// Whether attendees other than the organizer can invite others to the event. Optional. The default is True.
    public var guestsCanInviteOthers: Bool?
    /// Whether attendees other than the organizer can modify the event. Optional. The default is False.
    public var guestsCanModify: Bool?
    /// Whether attendees other than the organizer can see who the event's attendees are. Optional. The default is True.
    public var guestsCanSeeOtherGuests: Bool?
    /// Whether this is a private event copy where changes are not shared with other copies on other calendars. Optional. Immutable. The default is False.
    public var privateCopy: Bool?
    /// Whether this is a locked event copy where no changes can be made to the main event fields "summary", "description", "location", "start", "end" or "recurrence". The default is False. Read-Only.
    public var locked: Bool?
    /// Information about the event's reminders for the authenticated user.
    public var reminders: HATGoogleCalendarRemindersObject?
    /// Source from which the event was created. For example, a web page, an email message or any document identifiable by an URL with HTTP or HTTPS scheme. Can only be seen or modified by the creator of the event.
    public var source: HATGoogleCalendarSourceObject?
    /// File attachments for the event. Currently only Google Drive attachments are supported.
    /// In order to modify attachments the **supportsAttachments** request parameter should be set to **true**.
    ///
    /// There can be at most 25 attachments per event.
    public var attachments: [HATGoogleCalendarAttachmentsObject]?
    
    // MARK: - Initialisers
    
    public init() {
        
    }
}
