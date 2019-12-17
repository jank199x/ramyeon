#!/bin/bash

set -e

# ASCII art made at http://patorjk.com/software/taag/
ART="H4sIAAAAAAAA/9WSsRHAIAhFe6fgHMDaMSzS2Obcf4aIwIkGLinShMJwL/jJh4RMcSbAaJjDE0tNUnwD9OACCMRqL5DLGR5YJ4VTpShn0AxL522X2emmONqOY9a5jGVYStxqRYwS2YwaicM2Rc81t1+83NhBk33lWhagt2AwkqSV6QFYivw1S2eDkWSs2wCWvwe+jl8oXliHROiHAwAA"
echo -e "\n  $(base64 --decode <<<${ART} | gunzip)"
echo -e "\n  PAPanic ARCH Installer 0.0.1 \n\n  \e[1mPress Enter to continue or Ctrl+C to exit.\e[21m\n" && read
