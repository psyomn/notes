# Fluff (2019-01-22)

Not a very technical post, but I've decided to be a little more
vigilant in writing progress and new things that I do. So here is a
small post with fluff!

## Finally found a good newsreader

I've been looking for a reader for a long time. I don't like
distractions. Distractions for me are fancy sites, with a lot of
media, and time spent more on UI niceties than content. And if it's
not web, well, that would something that I prefer. I also like light
things to use.

This is where newsboat comes in. I've been quite happy with it. The
feeds I follow, I can store with a simple text file as such:

```nocode
https://queue.acm.org/rss/feeds/performance.xml ACM programming
https://queue.acm.org/rss/feeds/programminglanguages.xml ACM programming
https://queue.acm.org/rss/feeds/virtualmachines.xml ACM programming
https://www.youtube.com/feeds/videos.xml?channel_id=UCsvn_Po0SmunchJYOWpOxMg "youtube"
```

Notice the text after the urls -- you can tag things this way as well,
so you can quickly navigate in the UI.

Now the next question is how to visit the links. I like simple things,
and I set the browser to be `w3m`. In my `~/.newsboat/config` I have
the following:

```nocode
browser w3m
```

And bam! We done.
