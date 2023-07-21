locals {
  stag_ecr_names = [
    "application-be-stag",
    "attachment-be-stag",
    "authority-be-stag",
    "backoffice-be-stag",
    "contour-middleware-be-stag",
    "feed-be-stag",
    "meal-be-stag",
    "notification-be-stag",
    "pick-be-stag",
    "point-be-stag",
    "report-be-stag",
    "schedule-be-stag",
    "timetable-be-stag",
    "user-be-stag"]
  stag_tag_prefix = "stag-"
  stag_tag_limit  = 5
}
