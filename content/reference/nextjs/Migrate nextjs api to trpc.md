- using zod just to make typescript happy is getting annoying and theoretically slower

## Some input from AI
*I don't know how true this is but:*

RPC offers several performance advantages over traditional REST due to its modern approach to communication and data exchange. Here are the key points from the provided information that highlight the performance benefits of tRPC over normal REST:

1. **Performance Tiers**:
    - tRPC is generally viewed as outpacing REST in terms of performance, thanks to its adoption of HTTP/2 and binary data format, which allows for more efficient and faster data exchange [3] .
2. **Real-time Communication**:
    - tRPC’s capability for bidirectional streaming facilitates constant data exchange between the user and the server, making it beneficial for applications like on-the-go video streaming, chatting applications, and live gaming [2] .
3. **Efficiency and Speed**:
    - tRPC employs the Protocol Buffers information format, which is capable of surpassing JSON, the format utilized by REST, in size and speed, making it more efficient and faster [9] .
4. **Handling Bulky Data**:
    - For handling bulky data, the streaming capability of tRPC brings a considerable benefit. It allows data transmission in smaller fractions, alleviating network load while enhancing performance, which REST lacks [5] .
5. **Two-way Communication**:
    - Contrary to REST, tRPC facilitates two-way dialogue, enabling the server to spontaneously relay updates to the client without needing client-initiated requests [9] .

These points collectively indicate that tRPC is designed to offer superior performance compared to traditional REST, especially in scenarios involving real-time communication, handling bulky data, and ensuring efficient and speedy data exchange.

In conclusion, based on the provided information, tRPC demonstrates performance advantages over normal REST, especially in scenarios requiring real-time communication, efficient data exchange, and handling of bulky data.
## Tasks
- [x] #task Migrate nexjs to trpc 🔼 ✅ 2024-02-28
