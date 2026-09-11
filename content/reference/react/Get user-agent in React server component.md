```tsx
import { headers } from "next/headers";
import { UAParser } from "ua-parser-js";

export const deviceType = () => {
  if (typeof process === "undefined") {
    throw new Error(
      "[Server method] you are importing a server-only module outside of server",
    );
  }

  const { get } = headers();
  const ua = get("user-agent");

  const device = new UAParser(ua || "").getDevice();

  console.log(device);

  return device.type;
};
```