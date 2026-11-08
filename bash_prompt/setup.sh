# Get directory which script is being run from
DIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")")

# echo $DIR

# Source color palettes
. $DIR/colors.sh

# Source prompt template (this selects the prompt to use)
#. $DIR/templates/simple.sh
#. $DIR/templates/original.sh
. $DIR/templates/nota.sh

# Set color theme
#ps1_colorful_theme
#ps1_blue_theme
ps1_nota_theme

# Enable prompt 
setup_ps1
