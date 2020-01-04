source VERSION
# ASCII art made at http://patorjk.com/software/taag/
ART="H4sIAAAAAAAA/62RvRHAIAiFe6fwGMDaMSzS0HruP0PAB4n5uSR3hgIRkg95hAyrKc5YEIQcLKAfMNGOSUzLuXRWn87GbNvNnGfiUEIQTJtCwJJOp/+QubpjmrZiyQiExg8rXrNAGe2hNvQ/3KxjvilhKHCu1e7Y+7LvUzIpqQwnDDjEt6/xvAcRgcqwYz6u4mWTHzAmapnEbCM8YVaQAN+oDgMAAA=="
echo -e "\n  $(base64 --decode <<<${ART} | gunzip)"
echo -e "\n  Ramyeon Instant Arch Linux ${VERSION} \n\n  \e[1mPress Enter to continue or Ctrl+C to exit.\e[21m\n" && read
