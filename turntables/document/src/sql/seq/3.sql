--$ We did a mistake. We forgot to add a field to the persons table. The extra
--$ field to be added is the DOB. 

ALTER TABLE persons ADD COLUMN dob BIGINT;

