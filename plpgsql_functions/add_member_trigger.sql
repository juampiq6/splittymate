CREATE OR REPLACE FUNCTION add_member_to_group()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    INSERT INTO public.member (split_group_id, user_id)
    VALUES (NEW.id, NEW.created_by);
    RETURN NEW;
END;
$function$
