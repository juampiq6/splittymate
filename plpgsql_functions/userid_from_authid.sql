CREATE OR REPLACE FUNCTION find_user_uid_by_auth_uid(auth_uid UUID)
RETURNS UUID
LANGUAGE plpgsql AS
$$
DECLARE
    user_uid UUID;
BEGIN
    SELECT id INTO STRICT user_uid
    FROM public."user"
    WHERE auth_uid = find_user_uid_by_auth_uid.auth_uid;

    RETURN user_uid;
END;
$$