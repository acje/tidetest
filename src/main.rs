#[async_std::main]
async fn main() -> Result<(), std::io::Error> {
    let mut app = tide::new();
    app.at("/").get(|_| async move { "Hello, world!" });
    app.listen("0.0.0.0:8000").await?;
    Ok(())
}
