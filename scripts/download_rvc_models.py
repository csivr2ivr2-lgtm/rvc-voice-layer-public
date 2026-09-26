from __future__ import annotations

import argparse
from pathlib import Path
from zipfile import ZipFile

from huggingface_hub import hf_hub_download, snapshot_download

REPO = 'lj1995/VoiceConversionWebUI'

def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument('--rvc-dir', required=True)
    args = parser.parse_args()

    root = Path(args.rvc_dir).resolve()
    assets = root / 'assets'
    downloads = root / '.model-downloads'
    downloads.mkdir(parents=True, exist_ok=True)

    print('[1/5] HuBERT')
    snapshot_download(
        repo_id=REPO,
        revision='main',
        allow_patterns=['hubert_base/*'],
        local_dir=str(assets),
    )

    print('[2/5] RMVPE PT')
    hf_hub_download(
        repo_id=REPO,
        filename='rmvpe.pt',
        revision='main',
        local_dir=str(assets / 'rmvpe'),
    )

    print('[3/5] RMVPE ONNX')
    hf_hub_download(
        repo_id=REPO,
        filename='rmvpe.onnx',
        revision='main',
        local_dir=str(assets / 'rmvpe'),
    )

    print('[4/5] RVC pretrained v1/v2')
    snapshot_download(
        repo_id=REPO,
        revision='main',
        allow_patterns=['pretrained/*', 'pretrained_v2/*'],
        local_dir=str(assets),
    )

    print('[5/5] Training mute samples')
    mute_zip = Path(hf_hub_download(
        repo_id=REPO,
        filename='mute.zip',
        revision='main',
        local_dir=str(downloads),
    ))
    logs = root / 'logs'
    logs.mkdir(parents=True, exist_ok=True)
    with ZipFile(mute_zip) as zf:
        zf.extractall(logs)

    required = [
        assets / 'hubert_base' / 'pytorch_model.bin',
        assets / 'rmvpe' / 'rmvpe.pt',
        assets / 'rmvpe' / 'rmvpe.onnx',
        assets / 'pretrained',
        assets / 'pretrained_v2',
        logs / 'mute',
    ]
    missing = [str(p) for p in required if not p.exists()]
    if missing:
        raise SystemExit('Missing required assets after download:\n' + '\n'.join(missing))

    print('All required RVC assets are present.')

if __name__ == '__main__':
    main()