CREATE TABLE IF NOT EXISTS public.users
(
    id serial,
    google_id bigint,
    email text,
    name text,
    picture_url text,
    hod smallint DEFAULT 0,
    registered_on time with time zone DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.leaves
(
    id serial,
    user_id integer,
    reason text,
    requested_on time with time zone,
    PRIMARY KEY (id),
    CONSTRAINT user_id FOREIGN KEY (user_id)
        REFERENCES public.users (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
);