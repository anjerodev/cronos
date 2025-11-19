import { Hono } from "hono";
import { cors } from "hono/cors";

const app = new Hono();

app.use(cors());

const names = [
  "John",
  "Jane",
  "Kevin",
  "Michael",
  "Sarah",
  "David",
  "Emma",
  "Chris",
  "Olivia",
  "Daniel",
  "Sophia",
  "Matthew",
];
const lastNames = [
  "Doe",
  "Miller",
  "Johnson",
  "Smith",
  "Williams",
  "Brown",
  "Jones",
  "Garcia",
  "Martinez",
  "Anderson",
  "Taylor",
  "Thomas",
];
const randomName = () => {
  const name = names[Math.floor(Math.random() * names.length)];
  const lastName = lastNames[Math.floor(Math.random() * lastNames.length)];
  return `${name} ${lastName}`;
};

let users: { id: number; name: string }[] = [];

app.get("/", (c) => {
  return c.text("Hello Hono!");
});

app.get("/health", (c) => {
  return c.json({ status: "ok" });
});

app.get("/api/users", (c) => {
  console.log(users);
  users.push({ id: users.length + 1, name: randomName() });
  return c.json(users);
});

export default app;

console.log("🚀 Server running in", process.env.NODE_ENV, "mode");
