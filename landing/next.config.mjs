import nextEnv from "@next/env";
import { fileURLToPath } from "node:url";

// Server-only values stay out of nextConfig.env and the browser bundle.
const { combinedEnv } = nextEnv.loadEnvConfig(fileURLToPath(new URL("../", import.meta.url)));
// Next reloads the app directory's env later; retain explicitly loaded server settings.
nextEnv.updateInitialEnv(combinedEnv);

/** @type {import('next').NextConfig} */
const nextConfig = {
  devIndicators: false,
  async redirects() {
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
    ];
  },
  outputFileTracingIncludes: { "/api/auth/**/*": ["./lib/accounts/schema.sql"], "/auth/**/*": ["./lib/accounts/schema.sql"], "/v1/**/*": ["./lib/accounts/schema.sql"] },
  logging: { incomingRequests: { ignore: [/\/(?:auth|api\/auth|v1\/auth|login|register)(?:\/|\?|$)/] } },
};

export default nextConfig;
