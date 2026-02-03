const app = express();

app.set("trust proxy", 1); // ✅ ADD THIS

app.use(express.json());
app.use(cookieParser());
app.use(express.urlencoded({ extended: true }));

ConnectDB();

app.get("/", (req, res) => {
  res.send("Hello");
});

app.get("/health", (req, res) => {   // ✅ ADD THIS
  res.status(200).json({ status: "OK" });
});

app.use("/api", routes);
