-- Cold Landscape theme — SQL sample
-- Schema: a simple blog with posts, tags and view counters

CREATE TABLE authors (
    id         UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    username   TEXT        NOT NULL UNIQUE,
    email      TEXT        NOT NULL UNIQUE,
    bio        TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE posts (
    id           UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    author_id    UUID        NOT NULL REFERENCES authors(id) ON DELETE CASCADE,
    title        TEXT        NOT NULL,
    slug         TEXT        NOT NULL UNIQUE,
    body         TEXT        NOT NULL,
    published    BOOLEAN     NOT NULL DEFAULT false,
    published_at TIMESTAMPTZ,
    view_count   INTEGER     NOT NULL DEFAULT 0,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE tags (
    id   SERIAL PRIMARY KEY,
    name TEXT   NOT NULL UNIQUE
);

CREATE TABLE post_tags (
    post_id UUID    NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
    tag_id  INTEGER NOT NULL REFERENCES tags(id)  ON DELETE CASCADE,
    PRIMARY KEY (post_id, tag_id)
);

CREATE INDEX idx_posts_author ON posts(author_id);
CREATE INDEX idx_posts_slug   ON posts(slug) WHERE published = true;

-- ── Queries ──────────────────────────────────────────────────────────────────

-- Top 10 most-viewed published posts with their authors and tag list
SELECT
    p.id,
    p.title,
    p.slug,
    p.view_count,
    a.username            AS author,
    p.published_at,
    array_agg(t.name ORDER BY t.name) FILTER (WHERE t.name IS NOT NULL) AS tags
FROM posts p
JOIN authors a ON a.id = p.author_id
LEFT JOIN post_tags pt ON pt.post_id = p.id
LEFT JOIN tags t       ON t.id = pt.tag_id
WHERE p.published = true
  AND p.published_at >= now() - INTERVAL '90 days'
GROUP BY p.id, a.username
ORDER BY p.view_count DESC
LIMIT 10;

-- Monthly view counts per author (rolling 12 months)
SELECT
    a.username,
    date_trunc('month', p.published_at) AS month,
    SUM(p.view_count)                   AS total_views,
    COUNT(p.id)                         AS post_count
FROM posts p
JOIN authors a ON a.id = p.author_id
WHERE p.published = true
  AND p.published_at >= now() - INTERVAL '1 year'
GROUP BY a.username, month
ORDER BY a.username, month;

-- Increment view counter atomically
UPDATE posts
SET view_count = view_count + 1,
    updated_at = now()
WHERE slug = 'cold-landscape-theme-dev-notes'
RETURNING id, view_count;
