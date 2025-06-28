---
title: Design Work
layout: base.njk
description: Case studies and principles from a Blizzard UX leader.
---

# Design Work

## Professional Projects
{% for project in collections.work | reverse %}
{% if project.data.type == "professional" %}
- [{{ project.data.title }}]({{ project.url }}) - {{ project.data.role }}
{% endif %}
{% endfor %}

## Personal Projects
{% for project in collections.work | reverse %}
{% if project.data.type == "personal" %}
- [{{ project.data.title }}]({{ project.url }}) - {{ project.data.role }}
{% endif %}
{% endfor %}
