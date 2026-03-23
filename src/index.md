---
title: Home
layout: base.njk
description: Design Leader at Blizzard, Broadway investor, and connector of big ideas to next steps.
---

<picture>
  <source type="image/webp"
          srcset="/assets/images/chris-guimarin-300.webp 300w,
                  /assets/images/chris-guimarin-600.webp 600w"
          sizes="80px">
  <img src="/assets/images/chris-guimarin-300.jpg"
       srcset="/assets/images/chris-guimarin-300.jpg 300w,
               /assets/images/chris-guimarin-600.jpg 600w"
       sizes="80px"
       alt="Chris Guimarin"
       class="homepage-avatar"
       loading="eager"
       decoding="async">
</picture>

# Hi, I'm Chris.

<p class="page-subtitle">Design Leader and Broadway Backer</p>

Where imagination meets pragmatism.

Millions of players rely on Battle.net every day. My team smooths their experience from the moment they log in to the final checkout screen. Behind the scenes we power the tools that support customer service teams, helping them respond with clarity and speed. For game developers we simplify integration with Battle.net. Whether they build immersive player features, seamless commerce flows, or resilient support systems, we clear the path. Off the clock, you'll catch me volunteering on the board of NextGen Advocates, Broadway Cares' young‐professionals network, soaking up fresh industry insight and scouting the next show that will send audiences leaping to their feet.

## Recent Writing

{% assign recentWriting = collections.writing | reverse %}
<ul class="writing-recent-list">
{% for post in recentWriting limit:2 %}
  <li>
    <a href="{{ post.url }}">{{ post.data.title }}</a>
    <span class="date"> — {{ post.data.date | date: "%B %Y" }}</span>
  </li>
{% endfor %}
</ul>
