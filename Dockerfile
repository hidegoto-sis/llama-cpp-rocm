FROM ubuntu:24.04

# ROCm 6.1 リポジトリ追加
RUN apt update && apt install -y wget gpg

RUN mkdir -p /etc/apt/keyrings && \
    wget https://repo.radeon.com/rocm/rocm.gpg.key -O - | \
    gpg --dearmor | tee /etc/apt/keyrings/rocm.gpg > /dev/null

RUN echo 'deb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/rocm/apt/6.1/ ubuntu main' \
    > /etc/apt/sources.list.d/rocm.list

# HIP runtime + build tools
RUN apt update && apt install -y \
    git cmake build-essential hip-runtime-amd

WORKDIR /app
RUN git clone https://github.com/ggerganov/llama.cpp .

RUN cmake -B build -DLLAMA_HIP=ON -DLLAMA_HIPBLAS=ON
RUN cmake --build build --config Release -j$(nproc)

CMD ["./build/bin/llama-server", "--host", "0.0.0.0", "--port", "8081"]
]
