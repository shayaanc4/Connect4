# Connect4 AI Game on RISC-V

A fully playable Connect4 game on a custom single-cycle RISC-V processor, featuring VGA video output and a hardware neural-network inference accelerator.

## Memory-Mapped I/O

| Address            | Component               | Description                                              |
|--------------------|-------------------------|----------------------------------------------------------|
| `0x0000–0x0029`    | Board State RAM         | 42 cells storing the 6×7 board (one entry per slot)     |
| `0x0064`           | Switch Inputs           | SW[0]–SW[6] for player left/right movement               |
| `0x0065`           | Key Press               | Button for “confirm” or “drop” action                    |
| `0x0066`           | NN Trigger              | `LW xN,0x0066(x0)` starts the hardware inference engine  |
| `0x0067`           | NN Result               | `LW xN,0x0067(x0)` returns the AI’s chosen column (0–6)  |
| `0x0068+`          | VGA Framebuffer         | Character graphics memory for real-time display          |

## Neural Network Architecture & Training

- **Architecture**:  
  – Input layer: 42 nodes (flattened 6×7 board)  
  – Hidden layer: 32 nodes with sigmoid activation  
  – Output layer: 7 nodes (one per column)

- **Offline Training Pipeline**:  
  1. **Dataset**: Python/NumPy script simulates thousands of random & heuristic games to label board-move pairs  
  2. **Model**: PyTorch `nn.Linear(42,32)` → sigmoid → `nn.Linear(32,7)` → softmax  
  3. **Quantization**: Convert weights & biases to fixed-point and generate BRAM `.mif` files  
  4. **Deployment**: Upload quantized weights/biases into on-chip BRAM; inference engine reads them directly at runtime  

- **Runtime Inference**:  
  – Trigger with a single load (`0x0066`), wait ~200 cycles  
  – Read AI move from `0x0067` and continue game logic in assembly  
