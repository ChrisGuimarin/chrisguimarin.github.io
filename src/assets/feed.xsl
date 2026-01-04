<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:atom="http://www.w3.org/2005/Atom">
  <xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
      <head>
        <title><xsl:value-of select="/atom:feed/atom:title"/> – RSS Feed</title>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <link href="https://fonts.googleapis.com/css2?family=Nunito+Sans:wght@400;700&amp;display=swap" rel="stylesheet"/>
        <style>
          :root {
            --color-bg: #ffffff;
            --color-text: #1a1a1a;
            --color-text-muted: #666666;
            --color-primary: #11689b;
            --color-border: #e5e5e5;
            --color-banner-bg: #f0f7fb;
            --spacing-xs: 0.5rem;
            --spacing-sm: 1rem;
            --spacing-md: 2rem;
            --spacing-lg: 3rem;
            --max-width: 80ch;
          }
          
          @media (prefers-color-scheme: dark) {
            :root {
              --color-bg: #1a1a1a;
              --color-text: #F8F8FF;
              --color-text-muted: #a0a0a0;
              --color-primary: #4da8da;
              --color-border: #333333;
              --color-banner-bg: #252525;
            }
          }
          
          * {
            box-sizing: border-box;
          }
          
          body {
            font-family: 'Nunito Sans', system-ui, -apple-system, sans-serif;
            line-height: 1.5;
            background-color: var(--color-bg);
            color: var(--color-text);
            margin: 0;
            padding: var(--spacing-sm);
          }
          
          .container {
            max-width: var(--max-width);
            margin: 0 auto;
          }
          
          .rss-banner {
            background-color: var(--color-banner-bg);
            border: 1px solid var(--color-border);
            border-radius: 8px;
            padding: var(--spacing-md);
            margin-bottom: var(--spacing-md);
          }
          
          .rss-banner h2 {
            margin: 0 0 var(--spacing-sm) 0;
            color: var(--color-primary);
            font-size: 1.25rem;
            display: flex;
            align-items: center;
            gap: var(--spacing-xs);
          }
          
          .rss-banner p {
            margin: 0 0 var(--spacing-sm) 0;
            color: var(--color-text);
          }
          
          .rss-banner p:last-child {
            margin-bottom: 0;
          }
          
          .rss-banner a {
            color: var(--color-primary);
          }
          
          .rss-icon {
            width: 24px;
            height: 24px;
            fill: currentColor;
          }
          
          header {
            margin-bottom: var(--spacing-md);
            padding-bottom: var(--spacing-sm);
            border-bottom: 1px solid var(--color-border);
          }
          
          header h1 {
            color: var(--color-primary);
            margin: 0 0 var(--spacing-xs) 0;
            font-size: 2rem;
          }
          
          header p {
            color: var(--color-text-muted);
            margin: 0;
          }
          
          .meta {
            font-size: 0.9rem;
            color: var(--color-text-muted);
            margin-top: var(--spacing-xs);
          }
          
          .entries {
            list-style: none;
            padding: 0;
            margin: 0;
          }
          
          .entry {
            padding: var(--spacing-md) 0;
            border-bottom: 1px solid var(--color-border);
          }
          
          .entry:last-child {
            border-bottom: none;
          }
          
          .entry h2 {
            margin: 0 0 var(--spacing-xs) 0;
            font-size: 1.25rem;
          }
          
          .entry h2 a {
            color: var(--color-primary);
            text-decoration: none;
          }
          
          .entry h2 a:hover {
            text-decoration: underline;
          }
          
          .entry time {
            font-size: 0.9rem;
            color: var(--color-text-muted);
          }
          
          .entry-content {
            margin-top: var(--spacing-sm);
            color: var(--color-text);
          }
          
          .back-link {
            display: inline-block;
            margin-bottom: var(--spacing-md);
            color: var(--color-primary);
            text-decoration: none;
          }
          
          .back-link:hover {
            text-decoration: underline;
          }
          
          footer {
            margin-top: var(--spacing-lg);
            padding-top: var(--spacing-md);
            border-top: 1px solid var(--color-border);
            color: var(--color-text-muted);
            font-size: 0.9rem;
          }
          
          footer a {
            color: var(--color-primary);
          }
        </style>
      </head>
      <body>
        <div class="container">
          <a href="/" class="back-link">← Back to homepage</a>
          
          <div class="rss-banner">
            <h2>
              <svg class="rss-icon" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                <circle cx="6.18" cy="17.82" r="2.18"/>
                <path d="M4 4.44v2.83c7.03 0 12.73 5.7 12.73 12.73h2.83c0-8.59-6.97-15.56-15.56-15.56zm0 5.66v2.83c3.9 0 7.07 3.17 7.07 7.07h2.83c0-5.47-4.43-9.9-9.9-9.9z"/>
              </svg>
              This is an RSS feed
            </h2>
            <p>
              <strong>RSS</strong> (Really Simple Syndication) lets you subscribe to websites and get updates in a feed reader app—no algorithms, no ads, just the content you want.
            </p>
            <p>
              Copy this page's URL into your favorite feed reader, or <a href="https://aboutfeeds.com" target="_blank" rel="noopener noreferrer">learn more about RSS at aboutfeeds.com</a>.
            </p>
          </div>
          
          <header>
            <h1><xsl:value-of select="/atom:feed/atom:title"/></h1>
            <xsl:if test="/atom:feed/atom:subtitle">
              <p><xsl:value-of select="/atom:feed/atom:subtitle"/></p>
            </xsl:if>
            <p class="meta">
              <xsl:value-of select="count(/atom:feed/atom:entry)"/> items in this feed
            </p>
          </header>
          
          <ul class="entries">
            <xsl:for-each select="/atom:feed/atom:entry">
              <li class="entry">
                <h2>
                  <a>
                    <xsl:attribute name="href">
                      <xsl:value-of select="atom:link/@href"/>
                    </xsl:attribute>
                    <xsl:value-of select="atom:title"/>
                  </a>
                </h2>
                <time>
                  <xsl:value-of select="substring(atom:updated, 1, 10)"/>
                </time>
              </li>
            </xsl:for-each>
          </ul>
          
          <footer>
            <p>
              Subscribe by copying this URL into your feed reader: 
              <code><xsl:value-of select="/atom:feed/atom:link[@rel='self']/@href"/></code>
            </p>
            <p>
              <a href="/">Back to site</a> · 
              <a href="https://aboutfeeds.com" target="_blank" rel="noopener noreferrer">What is RSS?</a>
            </p>
          </footer>
        </div>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
