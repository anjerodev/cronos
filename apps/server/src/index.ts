import { Hono } from "hono";
import { cors } from "hono/cors";

const app = new Hono();

app.use(cors());

app.get("/", (c) => {
  return c.text("Hello Hono!");
});

app.get("/health", (c) => {
  return c.json({ status: "ok" });
});

app.get("/api/hello", (c) => {
  return c.json({ message: "Hello API!" });
});

export default app;
