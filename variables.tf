variable "stag_ecr" {
  type = map(object({
    image_limit = number
    tag_prefix  = string
  }))
  default = {
    application-be-stag = {
      image_limit = local.stag_tag_limit
      tag_prefix  = local.stag_tag_prefix
    }
    attachment-be-stag = {
      image_limit = local.stag_tag_limit
      tag_prefix  = local.stag_tag_prefix
    }
    authority-be-stag = {
      image_limit = local.stag_tag_limit
      tag_prefix  = local.stag_tag_prefix
    }
    backoffice-be-stag = {
      image_limit = local.stag_tag_limit
      tag_prefix  = local.stag_tag_prefix
    }
    contour-middleware-be-stag = {
      image_limit = local.stag_tag_limit
      tag_prefix  = local.stag_tag_prefix
    }
    feed-be-stag = {
      image_limit = local.stag_tag_limit
      tag_prefix  = local.stag_tag_prefix
    }
    meal-be-stag = {
      image_limit = local.stag_tag_limit
      tag_prefix  = local.stag_tag_prefix
    }
    notification-be-stag = {
      image_limit = local.stag_tag_limit
      tag_prefix  = local.stag_tag_prefix
    }
    pick-be-stag = {
      image_limit = local.stag_tag_limit
      tag_prefix  = local.stag_tag_prefix
    }
    point-be-stag = {
      image_limit = local.stag_tag_limit
      tag_prefix  = local.stag_tag_prefix
    }
    report-be-stag = {
      image_limit = local.stag_tag_limit
      tag_prefix  = local.stag_tag_prefix
    }
    schedule-be-stag = {
      image_limit = local.stag_tag_limit
      tag_prefix  = local.stag_tag_prefix
    }
    timetable-be-stag = {
      image_limit = local.stag_tag_limit
      tag_prefix  = local.stag_tag_prefix
    }
    user-be-stag = {
      image_limit = local.stag_tag_limit
      tag_prefix  = local.stag_tag_prefix
    }
  }
}
