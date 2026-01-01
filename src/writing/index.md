---
title: Writing
layout: base.njk
description: Essays, notes, and explorations from the intersection of design, technology, and leadership.
permalink: /writing/
---

# Writing

{% if collections.writing.length > 0 %}
{% for post in collections.writing | reverse %}
## [{{ post.data.title }}]({{ post.url }})
{{ post.date | dateReadable }}

{% if post.data.excerpt %}
{{ post.data.excerpt }}
{% endif %}

{% endfor %}
{% else %}
Writing coming soon.
{% endif %}
