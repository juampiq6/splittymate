DECLARE
    share_group BOOLEAN;
BEGIN
    SELECT EXISTS (
            SELECT 1
            FROM member
            WHERE user_id IN (user1, user2)
            GROUP BY split_group_id
            HAVING count(*) > 1
    ) INTO share_group;
    RETURN share_group;
END;