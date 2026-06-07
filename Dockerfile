FROM ubuntu:22.04

# ROCm/HIP runtime をインストール
RUN apt update && apt install -y git cmake build-essential hip-runtime-amd

WORKDIR /app
RUN git clone https://github.com/ggerganov/llama.cpp .

# HIP 対応でビルド
RUN cmake -B build -DLLAMA_HIP=ON -DLLAMA_HIPBLAS=ON
RUN cmake --build build --config Release -j$(nproc)

CMD ["./build/bin/llama-server", "--host", "0.0.0.0", "--port", "8081"]
