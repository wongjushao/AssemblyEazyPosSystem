# AssemblyEazyPosSystem

A DOS-based Point of Sale (POS) system written in x86 Assembly language for a fruit store scenario.

## Features

- Login gate with a 4-digit admin password (`8989`)
- Product menu for 5 items (Apple, Orange, Pineapple, Watermelon, Guava)
- Quantity input per item (up to 99)
- Subtotal and Sales and Service Tax (SST, 5%) calculation
- Receipt printing with customer number and date
- Multi-customer flow with daily sales summary

## Project Structure

- `simple pos system.asm` — main source file

## Requirements

- DOS environment (or emulator such as DOSBox)
- MASM or TASM assembler + linker

## Build and Run

In a DOS-compatible environment:

1. Assemble the source:
   - `masm "simple pos system.asm";`
   - or `tasm "simple pos system.asm"`
2. Link the object file:
   - `link "simple pos system.obj";`
3. Run:
   - `"simple pos system.exe"`

> Command syntax can vary slightly depending on your assembler/linker version.

## Usage

1. Launch the program.
2. Enter the admin password.
3. Select menu items (`1`–`5`) and input quantity.
4. Continue adding items (`Y/N`).
5. Print receipt and choose whether to process the next customer.
6. Exit to see total daily earnings.

## Notes

- This project is a single-file Assembly learning project.
- There are no automated tests or CI scripts included in this repository.
