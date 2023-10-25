use clap::Parser;
use yaml_rust;
use yaml_rust::{YamlLoader};

/// An extremely opinionated linter that I use to enforce programming style.
#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
struct Args {
    /// Directory of the project
    #[arg(short, long)]
    project_home: String,

    /// Config file to use
    #[arg(short, long)]
    config: String,
}

fn main() {
    let args = Args::parse();
}
