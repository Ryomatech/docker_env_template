# 実験共通環境（Docker + Apptainer 対応）

このリポジトリは、複数の機械学習プロジェクトで使い回せる共通の Docker / Apptainer ベースの Python 環境を提供します。

- ✅ PyTorch を含む標準的な ML 開発環境  
- ✅ 複数プロジェクトで共通利用を想定  
- ✅ スパコンでも使用可能（Apptainer対応）

---

## 📁 想定ディレクトリ構成（使用例）

```
projects/
├── docker-env/         ← このリポジトリ（共通環境）
└── my-ml-project/      ← MLプロジェクト本体
    ├── train.py
    └── docker-compose.yml ← プロジェクト用 Compose（共通環境を参照）
```

> 各プロジェクトが `../docker-env/` を参照することで、共通環境を使います。

---

## 💣 使用方法（プロジェクトから）

プロジェクト側の `docker-compose.yml` に以下を記述し、共通環境を参照します：

```yaml
version: "3.8"

services:
  ml:
    build:
      context: ../docker-env
      dockerfile: Dockerfile
    container_name: ml-env
    volumes:
      - .:/workspace    
    working_dir: /workspace/
    tty: true
    stdin_open: true
    command: zsh
```

> ※ `command: zsh` を使用する場合、`Dockerfile` で `zsh` をインストールしておいてください。

---

## 💻 通常のPCでの実行方法（Docker環境）

### 一時的にスクリプトを実行する（推奨）

```bash
# プロジェクトディレクトリ内で実行
cd my-ml-project

docker-compose -f docker-compose.yml run --rm ml python train.py
```

### 対話的にシェルに入りたい場合

```bash
docker-compose -f docker-compose.yml run --rm ml
```

> ※ GPU環境で実行する場合は `--gpus all` を `run` の後ろに追加してください：
> 
> ```bash
> docker compose -f docker-compose.yml run --rm --gpus all ml python train.py
> ```

---

## 📦 インストールされるパッケージ

共通環境で使用する Python ライブラリは、`docker-env/requirements.txt` に定義します。  
例：

```
numpy
pandas
matplotlib
scikit-learn
```

---

## 🚀 Apptainer（スパコン）での使用

以下の手順で Docker イメージを Apptainer に変換して使用します。

```bash
# Docker → Apptainer イメージへ変換
apptainer build ml-env.sif docker-daemon://ml-env:latest

# または Docker Hub イメージを利用
# apptainer build ml-env.sif docker://pytorch/pytorch:latest
```

### 実行例:

```bash
apptainer exec ml-env.sif python train.py

# GPU を使う場合：
apptainer exec --nv ml-env.sif python train.py
```

> `train.py` は Apptainer 実行時のマウントパス（例：`my-ml-project/`）に置いておいてください。

---

## 🔁 備考

- 複数の機械学習リポジトリで同じ環境を共有できます。
- Dockerfile・requirements.txt を共通で保守することで再現性と管理効率が向上します。
