
-- move labels to hstore

alter table jobs
  add shortlabeli18n hstore;

alter table jobs
  add longlabeli18n hstore;

UPDATE jobs
SET
  shortlabeli18n = hstore(ARRAY['fr', shortlabel, 'en', '']),
  longlabeli18n = hstore(ARRAY['fr', longlabel, 'en', ''])
;

alter table jobs drop column shortlabel;
alter table jobs drop column longlabel;
alter table jobs rename column shortlabeli18n to shortlabel;
alter table jobs rename column longlabeli18n to longlabel;
