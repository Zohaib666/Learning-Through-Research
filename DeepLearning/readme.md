# Brain Tumor Analysis: A Progressive Deep Learning Study (ANN → Transformers)

A systematic, multi-wave comparison of deep learning architectures for brain tumor **classification** (4-class MRI) and **segmentation** (3D BraTS), progressing from classical neural networks to attention-based and transformer models.

## Overview

This project benchmarks 10+ architectures on brain MRI data to answer a practical question: **as model complexity increases, where do the real gains come from — and where do they stop?** Each "wave" builds on the findings of the previous one.

- **Dataset A (classification):** MRI-BT — 7,023 T1 MRI images across 4 classes (Glioma, Meningioma, No Tumor, Pituitary)
- **Dataset B (segmentation):** BraTS 2024 (Glioma) — multi-modal 3D MRI volumes with voxel-level tumor labels

## Results Summary

### Classification (Dataset A — MRI-BT, 4-class)

| Wave | Model | Accuracy | F1 (macro) | Parameters |
|---|---|---|---|---|
| 1 | Perceptron | 87.1% | 0.865 | 65,540 |
| 1 | MLP | 87.7% | 0.874 | 17,474,948 |
| 2 | Custom CNN | 82.6% | 0.820 | 127,620 |
| 2 | **Residual CNN** | **97.9%** | **0.978** | 5,302,660 |
| 3 | Residual CNN (no GAN augmentation) | 98.3% | 0.982 | 5,302,660 |
| 3 | Residual CNN + GAN augmentation | 95.3% | 0.952 | 5,302,660 |
| 4 | Simple RNN | 88.1% | 0.875 | 41,476 |
| 4 | LSTM | 87.7% | 0.871 | 152,644 |
| 4 | BiLSTM | 90.2% | 0.897 | 370,500 |
| 4 | Seq2Seq + Attention | 89.8% | 0.892 | 239,301 |

**Key finding:** A Residual CNN outperforms every sequence-based model (RNN/LSTM/BiLSTM/Attention) by 8–10 points, confirming that 2D spatial convolution captures tumor morphology far better than row-by-row sequential processing. GAN-based data augmentation did not improve results on this dataset — a useful negative result.

### Segmentation & Advanced Architectures (Dataset B — BraTS 2024)

| Model | Task | Result | Status |
|---|---|---|---|
| BiLSTM (slice sequence) | Tissue classification | 60–73% accuracy | Completed (small test set, n=15) |
| SwinUNETR (3D, MONAI) | Voxel segmentation | Dice 0.377 at epoch 6/10 | Training curve improving; stopped early |
| Vision Transformer (ViT) | Tumor classification on BraTS slices | — | Blocked by a Keras Functional API bug (in progress) |
| Physics-Informed Neural Network (PINN) | Tumor cavity localization from coordinates | — | Sampling strategy needs revision (documented in notebook) |
| DCGAN | Synthetic MRI generation for augmentation | — | Implemented, not yet executed |

## Architecture Progression

```
Wave 1: Perceptron, MLP                         (baseline, no spatial awareness)
Wave 2: Custom CNN, Residual CNN                (spatial convolution — big jump)
Wave 3: + GAN-based augmentation                (data augmentation ablation)
Wave 4: RNN, LSTM, BiLSTM, Seq2Seq+Attention     (sequential modeling — image as sequence)
Wave 5: Vision Transformer                       (patch-based self-attention)
   +    SwinUNETR                                (3D hierarchical transformer for segmentation)
   +    PINN                                     (physics-constrained coordinate regression)
```

## Tech Stack

TensorFlow/Keras, PyTorch, MONAI (medical imaging), nibabel (NIfTI I/O), scikit-learn, NumPy, Matplotlib/Seaborn.

## Repository Structure

```
├── wave1-2-ann-cnn.ipynb          # Perceptron, MLP, Custom CNN, Residual CNN
├── brain-dcgan.ipynb              # GAN-based data augmentation
├── rnn-lstm-bilstm-brain.ipynb    # Sequence models (Wave 4) on MRI-BT and BraTS
├── Vit_Brain.ipynb                # Vision Transformer (Wave 5)
├── swinunetr-brain.ipynb          # 3D SwinUNETR segmentation on BraTS
├── pin-brain.ipynb                # Physics-informed neural network
└── README.md
```

## Known Limitations / Work in Progress

- ViT training currently fails on a KerasTensor/TF-function incompatibility — fix identified, not yet applied.
- SwinUNETR was stopped before full convergence; Dice score was still improving.
- PINN cavity-detection run under-sampled tumor cavity voxels; notebook includes a self-diagnosed fix (increase sample count).
- BraTS sequence-classification test set is small (n=15 patients), so those numbers should be read as directional, not definitive.

## Key Takeaway

Across every architecture tested, **spatial convolution (Residual CNN) remains the strongest and most efficient approach** for this classification task, while transformer- and physics-based methods show promise for segmentation but require further tuning to reach comparable reliability.

## License

MIT
