import mongoose from "mongoose";
import { DATABASE_URL } from "../config/env.js";

export const ConnectDB = () =>
  mongoose
    .connect(DATABASE_URL, {})
    .then(() => {
      console.log("Connected to MongoDB");
    })
    .catch((error) => {
      console.error("Error connecting to MongoDB:", error);
    });
