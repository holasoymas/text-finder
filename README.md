# Text Finder 📚🔍

TextFinder is a lightweight command-line tool for searching text within PDF files. It takes **two arguments**: `path/to/pdf/file` and `"String to search"`. It works across multiple platforms, including Linux, macOS, and Windows.

## Features ✨

- Search for specific text within PDF files.
- Cross-platform support (Linux, macOS, Windows).

## Installation 🛠️

### For Linux and macOS

To install TextFinder on Linux or macOS, run the following command in your terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/holasoymas/text-finder/main/install.sh | sh
```

## Usage 🚀
```bash
text-finder <path-to-pdf> <"string to search">
```

### Example 
```bash
text-finder The-Brothers-Karamazov.pdf "What is hell?"
```

### Output
```bash 
Scanning ..... page 286

---------------------------------------------
Match Found!

- Page Number: 286

- Input Sentence : "What is hell?"

- Full Sentence: "Fathers and teachers, I ponder, "What is hell?" I maintain that it is the suffering of beingunable to love"
---------------------------------------------
```

## Contribution 🤝

We **heavily** welcome contributions! Here's how you can help:

### 🐛 Report Bugs
-  Open a bug report in [GitHub Issues](https://github.com/holasoymas/text-finder/issues).  

### 💡 Suggest Features
- Propose new features in [GitHub Discussions](https://github.com/holasoymas/text-finder/discussions).  

### 🖥️ Code Contributions
1. **Fork the repository** and clone it locally.
2. **Create a branch**:  
3. **Submit a pull request** with clear title.

### 📖 Documentation
- Fix typos, clarify instructions, or add examples to this `README`.


