#!/bin/bash

# Define build arguments
USE_CUDA=0
USE_OLLAMA=0
USE_CUDA_VER=""
USE_EMBEDDING_MODEL_DOCKER="model-name"
USE_RERANKING_MODEL_DOCKER="reranking-model-name"
UID=1000
GID=1000


tar xvf app.tar -C /

# Create user and group if not root
groupadd --gid $GID app
useradd --uid $UID --gid $GID --home /root -s /bin/bash app

# Set environment variables
export ENV="prod"
export PORT=8080
export OLLAMA_BASE_URL="/ollama"
export OPENAI_API_KEY=""
export WEBUI_SECRET_KEY=""
export SCARF_NO_ANALYTICS=true
export DO_NOT_TRACK=true
export ANONYMIZED_TELEMETRY=false
export USE_CUDA_VER=0
# Set other model settings
export WHISPER_MODEL="base"
export WHISPER_MODEL_DIR="/app/backend/data/cache/whisper/models"

export RAG_EMBEDDING_MODEL="$USE_EMBEDDING_MODEL_DOCKER"
export RAG_RERANKING_MODEL="$USE_RERANKING_MODEL_DOCKER"
export SENTENCE_TRANSFORMERS_HOME="/app/backend/data/cache/embedding/models"

# Set Tiktoken model settings
export TIKTOKEN_ENCODING_NAME="cl100k_base"
export TIKTOKEN_CACHE_DIR="/app/backend/data/cache/tiktoken"

# Set Torch Extensions directory
# export TORCH_EXTENSIONS_DIR="/.cache/torch_extensions"

# Create necessary directories and set permissions
mkdir -p /root/.cache/chroma
echo -n 00000000-0000-0000-0000-000000000000 > /root/.cache/chroma/telemetry_user_id
# Install dependencies
apt-get update && \
apt-get install -y --no-install-recommends git build-essential pandoc gcc netcat-openbsd curl jq && \
apt-get install -y --no-install-recommends gcc python3-dev && \
# for RAG OCR
apt-get install -y --no-install-recommends ffmpeg libsm6 libxext6 && \
# cleanup
rm -rf /var/lib/apt/lists/*;
pip3 install uv torch torchvision torchaudio  transformers pysqlite3-binary --index-url https://download.pytorch.org/whl/ --no-cache-dir
cp /usr/local/python3.11/bin/uv* /usr/bin/
uv pip install --no-cache-dir -r /app/backend/requirements.txt && \
    python -c "import os; from sentence_transformers import SentenceTransformer; SentenceTransformer(os.environ['RAG_EMBEDDING_MODEL'], device='cpu')" && \
    python -c "import os; from faster_whisper import WhisperModel; WhisperModel(os.environ['WHISPER_MODEL'], device='cpu', compute_type='int8', download_root=os.environ['WHISPER_MODEL_DIR'])"; \
    python -c "import os; import tiktoken; tiktoken.get_encoding(os.environ['TIKTOKEN_ENCODING_NAME'])"; 

# Change ownership of directories
chown -R $UID:$GID /root/.cache/chroma

# Install Python dependencies from requirements file

sed -i "1i\__import__('pysqlite3')\nimport sys\nsys.modules['sqlite3'] = sys.modules.pop('pysqlite3')\n" /usr/local/python3.11/lib/python3.11/site-packages/chromadb/__init__.py
#if error:could not find _sqlite3 , copy that bellow
#cp /usr/local/python3.11/lib/python3.11/site-packages/pysqlite3/_sqlite3.cpython-311-x86_64-linux-gnu.so /usr/local/python3.11/lib/python3.11/lib-dynload/
# Run application
exec bash /app/backend/start.sh