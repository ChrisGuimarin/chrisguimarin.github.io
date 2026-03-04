---
title: Shelf
layout: base.njk
description: Essays, notes, and the books I keep handing to friends, all in one place.
---

{% render "page-header.njk", title: "Shelf", feedUrl: "/feed.xml", feedLabel: "Subscribe to book updates" %}

Words are how I see more clearly. Below are the essays I've been publishing and the books that keep reshaping how I look at the world. The shelf evolves as I read.

## Recent Writing

{% assign recentWriting = collections.writing | reverse %}
<ul class="writing-recent-list">
{% for post in recentWriting limit:3 %}
  <li>
    <a href="{{ post.url }}">{{ post.data.title }}</a>
    <span class="date"> — {{ post.data.date | date: "%B %Y" }}</span>
  </li>
{% endfor %}
</ul>

{% if collections.writing.length > 3 %}
<a href="/writing/">View all writing →</a>
{% endif %}

## Design & Product
{% assign designBooks = collections.books | byCategory: "Design & Product" %}
{% render "book-grid.njk", books: designBooks %}

## Leadership & Culture
{% assign leadershipBooks = collections.books | byCategory: "Leadership & Culture" %}
{% render "book-grid.njk", books: leadershipBooks %}

## Design Legends & Visual Inspiration
{% assign visualBooks = collections.books | byCategory: "Design Legends & Visual Inspiration" %}
{% render "book-grid.njk", books: visualBooks %}
