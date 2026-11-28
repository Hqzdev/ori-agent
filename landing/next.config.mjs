import nextEnv from "@next/env";
import { fileURLToPath } from "node:url";

// Server-only values stay out of nextConfig.env and the browser bundle.
const { combinedEnv } = nextEnv.loadEnvConfig(fileURLToPath(new URL("../", import.meta.url)));
// Next reloads the app directory's env later; retain explicitly loaded server settings.
nextEnv.updateInitialEnv(combinedEnv);

/** @type {import('next').NextConfig} */
const nextConfig = {
  turbopack: { root: fileURLToPath(new URL("../", import.meta.url)) },
  outputFileTracingRoot: fileURLToPath(new URL("../", import.meta.url)),
  devIndicators: false,
  // Older web deployments use a separate origin and have no /app base path.
  async redirects() {
    const legacy = process.env.BLOT_WEB_APP_URL === "https://blot-web-ha1zyys-projects.vercel.app";
    return [
      { source: "/blot/media/:path*", destination: "/ori/media/:path*", permanent: true },
      { source: "/blot/:section(pets|visuals)/:path*", destination: "/ori/:section/:path*", permanent: true },
      { source: "/blot/:logo(logo-ink|logo-paper).png", destination: "/ori/:logo.png", permanent: true },
      { source: "/blot/fonts/blot-sans.woff2", destination: "/ori/fonts/ori-sans.woff2", permanent: true },
      { source: "/blot/fonts/blot-mono.woff2", destination: "/ori/fonts/ori-mono.woff2", permanent: true },
      { source: "/blot/fonts/interface-icons.woff2", destination: "/ori/fonts/interface-icons.woff2", permanent: true },
      { source: "/workspace/documents/blot-:name(unification-plan|product-plan|technical-specification)", destination: "/workspace/documents/ori-:name", permanent: true },
      { source: "/workspace/documents/web-blot-auth", destination: "/workspace/documents/web-ori-auth", permanent: true },
      { source: "/BLOT_TECHNICAL_SPECIFICATION.md", destination: "/ORI_TECHNICAL_SPECIFICATION.md", permanent: true },
      ...(legacy ? [{ source: "/app/pricing", destination: process.env.BLOT_WEB_APP_URL + "/pricing", permanent: false }] : []),
    ];
  },
  async rewrites() {
    const upstream = "https://blot-web-ha1zyys-projects.vercel.app";
    if (process.env.BLOT_WEB_APP_URL !== upstream) return [];
    return ["/api/billing/:path*", "/api/yookassa-webhook"].map(path => ({
      source: "/app" + path, destination: upstream + path,
    }));
  },
  outputFileTracingIncludes: { "/api/auth/**/*": ["./lib/accounts/schema.sql", "./lib/accounts/supabase-ca.crt"], "/auth/**/*": ["./lib/accounts/schema.sql", "./lib/accounts/supabase-ca.crt"], "/v1/**/*": ["./lib/accounts/schema.sql", "./lib/accounts/supabase-ca.crt"] },
  logging: { incomingRequests: { ignore: [/\/(?:auth|api\/auth|v1\/auth|login|register)(?:\/|\?|$)/] } },
};

export default nextConfig;
