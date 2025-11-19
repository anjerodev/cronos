import { Hono } from "hono";
import { cors } from "hono/cors";

const app = new Hono();

app.use(cors());

let users = [
  { id: 1, name: "John Doe" },
  { id: 2, name: "Jane Doe" },
];

app.get("/", (c) => {
  return c.text("Hello Hono!");
});

app.get("/health", (c) => {
  return c.json({ status: "ok" });
});

app.get("/api/users", (c) => {
  console.log(users);
  users.push({ id: 3, name: "Other user" });
  return c.json(users);
});

export default app;

console.log("🚀 Server running in", process.env.NODE_ENV, "mode");
