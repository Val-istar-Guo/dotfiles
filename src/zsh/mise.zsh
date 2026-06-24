if command -v mise &> /dev/null; then
  plugins+=(mise)
  eval "$(mise activate zsh)"
fi
