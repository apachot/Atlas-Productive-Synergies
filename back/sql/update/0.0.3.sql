-- Add city perimeter

ALTER TABLE city
    ADD COLUMN perimeter polygon;
