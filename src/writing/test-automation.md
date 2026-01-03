---
title: "Test: Buttondown Automation"
date: 2026-01-03
excerpt: "This is a test post to verify Buttondown RSS automation is working correctly."
---

This is a **test post** to verify the Buttondown RSS automation is working correctly.

## What to expect

If the automation is working:
- Buttondown should detect this post in the RSS feed
- A draft email should be created automatically
- The draft should contain this full content

## Test checklist

- [ ] Post appears in RSS feed at `/writing/feed.xml`
- [ ] Buttondown detects the new item
- [ ] Draft is created (not marked as irrelevant)
- [ ] Draft contains the full post content

---

**This is a test post.** You can safely delete this post and the corresponding draft after verifying the automation works.

To disable this test post temporarily (remove from feed without deleting), add this to the frontmatter:
```
eleventyExcludeFromCollections: true
```

To completely remove it, just delete the file `src/writing/test-automation.md`.
