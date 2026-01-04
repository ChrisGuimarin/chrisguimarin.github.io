---
title: Shelf
layout: base.njk
description: Essays, notes, and the books I keep handing to friends, all in one place.
---

{% render "page-header.njk", title: "Shelf", feedUrl: "/feed.xml", feedLabel: "Subscribe to book updates" %}

{% if collections.writing.length > 0 %}
    {% for post in collections.writing | reverse | slice(0, 3) %}
    - [{{ post.data.title }}]({{ post.url }}) - {{ post.date | dateReadable }}
    {% endfor %}
    {% if collections.writing.length > 3 %}
    [View all writing →](/writing/)
    {% endif %}
{% else %}
    Writing coming soon.
{% endif %}

Books are my favorite continuing-education program. Below are the titles I keep recommending to friends, spanning design, leadership, and the art of seeing. The shelf rotates as I read. Join my newsletter for updates on what is open on the nightstand.

## Design & Product
{% assign designBooks = collections.books | byCategory: "Design & Product" %}
{% render "book-grid.njk", books: designBooks %}

## Leadership & Culture
{% assign leadershipBooks = collections.books | byCategory: "Leadership & Culture" %}
{% render "book-grid.njk", books: leadershipBooks %}

## Design Legends & Visual Inspiration
{% assign visualBooks = collections.books | byCategory: "Design Legends & Visual Inspiration" %}
{% render "book-grid.njk", books: visualBooks %}
