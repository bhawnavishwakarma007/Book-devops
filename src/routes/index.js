import express from "express";
import auth from "./auth.route.js";
import book from "./book.route.js";
import cart from "./cart.route.js";
import { verifyUser } from "../middleware.js";

const router = express.Router();

router.use("/auth", auth);
router.use("/book", book);
router.use("/cart", verifyUser, cart);

export default router;
