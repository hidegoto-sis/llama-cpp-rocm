FROM rocm/dev-ubuntu-22.04:6.0.2

RUN apt update && apt install -y git cmake build-essential

WORKDIR /app
RUN git clone https://github.com/ggerganov/llama.cpp .

RUN cmake -B build -DLLAMA_HIP=ON -DLLAMA_HIPBLAS=ON
RUN cmake --build build --config Release -j$(nproc)

CMD ["./build/bin/llama-server", "--host", "0.0.0.0", "--port", "8081"]
