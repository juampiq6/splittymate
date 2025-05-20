import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { verifyJwtAndAddUserToGroup } from "./jwt_verifier.ts";
import { createJwt } from "./jwt_creator.ts";
Deno.serve(async (req) => {
    const url = new URL(req.url);
    if (req.method !== "POST") {
        return new Response("Method Not Allowed", {
            status: 405
        });
    }
    if (url.pathname.endsWith("/verify-jwt")) {
        return verifyJwtAndAddUserToGroup(req);
    } else if (url.pathname.endsWith("/create-jwt")) {
        return createJwt(req);
    } else {
        return new Response("Not Found", {
            status: 404
        });
    }
});
