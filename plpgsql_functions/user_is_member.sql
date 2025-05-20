DECLARE
    is_member BOOLEAN;
BEGIN
    SELECT EXISTS (
            SELECT 1
            FROM member
            WHERE user_id = user_id_param AND split_group_id = group_id_param
    ) INTO is_member;
    RETURN is_member;
END;
