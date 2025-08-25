# Nushell Environment Config File

export def swap [file1, file2] {
  let tmpDir = mktemp -d
  let tmpFile = $tmpDir + '/file'
  mv $file1 $tmpFile
  mv $file2 $file1
  mv $tmpFile $file2
}

def create_left_prompt [] {
  mut home = ""
  try {
    if $nu.os-info.name == "windows" {
        $home = $env.USERPROFILE
    } else {
        $home = $env.HOME
    }
  }

  let dir = $env.PWD | str replace $home "~"
  let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
  let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
  let path_segment = $"($path_color)($dir)"
  let path = $path_segment | str replace --all (char path_sep) $"($separator_color)/($path_color)"

  let $info = git-repo-info
  let git_part = if $info.in_git_repo {
    let $inf = if ($info.branch_name | is-empty) {
      $info.commit_hash
    } else {
      $info.branch_name
    }
    let $changes = if $info.uncommited_changes { '✗' } else { '✔' }
    $"(ansi cyan) \(($inf) ($changes)\)"
  } else {
    ''
  }

  [$path, $git_part] | str join
}

def create_right_prompt [] {
  let last_exit_code = if $env.LAST_EXIT_CODE != 0 {
    [(ansi rb), $env.LAST_EXIT_CODE] | str join
  } else { '' }

  $last_exit_code
}

export def git-repo-info [] {
  let commit_hash = do -i { git rev-parse --short HEAD | complete } | get stdout | str trim
  let in_git_repo = not ($commit_hash | is-empty)
  let branch_name = if $in_git_repo {
    git branch --show-current | str trim
  } else {
    ''
  }
  let uncommited_changes = if $in_git_repo {
    not (git status --porcelain | is-empty)
  } else {
    ''
  }

  {
    in_git_repo: $in_git_repo,
    branch_name: $branch_name,
    commit_hash: $commit_hash,
    uncommited_changes: $uncommited_changes,
  }
}

$env.PROMPT_COMMAND = {|| create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = ' '
$env.PROMPT_INDICATOR_VI_INSERT = {|| " " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| ">" }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

$env.EDITOR = 'vim'

$env.PATH = ($env.PATH | split row (char esep)
  | prepend '../venv/bin'
  | prepend './venv/bin'
  | prepend $"($env.HOME)/.rbenv/shims"
  | append $"($env.HOME)/.volta/bin"
  | append $"($env.HOME)/.cargo/bin"
  | append $"($env.HOME)/.deno/bin"
  | append '/opt/homebrew/bin'
  | append '/Library/TeX/texbin'
  | append '/sbin'
  | append '/usr/sbin'
)

$env.VOLTA_FEATURE_PNPM = 1

alias activate_venv = sh -i -c 'source venv/bin/activate ; nu'

alias vscode = `/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code`
alias c = clear
alias txtdiff = git diff --word-diff --patience
alias g = git
alias ga = git add
alias gst = git status
alias glg = git log --stat
alias gco = git checkout
alias gl = git pull
alias gp = git push
alias gb = git branch
alias gd = git diff
alias gf = git fetch

# load ssh passphrase from keychain (otherwise it's not persisted after logging user out)
ssh-add --apple-use-keychain err> /dev/null
