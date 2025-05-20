import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createHmac } from "node:crypto";
export { createJwt };
function base64urlEncode(input) {
    return btoa(String.fromCharCode(...input)).replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '');
}
const createJwt = async (req) => {
    let body;
    try {
        body = await req.json();
    } catch (error) {
        return new Response("Invalid JSON", {
            status: 400
        });
    }
    const { group_id, group_name, inviter_email, inviter_name } = body;
    const secret = Deno.env.get("jwt_password");
    if (!secret) {
        return new Response("Missing JWT secret in secrets", {
            status: 500
        });
    }
    const header = {
        alg: "HS512",
        typ: "JWT"
    };
    const payload = {
        group_id,
        group_name,
        inviter_email,
        inviter_name,
        exp: Math.floor(Date.now() / 1000) + 2 * 60 * 60
    };
    const encoder = new TextEncoder();
    const headerBase64 = base64urlEncode(encoder.encode(JSON.stringify(header)));
    const payloadBase64 = base64urlEncode(encoder.encode(JSON.stringify(payload)));
    const signature = createHmac("sha512", secret).update(`${headerBase64}.${payloadBase64}`).digest("base64url");
    const jwt = `${headerBase64}.${payloadBase64}.${signature}`;
    return new Response(JSON.stringify({
        jwt
    }), {
        headers: {
            'Content-Type': 'application/json'
        }
    });
};
