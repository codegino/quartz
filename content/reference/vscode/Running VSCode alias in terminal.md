### Method 1: Using the Command Palette

According to the official documentation from Visual Studio Code, you can run VS Code from the terminal by typing ‘code’ after adding it to the path. Here are the steps to achieve this:

1. Launch VS Code.
2. Open the Command Palette (Cmd+Shift+P) and type ‘shell command’ to find the Shell Command: Install ‘code’ command in PATH command [1] [17] .

After following these steps, you’ll be able to type ‘code .’ in any folder to start editing files in that folder.

### Method 2: Alternative Manual Instructions

Instead of running the command above, you can manually add VS Code to your path by running the following commands in the terminal:

```bash
cat << EOF >> ~/.bash_profile
# Add Visual Studio Code (code)
export PATH="\$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
EOF
```

Start a new terminal to pick up your `.bash_profile` changes.

### Method 3: Creating a Function

Another approach is to create a function in your `.bash_profile` or `.zshrc` file that allows you to run VS Code from the terminal. Here’s an example of the function:

```bash
code () {
    VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $*
}
```

After adding this function to your configuration file, you can simply type `code .` in any folder to start editing files in that folder .

### Method 4: Creating a Symbolic Link

You can also create a symbolic link from the “code” program supplied in the Visual Studio Code.app bundle to /usr/local/bin. This allows you to run VS Code from the terminal by typing `code .`. Here’s how you can create the symbolic link:

```bash
ln -s /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code /usr/local/bin/code
```


After creating the symbolic link, you can run VS Code from the terminal using the `code` command .

### Checking for Quarantine Attribute

It’s worth noting that some Mac users have reported issues with the quarantine attribute being applied to VS Code, which may require re-applying the necessary configurations after a restart. You can check for the quarantine attribute and remove it if necessary using the `xattr` command .

These methods should provide you with different options for running Visual Studio Code from the terminal on a Mac. If you have any specific preferences or if you need further clarification on any of these methods, feel free to let me know!