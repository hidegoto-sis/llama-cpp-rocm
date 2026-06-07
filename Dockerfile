FROM ubuntu:24.04

# 基本ツール
RUN apt update && apt install -y git cmake build-essential

WORKDIR /app

# llama.cpp を取得
RUN git clone https://github.com/ggerganov/llama.cpp .

# HIP（ROCm）をホストからマウントして使う
RUN cmake -B build \
    -DLLAMA_HIP=ON \
    -DLLAMA_HIPBLAS=ON \
    -DROCM_PATH=/opt/rocm

RUN cmake --build build --config Release -j$(nproc)

# モデルは /models に置く前提
CMD ["./build/bin/llama-server",
     "--model", "/models/model.gguf",
     "--host", "0.0.0.0",
     "--port", "8081"]
