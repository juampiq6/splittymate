import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js";
import { createHmac } from "node:crypto";
export { verifyJwtAndAddUserToGroup };
function base64urlDecode(input) {
    const padding = '='.repeat((4 - input.length % 4) % 4);
    const base64 = (input + padding).replace(/-/g, '+').replace(/_/g, '/');
    return Uint8Array.from(atob(base64), (c) => c.charCodeAt(0));
}
const verifyJwtAndAddUserToGroup = async (req) => {
    try {
        const { jwt } = await req.json();
        if (!jwt || typeof jwt !== 'string') {
            throw new ErrorException(400, "Invalid JWT");
        }
        const secret = Deno.env.get("jwt_password");
        if (!secret) {
            throw new ErrorException(500, "Missing JWT secret in secrets");
        }
        const { payload, error } = verifyJwt(jwt, secret);
        if (error || !payload) {
            return new Response(JSON.stringify({
                error: error || "Invalid payload"
            }), {
                headers: {
                    'Content-Type': 'application/json'
                },
                status: 401
            });
        }
        return await add_user_to_group(payload.group_id, req);
    } catch (error) {
        console.error(error);
        if (error instanceof ErrorException) {
            return error.toJsonResponse();
        }
        return new Response(JSON.stringify({
            error: 'Internal server error'
        }), {
            headers: {
                'Content-Type': 'application/json'
            },
            status: 500
        });
    }
};
const verifyJwt = (jwt, secret) => {
    const [header, payload, signature] = jwt.split('.');
    // Verify the signature
    const expectedSignature = createHmac("sha512", secret).update(`${header}.${payload}`).digest("base64url");
    if (expectedSignature !== signature) {
        return {
            payload: null,
            error: "Invalid signature"
        };
    }
    // Decode the payload and check expiration
    const payloadData = JSON.parse(new TextDecoder().decode(base64urlDecode(payload)));
    if (payloadData.exp < Math.floor(Date.now() / 1000)) {
        return {
            payload: null,
            error: "Token expired"
        };
    }
    return {
        payload: payloadData,
        error: null
    };
};
const add_user_to_group = async (group_id, req) => {
    if (!group_id) {
        return new Response("No groupId provided", {
            status: 400
        });
    }
    const authToken = req.headers.get('Authorization')?.replace('Bearer ', '');
    if (!authToken) {
        return new Response("Missing auth token", {
            status: 401
        });
    }
    const supabaseClient = createClient(Deno.env.get('SUPABASE_URL'), Deno.env.get('SUPABASE_ANON_KEY'), {
        global: {
            headers: {
                Authorization: `Bearer ${authToken}`
            }
        }
    });
    // Check if the user is authenticated
    const { data: { user }, error: userError } = await supabaseClient.auth.getUser(authToken);
    if (userError || !user) {
        return new Response(JSON.stringify({
            error: 'Invalid token'
        }), {
            headers: {
                'Content-Type': 'application/json'
            },
            status: 401
        });
    }
    const { data: userRow, error: userIdError } = await supabaseClient.from('user').select('id').eq('auth_id', user.id).single();
    if (userIdError) {
        console.error(userIdError);
        return new Response(JSON.stringify({
            error: 'User not found'
        }), {
            headers: {
                'Content-Type': 'application/json'
            },
            status: 404
        });
    }
    const { error: insertError } = await supabaseClient.from('member').insert({
        user_id: userRow.id,
        split_group_id: group_id
    });
    if (insertError) {
        console.log(userRow, ' ----- ', group_id);
        console.error(insertError);
        return new Response(JSON.stringify({
            error: 'Failed to add member'
        }), {
            headers: {
                'Content-Type': 'application/json'
            },
            status: 500
        });
    }
    return new Response(JSON.stringify({
        message: 'Member added successfully'
    }), {
        headers: {
            'Content-Type': 'application/json'
        },
        status: 201
    });
};

class ErrorException {
    statusCode: number;
    message: string;
    constructor(statusCode, message) {
        this.statusCode = statusCode;
        this.message = message;
    }
    toJsonResponse() {
        return new Response(JSON.stringify({
            error: this.message
        }), {
            headers: {
                'Content-Type': 'application/json'
            },
            status: this.statusCode
        });
    }

    toString() {
        return this.message;
    }
}
