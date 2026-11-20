#!/usr/bin/env python3
"""校验 ZJ 萤石公开仓身份、必需文件及 TOS 状态。"""
import json
from pathlib import Path
from verify_tos_release import verify
root = Path(__file__).resolve().parents[1]
contract = json.loads((root / "repository-contract.json").read_text())
assert contract["repository"] == "LJMcarryu/ZJYSIFLYADLib_iOS"
assert contract["channel"] == "zjys"
for path in contract["requiredRootFiles"]:
    assert (root / path).is_file(), path
for key in ("root", "readme", "podfile", "project"):
    assert (root / contract["demo"][key]).exists(), key
for name in contract["docs"]["guides"]:
    assert (root / contract["docs"]["guideRoot"] / name).is_file(), name
print(json.dumps(verify(root), ensure_ascii=False))
