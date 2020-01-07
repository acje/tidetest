use async_std::task;

fn main() -> Result<(), std::io::Error> {
    task::block_on(async {
        let mut app = tide::new();
       // app.at("/").get(|req| async move { req });
        app.at("/").get(|_| async move { "Hello, world!" });
        app.listen("0.0.0.0:8000").await?;
        Ok(())
    })
}
