fn main() -> Result<(), std::io::Error> {
    let mut app = tide::App::new();
    app.at("/").get(|_| async move { "Hello, world!" });
    Ok(app.serve("0.0.0.0:8000")?)
}
